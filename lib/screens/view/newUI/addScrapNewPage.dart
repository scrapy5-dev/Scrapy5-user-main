import 'dart:convert';
import 'dart:io';

import 'package:ez/Helper/session.dart';
import 'package:ez/screens/view/models/getServiceChargeModel.dart';
import 'package:ez/screens/view/models/getUserModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../../constant/global.dart';
import '../../../models/CategoryDataModel.dart';
import '../../../models/scarpFormGetcatDataModel.dart';
import '../models/MaterCategoryModel.dart';
import '../models/NewSubCategoryModel.dart';
import '../models/OfferModel.dart';
import '../models/categories_model.dart';
import '../models/scrapModel.dart';
import 'AddScrap.dart';
import 'newTabbar.dart';

class AddScrapNew extends StatefulWidget {
  List<String> catiddddList;
  List<String> subcatidddList;
  List<Map<String, dynamic>> selectsubCatMapList = [];

  AddScrapNew(
      {required this.catiddddList,
      required this.subcatidddList,
      required this.selectsubCatMapList});

  @override
  State<AddScrapNew> createState() => _AddScrapNewState();
}

class _AddScrapNewState extends State<AddScrapNew> {
  TextEditingController serviceNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  String? selectedCategory;
  String? selectedSubcategory;
  AllCateModel? collectionModal;

  List<MaterCategoryModel> masterCatList = [];

  bool isLoading = false;

  MaterCategoryModel? masterData;
  String? selectedMasterCategory;

  //get multiple data

