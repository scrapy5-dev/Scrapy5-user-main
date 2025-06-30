import 'dart:convert';

import 'package:ez/screens/view/models/NewSubCategoryModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Helper/session.dart';
import '../../constant/global.dart';
import 'package:http/http.dart' as http;

import 'newUI/ScrapForm.dart';
import 'newUI/addScrapNewPage.dart';

class NewSubCategoryScreen extends StatefulWidget {
  var idList;
  var catId;
  NewSubCategoryScreen({this.idList, this.catId});

  @override
  State<NewSubCategoryScreen> createState() => _NewSubCategoryScreenState();
}

class _NewSubCategoryScreenState extends State<NewSubCategoryScreen> {
  List<String> selectedcatIdList = [];
  List<String> selectedSubcatIdList = [];
  var check = false;

  List<Map<String, dynamic>> selectsubCat = [];

  @override
  void initState() {
    print('=catid==form home=====${widget.catId}');
    super.initState();
    Future.delayed(
        Duration(
          seconds: 0,
        ), () {
      return getNewSubCategory();
    });
  }

  NewSubCategoryModel? newSubCategoryModel;

  getNewSubCategory() async {
    // String idLists = widget.idList.join(",");
    // print("cat  id variable in select sub cat page  here is ${idLists}");
    var headers = {
      'Cookie': 'ci_session=297de3b404a7e886997e0d8c9f331f70977b5047'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('${baseUrl()}/get_sub_categories'));
    request.fields.addAll({
      //  'cat_id': '${idLists}'
      'cat_id': '${widget.catId}'
    });
    print("category id is herere ${request.fields}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    print('${baseUrl()}/get_sub_categories');
    print('${request.fields}');

    if (response.statusCode == 200) {
      var finalResult = await response.stream.bytesToString();
      final jsonValue = NewSubCategoryModel.fromJson(json.decode(finalResult));
      setState(() {
        newSubCategoryModel = jsonValue;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColorWhite,
      appBar: AppBar(
        backgroundColor: backgroundblack,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        elevation: 2,
        title: Text(
          "",
          style: TextStyle(
            fontSize: 20,
            color: appColorWhite,
          ),
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
      body: newSubCategoryModel == null
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.black,
            ))
          : newSubCategoryModel?.data?.isEmpty ?? true
              ? Center(
                  child: Text(
                    "No services to show",
                    style: TextStyle(
                        fontSize: 16,
                        color: appColorBlack,
                        fontWeight: FontWeight.w500),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: ListView(
                    children: [
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //     InkWell(
                      //       onTap: () {
                      //         showModalBottomSheet(
                      //             context: context,
                      //             builder: (context) {
                      //               return StatefulBuilder(builder:
                      //                   (BuildContext context,
                      //                       StateSetter setState) {
                      //                 return Container(
                      //                   decoration: BoxDecoration(
                      //                     borderRadius: BorderRadius.only(
                      //                         topLeft: Radius.circular(10),
                      //                         topRight: Radius.circular(10)),
                      //                   ),
                      //                   padding: EdgeInsets.symmetric(
                      //                       horizontal: 12, vertical: 15),
                      //                   child: Column(
                      //                     mainAxisSize: MainAxisSize.min,
                      //                     children: [
                      //                       Text(
                      //                         "Filter by price",
                      //                         style: TextStyle(
                      //                             color: appColorBlack,
                      //                             fontSize: 16,
                      //                             fontWeight: FontWeight.w500),
                      //                       ),
                      //                       SizedBox(
                      //                         height: 10,
                      //                       ),
                      //                       RangeSlider(
                      //                         divisions: 20,
                      //                         activeColor: backgroundblack,
                      //                         labels: RangeLabels(
                      //                           _startValue.round().toString(),
                      //                           _endValue.round().toString(),
                      //                         ),
                      //                         min: 100,
                      //                         max: 10000,
                      //                         values: RangeValues(
                      //                             _startValue, _endValue),
                      //                         onChanged: (values) {
                      //                           setState(() {
                      //                             _startValue = values.start;
                      //                             _endValue = values.end;
                      //                           });
                      //                         },
                      //                       ),
                      //                       // Container(
                      //                       //   decoration: BoxDecoration(
                      //                       //       borderRadius:
                      //                       //       BorderRadius.circular(10),
                      //                       //       border: Border.all(
                      //                       //           color: appColorBlack
                      //                       //               .withOpacity(0.5))),
                      //                       //   child: DropdownButton(
                      //                       //     value: selectedValue,
                      //                       //     underline: Container(),
                      //                       //     icon: Container(
                      //                       //         alignment: Alignment.centerRight,
                      //                       //         width: MediaQuery.of(context)
                      //                       //             .size
                      //                       //             .width /
                      //                       //             1.8,
                      //                       //         child: Padding(
                      //                       //           padding:
                      //                       //           EdgeInsets.only(right: 10),
                      //                       //           child: Icon(
                      //                       //               Icons.keyboard_arrow_down),
                      //                       //         )),
                      //                       //     hint: Padding(
                      //                       //       padding: EdgeInsets.only(left: 5),
                      //                       //       child: Text("Sort by"),
                      //                       //     ),
                      //                       //     items: itemsList.map((items) {
                      //                       //       return DropdownMenuItem(
                      //                       //         value: items['id'],
                      //                       //         child: Padding(
                      //                       //           padding:
                      //                       //           EdgeInsets.only(left: 5),
                      //                       //           child: Text(
                      //                       //               items['name'].toString()),
                      //                       //         ),
                      //                       //       );
                      //                       //     }).toList(),
                      //                       //     onChanged: ( newValue) {
                      //                       //       setState(() {
                      //                       //         selectedValue = newValue.toString();
                      //                       //         print(
                      //                       //             "selected value is ${selectedValue}");
                      //                       //       });
                      //                       //     },
                      //                       //   ),
                      //                       // ),
                      //                       //   SizedBox(height: 20,),
                      //                       // Text("Price Range",style: TextStyle(color: appColorBlack,fontSize: 15,fontWeight: FontWeight.w500),),
                      //                       // Slider(
                      //                       //   label: "price",
                      //                       //   min: 00.0,
                      //                       //   max: 100.0,
                      //                       //   value: _value.toDouble(),
                      //                       //   onChanged: (value) {
                      //                       //     setState(() {
                      //                       //       _value = value.toInt();
                      //                       //     });
                      //                       //   },
                      //                       // ),
                      //                       SizedBox(
                      //                         height: 50,
                      //                       ),
                      //                       Row(
                      //                         mainAxisAlignment:
                      //                             MainAxisAlignment.center,
                      //                         children: [
                      //                           InkWell(
                      //                             onTap: () {
                      //                               setState(() {
                      //                                 getResidential();
                      //                               });
                      //                               Navigator.of(context).pop();
                      //                             },
                      //                             child: Container(
                      //                               width: 100,
                      //                               height: 40,
                      //                               alignment: Alignment.center,
                      //                               decoration: BoxDecoration(
                      //                                 color: backgroundblack,
                      //                                 borderRadius:
                      //                                     BorderRadius.circular(
                      //                                         10),
                      //                               ),
                      //                               child: Text(
                      //                                 "Apply",
                      //                                 style: TextStyle(
                      //                                     color: appColorWhite,
                      //                                     fontSize: 16,
                      //                                     fontWeight:
                      //                                         FontWeight.w600),
                      //                               ),
                      //                             ),
                      //                           ),
                      //                         ],
                      //                       ),
                      //                       // Expanded(child: Slider(value: _value.toDouble(),onChanged: (double newValue){
                      //                       //   setState(() {
                      //                       //     _value = newValue.toInt();
                      //                       //   });
                      //                       // }))
                      //                     ],
                      //                   ),
                      //                 );
                      //               });
                      //             });
                      //       },
                      //       child: Container(
                      //         width: 100,
                      //         padding: EdgeInsets.symmetric(vertical: 6),
                      //         decoration: BoxDecoration(
                      //             color: backgroundblack,
                      //             borderRadius: BorderRadius.circular(8)),
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: [
                      //             Icon(
                      //               Icons.filter_list,
                      //               color: appColorWhite,
                      //             ),
                      //             Text(
                      //               "Filter",
                      //               style: TextStyle(color: appColorWhite),
                      //             )
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //     InkWell(
                      //       onTap: () {
                      //         showModalBottomSheet(
                      //             context: context,
                      //             builder: (context) {
                      //               return StatefulBuilder(builder:
                      //                   (BuildContext context,
                      //                       StateSetter setState) {
                      //                 return Container(
                      //                   decoration: BoxDecoration(
                      //                     borderRadius: BorderRadius.only(
                      //                         topLeft: Radius.circular(10),
                      //                         topRight: Radius.circular(10)),
                      //                   ),
                      //                   padding: EdgeInsets.symmetric(
                      //                       horizontal: 12, vertical: 15),
                      //                   child: Column(
                      //                     mainAxisSize: MainAxisSize.min,
                      //                     children: [
                      //                       Text(
                      //                         "Sort By",
                      //                         style: TextStyle(
                      //                             color: appColorBlack,
                      //                             fontSize: 16,
                      //                             fontWeight: FontWeight.w500),
                      //                       ),
                      //                       SizedBox(
                      //                         height: 10,
                      //                       ),
                      //                       Container(
                      //                         decoration: BoxDecoration(
                      //                             borderRadius:
                      //                                 BorderRadius.circular(10),
                      //                             border: Border.all(
                      //                                 color: appColorBlack
                      //                                     .withOpacity(0.5))),
                      //                         child: DropdownButton(
                      //                           value: selectedValue,
                      //                           underline: Container(),
                      //                           icon: Container(
                      //                               alignment:
                      //                                   Alignment.centerRight,
                      //                               width:
                      //                                   MediaQuery.of(context)
                      //                                           .size
                      //                                           .width /
                      //                                       1.8,
                      //                               child: Padding(
                      //                                 padding: EdgeInsets.only(
                      //                                     right: 10),
                      //                                 child: Icon(Icons
                      //                                     .keyboard_arrow_down),
                      //                               )),
                      //                           hint: Padding(
                      //                             padding:
                      //                                 EdgeInsets.only(left: 5),
                      //                             child: Text("Sort by"),
                      //                           ),
                      //                           items: itemsList.map((items) {
                      //                             return DropdownMenuItem(
                      //                               value: items['id'],
                      //                               child: Padding(
                      //                                 padding: EdgeInsets.only(
                      //                                     left: 5),
                      //                                 child: Text(items['name']
                      //                                     .toString()),
                      //                               ),
                      //                             );
                      //                           }).toList(),
                      //                           onChanged: (newValue) {
                      //                             setState(() {
                      //                               selectedValue =
                      //                                   newValue.toString();
                      //                               print(
                      //                                   "selected value is ${selectedValue}");
                      //                             });
                      //                           },
                      //                         ),
                      //                       ),
                      //                       //   SizedBox(height: 20,),
                      //                       // Text("Price Range",style: TextStyle(color: appColorBlack,fontSize: 15,fontWeight: FontWeight.w500),),
                      //                       // Slider(
                      //                       //   label: "price",
                      //                       //   min: 00.0,
                      //                       //   max: 100.0,
                      //                       //   value: _value.toDouble(),
                      //                       //   onChanged: (value) {
                      //                       //     setState(() {
                      //                       //       _value = value.toInt();
                      //                       //     });
                      //                       //   },
                      //                       // ),
                      //                       SizedBox(
                      //                         height: 50,
                      //                       ),
                      //                       Row(
                      //                         mainAxisAlignment:
                      //                             MainAxisAlignment.center,
                      //                         children: [
                      //                           InkWell(
                      //                             onTap: () {
                      //                               setState(() {
                      //                                 getResidential();
                      //                               });
                      //                               Navigator.of(context).pop();
                      //                             },
                      //                             child: Container(
                      //                               width: 100,
                      //                               height: 40,
                      //                               alignment: Alignment.center,
                      //                               decoration: BoxDecoration(
                      //                                 color: backgroundblack,
                      //                                 borderRadius:
                      //                                     BorderRadius.circular(
                      //                                         10),
                      //                               ),
                      //                               child: Text(
                      //                                 "Apply",
                      //                                 style: TextStyle(
                      //                                     color: appColorWhite,
                      //                                     fontSize: 16,
                      //                                     fontWeight:
                      //                                         FontWeight.w600),
                      //                               ),
                      //                             ),
                      //                           ),
                      //                         ],
                      //                       ),
                      //                       // Expanded(child: Slider(value: _value.toDouble(),onChanged: (double newValue){
                      //                       //   setState(() {
                      //                       //     _value = newValue.toInt();
                      //                       //   });
                      //                       // }))
                      //                     ],
                      //                   ),
                      //                 );
                      //               });
                      //             });
                      //         //Navigator.push(context, MaterialPageRoute(builder: (context) => FilterPage()));
                      //       },
                      //       child: Container(
                      //         width: 100,
                      //         padding: EdgeInsets.symmetric(vertical: 6),
                      //         decoration: BoxDecoration(
                      //             color: backgroundblack,
                      //             borderRadius: BorderRadius.circular(8)),
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: [
                      //             Icon(
                      //               Icons.sort,
                      //               color: appColorWhite,
                      //             ),
                      //             Text(
                      //               "Sort by",
                      //               style: TextStyle(color: appColorWhite),
                      //             )
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      bestSellerItems(context),
                      SizedBox(
                        height: 100,
                      )
                    ],
                  ),
                ),
          bottomSheet: selectedSubcatIdList.isNotEmpty
          ? Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isButten = true;
                      });
                      if (selectedSubcatIdList.isNotEmpty) {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
                                    // ScrapForm
                                    AddScrapNew(
                                      catiddddList: selectedcatIdList,
                                      subcatidddList: selectedSubcatIdList,
                                      selectsubCatMapList: selectsubCat,
                                      // selectedValue1: widget.selectedValue1,
                                      // selectedValueName1: widget.selectedValueName1,
                                      // selectedValue2: widget.selectedValue2,
                                      // selectedValueName2: widget.selectedValueName2,
                                      //fghjklkjhgf
                                      // selectedValue3: newSubCategoryModel!.data![index].catId,
                                      // selectedValueName3: newSubCategoryModel!.data![index].cName,
                                      // selectedValue4: newSubCategoryModel!.data![index].catsubId,
                                      // selectedValueName4: newSubCategoryModel!.data![index].subTitle,
                                    ),
                            ),
                        );
                        setState(() {
                          isButten = false;
                        });
                      } else {
                        Fluttertoast.showToast(
                            msg:
                                "${getTranslated(context, 'Please Select Scrap')}");
                        setState(() {
                          isButten = false;
                        });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Container(
                          height: 45,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: backgroundblack,
                              borderRadius: BorderRadius.circular(6)),
                          child: !isButten
                              ? Text(
                                  "${getTranslated(context, 'sellIt')}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                )
                              : CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : SizedBox.shrink(),
    );
  }

  bool isButten = false;
  Widget bestSellerItems(BuildContext context) {
    return newSubCategoryModel!.data != 0
        ? GridView.builder(
            shrinkWrap: true,
            //physics: NeverScrollableScrollPhysics(),
            primary: false,
            padding: EdgeInsets.all(10),
            itemCount: newSubCategoryModel!.data!.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 115 / 130,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 10.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () {
                    if (selectedSubcatIdList
                        .contains(newSubCategoryModel!.data![index].id)) {
                      print('iff');
                      selectedcatIdList
                          .remove(newSubCategoryModel!.data![index].pId);
                      selectedSubcatIdList
                          .remove(newSubCategoryModel!.data![index].id);
                      print(
                          "selectedcatIdList id list here $selectedcatIdList");
                      print(
                          "selectedSubcatIdList id list here $selectedSubcatIdList");
                      for (var i = 0; i < selectedcatIdList.length; i++) {
                        print("cat id loop ${selectedcatIdList[i]}");
                      }
                      for (var i = 0; i < selectedSubcatIdList.length; i++) {
                        print("sub cat id loop ${selectedSubcatIdList[i]}");
                      }
                      // new map list
                      //     Map<String, dynamic> newItem = {
                      //       'catid': '${newSubCategoryModel!.data![index].id}',
                      //       'pid': '${newSubCategoryModel!.data![index].pId}',
                      //       'image': '',
                      //       'name': '${newSubCategoryModel!.data![index].cName}',
                      //       'mcatId': '${newSubCategoryModel!.data![index].mCatId}',
                      //       'qty': '',
                      //       'price': '',
                      //
                      //     };
                      //     selectsubCat.remove(newItem);
                      selectsubCat.removeAt(index);
                    } else {
                      print('else');
                      selectedcatIdList
                          .add(newSubCategoryModel!.data![index].pId ?? '');
                      selectedSubcatIdList
                          .add(newSubCategoryModel!.data![index].id.toString());
                      print(
                          "selectedcatIdList id list here $selectedcatIdList");
                      print(
                          "selectedSubcatIdList  id list here $selectedSubcatIdList");
                      for (var i = 0; i < selectedcatIdList.length; i++) {
                        print("cat id loop ${selectedcatIdList[i]}");
                      }
                      for (var i = 0; i < selectedSubcatIdList.length; i++) {
                        print("sub cat id loop ${selectedSubcatIdList[i]}");
                      }
                      //new map list
                      Map<String, dynamic> newItem = {
                        'catid': '${newSubCategoryModel!.data![index].id}',
                        'pid': '${newSubCategoryModel!.data![index].pId}',
                        'image': '',
                        'name': '${newSubCategoryModel!.data![index].cName}',
                        'mcatId': '${newSubCategoryModel!.data![index].mCatId}',
                        'qty': '',
                        'price': '${newSubCategoryModel!.data![index].sellingPrice}',
                      };
                      selectsubCat.add(newItem);
                    }
                    setState(() {});
                    // //fghjkl;l'kjmhfghbjn
                    // // Navigator.push(
                    // //   context,
                    // //   MaterialPageRoute(
                    // //       builder: (context) => DetailScreen(
                    // //             resId: collectionModal!.categories![index].id,
                    // //           )),
                    // // );
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => ScrapForm(
                    //   // selectedValue1: widget.selectedValue1,
                    //   // selectedValueName1: widget.selectedValueName1,
                    //   // selectedValue2: widget.selectedValue2,
                    //   // selectedValueName2: widget.selectedValueName2,
                    //   //fghjklkjhgf
                    //   // selectedValue3: newSubCategoryModel!.data![index].catId,
                    //   // selectedValueName3: newSubCategoryModel!.data![index].cName,
                    //   // selectedValue4: newSubCategoryModel!.data![index].catsubId,
                    //   // selectedValueName4: newSubCategoryModel!.data![index].subTitle,
                    // )));
                    print('id============$selectedSubcatIdList');
                    print('id============$selectsubCat');
                    print('ckeck============$check');
                  },
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      width: 210,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 100,
                                alignment: Alignment.topCenter,
                                decoration: BoxDecoration(
                                  color: Colors.black45,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10),
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "${newSubCategoryModel!.data![index].img.toString()}"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              selectedSubcatIdList.contains(newSubCategoryModel!.data![index].id)
                                  ? Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 3, right: 3),
                                        child: Container(
                                            height: 28,
                                            width: 28,
                                            padding: EdgeInsets.all(1),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(100),
                                                color: backgroundblack),
                                            child: Icon(Icons.check),
                                        ),
                                      ),
                                    )
                                  : SizedBox.shrink(),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 12, left: 8, right: 8, bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  // mainAxisAlignment:
                                  // MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 110,
                                      child: Text(
                                        newSubCategoryModel!.data![index].cName![0].toUpperCase() + newSubCategoryModel!.data![index].cName!.substring(1),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            height: 1.2,
                                            color: appColorBlack,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    // Text(
                                    //     "${catModal.restaurants![index].cityName}"),
                                  ],
                                ),
                                // Container(height: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "\u{20B9}${newSubCategoryModel!.data![index].sellingPrice.toString()}/" ?? "",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: appColorBlack,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: 5,),
                                        Text(
                                          "${newSubCategoryModel!.data![index].unit.toString()}" ?? "",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: appColorBlack,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: 5,),
                                        Text(
                                          "(\u{20B9}${newSubCategoryModel!.data![index].mrp.toString()})" ?? "",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              decoration: TextDecoration.lineThrough,
                                              color: Colors.red,
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                    // charge comment
                                    //
                                    // Row(
                                    //   mainAxisAlignment:
                                    //   MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     Text(
                                    //       "₹" +
                                    //           newSubCategoryModel!.data![index].charge.toString(),
                                    //       style: TextStyle(
                                    //           color: appColorBlack,
                                    //           fontSize: 16,
                                    //           fontWeight: FontWeight.bold),
                                    //     ),
                                    //     // Container(
                                    //     //   width: 90,
                                    //     //   decoration: BoxDecoration(
                                    //     //
                                    //     //     borderRadius: BorderRadius.circular(8)
                                    //     //   ),
                                    //     //   child: Card(
                                    //     //     elevation: 1,
                                    //     //     child: Row(
                                    //     //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    //     //       children: [
                                    //     //         InkWell(
                                    //     //             onTap: (){
                                    //     //               setState(() {
                                    //     //                 counter--;
                                    //     //               });
                                    //     //             },
                                    //     //             child: Icon(Icons.remove,color: Colors.black,)),
                                    //     //         Text("0"),
                                    //     //         InkWell(
                                    //     //             onTap: (){
                                    //     //               setState(() {
                                    //     //                 counter++;
                                    //     //               });
                                    //     //               print("");
                                    //     //             },
                                    //     //             child: Icon(Icons.add,color: Colors.black,)),
                                    //     //       ],
                                    //     //     ),
                                    //     //   ),
                                    //     // ),
                                    //     // InkWell(
                                    //     //     onTap: (){
                                    //     //       setState(() {
                                    //     //         isTapped = true;
                                    //     //       });
                                    //     //     },
                                    //     //     child: Icon(Icons.shopping_cart_sharp,color: backgroundblack,)),
                                    //     // RatingBar.builder(
                                    //     //   initialRating: catModal
                                    //     //               .restaurants![index]
                                    //     //               .resRating ==
                                    //     //           ""
                                    //     //       ? 0.0
                                    //     //       : double.parse(catModal
                                    //     //           .restaurants![index].resRating
                                    //     //           .toString()),
                                    //     //   minRating: 0,
                                    //     //   direction: Axis.horizontal,
                                    //     //   allowHalfRating: true,
                                    //     //   itemCount: 5,
                                    //     //   itemSize: 15,
                                    //     //   ignoreGestures: true,
                                    //     //   unratedColor: Colors.grey,
                                    //     //   itemBuilder: (context, _) => Icon(
                                    //     //       Icons.star,
                                    //     //       color: appColorOrange),
                                    //     //   onRatingUpdate: (rating) {
                                    //     //     print(rating);
                                    //     //   },
                                    //     // ),
                                    //   ],
                                    // ),
                                    //
                                    //
                                    // charge comment
                                    //   Text("Book Service",style: TextStyle(color: backgroundblack,fontWeight: FontWeight.w600,),)

                                    // Container(
                                    //   child: Padding(
                                    //       padding: EdgeInsets.all(0),
                                    //       child: Text(
                                    //         "BOOK NOW",
                                    //         style: TextStyle(
                                    //             color: Colors.blue,
                                    //             fontSize: 12),
                                    //       )),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        : Container(
            height: 100,
            child: Center(
              child: Text(
                "No Services Available",
                style: TextStyle(
                  color: appColorBlack,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          );
  }
}
