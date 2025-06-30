import 'dart:convert';

import 'package:ez/models/CategoryDataModel.dart';
import 'package:ez/screens/view/newUI/AllProviderService.dart';
import 'package:ez/screens/view/newUI/subCategoryScreen.dart';
import 'package:ez/screens/view/newUI/viewCategory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../../Helper/session.dart';
import '../../../constant/global.dart';
import '../models/catModel.dart';
import '../models/categories_model.dart';

class SubCategoryScreen extends StatefulWidget {
  final name, id, image, description, selectedValue1, selectedValueName1;
  const SubCategoryScreen(
      {Key? key,
      this.selectedValue1,
      this.name,
      this.selectedValueName1,
      this.id,
      this.description,
      this.image})
      : super(key: key);

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  bool isLoading = false;
  AllCateModel? collectionModal;

  @override
  void initState() {
    super.initState();
    // getSubCategory();
    getCategoryData();
  }

  bool islLoading = false;
  CategoryDataModel? categoryDataModel;
  var catData;
  getCategoryData() async {
    setState(() {
      islLoading = true;
    });
    var response = await http.post(
        Uri.parse("${baseUrl()}/get_categories_list_data"),
        body: {'m_cat_id': '${widget.id}'});
    print("checking response url ${response.request}");
    print("checking response request m_cat_id:${widget.id}");
    var finalData = json.decode(response.body);
    print("here is data now $finalData");
    setState(() {
      catData = finalData;
    });
    setState(() {
      islLoading = false;
    });
    print(
        "checking data here ${catData['data'].length} and ${catData['data']} and");
  }

  getSubCategory() async {
    var uri = Uri.parse('${baseUrl()}/get_all_cat');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    print("uri here ${uri.toString()}");
    print("checking id here ${widget.id}");
    print(baseUrl.toString());
    request.headers.addAll(headers);
    request.fields['category_id'] = widget.id;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);

