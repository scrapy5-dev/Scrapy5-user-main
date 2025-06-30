import 'dart:convert';

import 'package:date_picker_timeline/extra/color.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:ez/Helper/session.dart';
import 'package:ez/screens/chat_page.dart';
import 'package:ez/screens/view/models/cancel_booking_model.dart';
import 'package:ez/screens/view/models/getBookingModel.dart';
import 'package:ez/screens/view/newUI/newTabbar.dart';
import 'package:ez/screens/view/newUI/ratingService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../constant/global.dart';

// ignore: must_be_immutable
class BookingDetailScreen extends StatefulWidget {
  Booking data;
  List<String> statusOne;
  BookingDetailScreen(this.data, this.statusOne);

  @override
  State<StatefulWidget> createState() {
    return _BookingDetailScreenState(this.data);
  }
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  bool isLoading = false;
  var rateValue;
  bool isPayment = false;
  Razorpay? _razorpay;
  String? orderid = '';

  checkOut() {
    _razorpay = Razorpay();
    generateOrderId(
        rozPublic, rozSecret, int.parse(widget.data.amount.toString()) * 100);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<String> generateOrderId(String key, String secret, int amount) async {
    setState(() {
      isPayment = true;
    });
    var authn = 'Basic ' + base64Encode(utf8.encode('$key:$secret'));

    var headers = {
      'content-type': 'application/json',
      'Authorization': authn,
    };

    var data =
        '{ "amount": $amount, "currency": "INR", "receipt": "receipt#R1", "payment_capture": 1 }'; // as per my experience the receipt doesn't play any role in helping you generate a certain pattern in your Order ID!!

    var res = await http.post(Uri.parse('https://api.razorpay.com/v1/orders'),
        headers: headers, body: data);
    print('ORDER ID response => ${res.body}');
    orderid = json.decode(res.body)['id'].toString();
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" + orderid!);
    if (orderid!.length > 0) {
      openCheckout();
    } else {
      setState(() {
        isPayment = false;
      });
    }
    return json.decode(res.body)['id'].toString();
  }

  TextEditingController _ratingcontroller = TextEditingController();

  _BookingDetailScreenState(Booking data);

  successPaymentApiCall() async {
    setState(() {
      isPayment = true;
    });
    var uri = Uri.parse("${baseUrl()}/payment_success");
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['txn_id'] = widget.data.txnId.toString();
    request.fields['amount'] = widget.data.amount.toString();
    request.fields['booking_id'] = widget.data.id.toString();

    var response = await request.send();

    print(response.statusCode);

    String responseData = await response.stream
        .transform(utf8.decoder)
        .join(); // decodes on response data using UTF8.decoder
    Map data = json.decode(responseData);
    print(data);

    setState(() {
      isPayment = false;

      if (data["response_code"] == "1") {
        print("working");
        Fluttertoast.showToast(msg: "Payment Success");
        // const snackBar = SnackBar(
        //   backgroundColor: Colors.green,
        //   content: Text('Payment successful'),
        // );
        //
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => TabbarScreen()));
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => BookingSccess(
        //           image: widget.restaurants!.restaurant!.allImage![0],
        //           name: widget.restaurants!.restaurant!.resName,
        //           location: _pickedLocation,
        //           date: widget.dateValue,
        //           time: widget.timeValue)
        //   ),
        // );
      } else {
        print("ook ");
        setState(() {
          isPayment = false;
          Fluttertoast.showToast(msg: "something went wrong. Try again");
        });
      }
    });
  }

