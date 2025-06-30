import 'dart:convert';
import 'dart:developer';

import 'package:ez/screens/view/newUI/subCategoryScreen.dart';
import 'package:ez/screens/view/newUI/sub_category.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Helper/session.dart';
import 'package:http/http.dart' as http;

import '../../../constant/global.dart';
import '../../../models/SearchModel.dart';
import 'ScrapForm.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchApi("");
    // getSerchdata();
  }

  bool currentIndex = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF00FFFF),
            flexibleSpace: Card(
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width / 1.1,
                child: Row(children: [
                  SizedBox(
                    width: 15,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child:
                          Icon(Icons.arrow_back_ios, color: Color(0xFF00FFFF))),
                  SizedBox(
                    width: 15,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: TextField(
                      autofocus: true,
                      cursorColor: Colors.black,
                      controller: searchController,
                      onChanged: (value) {
                        // setSearchData(value);
                        searchApi(value);
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "${getTranslated(context, 'Search')}",
                          hintStyle: TextStyle(color: Color(0xFF00FFFF))),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ]),
              ),
            ),
            automaticallyImplyLeading: false,
          ),
          body: searchModel?.category == null ||
                  searchModel?.category == " " ||
                  searchModel?.subCategory == null ||
                  searchModel?.subCategory == "" ||
                  searchModel?.masterCategory == null ||
                  searchModel?.masterCategory == ""
              ? Container(
                  height: MediaQuery.of(context).size.height / 1.3,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Stack(
                  children: [
                    SingleChildScrollView(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          // ListView.builder(
                          //   physics: NeverScrollableScrollPhysics(),
                          //   shrinkWrap: true,
                          //   itemCount: searchModel?.category?.length ?? 0,
                          //   itemBuilder: (context, index) {
                          //     return InkWell(
                          //         onTap: () {
                          //           // Navigator.push(
                          //           //   context,
                          //           //   MaterialPageRoute(
                          //           //       builder: (context) =>
                          //           //
                          //           //           ScrapForm(
                          //           //
                          //           //           )
                          //           //   ),
                          //           // );
                          //         },
                          //         child: Card(
                          //           shape: RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(15.0),
                          //           ),
                          //           elevation: 3,
                          //           child: Container(
                          //             height: 100,
                          //             decoration: BoxDecoration(
                          //                 borderRadius:
                          //                     BorderRadius.circular(15),
                          //                 color: Colors.white),
                          //             child: Row(
                          //               crossAxisAlignment:
                          //                   CrossAxisAlignment.center,
                          //               children: [
                          //                 Container(
                          //                   height: 100,
                          //                   width: 100,
                          //                   decoration: BoxDecoration(
                          //                       image: DecorationImage(
                          //                           image: NetworkImage(
                          //                               '${searchModel?.category?[index].img}'),
                          //                           fit: BoxFit.fill),
                          //                       borderRadius:
                          //                           BorderRadius.circular(15),
                          //                       color: Colors.white),
                          //                 ),
                          //                 SizedBox(
                          //                   width: 20,
                          //                 ),
                          //                 SizedBox(
                          //                   width: 100,
                          //                   child: Text(
                          //                     "${searchModel?.category?[index].description}",
                          //                     style: TextStyle(
                          //                         fontSize: 14,
                          //                         fontWeight: FontWeight.w500),
                          //                     maxLines: 1,
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //         ),
                          //     );
                          //   },
                          // ),
                          // ListView.builder(
                          //   physics: NeverScrollableScrollPhysics(),
                          //   shrinkWrap: true,
                          //   itemCount: searchModel?.subCategory?.length ?? 0,
                          //   itemBuilder: (context, index) {
                          //     return InkWell(
                          //       onTap: () {
                          //         Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //               builder: (context) =>
                          //                   SubCategoryScreen1(
                          //                     id: searchModel
                          //                         ?.subCategory?[index].id,
                          //                     name: searchModel
                          //                         ?.subCategory?[index].cName,
                          //
                          //                     // selectedValue1: widget.selectedValue1,
                          //                     // selectedValueName1: widget.selectedValueName1,
                          //                     // selectedValue2:  catData['data'][index]['id'],
                          //                     // selectedValueName2: catData['data'][index]['c_name'],
                          //                     //
                          //                   )),
                          //         );
                          //       },
                          //       child: Card(
                          //         shape: RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(15.0),
                          //         ),
                          //         elevation: 3,
                          //         child: Container(
                          //           height: 100,
                          //           decoration: BoxDecoration(
                          //               borderRadius: BorderRadius.circular(15),
                          //               color: Colors.white),
                          //           child: Row(
                          //             crossAxisAlignment:
                          //                 CrossAxisAlignment.center,
                          //             children: [
                          //               Container(
                          //                 height: 100,
                          //                 width: 100,
                          //                 decoration: BoxDecoration(
                          //                     image: DecorationImage(
                          //                         image: NetworkImage(
                          //                             '${searchModel?.subCategory?[index].img}'),
                          //                         fit: BoxFit.fill),
                          //                     borderRadius:
                          //                         BorderRadius.circular(15),
                          //                     color: Colors.white),
                          //               ),
                          //               SizedBox(
                          //                 width: 20,
                          //               ),
                          //               SizedBox(
                          //                 width: 100,
                          //                 child: Text(
                          //                   "${searchModel?.subCategory?[index].cName}",
                          //                   style: TextStyle(
                          //                       fontSize: 14,
                          //                       fontWeight: FontWeight.w500),
                          //                   maxLines: 1,
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     );
                          //   },
                          // ),
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: searchModel?.category?.length ?? 0,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SubCategoryScreen1(
                                              id: searchModel?.category?[index].id,
                                              // name: searchModel?.masterCategory?[index].,
                                              // image: searchModel?.category?[index].img,
                                              // description: "",
                                              // selectedValue1: masterData!.data![index].id,
                                              // selectedValueName1: masterData!.data![index].categories,
                                            ),
                                         // ViewCategory(id: categories.id!, name: categories.cName!)
                                        ),
                                  );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  elevation: 3,
                                  child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage('${searchModel?.category?[index].img}'),
                                                  fit: BoxFit.fill),
                                              borderRadius: BorderRadius.circular(15),
                                              color: Colors.white),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 20),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                width: 50,
                                                child: Text(
                                                  "${searchModel?.category?[index].cName}",
                                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                                  maxLines: 1,
                                                ),
                                              ),
                                              // Row(
                                              //   children: [
                                              //     Text(
                                              //       "\u{20B9}${searchModel?.category?[index].sellingPrice}/",
                                              //       style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                              //       maxLines: 1,
                                              //     ),
                                              //     SizedBox(height: 5),
                                              //     Text(
                                              //       "${searchModel?.category?[index].unit}",
                                              //       style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                              //       maxLines: 1,
                                              //     ),
                                              //     Text(
                                              //       "(\u{20B9}${searchModel?.category?[index].mrp})",
                                              //       overflow: TextOverflow.ellipsis,
                                              //       style: TextStyle(
                                              //           decoration: TextDecoration.lineThrough,
                                              //           color: Colors.red,
                                              //           fontSize: 12,
                                              //           fontWeight: FontWeight.normal),
                                              //     ),
                                              //   ],
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
//               searchList.isEmpty?SizedBox.shrink():
//               Container(
//                 height: 200,
//                 color: Colors.white,
//                 child: Padding(
//                   padding: const EdgeInsets.all(15),
//                   child: Column(
//                     children: [
//                       Row(children: [
// Spacer(),
//                         InkWell(
//                             onTap: () async {
//                               final SharedPreferences prefs = await SharedPreferences.getInstance();
//                               searchList.clear();
//                               prefs.remove('items');
//                               setState(() {
//
//                               });
//                             },
//                             child: Text("${getTranslated(context, 'CLEARALL')}",style: TextStyle(fontSize: 13,color: Colors.red),))
//
//
//                       ],),
//                       Container(
// height: 150,
//                         child: ListView.builder(
// reverse: true,
//                           itemCount: searchList.length??0,
//                           itemBuilder: (context, index) {
//                           return
//
//
//                             InkWell(
//                               onTap: () {
//
//                                 setState(() {
//                                   searchController.text=searchList[index].toString();
//                                 });
//                               },
//                               child: Container(height: 30,
//                                                         width: MediaQuery.of(context).size.width,
//                               child: Padding(
//                                 padding: const EdgeInsets.only( right: 10,left: 10),
//                                 child: Row(children: [
//                                   Text(searchList[index],style: TextStyle(fontSize: 12,color: Colors.grey),),
//
//
//                                 ]),
//                               ),
//                                                         ),
//                             );
//                         },),
//                       ),
//                     ],
//                   ),
//                 ),
//               )
                  ],
                ),
      ),
    );
  }

  SearchModel? searchModel;

  Future<void> searchApi(String val) async {
    var headers = {'Cookie': 'ci_session=150ah7cca9g5b61a3nbpvaa41ch6lihe'};
    var request = http.MultipartRequest(
        'POST', Uri.parse('${baseUrl()}/search_category'));
    request.fields.addAll({'search': val});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    print("===my technic serach=======${request.fields}===============");
    print("===my technic=======${request.url}===============");
    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalResult2 = jsonDecode(result);
      var finalresult = SearchModel.fromJson(finalResult2);
      log(" serach issss $result");
      setState(() {
        searchModel = finalresult;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> setSearchData(String setStringg) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (searchList.contains(setStringg)) {
      print("===my technic======contain=============");
    } else {
      print("===my technic======not containcontain=============");
      searchList.add(setStringg);
      await prefs.setStringList('items', searchList);
      setState(() {});
    }
  }

  List<String> searchList = [];
  getSerchdata() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    searchList = prefs.getStringList('items') ?? [];
  }
}