  getMaterCategory() async {
    var headers = {
      'Cookie': 'ci_session=911aff6f1f7ad6b9772ceea1f8048b8a690650a5'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('${baseUrl()}/get_master_category'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResult = await response.stream.bytesToString();
      final jsonResponse =
          MaterCategoryModel.fromJson(json.decode(finalResult));
      setState(() {
        masterData = jsonResponse;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  CategoryDataModel? categoryDataModel;

  _getCollection() async {
    var headers = {'Cookie': 'ci_session=q39hu16mqqotlba2gnf3n2o189qbuj23'};
    var request = http.MultipartRequest(
        'POST', Uri.parse('${baseUrl()}/get_categories_list_data'));
    request.fields.addAll({'m_cat_id': '$selectedMasterCategory'});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var resuult = await response.stream.bytesToString();
      var finalResult = CategoryDataModel.fromJson(jsonDecode(resuult));
      setState(() {
        categoryDataModel = finalResult;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  //
  // List<Categories> subCatList = [];

  ScarpFormGetcatDataModel? scarpFormGetcatDataModel;

  getSubCategory() async {
    print('$selectedCategory');
    var headers = {'Cookie': 'ci_session=88g0g98qiv75opnue4s1vqffpu3r07t0'};
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://scrapy5.com/api/get_all_cat'));
    request.fields.addAll({'category_id': widget.subcatidddList.toString()});
    print("aaaaaaaaaaaaaaaaa${request.fields}");

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print('get sub category cuccess1');

      var resuult = await response.stream.bytesToString();
      print('get sub category cuccess2');

      var finalResult = ScarpFormGetcatDataModel.fromJson(jsonDecode(resuult));
      print('get sub category cuccess3');

      setState(() {
        print('get sub category cuccess4');

        scarpFormGetcatDataModel = finalResult;
        print(
            'sub cat list length==================================${scarpFormGetcatDataModel?.categories?.length}');
        print('get sub category cuccess5');
      });
    } else {
      print(response.reasonPhrase);
    }

    // var uri = Uri.parse('${baseUrl()}/get_all_cat');
    // var request = new http.MultipartRequest("POST", uri);
    // Map<String, String> headers = {
    //   "Accept": "application/json",
    // };
    // print("checking id here ${selectedCategory}");
    // print(baseUrl.toString());
    // request.headers.addAll(headers);
    // request.fields['category_id'] = selectedCategory.toString();
    // var response = await request.send();
    // print(response.statusCode);
    // String responseData = await response.stream.transform(utf8.decoder).join();
    // var userData = json.decode(responseData);
    //
    // if (mounted) {
    //
    //   setState(() {
    //     subCatList = AllCateModel.fromJson(userData).categories!;
    //     collectionModal = AllCateModel.fromJson(userData);
    //   });
    // }
    // print(responseData);
  }

  OfferModel? offerModeldata;

  String? finalCharge;

  getOfferFunction(var cattId, var subCatId) async {
    print('get offer api');
    var headers = {
      'Cookie': 'ci_session=88e25f8723337d9101be7590e6fdd7e2628e954b'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('${baseUrl()}/get_offer_amount'));
    request.fields.addAll({
      'cat_id': '${cattId.toString()}',
      'sub_cat_id': '${subCatId.toString()}'
    });

    print('get offer  ===============${request.fields}');
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    print("===my technic=======${request.fields}===============");
    print("===my technic=======${request.url}===============");
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = OfferModel.fromJson(json.decode(finalResponse));
      setState(() {
        offerModeldata = jsonResponse;

        if (offerModeldata!.data!.isEmpty) {
          finalCharge = '0';
        } else {
          finalCharge = offerModeldata!.data?[0].discount;
        }
      });
      print('============================get offer success');
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    print('=======================this is scrap increment and decrement page');
    print(
        'scrapfrom=/subcatidddList====================${widget.subcatidddList}');
    print('scrapform/catiddddList================${widget.catiddddList}');
    print(
        '/catiddddList mapp init================${widget.selectsubCatMapList}');
    // TODO: implement initState
    super.initState();

    // _getCollection();
    //getSubCategory();

    //getMaterCategory();
    widget.selectsubCatMapList.forEach((element) {
      tempPrice.add(element['price']);
    });
    getUserDataApicall();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    widget.selectsubCatMapList.clear();
    widget.catiddddList.clear();
    widget.subcatidddList.clear();
  }

  String _dateValue = '';
  String addId = '';
  var dateFormate;

  String? catName;
  String? subCatName;
  TimeOfDay? selectedTime;

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        useRootNavigator: true,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
                // colorScheme: ColorScheme.light(primary: backgroundblack),
                buttonTheme: ButtonThemeData(
                    // colorScheme: ColorScheme.light(primary: backgroundblack)

                    )),
            child: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: false),
                child: child!),
          );
        });
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay.replacing(hour: timeOfDay.hourOfPeriod);
        timeController.text = selectedTime!.format(context);
      });
    }
    var per = selectedTime!.period.toString().split(".");
    print(
        "selected time here ${selectedTime!.format(context).toString()} and ${per[1]}");
  }

  String? sDate;
  File? imageFiles;
  List<ScrapModel> scrapList = [];
  TextEditingController nameController = TextEditingController();

  addDetail(var catiddd, var subcatId, var quantity, var nam, var mastersid,
      var img, var qttty) async {
    print('add scrap api $quantity $qttty');

    int totalValue = 0;

    if (serviceCharge == null ||
        serviceCharge == "" ||
        finalCharge == null ||
        finalCharge == "") {
      if (qttty == "" || qttty == null) {
        print("total value here $totalValue $qttty");
        totalValue = 0;
      } else {
        totalValue = int.parse(qttty.toString()) + int.parse(qttty.toString());
        print("total va;ueee $totalValue and quttttyy $qttty");
      }
    } else if (finalCharge == null ||
        finalCharge == "" || qttty == "" ||
        qttty == null) {
      totalValue = 0;
    } else {
      print("hgshgahdsgdhgdagsd $totalValue ");
      totalValue = qttty;
          // int.parse(serviceCharge.toString()) * int.parse(qttty.toString()) + int.parse(finalCharge.toString());
    }
    var headers = {
      'Cookie': 'ci_session=6bb733371562cedef8b28f44ffc9ae00e52b265a'
    };
    var request =
        http.MultipartRequest('POST', Uri.parse('${baseUrl()}/add_scrap'));
    request.fields.addAll({
      'user_id': "${userID.toString()}",
      'category_id': '${catiddd.toString()}',
      'subcategory_id': '${subcatId.toString()}',
      'qty': '${quantity.toString()}',
      'name': '${nam.toString()}',
      'price': serviceCharge == "" || serviceCharge == null
          ? "0"
          : '${serviceCharge.toString()}',
      'total': '$totalValue',
      'master_category': '$mastersid'
    });

    print("add scrap parameters===== ${request.fields.toString()}");
    print('image file============${img.toString()}');

    request.files.add(
        await http.MultipartFile.fromPath('image', '${img.path.toString()}'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResult = await response.stream.bytesToString();
      print("===my technic=======$finalResult===============");
      final jsonResponse = json.decode(finalResult);
      if (jsonResponse['response_code'] == "1") {
        Fluttertoast.showToast(msg: "Scrap added Successfully In Cart");
        setState(() {
          nameController.clear();
          selectedCategory == null;
          selectedMasterCategory == null;
          selectedSubcategory == null;
          quantityController.clear();
          imageFiles == null;
        });
      }
    } else {
      print(response.reasonPhrase);
      Fluttertoast.showToast(msg: "Something went wrong");
      setState(() {
        isLoading = false;
      });
      //Navigator.of(context).pop();
    }
  }

  GeeUserModel? model;
  String? userCity;

  getUserDataApicall() async {
    print('user data=====${userID}');
    print('get data =====${baseUrl()}/user_data');
    try {
      Map<String, String> headers = {
        'content-type': 'application/x-www-form-urlencoded',
      };
      var map = new Map<String, dynamic>();
      map['user_id'] = userID;

      final response = await client.post(Uri.parse("${baseUrl()}/user_data"),
          headers: headers, body: map);

      var dic = json.decode(response.body);
      Map<String, dynamic> userMap = jsonDecode(response.body);
      print("===my technic=======${baseUrl()}/user_data===============");
      print("===my technic=======$map===============");
      model = GeeUserModel.fromJson(userMap);

      userCity = model!.user!.city.toString();
      print("===my technic=======$userCity===============");
      print("GetUserData>>>>>>");
      print(dic);
    } on Exception {
      // Fluttertoast.showToast(msg: "No Internet connection");
      throw Exception('No Internet connection');
    }
  }

  GetServiceChargeModel? serviceChargeModel;
  String serviceCharge = "0";

  getServiceCharge(var catId, var subCatId) async {
    print('get service api');
    var headers = {
      'Cookie': 'ci_session=153ebf28d2ee5afcf5e84db07b38e2e4bfe5bdef'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('${baseUrl()}/get_service_charge'));
    request.fields.addAll({
      'cat_id': '${catId.toString()}',
      'sub_cat_id': '${subCatId.toString()}',
      'city_id': '${userCity.toString()}',
      //'city_id': '2',
    });
    print(
        "get service api ===================params here ${request.fields.toString()}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse =
          GetServiceChargeModel.fromJson(json.decode(finalResponse));
      setState(() {
        serviceChargeModel = jsonResponse;
        if (serviceChargeModel!.data!.isEmpty) {
          serviceCharge = '0';
        } else {
          serviceCharge = serviceChargeModel!.data![0].charge.toString();
        }
      });
      print('====================get service charge success');

      await getOfferFunction(catId, subCatId);
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundblack,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        // bottom:
        title: Text(
          "${getTranslated(context, 'addScrap')}",
          style: TextStyle(color: appColorWhite),
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
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Container(
          height: MediaQuery.of(context).size.height / 1.3,
          child: ListView.builder(
            itemCount: widget.selectsubCatMapList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Card(
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            InkWell(
                              onTap: () {
                                addImage(index);
                              },
                              child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(),
                                  ),
                                  child: widget.selectsubCatMapList[index]['image'] == null || widget.selectsubCatMapList[index]['image'] == ''
                                      ? Center(
                                          child: Icon(
                                          Icons.camera_alt_outlined,
                                          size: 30,
                                          color: Colors.grey,
                                        ),
                                      )
                                      : Image.file(
                                          widget.selectsubCatMapList[index]['image'],
                                          fit: BoxFit.fill,
                                        ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                addImage(index);
                              },
                              child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(),
                                  ),
                                  child: Center(
                                      child: Icon(
                                    Icons.camera_alt_outlined,
                                    size: 30,
                                    color: Colors.grey,
                                  ))),
                            ),
                          ],
                        ),

                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 4,
                              child: Text(
                                '${widget.selectsubCatMapList[index]['name']}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 4,
                              child: Text(
                                '\u{20B9}${widget.selectsubCatMapList[index]['price']}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // SizedBox(
                            //   width: MediaQuery.of(context).size.width / 4,
                            //   child: Text(
                            //     "(\u{20B9}${widget.selectsubCatMapList[index]['price']})" ?? "",
                            //     maxLines: 1,
                            //     overflow: TextOverflow.ellipsis,
                            //     style: TextStyle(
                            //         decoration: TextDecoration.lineThrough,
                            //         color: Colors.red,
                            //         fontSize: 12,
                            //         fontWeight: FontWeight.normal),
                            //   ),
                            // ),
                            SizedBox(
                              height: 10,
                            ),
                            widget.selectsubCatMapList[index]['qty'] != ""
                                ? Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          print("deceremnettt-----------------");
                                          decrement(
                                            index,
                                          );
                                        },
                                        child: Card(
                                            elevation: 3,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8, right: 8),
                                              child: Text(
                                                '-',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      widget.selectsubCatMapList[index]['qty'] == ''
                                          ? Text('0')
                                          : Text(
                                              '${widget.selectsubCatMapList[index]['qty']}'),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          print("===========increment===========");
                                          incrementt(
                                            index,
                                          );
                                        },
                                        child: Card(
                                            elevation: 3,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8, right: 8),
                                              child: Text(
                                                '+',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                        ),
                                      ),
                                    ],
                                  )
                                : InkWell(
                                    onTap: () {
                                      widget.selectsubCatMapList[index]['qty']='0';
                                      setState(() {
                                        price = widget.selectsubCatMapList[index]['price'];
                                        iiincrement = 0;
                                        indx = index;
                                      });
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width / 4,
                                      height: 30,
                                      child: Center(
                                        child: Text(
                                            '${getTranslated(context, 'Add Quantity')}'),
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ],
                             ),
                        // Spacer(), Column(
                        //   children: [
                        //     // InkWell(
                        //     //
                        //     //   onTap: () {
                        //     //     addImage(index);
                        //     //   },
                        //     //   child: Container(
                        //     //     width: 80,
                        //     //
                        //     //     decoration: BoxDecoration(
                        //     //         borderRadius: BorderRadius.circular(5),
                        //     //         color: backgroundblack
                        //     //
                        //     //     ),
                        //     //     child: Center(
                        //     //       child: Padding(
                        //     //         padding: const EdgeInsets.all(8.0),
                        //     //         child: Text('Add Image',
                        //     //           style: TextStyle(
                        //     //               fontWeight: FontWeight.bold,
                        //     //               fontSize: 9),),
                        //     //       ),
                        //     //     ),
                        //     //
                        //     //   ),
                        //     // ),
                        //     // SizedBox(height: 20,),
                        //     indx==index?
                        //
                        //
                        //     Row(children: [
                        //
                        //       InkWell(
                        //
                        //         onTap: () {
                        //           decrement(index);
                        //         },
                        //         child: Card(
                        //             elevation: 3,
                        //             child: Padding(
                        //               padding: const EdgeInsets.only(
                        //                   left: 8, right: 8),
                        //               child: Text('-', style: TextStyle(
                        //                   fontSize: 25,
                        //                   fontWeight: FontWeight.bold),),
                        //             )),
                        //       ),
                        //
                        //
                        //       SizedBox(width: 10,),
                        //
                        //       widget.selectsubCatMapList[index]['qty'] == '' ?
                        //       Text('0') :
                        //       Text('${widget
                        //           .selectsubCatMapList[index]['qty']}'),
                        //       SizedBox(width: 10,),
                        //       InkWell(
                        //         onTap: () {
                        //           incrementt(index);
                        //         },
                        //
                        //         child: Card(
                        //             elevation: 3,
                        //             child: Padding(
                        //               padding: const EdgeInsets.only(
                        //                   left: 8, right: 8),
                        //               child: Text('+', style: TextStyle(
                        //                   fontSize: 25,
                        //                   fontWeight: FontWeight.w500),),
                        //             )),
                        //       ),
                        //
                        //
                        //     ],):
                        //     InkWell(
                        //       onTap: () {
                        //
                        //         setState(() {
                        //           iiincrement=0;
                        //           indx=index;
                        //
                        //         });
                        //
                        //       },
                        //       child: Container(width: MediaQuery.of(context).size.width/4,
                        //       height: 30,
                        //
                        //         child: Center(child: Text('Add Quantity'),),
                        //         decoration: BoxDecoration(border: Border.all(),
                        //         borderRadius: BorderRadius.circular(8),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        //
                        //
                        // SizedBox(width: 10,),
                        //
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      bottomSheet: InkWell(
        onTap: () {
          checkdata();
          // addDetail();

          // setState(() {
          //   scrapList.add(
          //     ScrapModel(
          //       id: "1",
          //       image: imageFiles!.path.toString(),
          //       category: selectedCategory.toString(),
          //       subCategory: selectedSubcategory.toString(),
          //       qty: quantityController.text.toString(),
          //     ),
          //   );
          // });
          // Navigator.pop(context,scrapList);
        },
        child: Container(
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: backgroundblack, borderRadius: BorderRadius.circular(6)),
          child: isLoading == true
              ? CircularProgressIndicator(
                  color: Colors.white,
                )
              : Text(
                  "${getTranslated(context, 'AddScrapInCart')}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
        ),
      ),
    );
  }

  var iiincrement = 0;

  List <String> tempPrice = [];

  void incrementt(
    int indexx,
  ) {
    setState(() {
      iiincrement++;
     // int price1 = widget.selectsubCatMapList[indexx]['price'];

      if(widget.selectsubCatMapList[indexx]['qty'] == ""){
        widget.selectsubCatMapList[indexx]['qty']= "0";

        widget.selectsubCatMapList[indexx]['qty']=  (int.parse(widget.selectsubCatMapList[indexx]['qty'])+1).toString();
      } else{
        widget.selectsubCatMapList[indexx]['qty']=  (int.parse(widget.selectsubCatMapList[indexx]['qty'])+1).toString();
      }
     // widget.selectsubCatMapList[indexx]['qty'] = iiincrement.toString();
    // finalPrice = int.parse(price1.toString()) *
    int.parse("${widget.selectsubCatMapList[indexx]['qty']}");
      widget.selectsubCatMapList[indexx]['price'] = int.parse(tempPrice[indexx]) *
          int.parse("${widget.selectsubCatMapList[indexx]['qty']}");
      print('with qty===============${widget.selectsubCatMapList}');
    });
  }

  void decrement(
    int indexx,
  ) {
    // if(widget.selectsubCatMapList[indexx]['qty']>=1) {.
    if(int.parse(widget.selectsubCatMapList[indexx]['qty']) > 1){
     // widget.selectsubCatMapList[indexx]['qty']= "0";

      widget.selectsubCatMapList[indexx]['qty']=  (int.parse(widget.selectsubCatMapList[indexx]['qty'])-1).toString();
      widget.selectsubCatMapList[indexx]['price'] = int.parse(tempPrice[indexx]) *
          int.parse("${widget.selectsubCatMapList[indexx]['qty']}");

      setState(() {

      });
    }

    // } else{
    //   widget.selectsubCatMapList[indexx]['qty']=  (int.parse(widget.selectsubCatMapList[indexx]['qty'])+1).toString();
    // }


    // if (iiincrement > 1) {
    //   setState(() {
    //     iiincrement--;
    //     widget.selectsubCatMapList[indexx]['qty'] = iiincrement.toString();
    //     widget.selectsubCatMapList[indexx]['price'] = int.parse(price.toString()) *
    //         int.parse("${widget.selectsubCatMapList[indexx]['qty']}");
    //     print('with qty===============${widget.selectsubCatMapList}');
    //   });
    // }
    // }else{
    //   iiincrement=0;
    //
    // }
  }

  void addImage(int indddex) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () async {
                    PickedFile? image = await ImagePicker.platform
                        .pickImage(source: ImageSource.gallery);
                    imageFiles = File(image!.path);
                    setState(() {
                      widget.selectsubCatMapList[indddex]['image'] = imageFiles;
                      print(
                          'with qty===============${widget.selectsubCatMapList}');
                    });
                    print("image files here ${imageFiles!.path.toString()}");
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.photo),
                      SizedBox(
                        width: 5,
                      ),
                      Text("Gallery")
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () async {
                    PickedFile? image = await ImagePicker.platform
                        .pickImage(source: ImageSource.camera);
                    imageFiles = File(image!.path);
                    print("image files here ${imageFiles!.path.toString()}");
                    setState(() {
                      widget.selectsubCatMapList[indddex]['image'] = imageFiles;
                      print(
                          'with qty===============${widget.selectsubCatMapList}');
                    });
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.camera_alt),
                      SizedBox(
                        width: 5,
                      ),
                      Text("Camera")
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  var check;
  void checkdata() {
    setState(() {
      isLoading = true;
    });

    for (int i = 0; i < widget.selectsubCatMapList.length; i++) {
      if (widget.selectsubCatMapList[i]['image'] == '' ||
          widget.selectsubCatMapList[i]['image'] == null ||
          widget.selectsubCatMapList[i]['qty'] == '' ||
          widget.selectsubCatMapList[i]['qty'] == null) {
        setState(() {
          check = 1;
        });
      } else {
        setState(() {
          check = 0;
        });
      }
    }
    if (check == 0) {
      AddScrap();
    } else {
      Fluttertoast.showToast(
          msg:
              "${getTranslated(context, 'Please add  image and quantity in all Scrap')}");

      setState(() {
        isLoading = false;
      });
    }
  }

  void AddScrap() async {
    for (int i = 0; i < widget.selectsubCatMapList.length; i++) {
      print('loop $i');

      await getServiceCharge(widget.selectsubCatMapList[i]['pid'],
          widget.selectsubCatMapList[i]['catid']);

      await addDetail(
          widget.selectsubCatMapList[i]['pid'],
          widget.selectsubCatMapList[i]['catid'],
          widget.selectsubCatMapList[i]['qty'],
          widget.selectsubCatMapList[i]['name'],
          widget.selectsubCatMapList[i]['mcatId'],
          widget.selectsubCatMapList[i]['image'],
          widget.selectsubCatMapList[i]['price']);
    }
    print('======================== loop complete');

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AddScrapPage(),
        ),
    );
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TabbarScreen(),));

    setState(() {
      isLoading = false;
    });
  }

  var price;
  int? indx;
}