  List resonList = [
    "I will not be available at the address.",
    "Already sold to another vendor.",
    "Material quantity is less than 5 kg.",
    "I accidentally submitted the order.",
    "Just checking; no material at my place.",
    "Pickup not on time.",
    "No response from Scrapy5.",
    "Rate issues.",
    "Other"
  ];
  void openCheckout() async {
    var options = {
      'key': "rzp_test_CpvP0qcfS4CSJD",
      'amount': int.parse(widget.data.amount.toString()) * 100,
      'currency': 'INR',
      'name': 'Scrapy',
      'description': '',
      'prefill': {'contact': userMobile, 'email': userEmail},
    };

    print("Razorpay Option === $options");
    try {
      _razorpay!.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "SUCCESS Order:" + response.paymentId!);
    // bookApiCall(response.paymentId!, "Razorpay");
    successPaymentApiCall();
    print(response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() {
      isPayment = false;
    });
    Fluttertoast.showToast(
      msg: "ERROR: " + response.code.toString() + " - " + response.message!,
    );
    print(response.code.toString() + " - " + response.message!);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "EXTERNAL_WALLET: " + response.walletName!);
    print(response.walletName);
  }

  @override
  void initState() {
    super.initState();
  }

  TextEditingController resoncontroller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  var reson;

  Widget scrapName(List<String> lst) {
    String temp = "";
    temp = lst.join(",");
    return Text(
      temp,
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
    );
  }

  Widget totalAmount(List<String> lst) {
    double amt = 0.0;
    lst.forEach((element) {
      amt += double.parse(element.toString());
    });
    return Text(
      "\u{20B9} $amt",
      textAlign: TextAlign.end,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(
        " para check ${widget.data.txnId} and ${widget.data.id} and ${widget.data.amount}");
    return Scaffold(
      bottomSheet: BottomAppBar(
        elevation: 5,
        child: Container(
            width: double.maxFinite, //set your width here
            decoration: BoxDecoration(
                // color: Colors.grey.shade200,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20.0))),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: widget.data.status == "Cancelled by user" || widget.data.status == "Complete"
                          //widget.data.status == "On The Way"
                          ? SizedBox()
                          : ElevatedButton(
                              onPressed: () async {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return AlertDialog(
                                            content: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: 350,
                                                child: SingleChildScrollView(
                                                  child: Form(
                                                    key: _formKey,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Container(
                                                          height: 300,
                                                          child:
                                                              ListView.builder(
                                                            shrinkWrap: true,
                                                            physics:
                                                                NeverScrollableScrollPhysics(),
                                                            itemCount: resonList
                                                                .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    reson =
                                                                        resonList[
                                                                            index];
                                                                  });
                                                                },
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          5),
                                                                  child: Row(
                                                                    children: [
                                                                      Container(
                                                                          height:
                                                                              17,
                                                                          width:
                                                                              17,
                                                                          decoration: BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              border: Border.all()),
                                                                          child: reson == resonList[index].toString()
                                                                              ? Center(
                                                                                  child: Icon(
                                                                                  Icons.check,
                                                                                  size: 14,
                                                                                  color: Colors.black,
                                                                                ))
                                                                              : SizedBox.shrink()),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      SizedBox(
                                                                          width: MediaQuery.of(context).size.width /
                                                                              2,
                                                                          child:
                                                                              Text(
                                                                            resonList[index],
                                                                            style:
                                                                                TextStyle(fontSize: 12),
                                                                          ))
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),

                                                        reson == "Other"
                                                            ? TextFormField(
                                                                // onChanged: (value) {
                                                                //   setState(() {
                                                                //
                                                                //     reson =value;
                                                                //
                                                                //   },);
                                                                //
                                                                // },
                                                                controller:
                                                                    resoncontroller,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                                cursorColor:
                                                                    Colors
                                                                        .black,
                                                                decoration:
                                                                    InputDecoration(
                                                                  filled: true,
                                                                  fillColor:
                                                                      appColorWhite,
                                                                  focusedErrorBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                Colors.black),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                  ),
                                                                  hintText:
                                                                      "${getTranslated(context, 'Strathere')}",
                                                                  focusColor:
                                                                      Colors
                                                                          .black,
                                                                  labelStyle: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          14),
                                                                  hintStyle: TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          400],
                                                                      fontSize:
                                                                          14),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Colors
                                                                            .grey,
                                                                        width:
                                                                            1),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                  ),
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Colors
                                                                            .grey,
                                                                        width:
                                                                            1),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                  ),
                                                                ),
                                                                validator:
                                                                    (value) {
                                                                  if (value ==
                                                                          null ||
                                                                      value
                                                                          .isEmpty) {
                                                                    return 'Please Enter Some Reson';
                                                                  }
                                                                  return null;
                                                                },
                                                              )
                                                            : SizedBox.shrink(),

                                                        // Text("Are you sure ?\n Want to cancel service",style: TextStyle(color: appColorBlack,fontSize: 15,fontWeight: FontWeight.w500,),textAlign: TextAlign.center,),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Container(
                                                                height: 40,
                                                                width: 100,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            10),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      backgroundblack,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                child: Text(
                                                                  "Discard",
                                                                  style: TextStyle(
                                                                      color:
                                                                          appColorWhite,
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () async {
                                                                print(
                                                                    "klljjjjjj");
                                                                if (_formKey
                                                                    .currentState!
                                                                    .validate()) {
                                                                  print("hhhhhhhhhhhhhhhhhhhhhhhhhhhh${widget.data.status}");
                                                                  if (reson !=
                                                                      null) {
                                                                    setState(
                                                                        () {
                                                                      isLoading =
                                                                          true;
                                                                    });
                                                                    if (/*widget.data.status == "On Way" ||
                                                                        widget.data.status ==
                                                                            "Confirm" ||
                                                                        widget.data.status ==
                                                                            "Pending" ||
                                                                        widget.data.status ==
                                                                            "Complete"*/true) {
                                                                      print(
                                                                          "dhjkshfjskdhfsjdfhdks ${widget.data.status}");
                                                                      CancelBookingModel
                                                                          cancelModel =
                                                                          await cancelBooking(
                                                                              widget.data.id,
                                                                              reson);
                                                                      if (cancelModel
                                                                              .responseCode ==
                                                                          "1") {

                                                                        Navigator.pop(
                                                                            context,
                                                                            true);

                                                                        // Navigator.pop(context);
                                                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TabbarScreen(),));
                                                                        Fluttertoast.showToast(
                                                                            msg:
                                                                            "Order Cancel!",
                                                                            toastLength: Toast
                                                                                .LENGTH_LONG,
                                                                            gravity: ToastGravity
                                                                                .BOTTOM,
                                                                            timeInSecForIosWeb:
                                                                            1,
                                                                            backgroundColor:
                                                                            Colors.grey.shade200,
                                                                            textColor: Colors.black,
                                                                            fontSize: 13.0);
                                                                      }
                                                                    }
                                                                  } else {
                                                                    Fluttertoast
                                                                        .showToast(
                                                                            msg:
                                                                                "Please Select Reason");
                                                                  }
                                                                }
                                                              },
                                                              child: Container(
                                                                height: 40,
                                                                width: 100,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            10),
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .green,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8)),
                                                                child: Text(
                                                                  "Proceed",
                                                                  style: TextStyle(
                                                                      color:
                                                                          appColorWhite,
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    });
                                // setState(() {
                                //   isLoading = true;
                                // });
                                // if(widget.data.status == "Pending"){
                                //   CancelBookingModel cancelModel = await cancelBooking(widget.data.id);
                                //   if(cancelModel.responseCode == "1"){
                                //     Navigator.pop(context, true);
                                //
                                //     Fluttertoast.showToast(
                                //         msg: "Booking Cancelled Successfully!",
                                //         toastLength: Toast.LENGTH_LONG,
                                //         gravity: ToastGravity.BOTTOM,
                                //         timeInSecForIosWeb: 1,
                                //         backgroundColor:
                                //         Colors.grey.shade200,
                                //         textColor: Colors.black,
                                //         fontSize: 13.0);
                                //   }
                                // }
                                /*widget.data.status == "Pending"
                              ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ReviewService(widget.data)))
                              : changeStatusBloc
                              .changeStatusSink(
                              widget.data.id!, "Booking Cancel")
                              .then((value) {
                            setState(() {
                              isLoading = false;
                            });
                            if (value.responseCode == "1") {
                              Fluttertoast.showToast(
                                  msg: "Booking cancel successfully",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor:
                                  Colors.grey.shade200,
                                  textColor: Colors.black,
                                  fontSize: 13.0);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BookingList()));
                              getBookingBloc.getBookingSink(
                                  userID, "Confirm");
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Something went wrong",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor:
                                  Colors.grey.shade200,
                                  textColor: Colors.black,
                                  fontSize: 13.0);
                              setState(() {
                                isLoading = false;
                              });
                            }
                          });*/
                              },
                              child:
                                  // widget.data.status != "Pending"
                                  //     ?
                                  //
                                  // SizedBox.shrink()
                                  //     :
                                  Text("Cancel Service"),
                              style: ElevatedButton.styleFrom(
                                  primary: backgroundblack,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 15),
                                  textStyle: TextStyle(fontSize: 17),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  )),
                            )
                      // : Text(''),
                      ),
                ],
              ),
            )),
      ),
      // bottomNavigationBar:
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: backgroundblack,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        elevation: 0,
        title: Text(
          '${getTranslated(context, 'bookingDetail')}',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(12),
          child: RawMaterialButton(
            shape: CircleBorder(),
            padding: const EdgeInsets.all(0),
            fillColor: Colors.white,
            splashColor: Colors.grey[400],
            child: Icon(
              Icons.arrow_back,
              size: 20,
              color: appColorBlack,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: isLoading ? loader() : bodyData(),
    );
  }

  Widget bodyData() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              children: [
                bookDetailCard(),
                widget.data.status == "Cancelled by user"
                    ? Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.red),
                                child: Center(
                                  child: Text(
                                    'This Order Is Cancelled by You',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border:
                                          Border.all(color: backgroundblack),
                                      color:
                                          widget.statusOne.contains("Confirm")
                                              ? Colors.green
                                              : Colors.transparent,
                                      // widget.data.status == "Confirm"
                                      //     ? backgroundblack
                                      //     : Colors.transparent
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Confirm',
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                DottedLine(
                                  direction: Axis.horizontal,
                                  lineLength:
                                      50, // Set the length of the dotted line
                                  lineThickness: 1,
                                  dashRadius: 1,
                                  dashLength: 2,
                                  // Set the thickness of the dotted line
                                ),
                                // Expanded(
                                //   child: Container(
                                //     height: 40,
                                //     decoration: BoxDecoration(
                                //         borderRadius: BorderRadius.circular(5),
                                //         border:
                                //             Border.all(color: backgroundblack),
                                //         color:
                                //             widget.statusOne.contains("alloted")
                                //                 ? Colors.green
                                //                 : Colors.transparent
                                //         // widget.data.status == "alloted"
                                //         //     ? backgroundblack
                                //         //     : Colors.transparent
                                //         ),
                                //     child: Center(
                                //       child: Text(
                                //         'Alloted',
                                //         style: TextStyle(
                                //             fontSize: 10,
                                //             fontWeight: FontWeight.bold),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                // DottedLine(
                                //   direction: Axis.horizontal,
                                //   lineLength:
                                //       50, // Set the length of the dotted line
                                //   lineThickness: 1,
                                //   dashRadius: 1,
                                //   dashLength: 2,
                                //   // Set the thickness of the dotted line
                                // ),
                                Expanded(
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border:
                                            Border.all(color: backgroundblack),
                                        color: widget.statusOne
                                                .contains("Out For Pickup")
                                            ? Colors.green
                                            : Colors.transparent
                                        // widget.data.status == "Out For Pickup"
                                        //     ? backgroundblack
                                        //     : Colors.transparent
                                        ),
                                    child: Center(
                                      child: Text(
                                        'OutForPickup',
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                // DottedLine(
                                //   direction: Axis.horizontal,
                                //   lineLength:
                                //       10, // Set the length of the dotted line
                                //   lineThickness: 1,
                                //   dashRadius: 1,
                                //   dashLength: 2,
                                //   // Set the thickness of the dotted line
                                // ),
                                // Expanded(
                                //   child: Container(
                                //     height: 40,
                                //     decoration: BoxDecoration(
                                //         borderRadius: BorderRadius.circular(5),
                                //         border: Border.all(color: backgroundblack),
                                //         color: widget.data.status == "Out For Pickup"
                                //             ? backgroundblack
                                //             : Colors.transparent),
                                //     child: Center(
                                //       child: Text(
                                //         'OutForPickup',
                                //         style: TextStyle(
                                //             fontSize: 9,
                                //             fontWeight: FontWeight.bold),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                // DottedLine(
                                //   direction: Axis.horizontal,
                                //   lineLength:
                                //   10, // Set the length of the dotted line
                                //   lineThickness: 1,
                                //   dashRadius: 1,
                                //   dashLength: 2,
                                //   // Set the thickness of the dotted line
                                // ),
                                // Expanded(
                                //   child: Container(
                                //     height: 40,
                                //     decoration: BoxDecoration(
                                //         borderRadius: BorderRadius.circular(5),
                                //         border: Border.all(
                                //             color: widget.data.status == "Pending"
                                //                 ? Colors.red
                                //                 : backgroundblack),
                                //         color: widget.data.status == "Pending"
                                //             ? Colors.red
                                //             : Colors.transparent),
                                //     child: Center(
                                //       child: Text(
                                //         'Pending',
                                //         style: TextStyle(
                                //             fontSize: 10,
                                //             fontWeight: FontWeight.bold),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border:
                                            Border.all(color: backgroundblack),
                                        color:
                                            widget.statusOne.contains("Arrived")
                                                ? Colors.green
                                                : Colors.transparent
                                        // widget.data.status == "Arrived"
                                        //     ? backgroundblack
                                        //     : Colors.transparent
                                        ),
                                    child: Center(
                                      child: Text(
                                        'Arrived',
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                DottedLine(
                                  direction: Axis.horizontal,
                                  lineLength:
                                      50, // Set the length of the dotted line
                                  lineThickness: 1,
                                  dashRadius: 1,
                                  dashLength: 2,
                                  // Set the thickness of the dotted line
                                ),
                                Expanded(
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: backgroundblack),
                                        color: widget.statusOne.contains("Complete")
                                            ? Colors.green
                                            : Colors.transparent
                                        // widget.data.status == "Completed"
                                        //     ? backgroundblack
                                        //     : Colors.transparent
                                        ),
                                    child: Center(
                                      child: Text(
                                        'Completed',
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                widget.data.status == "Confirm" ? SizedBox():
                                DottedLine(
                                  direction: Axis.horizontal,
                                  lineLength: 50, // Set the length of the dotted line
                                  lineThickness: 1,
                                  dashRadius: 1,
                                  dashLength: 2,
                                  // Set the thickness of the dotted line
                                ),
                                widget.data.status == "Pending" ?
                                Expanded(
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: widget.statusOne.contains("Pending")
                                                ? Colors.red
                                                : Colors.transparent
                                            //widget.data.status == "Pending"
                                            //        ?
                                            ),
                                        // : backgroundblack),
                                        color: Colors.red),
                                    child: Center(
                                      child: Text(
                                        'Pending',
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ): SizedBox()
                              ],
                            ),
                          ),
                        ],
                      ),
                bookcard(),
                // datetimecard(),
                // widget.data.isPaid == "1" ?
                // InkWell(
                //   onTap: (){
                //     Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(providerId: widget.data.service!.vendorId,providerName: widget.data.service!.vendorName,providerImage: widget.data.service!.vendorImage,)));
                //   },
                //   child: Container(
                //     decoration: BoxDecoration(
                //       color: backgroundblack,
                //       borderRadius: BorderRadius.circular(8)
                //     ),
                //     child: Padding(
                //       padding:  EdgeInsets.all(8.0),
                //       child: Row(
                //         mainAxisSize: MainAxisSize.min,
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Icon(Icons.chat_bubble,color: appColorWhite,),
                //         SizedBox(width: 3,),
                //         Text("Chat with service provider",style: TextStyle(color: appColorWhite),),
                //         ],
                //     ),
                //     ),),
                // ) ,
                // : SizedBox(),

                widget.data.vId == "0"
                    ? SizedBox.shrink()
                    : Container(
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Card(
                            elevation: 2.0,
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Review vendor',
                                        style: TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Divider(),
                                  SizedBox(height: 5),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) => ReviewService(
                                            restID: widget.data.vId.toString(),
                                            id: widget.data.id,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: 20, top: 8),
                                      height: 40,
                                      width: 100,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: backgroundblack,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        "Add Review",
                                        style: TextStyle(
                                            color: appColorWhite,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                // pricingcard(),
                widget.data.status == "Completed"
                    ? InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReviewService(
                                restID: widget.data.vId,
                                id: widget.data.id,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width / 2,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: backgroundblack,
                              borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            "Add Review",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
                SizedBox(height: 60)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget paymentOption() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 10),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            title: Text(
              "Payment options",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(
              "Select your preferred payment mode",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
            ),
          ),
          /*Card(
            child: ExpansionTile(
              tilePadding: const EdgeInsets.only(left: 10, right: 5),
              leading: Icon(Icons.payment),
              title: Text(
                "Cradit/Debit Card (STRIPE)",
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
              ),
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      // border: Border.all(),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Expanded(child: _cardNumber()),
                              _creditCradWidget(),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(child: _expiryDate()),
                            Expanded(child: _cvvNumber()),
                          ],
                        ),
                      ],
                    )),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.black45,
                            onPrimary: Colors.grey,
                            onSurface: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            padding: EdgeInsets.all(8.0),
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () {
                          setState(() {
                            FocusScope.of(context).unfocus();
                          });
                          if (_pickedLocation.length > 0) {
                            String number =
                                maskFormatterNumber.getMaskedText().toString();
                            String cvv =
                                maskFormatterCvv.getMaskedText().toString();
                            String month = maskFormatterExpiryDate
                                .getMaskedText()
                                .toString()
                                .split("/")[0];
                            String year = maskFormatterExpiryDate
                                .getMaskedText()
                                .toString()
                                .split("/")[1];

                            setState(() {
                              isPayment = true;
                            });

                            getCardToken
                                .getCardToken(
                                    number, month, year, cvv, "test", context)
                                .then((onValue) {
                              print(onValue["id"]);
                              createCutomer
                                  .createCutomer(onValue["id"], "test", context)
                                  .then((cust) {
                                print(cust["id"]);
                                applyCharges
                                    .applyCharges(cust["id"], context,
                                        widget.selectedTypePrice.toString())
                                    .then((value) {
                                  bookApiCall(value["balance_transaction"], "Stripe");

                                  setState(() {
                                    isPayment = false;
                                  });
                                });
                              });
                            });
                          } else {
                            Fluttertoast.showToast(msg: "Select Address");
                            // Toast.show("Select Address", context,
                            //     duration: Toast.LENGTH_SHORT,
                            //     gravity: Toast.BOTTOM);
                          }
                        },
                        child: Text(
                          "Pay",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            // fontFamily: ""
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),*/
          Card(
            child: ListTile(
              onTap: () {
                checkOut();
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              leading: Icon(Icons.payment),
              title: Text(
                "Razorpay",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          // Card(
          //   child: ListTile(
          //     onTap: () {
          //       // if (_pickedLocation.length > 0) {
          //       //   // bookApiCall('' , 'Cash On Delivery');
          //       //   // Fluttertoast.showToast(msg: "Under Development");
          //       // } else {
          //       //   Fluttertoast.showToast(
          //       //       msg: "Select Address",
          //       //       gravity: ToastGravity.BOTTOM,
          //       //       toastLength: Toast.LENGTH_SHORT);
          //       // }
          //     },
          //     contentPadding: EdgeInsets.symmetric(horizontal: 10),
          //     leading: Icon(Icons.attach_money_outlined, color: Colors.black),
          //     title: Text(
          //       "Cash On Delivery",
          //       style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
          //       textAlign: TextAlign.start,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget bookDetailCard() {
    // var dateFormate =
    // DateFormat("dd/MM/yyyy").format(DateTime.parse(widget.data.date ?? ""));
    // var bookingTime = TimeOfDay(hour: DateTime.parse(widget.data.createDate!).hour , minute: DateTime.parse(widget.data.createDate!).minute) ;
    return Container(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Card(
          elevation: 2.0,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Booking Id - ${widget.data.id}"),
                      SizedBox(
                        height: 5,
                      ),
                      // Row(
                      //   children: [
                      //     Text("Scrap Name: ",style: TextStyle(
                      //         fontSize: 15.0, fontWeight: FontWeight.w400)
                      //     ),
                      //     Text(
                      //       widget.data.scrapName ?? "",
                      //       style: TextStyle(
                      //           fontSize: 15.0, fontWeight: FontWeight.w400),
                      //     ),
                      //   ],
                      // ),
                      Row(
                        children: [
                          Text("Customer Name: ",
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.w400)),
                          Text(
                            userName,
                          ),
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Colors.grey.shade600,
                          ),
                          Flexible(
                              child: Text(
                            widget.data.address ?? "",
                            maxLines: 3,
                            style: TextStyle(fontSize: 11.0),
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                            width: 100.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              color: Colors.blue.shade100,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "${widget.data.slot}",
                                  style: TextStyle(
                                      color: appColorGreen,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.data.date.toString(),
                                  style: TextStyle(
                                      color: appColorGreen,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget bookcard() {
    print("===my technic status =======${widget.data.status}===============");
    var dateFormate = widget.data.pDate;
    // DateFormat("dd, MMMM yyyy").format(DateTime.parse(widget.data.pDate!));
    var bookingTime = widget.data.pDate;
    //  TimeOfDay(hour: DateTime.parse(widget.data.pDate!).hour , minute: DateTime.parse(widget.data.pDate!).minute) ;
    var timeString = "$bookingTime }";
    return Container(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Card(
          elevation: 2.0,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${getTranslated(context, 'bookingDetail')}',
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Divider(),
                // SizedBox(height: 5),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text("OTP"),
                //     Text("${widget.data.otp}")
                //   ],
                // ),
                // SizedBox(height: 5),
                // Divider(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${getTranslated(context, 'categories')}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                        alignment: Alignment.centerRight,
                        child: widget.data.bookingAllData == null
                            ? Text("")
                            : SizedBox(
                                width: 150,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      widget.data.bookingAllData!.categoryName!
                                          .join(","),
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              )
                        // decoration: BoxDecoration(
                        //     color: Colors.grey.shade100,
                        //     borderRadius: BorderRadius.circular(5)),
                        ),
                  ],
                ),
                Divider(),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${getTranslated(context, 'scrapType')}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: widget.data.bookingAllData == null
                          ? Text("")
                          : SizedBox(
                              width: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    widget.data.bookingAllData!.scrapName!
                                        .join(","),
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                      // decoration: BoxDecoration(
                      //     color: Colors.grey.shade100,
                      //     borderRadius: BorderRadius.circular(5)),
                    ),
                  ],
                ),
                Divider(),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${getTranslated(context, 'subScrapType')}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: widget.data.bookingAllData == null
                          ? Text("")
                          : SizedBox(
                              width: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    widget.data.bookingAllData!.subCategoryName!
                                        .join(","),
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                      // decoration: BoxDecoration(
                      //     color: Colors.grey.shade100,
                      //     borderRadius: BorderRadius.circular(5)),
                    ),
                  ],
                ),
                // Divider(),
                // SizedBox(height: 5),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       '${getTranslated(context, 'serviceStatus')}',
                //     ),
                //     // Container(
                //     //   alignment: Alignment.centerRight,
                //     //   child: widget.data.status == "Cancelled"
                //     //       ? Text(
                //     //     widget.data.status!,
                //     //     textAlign: TextAlign.center,
                //     //     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                //     //   )
                //     //       : widget.data.status != "Completed" ? Text(
                //     //     widget.data.status!,
                //     //     textAlign: TextAlign.center,
                //     //     style: TextStyle(fontWeight: FontWeight.bold),
                //     //   ) : Text(
                //     //     // widget.data.status!,
                //     //     "Completed",
                //     //     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                //     //   ),
                //     //   // decoration: BoxDecoration(
                //     //   //     color: Colors.grey.shade100,
                //     //   //     borderRadius: BorderRadius.circular(5)),
                //     // ),
                //     widget.data.status==""?
                //     Text(
                //       // widget.data.status!,
                //       "Pending",
                //       style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                //     ):
                //     Text(
                //       // widget.data.status!,
                //       "${widget.data.status}",
                //       style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                //     ),
                //   ],
                // ),
                Divider(),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${getTranslated(context, 'paymentStatus')}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                        alignment: Alignment.centerRight,
                        child:
                        widget.data.isPaid == "1" ?
                        Text(
                          "Paid",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        )
                      // Text("${widget.data.isPaid}",
                      //           textAlign: TextAlign.end,
                      //           style: TextStyle(
                      //               fontWeight: FontWeight.bold,
                      //               color: Colors.red),
                      //         ),
                            : Text(
                                "UnPaid",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              )
                        // decoration: BoxDecoration(
                        //     color: Colors.grey.shade100,
                        //     borderRadius: BorderRadius.circular(5)),
                        ),
                  ],
                ),
                SizedBox(height: 5),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${getTranslated(context, 'Quantity')}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                        width: 100,
                        alignment: Alignment.centerRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${widget.data.bookingAllData!.qty!.join(",")}",
                              maxLines: 2,
                              textAlign: TextAlign.end,
                              style: TextStyle(),
                            ),
                          ],
                        ),
                        // decoration: BoxDecoration(
                        //     color: Colors.grey.shade100,
                        //     borderRadius: BorderRadius.circular(5)),
                        ),
                  ],
                ),
                SizedBox(height: 5),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${getTranslated(context, 'price')}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                        alignment: Alignment.centerRight,
                        child: widget.data.bookingAllData!.total == null ||
                                widget.data.bookingAllData!.total == ""
                            ? Text("")
                            : Text(
                                "${widget.data.bookingAllData!.total!.join(",")}",
                                textAlign: TextAlign.end,
                                style: TextStyle(),
                              ),
                        // decoration: BoxDecoration(
                        //     color: Colors.grey.shade100,
                        //     borderRadius: BorderRadius.circular(5)),
                        ),
                  ],
                ),
                SizedBox(height: 5),
                Divider(),
                // SizedBox(height: 5),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       'Payment',
                //     ),
                //     Container(
                //       height: 30,
                //       width: 80,
                //       alignment: Alignment.centerRight,
                //       child: Text(
                //        " \u{20B9} ${ widget.data.total}",
                //
                //       ),
                //       // decoration: BoxDecoration(
                //       //     color: Colors.grey.shade100,
                //       //     borderRadius: BorderRadius.circular(5)),
                //     ),
                //   ],
                // ),
                //
                // Divider(),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${getTranslated(context, 'bookingAt')}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.data.pDate! + "\n" + widget.data.slot.toString(),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${getTranslated(context, 'Paymentype')}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.data.paymentType.toString(),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),

                widget.data.paymentType == "Online"
                    ? Column(
                        children: [
                          SizedBox(height: 5),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${getTranslated(context, 'paymentMethood')}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.data.payemntMethod.toString(),
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                        ],
                      )
                    : SizedBox(),
                widget.data.payemntMethod == "Phone Pay" ||
                        widget.data.payemntMethod == "Paytm" ||
                        widget.data.payemntMethod == "Google Pay"
                    ? Column(
                        children: [
                          SizedBox(height: 5),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${getTranslated(context, 'mobileonlinepayment')}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.data.mobileNumber.toString(),
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                        ],
                      )
                    : SizedBox(),
                   widget.data.payemntMethod == "bank detail"
                    ? Column(
                        children: [
                          SizedBox(height: 5),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${getTranslated(context, 'AccountHolderName')}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.data.accHolder.toString(),
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${getTranslated(context, 'AccountNumber')}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.data.accNumber.toString(),
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${getTranslated(context, 'IfscCode')}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.data.accIfsc.toString(),
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${getTranslated(context, 'BankBranch')}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.data.bankBranch.toString(),
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${getTranslated(context, 'Bankname')}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.data.bankName.toString(),
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2.5,
                                child: Text(
                                  '${getTranslated(context, 'mobileonlinepayment')}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                widget.data.mobileNumber.toString(),
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                        ],
                      )
                    : SizedBox(),
                SizedBox(height: 5),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${getTranslated(context, 'TotalPrice')}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    widget.data.vendorAmount == "" ||  widget.data.vendorAmount == null ?
                    Container(
                      alignment: Alignment.centerRight,
                      child: totalAmount(widget.data.bookingAllData!.total!),
                      // decoration: BoxDecoration(
                      //     color: Colors.grey.shade100,
                      //     borderRadius: BorderRadius.circular(5)),
                    ):  Container(
                      alignment: Alignment.centerRight,
                      child: Text("\u{20B9} ${widget.data.vendorAmount}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
                      // decoration: BoxDecoration(
                      //     color: Colors.grey.shade100,
                      //     borderRadius: BorderRadius.circular(5)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Divider(),
                SizedBox(height: 20),
                Text(
                  '${getTranslated(context, 'Pickup Instructions')}',
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Text(
                      "${getTranslated(context, '(a) ')}",
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      "${getTranslated(context, 'Please take out scrap item for faster pickup')}",
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "${getTranslated(context, '(b) ')}",
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      "${getTranslated(context, 'Show pickup code to out executive')}",
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "${getTranslated(context, '(c) ')}",
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      "${getTranslated(context, 'Price are not negotiable check price list')}",
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "${getTranslated(context, '(d) ')}",
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      "${getTranslated(context, 'Our price are dynamic based on recycling industry')}",
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Text(
                      "${getTranslated(context, '(e) ')}",
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      "${getTranslated(context, 'Payment depends on scrap weight at your doorstep.')}",
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget datetimecard() {
    var dateFormate =
        DateFormat("dd, MMMM yyyy").format(DateTime.parse(widget.data.pDate!));
    return Container(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Card(
          elevation: 2.0,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Booking Date & Time',
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Divider(),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Booking At',
                    ),
                    Text(
                      dateFormate + "\n" + widget.data.slot!,
                    ),
                  ],
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget pricingcard() {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Card(
          elevation: 2.0,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Booking Amount',
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Divider(),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount',
                    ),
                    widget.data.amount == null ||
                            widget.data.amount == "" ||
                            widget.data.amount == "0"
                        ? Text("₹ " + widget.data.total.toString(),
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold))
                        : Text(
                            "₹ " + widget.data.amount!,
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                  ],
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Future cancelBooking(id, String Reson) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('${baseUrl()}/cancel_booking'));
    request.fields.addAll({
      'id': '$id',
      'status': 'Cancelled',
      'reasion':
          reson == "Other" ? resoncontroller.text.toString() : reson.toString(),
    });

    print("camncwlekkleekl ${request.fields}");
    print(request.fields);
    http.StreamedResponse response = await request.send();
    print("===my technic=======${request.fields}===============");

    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();
      print("===my technic=======${str}===============");
      return CancelBookingModel.fromJson(json.decode(str));
    } else {
      return null;
    }
  }
}
