import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ez/Helper/session.dart';
import 'package:ez/constant/sizeconfig.dart';
import 'package:ez/screens/view/models/OfferModel.dart';
import 'package:ez/screens/view/models/bannerModal.dart';
import 'package:ez/screens/view/newUI/viewNotification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import '../../../constant/global.dart';
import '../models/notification_modal.dart';

class OfferPage extends StatefulWidget {
  @override
  State<OfferPage> createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {
  void initState() {
    super.initState();
    // _getBanners();
    //  getOfferFunction();
    _getData();
  }

  BannerModal? bannerModal;

  _getBanners() async {
    var uri = Uri.parse('${baseUrl()}/get_all_banners');
    var request = new http.MultipartRequest("GET", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    // request.fields['vendor_id'] = userID;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    if (mounted) {
      setState(() {
        bannerModal = BannerModal.fromJson(userData);
      });
    }

    print(responseData);
  }

  OfferModel? offerModeldata;

  getOfferFunction() async {
    var headers = {
      'Cookie': 'ci_session=0ea9c1cfb58a9963d191b28aa70aaacd7c5f7b24'
    };
    var request = http.Request('POST', Uri.parse('${baseUrl()}/get_offer'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = OfferModel.fromJson(json.decode(finalResponse));
      setState(() {
        offerModeldata = jsonResponse;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  NotificationModal? modal;

  _getData() async {
    var uri = Uri.parse('${baseUrl()}/offer_notification_listing');
    var request = new http.MultipartRequest("Post", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    print("user_id:$userID================$uri");
    request.headers.addAll(headers);
    request.fields.addAll({'user_id': userID});
    request.fields['user_id'] = userID;
    var response = await request.send();
    print(" response data here ${response.statusCode}");
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    if (mounted) {
      setState(() {
        modal = NotificationModal.fromJson(userData);
      });
    }
  }

  Widget orderWidget() {
    return modal == null
        ? Align(
            alignment: Alignment.center,
            child: Container(
              height: 20,
              width: 20,
              child: Image.asset("assets/images/loader1.gif"),
              // child: Center(
              //     child: CircularProgressIndicator(
              //   strokeWidth: 3,
              //   valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
              // ),
            ),
          )
        : modal!.responseCode == '1'
            ? Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: ListView.builder(
                    shrinkWrap: true,
                    //physics: NeverScrollableScrollPhysics(),
                    itemCount: modal?.notifications?.length,
                    itemBuilder: (context, index) => dataWidget(index)),
              )
            : Container(
                height: SizeConfig.screenHeight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        child: Image.asset(
                          "assets/images/emptyNotification.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                        '${getTranslated(context, 'Notification list is empty')}',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
                ),
              );
  }

  Widget dataWidget(int index) {
    return Column(
      children: [
        Container(
          child: Material(
            elevation: 0,
            borderRadius: BorderRadius.circular(5.0),
            child: InkWell(
              splashColor: Colors.grey[200],
              focusColor: Colors.grey[200],
              highlightColor: Colors.grey[200],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Offerdetails(
                        massage: modal?.notifications?[index].message,
                        title: modal?.notifications?[index].title,
                        type: modal?.notifications?[index].type,
                        date: modal?.notifications?[index].date),
                  ),
                );
                //           ViewNotification(
                //
                //           products: modal?.notifications)),
                // );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: index % 3 == 0
                              ? Color(0xFFE9E4B2)
                              : index % 3 == 1
                              ? Color(0xFFEBBFA1)
                              : Color(0xFFC6D3EF),
                          shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: modal!.notifications![index].title ==
                            "Order Placed"
                            ? Image.asset(
                          "assets/images/orderPlaced.png",
                        )
                            : modal!.notifications![index].title ==
                            "Order Dispatch"
                            ? Image.asset(
                            "assets/images/order Dispatch.png",
                            height: 20)
                            : modal!.notifications![index].title ==
                            "Order Deliver"
                            ? Image.asset(
                            "assets/images/orderDeliver.png",
                            height: 20)
                            : modal!.notifications![index].title ==
                            "Order Cancel"
                            ? Image.asset(
                            "assets/images/orderCancel.png",
                            height: 20)
                            : ImageIcon(
                          AssetImage("assets/images/assign.png"),//change here
                          size: 20,
                          color:
                          Colors.black.withOpacity(0.2),
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Flexible(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(modal!.notifications![index].message!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: appColorGreen,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'OderId: ${modal!.notifications![index].dataId}',
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  "${modal!.notifications![index].date}",
                                  // format(
                                  //   DateTime.parse(
                                  //       modal!.notifications![index].date!),
                                  // ),
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Divider(color: Colors.black45, thickness: 0.3)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColorWhite,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        backgroundColor: backgroundblack,
        elevation: 2,
        title: Text(
          '${getTranslated(context, 'offer')}',
          style: TextStyle(color: appColorWhite, fontWeight: FontWeight.bold),
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
      body: Column(
        children: [
          Container(height: 15),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: DefaultTabController(
                length: 1,
                initialIndex: 0,
                child: Column(
                  children: <Widget>[
                    /*Container(
                        width: 250,
                        height: 40,
                        decoration: new BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[300]),
                        child: Center(
                          child: TabBar(
                            labelColor: appColorWhite,
                            unselectedLabelColor: appColorBlack,
                            labelStyle: TextStyle(
                                fontSize: 13.0,
                                color: appColorWhite,
                                fontWeight: FontWeight.bold),
                            unselectedLabelStyle: TextStyle(
                                fontSize: 13.0,
                                color: appColorBlack,
                                fontWeight: FontWeight.bold),
                            indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Color(0xFF619aa5)),
                            tabs: <Widget>[
                              Tab(
                                text: 'Orders',
                              ),
                              Tab(
                                text: 'Booking',
                              ),
                            ],
                          ),
                        ),
                      ),*/
                    Expanded(
                      child: TabBarView(
                        children: <Widget>[
                          orderWidget(),
                          // bookingWidget()
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bookingWidget() {
    return offerModeldata == null
        ? Align(
            alignment: Alignment.center,
            child: Container(
                height: 20,
                width: 20,
                child: Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                ))),
          )
        : offerModeldata!.responseCode == "1"
            ? Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: ListView.builder(
                    shrinkWrap: true,
                    //physics: NeverScrollableScrollPhysics(),
                    itemCount: offerModeldata!.data!.length,
                    itemBuilder: (context, index) => bookingItemWidget(index)),
              )
            : Container(
                height: SizeConfig.screenHeight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        child: Image.asset(
                          "assets/images/emptyNotification.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                        '${getTranslated(context, 'offerlistisEmpty')}',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
                ),
              );
  }

  Widget bookingItemWidget(int index) {
    // var dateFormate = DateFormat("dd/MM/yyyy").format(DateTime.parse(bookingNotificationModal!
    //     .notifications![index].date! ?? ""));
    return Column(
      children: [
        Container(
          child: Material(
            elevation: 0,
            borderRadius: BorderRadius.circular(5.0),
            child: InkWell(
              splashColor: Colors.grey[200],
              focusColor: Colors.grey[200],
              highlightColor: Colors.grey[200],
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => ViewBookingNotification(
                //           booking: bookingNotificationModal!.notifications![index].booking!)),
                // );
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: backgroundblack.withOpacity(0.2),
                        ),
                        child: Text(
                          "${offerModeldata!.data![index].id}",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${offerModeldata!.data![index].name![0].toUpperCase() + offerModeldata!.data![index].name!.substring(1)}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "${offerModeldata!.data![index].cName![0].toUpperCase() + offerModeldata!.data![index].cName!.substring(1)}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Add on",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "\u{20B9} ${offerModeldata!.data![index].discount}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Text(
                                "${getTranslated(context, "ExpDate")}${offerModeldata!.data![index].endDate}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ),
        Divider(color: Colors.black45, thickness: 0.3)
      ],
    );
  }
}
