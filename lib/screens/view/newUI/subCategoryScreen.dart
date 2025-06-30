import 'dart:convert';

import 'package:ez/screens/view/models/categories_model.dart';
import 'package:ez/screens/view/newUI/ScrapForm.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../Helper/session.dart';
import '../../../constant/global.dart';
import 'package:http/http.dart' as http;

import 'addScrapNewPage.dart';

class SubCategoryScreen1 extends StatefulWidget {
  String? id,
      name,
      selectedValue1,
      selectedValue2,
      selectedValue3,
      selectedValueName1,
      selectedValueName2,
      selectedValueName3;
  SubCategoryScreen1(
      {this.id,
      this.name,
      this.selectedValueName1,
      this.selectedValue1,
      this.selectedValueName2,
      this.selectedValue2,
      this.selectedValue3,
      this.selectedValueName3});
  @override
  State<SubCategoryScreen1> createState() => _SubCategoryScreen1State();
}

class _SubCategoryScreen1State extends State<SubCategoryScreen1> {
  Future<Null> refreshFunction() async {
    await getSubCategory();
  }

  List<String> selectedcatIdList = [];
  List<String> selectedSubcatIdList = [];
  List<Map<String, dynamic>> selectsubCat = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSubCategory();
    print(
        "===============================this is sub catogry master screen   ${widget.id.toString()}");
  }

  AllCateModel? collectionModal;
  getSubCategory() async {
    var uri = Uri.parse('${baseUrl()}/get_all_cat');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    print('${baseUrl()}/get_all_cat');
    request.headers.addAll(headers);
    request.fields['category_id'] = widget.id.toString();
    print("category id isss${request.fields}===========");
    var response = await request.send();
    print(response.statusCode);
    print(request.fields);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    if (mounted) {
      setState(() {
        //  subCatList = AllCateModel.fromJson(userData).categories!;
        collectionModal = AllCateModel.fromJson(userData);
      });
    }
    print(responseData);
  }

  bool isButten = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundblack,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
            ),
        ),
        // bottom:
        title: widget.name == null
            ? SizedBox.shrink()
            : Text(
                "${widget.name!.toUpperCase()}",
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
      body: RefreshIndicator(
          onRefresh: refreshFunction,
          child: collectionModal == null
              ? Center(child: CircularProgressIndicator())
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
                    ],
                  ),
                )),
        bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                if (selectedSubcatIdList.isNotEmpty) {
                  print("herere price ${collectionModal!.categories![0].sellingPrice.toString()}");
                  Navigator.pushReplacement(
                    context, MaterialPageRoute(
                      builder: (context) =>
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
                      msg: "${getTranslated(context, 'Please Select Scrap')}");
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
      ),
    );
  }

  Widget bestSellerItems(BuildContext context) {
    return collectionModal!.categories!.length != null
        ? collectionModal!.categories!.isEmpty
            ? Container(
                height: MediaQuery.of(context).size.height / 1.5,
                width: MediaQuery.of(context).size.width,
                child: Center(
                    child: Text("${getTranslated(context, 'noDataToShow')}")),
              )
            : GridView.builder(
                shrinkWrap: true,
                //physics: NeverScrollableScrollPhysics(),
                primary: false,
                padding: EdgeInsets.all(10),
                itemCount: collectionModal!.categories!.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 110 / 130,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 10.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: () {
                        //
                        // Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        //
                        //     ScrapForm
                        //       (
                        //
                        //
                        //
                        //   selectedValue1: widget.selectedValue1,
                        //   selectedValueName1: widget.selectedValueName1,
                        //   selectedValue2: widget.selectedValue2,
                        //   selectedValueName2: widget.selectedValueName2,
                        //   selectedValue3: widget.selectedValue3,
                        //   selectedValueName3: widget.selectedValueName3,
                        //   selectedValue4: collectionModal!.categories![index].id,
                        //   selectedValueName4: collectionModal!.categories![index].cName,
                        //
                        //
                        // )
                        //
                        // ));
                        if (selectedSubcatIdList
                            .contains(collectionModal!.categories![index].id)) {
                          selectedcatIdList
                              .remove(collectionModal!.categories![index].pId);
                          selectedSubcatIdList
                              .remove(collectionModal!.categories![index].id);
                          print(
                              "selectedcatIdList id list here $selectedcatIdList");
                          print(
                              "selectedSubcatIdList id list here $selectedSubcatIdList");
                          for (var i = 0; i < selectedcatIdList.length; i++) {
                            print("cat id loop ${selectedcatIdList[i]}");
                          }
                          for (var i = 0;
                              i < selectedSubcatIdList.length;
                              i++) {
                            print("sub cat id loop ${selectedSubcatIdList[i]}");
                          }
//map type list
                          Map<String, dynamic> newItem = {
                            'catid':
                                '${collectionModal!.categories![index].id}',
                            'pid': '${collectionModal!.categories![index].pId}',
                            'image': '',
                            'name':
                                '${collectionModal!.categories![index].cName}',
                            'mcatId':
                                '${collectionModal!.categories![index].mid}',
                            'qty': '',
                            'price': collectionModal!.categories![index].sellingPrice,
                          };
                          selectsubCat.remove(newItem);
                          print(selectsubCat);
                        } else {
                          selectedcatIdList.add(collectionModal!.categories![index].pId ?? '');
                          selectedSubcatIdList.add(collectionModal!.categories![index].id.toString());
                          print(
                              "selectedcatIdList id list here $selectedcatIdList");
                          print(
                              "selectedSubcatIdList  id list here $selectedSubcatIdList");
                          for (var i = 0; i < selectedcatIdList.length; i++) {
                            print("cat id loop ${selectedcatIdList[i]}");
                          }
                          for (var i = 0;
                              i < selectedSubcatIdList.length;
                              i++) {
                            print("sub cat id loop ${selectedSubcatIdList[i]}");
                          }
                          //map type list
                          Map<String, dynamic> newItem = {
                            'catid':
                                '${collectionModal!.categories![index].id}',
                            'pid': '${collectionModal!.categories![index].pId}',
                            'image': '',
                            'name':
                                '${collectionModal!.categories![index].cName}',
                            'mcatId':
                                '${collectionModal!.categories![index].mid}',
                            'qty': '',
                            'price': collectionModal!.categories![index].sellingPrice,
                          };
                          selectsubCat.add(newItem);
                          print(selectsubCat);
                        }
                        setState(() {});
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
                                          topLeft: Radius.circular(10)),
                                      image: DecorationImage(
                                        image: NetworkImage(collectionModal!
                                            .categories![index].img
                                            .toString()),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  selectedSubcatIdList.contains(collectionModal!.categories![index].id)
                                      ? Align(
                                          alignment: Alignment.topRight,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 3, right: 3),
                                            child: Container(
                                                height: 28,
                                                width: 28,
                                                padding: EdgeInsets.all(1),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    color: backgroundblack),
                                                child: Icon(Icons.check)),
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
                                          width: 85,
                                          child: Text(
                                            collectionModal!.categories![index]
                                                    .cName![0]
                                                    .toUpperCase() +
                                                collectionModal!
                                                    .categories![index].cName!
                                                    .substring(1),
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
                                    Container(height: 5),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "\u{20B9}${collectionModal!.categories![index].sellingPrice.toString()}/" ?? "",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: appColorBlack,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),SizedBox(width: 5,),
                                            Text(
                                              "${collectionModal!.categories![index].unit.toString()}" ?? "",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: appColorBlack,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              "(\u{20B9}${collectionModal!.categories![index].mrp.toString()})" ?? "",
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
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Text(
                                            //   "₹" +
                                            //   collectionModal!.categories![index].,
                                            //   style: TextStyle(
                                            //       color: appColorBlack,
                                            //       fontSize: 16,
                                            //       fontWeight: FontWeight.bold),
                                            // ),
                                            // Container(
                                            //   width: 90,
                                            //   decoration: BoxDecoration(
                                            //
                                            //     borderRadius: BorderRadius.circular(8)
                                            //   ),
                                            //   child: Card(
                                            //     elevation: 1,
                                            //     child: Row(
                                            //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            //       children: [
                                            //         InkWell(
                                            //             onTap: (){
                                            //               setState(() {
                                            //                 counter--;
                                            //               });
                                            //             },
                                            //             child: Icon(Icons.remove,color: Colors.black,)),
                                            //         Text("0"),
                                            //         InkWell(
                                            //             onTap: (){
                                            //               setState(() {
                                            //                 counter++;
                                            //               });
                                            //               print("");
                                            //             },
                                            //             child: Icon(Icons.add,color: Colors.black,)),
                                            //       ],
                                            //     ),
                                            //   ),
                                            // ),
                                            // InkWell(
                                            //     onTap: (){
                                            //       setState(() {
                                            //         isTapped = true;
                                            //       });
                                            //     },
                                            //     child: Icon(Icons.shopping_cart_sharp,color: backgroundblack,)),
                                            // RatingBar.builder(
                                            //   initialRating: catModal
                                            //               .restaurants![index]
                                            //               .resRating ==
                                            //           ""
                                            //       ? 0.0
                                            //       : double.parse(catModal
                                            //           .restaurants![index].resRating
                                            //           .toString()),
                                            //   minRating: 0,
                                            //   direction: Axis.horizontal,
                                            //   allowHalfRating: true,
                                            //   itemCount: 5,
                                            //   itemSize: 15,
                                            //   ignoreGestures: true,
                                            //   unratedColor: Colors.grey,
                                            //   itemBuilder: (context, _) => Icon(
                                            //       Icons.star,
                                            //       color: appColorOrange),
                                            //   onRatingUpdate: (rating) {
                                            //     print(rating);
                                            //   },
                                            // ),
                                          ],
                                        ),
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
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(
                child: CircularProgressIndicator(
              color: Colors.black,
            )),
          );
  }
}