    if (mounted) {
      setState(() {
        collectionModal = AllCateModel.fromJson(userData);
      });
    }
    print(responseData);
  }

  bool isButten = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomSheet: multiId != null && multiId != ""
            ? InkWell(
                onTap: () {
                  setState(() {
                    isButten = true;
                  });
                  if (multiId != null && multiId != "") {
                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => SubCategoryScreen1(
                          id: multiId.toString(),
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
                child: Container(
                  height: 45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: backgroundblack,
                      borderRadius: BorderRadius.circular(6)),
                  child: isButten == true
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          "${getTranslated(context, 'sellIt')}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                ),
              )
            : SizedBox.shrink(),
        appBar: AppBar(
          backgroundColor: backgroundblack,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          // bottom:
          title: Text(
            widget.name?.toUpperCase() ?? "",
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
          // leading: IconButton(
          //   icon: Icon(
          //     Icons.arrow_back,
          //     color: Colors.black,
          //   ),
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          // ),
        ),
        body: islLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ListView(
                  physics: ScrollPhysics(),
                  children: [
                    // Container(
                    //   child: Stack(
                    //     children: [
                    //       Container(
                    //           height: 150,
                    //           width: MediaQuery.of(context).size.width,
                    //           child: Image.network("${widget.image}",fit: BoxFit.fill,)),
                    //       Align(
                    //         alignment: Alignment.center,
                    //           // left: 1,
                    //           // right: 1,
                    //           // top: 1,
                    //           // bottom: 10,
                    //            child: Padding(
                    //              padding: EdgeInsets.only(top:70),
                    //              child: Text("${widget.name}",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 16),textAlign: TextAlign.center,),
                    //            )),
                    //     ],
                    //   ),
                    // ),
                    // Container(
                    //     padding: EdgeInsets.symmetric(horizontal: 10,vertical: 12),
                    //     child: Text("${widget.description}")),
                    ///
                    // Padding(
                    //   padding:  EdgeInsets.symmetric(vertical: 10),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       InkWell(
                    //         onTap:(){
                    //           Navigator.push(context, MaterialPageRoute(builder: (context) => AllProviderService(catid: widget.id,)));
                    //         },
                    //         child: Container(
                    //           height: 45,
                    //           width: 150,
                    //           alignment: Alignment.center,
                    //           decoration: BoxDecoration(
                    //             border: Border.all(
                    //               color: backgroundblack,
                    //               width: 1,
                    //             ),
                    //             color: backgroundblack.withOpacity(0.6),
                    //             borderRadius: BorderRadius.circular(5)
                    //           ),
                    //           child: Text("View Provider",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    bestSellerItems(context),
                  ],
                ),
              ));
  }

  Widget bestSellerItems(BuildContext context) {
    return catData['data'].isNotEmpty
        ? GridView.builder(
            shrinkWrap: true,
            primary: false,
            padding: EdgeInsets.all(10),
            itemCount: catData['data'].length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 15.0,
              childAspectRatio: 250 / 290,
            ),
            itemBuilder: (BuildContext context, int index) {
              // print("now here ${catData['data'][index]} and now ${catData['data'][index]['id']} and ${catData['data'][index].id}");
              return Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: InkWell(
                  onTap: () {
                    // selectedValue3: collectionModal?.categories?[index].id,
                    // selectedValueName3: collectionModal?.categories?[index].cName,

                    //   ViewCategory(
                    // id: catData['data'][index]['id'],
                    // name: catData['data'][index]['c_name'],
                    // catId: widget.id,
                    // fromSeller: false,
                    // selectedValue1: widget.selectedValue1,
                    // selectedValueName1: widget.selectedValueName1,
                    // selectedValue2: catData['data'][index]['id'],
                    // selectedValueName2: catData['data'][index]['c_name'],)
                    //my comment  =======================below
                    // Navigator.push(
                    //   context,
                    //
                    //   CupertinoPageRoute(
                    //
                    //     builder: (context) =>
                    //       SubCategoryScreen1(
                    //       id:  catData['data'][index]['id'],
                    //       name: catData['data'][index]['c_name'],
                    //       selectedValue1: widget.selectedValue1,
                    //       selectedValueName1: widget.selectedValueName1,
                    //       selectedValue2:  catData['data'][index]['id'],
                    //       selectedValueName2: catData['data'][index]['c_name'],
                    //
                    //
                    //     ),
                    //   ),
                    //
                    //
                    // );

                    if (CatIDD.contains(catData['data'][index]['id'])) {
                      setState(() {
                        CatIDD.remove(catData['data'][index]['id']);
                        multiId = CatIDD.join(",");
                        print("===my technic=======$multiId===============");
                      });
                    } else {
                      setState(() {
                        CatIDD.add(catData['data'][index]['id']);
                        multiId = CatIDD.join(",");
                        print("===my technic=======$multiId===============");
                      });
                    }
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 100,
                              // width: 140,
                              alignment: Alignment.topCenter,
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      catData['data'][index]['img']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                catData['data'][index]['c_name']![0]
                                        .toUpperCase() +
                                    catData['data'][index]['c_name']!
                                        .substring(1),
                                maxLines: 1,
                                style: TextStyle(
                                    color: appColorBlack,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            // Card(
                            //   elevation: 5,
                            //   shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(20),
                            //   ),
                            //   child: Container(
                            //     width: 180,
                            //     child: Padding(
                            //       padding: const EdgeInsets.only(
                            //           bottom: 15, left: 15, right: 5),
                            //       child: Column(
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         mainAxisAlignment: MainAxisAlignment.end,
                            //         children: [
                            //           Text(
                            //             collectionModal!.categories![index].cName!,
                            //             maxLines: 1,
                            //             style: TextStyle(
                            //                 color: appColorBlack,
                            //                 fontSize: 14,
                            //                 fontWeight: FontWeight.bold),
                            //           ),
                            //           Container(height: 10),
                            //           /*Row(
                            //             mainAxisAlignment:
                            //             MainAxisAlignment.spaceBetween,
                            //             crossAxisAlignment:
                            //             CrossAxisAlignment.end,
                            //             children: [
                            //               Column(
                            //                 crossAxisAlignment:
                            //                 CrossAxisAlignment.start,
                            //                 children: [
                            //                   Container(
                            //                     width: 110,
                            //                     child: Text(
                            //                       catModal!.restaurants![index].resDesc!,
                            //                       maxLines: 2,
                            //                       overflow: TextOverflow.ellipsis,
                            //                       style: TextStyle(
                            //                           color: appColorBlack,
                            //                           fontSize: 12,
                            //                           fontWeight: FontWeight.normal),
                            //                     ),
                            //                   ),
                            //                   Text(
                            //                     "₹" + catModal!.restaurants![index].price!,
                            //                     style: TextStyle(
                            //                         color: appColorBlack,
                            //                         fontSize: 16,
                            //                         fontWeight: FontWeight.bold),
                            //                   ),
                            //                   Container(
                            //                     child: Padding(
                            //                         padding: EdgeInsets.all(0),
                            //                         child: Text(
                            //                           "BOOK NOW",
                            //                           style: TextStyle(
                            //                               color: Colors.blue,
                            //                               fontSize: 12),
                            //                         )),
                            //                   ),
                            //                 ],
                            //               ),
                            //
                            //             ],
                            //           ),*/
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // Container(
                            //   height: 100,
                            //   width: 140,
                            //   alignment: Alignment.topCenter,
                            //   decoration: BoxDecoration(
                            //     color: Colors.black45,
                            //     borderRadius: BorderRadius.circular(10),
                            //     image: DecorationImage(
                            //       image: NetworkImage(collectionModal!.categories![index].img!),
                            //       fit: BoxFit.cover,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        CatIDD.contains(catData['data'][index]['id'])
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
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: backgroundblack),
                                      child: Icon(Icons.check)),
                                ),
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        : Container(
            height: MediaQuery.of(context).size.height / 1.5,
            width: MediaQuery.of(context).size.width,
            child: Center(
                child: Text("${getTranslated(context, 'noDataToShow')}")),
          );
  }

  List CatIDD = [];
  var multiId;
}
