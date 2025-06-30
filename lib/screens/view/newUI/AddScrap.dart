// import 'dart:convert';
// import 'dart:io';
//
// import 'package:ez/models/GetScrapModel.dart';
// import 'package:ez/screens/view/models/scrapModel.dart';
// import 'package:ez/screens/view/newUI/ScrapForm.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../constant/global.dart';
// import '../models/categories_model.dart';
//
// class AddScrapPage extends StatefulWidget {
//   const AddScrapPage({Key? key}) : super(key: key);
//
//   @override
//   State<AddScrapPage> createState() => _AddScrapPageState();
// }
//
// class _AddScrapPageState extends State<AddScrapPage> {
//   TextEditingController serviceNameController = TextEditingController();
//   TextEditingController locationController = TextEditingController();
//   TextEditingController timeController = TextEditingController();
//   TextEditingController dateController = TextEditingController();
//   TextEditingController quantityController = TextEditingController();
//
//   String? selectedCategory;
//   String? selectedSubcategory;
//
//   AllCateModel? collectionModal;
//
//   List<Categories> catlist = [];
//   _getCollection() async {
//     var uri = Uri.parse('${baseUrl()}/get_all_cat');
//     var request = new http.MultipartRequest("GET", uri);
//     Map<String, String> headers = {
//       "Accept": "application/json",
//     };
//     print(baseUrl.toString());
//
//     request.headers.addAll(headers);
//     // request.fields['vendor_id'] = userID;
//     var response = await request.send();
//     print(response.statusCode);
//     String responseData = await response.stream.transform(utf8.decoder).join();
//     var userData = json.decode(responseData);
//
//     if (mounted) {
//       setState(() {
//         collectionModal = AllCateModel.fromJson(userData);
//         catlist = AllCateModel.fromJson(userData).categories!;
//         print(
//             "ooooo ${collectionModal!.status} and ${collectionModal!.categories!.length} and ${userID}");
//       });
//     }
//     print(responseData);
//   }
//
//   List<Categories> subCatList = [];
//
//   getSubCategory() async {
//     var uri = Uri.parse('${baseUrl()}/get_all_cat');
//     var request = new http.MultipartRequest("POST", uri);
//     Map<String, String> headers = {
//       "Accept": "application/json",
//     };
//     print("checking id here ${selectedCategory}");
//     print(baseUrl.toString());
//     request.headers.addAll(headers);
//     request.fields['category_id'] = selectedCategory.toString();
//     var response = await request.send();
//     print(response.statusCode);
//     String responseData = await response.stream.transform(utf8.decoder).join();
//     var userData = json.decode(responseData);
//
//     if (mounted) {
//       setState(() {
//         subCatList = AllCateModel.fromJson(userData).categories!;
//         collectionModal = AllCateModel.fromJson(userData);
//       });
//     }
//     print(responseData);
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _getCollection();
//     getScrapData();
//     getData();
//   }
//
//   String _dateValue = '';
//   String addId = '';
//   var dateFormate;
//   String _pickedLocation = '';
//   // Future getAddress(id) async {
//   //   var request =
//   //   http.MultipartRequest('POST', Uri.parse('${baseUrl()}/get_address'));
//   //   request.fields.addAll({'id': '$id', 'user_id': '$userID'});
//   //
//   //   print(request);
//   //   print(request.fields);
//   //
//   //   http.StreamedResponse response = await request.send();
//   //   if (response.statusCode == 200) {
//   //     final str = await response.stream.bytesToString();
//   //     final jsonResponse = AddressModel.fromJson(json.decode(str));
//   //     if (jsonResponse.responseCode == "1") {
//   //       setState(() {
//   //         _pickedLocation =
//   //         "${jsonResponse.data![0].address!}, ${jsonResponse.data![0].building}";
//   //       });
//   //     }
//   //     print(_pickedLocation);
//   //     return AddressModel.fromJson(json.decode(str));
//   //   } else {
//   //     return null;
//   //   }
//   // }
//   // final _formKey = GlobalKey<FormState>();
//   // Future _selectDate() async {
//   //   DateTime? picked = await showDatePicker(
//   //       context: context,
//   //       initialDate: new DateTime.now(),
//   //       firstDate: DateTime.now(),
//   //       lastDate: DateTime(2025),
//   //       //firstDate: DateTime.now().subtract(Duration(days: 1)),
//   //       // lastDate: new DateTime(2022),
//   //       builder: (BuildContext context, Widget? child) {
//   //         return Theme(
//   //           data: ThemeData.light().copyWith(
//   //               primaryColor: Colors.black, //Head background
//   //               accentColor: Colors.black,
//   //               colorScheme:
//   //               ColorScheme.light(primary: const Color(0xFFEB6C67)),
//   //               buttonTheme:
//   //               ButtonThemeData(textTheme: ButtonTextTheme.accent)),
//   //           child: child!,
//   //         );
//   //       });
//   //   if (picked != null)
//   //     setState(() {
//   //       String yourDate = picked.toString();
//   //       _dateValue = convertDateTimeDisplay(yourDate);
//   //       print(_dateValue);
//   //       dateFormate =
//   //           DateFormat("dd/MM/yyyy").format(DateTime.parse(_dateValue ?? ""));
//   //       sDate = DateFormat("dd-MM-yyyy").format(DateTime.parse(_dateValue ?? ""));
//   //       dateController.text = dateFormate;
//   //     });
//   // }
//   //
//   // String convertDateTimeDisplay(String date) {
//   //   final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
//   //   final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
//   //   final DateTime displayDate = displayFormater.parse(date);
//   //   final String formatted = serverFormater.format(displayDate);
//   //   return formatted;
//   // }
//
//   String? catName;
//   String? subCatName;
//   TimeOfDay? selectedTime;
//   _selectTime(BuildContext context) async {
//     final TimeOfDay? timeOfDay = await showTimePicker(
//         context: context,
//         useRootNavigator: true,
//         initialTime: TimeOfDay.now(),
//         builder: (BuildContext context, Widget? child) {
//           return Theme(
//             data: ThemeData.light().copyWith(
//                 colorScheme: ColorScheme.light(primary: backgroundblack),
//                 buttonTheme: ButtonThemeData(
//                     colorScheme: ColorScheme.light(primary: backgroundblack))),
//             child: MediaQuery(
//                 data: MediaQuery.of(context)
//                     .copyWith(alwaysUse24HourFormat: false),
//                 child: child!),
//           );
//         });
//     if (timeOfDay != null && timeOfDay != selectedTime) {
//       setState(() {
//         selectedTime = timeOfDay.replacing(hour: timeOfDay.hourOfPeriod);
//         timeController.text = selectedTime!.format(context);
//       });
//     }
//     var per = selectedTime!.period.toString().split(".");
//     print(
//         "selected time here ${selectedTime!.format(context).toString()} and ${per[1]}");
//   }
//
//   String? sDate;
//
//   File? imageFiles;
//
// GetScrapModel? scrapModel;
//
// String? catData,subCatData,imageData,qtyData;
// String? currentAddress;
//   getScrapData()async{
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//    String? latitude =  prefs.getString('lati');
//    String? longitude =  prefs.getString('longi');
//    print("latitude and longitude ${latitude} and ${longitude}");
//
//     print("user id ${userID}");
//     var headers = {
//       'Cookie': 'ci_session=09ce4c54a28ddd34fbb121d896a5c2f033453c7c'
//     };
//     var request = http.MultipartRequest('POST', Uri.parse('${baseUrl()}/get_scrap_data'));
//     request.fields.addAll({
//       'user_id': '${userID}'
//     });
//     request.headers.addAll(headers);
//     http.StreamedResponse response = await request.send();
//     if (response.statusCode == 200) {
//       var finalResult = await response.stream.bytesToString();
//       final jsonResponse = GetScrapModel.fromJson(json.decode(finalResult));
//       setState(() {
//         scrapModel = jsonResponse;
//       });
//       print("checking data length here ${scrapModel!.data!.length}");
//       for(var i=0;i<scrapModel!.data!.length;i++){
//         categoryNameList.add(scrapModel!.data![i].categoryId.toString());
//         subCategoryNameList.add(scrapModel!.data![i].subcategoryId.toString());
//         quantityList.add(scrapModel!.data![i].qty.toString());
//         scrapImageList.add(scrapModel!.data![i].image.toString());
//       }
//       setState(() {
//         currentAddress = prefs.getString('address');
//         catData = categoryNameList.join(",");
//         print("cat data here ${catData}");
//         subCatData = subCategoryNameList.join(",");
//         print("subCat data here ${subCatData}");
//         qtyData = quantityList.join(",");
//         print("qty data here ${qtyData}");
//         imageData = scrapImageList.join(",");
//         print("image data here ${imageData}");
//       });
//     }
//     else {
//       print(response.reasonPhrase);
//     }
//
//   }
//
//   String convertDateTimeDisplay(String date) {
//     final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
//     final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
//     final DateTime displayDate = displayFormater.parse(date);
//     final String formatted = serverFormater.format(displayDate);
//     return formatted;
//   }
//
//   Future _selectDate() async {
//     DateTime? picked = await showDatePicker(
//         context: context,
//         initialDate: new DateTime.now(),
//         firstDate: DateTime.now(),
//         lastDate: DateTime(2025),
//         //firstDate: DateTime.now().subtract(Duration(days: 1)),
//         // lastDate: new DateTime(2022),
//         builder: (BuildContext context, Widget? child) {
//           return Theme(
//             data: ThemeData.light().copyWith(
//                 primaryColor: Colors.black, //Head background
//                 accentColor: Colors.black,
//                 colorScheme:
//                 ColorScheme.light(primary: const Color(0xFFEB6C67)),
//                 buttonTheme:
//                 ButtonThemeData(textTheme: ButtonTextTheme.accent)),
//             child: child!,
//           );
//         });
//     if (picked != null)
//       setState(() {
//         String yourDate = picked.toString();
//         _dateValue = convertDateTimeDisplay(yourDate);
//         print(_dateValue);
//         dateFormate = DateFormat("dd/MM/yyyy").format(DateTime.parse(_dateValue ?? ""));
//       });
//   }
//
//   List<String> categoryNameList = [];
//   List<String> subCategoryNameList = [];
//   List<String> quantityList = [];
//   List<String> scrapImageList  = [];
//
//   SharedPreferences? prefs;
//   getData()async{
//     prefs = await SharedPreferences.getInstance();
//   }
//
//     bookingApi()async{
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? currentAddress = prefs.getString('address');
//       var headers = {
//         'Cookie': 'ci_session=9e41b47705375091ce81aa4468ff141e6b1df32a'
//       };
//       var request = http.MultipartRequest('POST', Uri.parse('${baseUrl()}/booking'));
//       request.fields.addAll({
//         'price': '50',
//         'user_id': '${userID}',
//         'category_id': '${catData}',
//         'subcategory_id': '${subCatData}',
//         'date': '${dateFormate}',
//         'address': '83, Ratan Lok Colony, Indore, Madhya Pradesh',
//         'image': '${imageData}',
//         'qty': '${qtyData}',
//         'slot': '${selectedTime!.format(context)}',
//         'total': '21,62'
//       });
//       print("param here ${request.fields.toString()}");
//       Fluttertoast.showToast(msg: "Booked Successfully");
//       request.headers.addAll(headers);
//       http.StreamedResponse response = await request.send();
//       if (response.statusCode == 200) {
//         var finalResult =  await response.stream.bytesToString();
//         final jsonResponse = json.decode(finalResult);
//         print("result here ${jsonResponse['message']}");
//       }
//       else {
//         print(response.reasonPhrase);
//       }
//
//     }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: Align(
//         alignment: Alignment.bottomRight,
//         child: FloatingActionButton(
//           onPressed: () async {
//      await Navigator.push(
//                 context, MaterialPageRoute(builder: (context) => ScrapForm()));
//             setState(() {
//               getScrapData();
//             });
//           },
//           child: Icon(Icons.add),
//         ),
//       ),
//       bottomSheet:  Column(
//         mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.end,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//            scrapModel == null ? SizedBox.shrink() : Container(
//               padding: EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.white10,
//                 borderRadius: BorderRadius.circular(7),
//               ),
//               child: Card(
//                 elevation: 2,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8)
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.only(left: 5,top: 5),
//                       child: Text("Select date and time to sell your scrap",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10,left: 5,right: 5),
//                       child: InkWell(
//                         onTap: ()async{
//                           await _selectDate();
//                         },
//                         child: Container(
//                           height: 60,
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                             border: Border.all(width: 0.5, color: Colors.grey),
//                             borderRadius: BorderRadius.all(Radius.circular(10)),
//                             color: Colors.white,
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: <Widget>[
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 10,),
//                                 child: Icon(Icons.date_range),
//                               ),
//                               Expanded(
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(left: 20,),
//                                     child: new Text(
//                                       _dateValue.length > 0 ? dateFormate : "Pick a date",
//                                       textAlign: TextAlign.start,
//                                     ),
//                                   )),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only( top: 10,left: 5,right: 5),
//                       child: InkWell(
//                         onTap: ()async{
//                           // openBottmSheet(context);
//                           await _selectTime(context);
//                         },
//                         child: Container(
//                           height: 60,
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                             border: Border.all(width: 0.5, color: Colors.grey),
//                             borderRadius: BorderRadius.all(Radius.circular(10)),
//                             color: Colors.white,
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: <Widget>[
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 10),
//                                 child: Icon(Icons.timer_sharp),
//                               ),
//                               Expanded(
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(left: 20),
//                                     child: new Text(
//                                       selectedTime == null
//                                           ? "Choose a time"
//                                           : "${selectedTime!.format(context)}",
//                                       textAlign: TextAlign.start,
//                                     ),
//                                   )),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             InkWell(
//               onTap: (){
//                 bookingApi();
//               },
//               child: Container(
//                 height: 45,
//                 margin: EdgeInsets.symmetric(horizontal: 10),
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                     color: backgroundblack, borderRadius: BorderRadius.circular(6)),
//                 child: Text(
//                   "Upload",
//                   style: TextStyle(
//                       color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       appBar: AppBar(
//         backgroundColor: backgroundblack,
//         elevation: 0,
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(20),
//                 bottomRight: Radius.circular(20))),
//         // bottom:
//         title: Text(
//           "Add Scrap",
//           style: TextStyle(color: appColorWhite),
//         ),
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//       ),
//       body: Container(
//         child: scrapModel  == null
//             ? Center(
//                 child: Text("No scraps to add"),
//               )
//             : ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: scrapModel!.data!.length,
//                 physics: ScrollPhysics(),
//                 itemBuilder: (context, index) {
//                   return Card(
//                     child: Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Expanded(child: Text("Category Name : ")),
//                               scrapModel!.data![index].cName == null ? SizedBox.shrink() :     Expanded(
//                                   child: Text("${scrapModel!.data![index].cName}")),
//                             ],
//                           ),
//                           SizedBox(
//                             height: 6,
//                           ),
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Expanded(child: Text("SubCategory Name : ")),
//                               scrapModel!.data![index].subName == null ? SizedBox.shrink() :      Expanded(
//                                   child: Text("${scrapModel!.data![index].subName}")),
//                             ],
//                           ),
//                           SizedBox(
//                             height: 6,
//                           ),
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Expanded(
//                                   child: Text(
//                                 "Quantity : ",
//                                 style: TextStyle(fontSize: 14),
//                               )),
//                          scrapModel!.data![index].qty == null ? SizedBox.shrink() : Expanded(child: Text("${scrapModel!.data![index].qty} Kg")),
//                             ],
//                           ),
//                           SizedBox(
//                             height: 6,
//                           ),
//                           //
//                           // Text("SubCategory Name : ${scrapList[index].subCategory}"),
//                           // Text("Quantity : ${scrapList[index].qty}"),
//                           Container(
//                               height: 70,
//                               width: 80,
//                               child: scrapModel!.data![index].image == null ? Icon(Icons.photo) : ClipRRect(
//                                   borderRadius: BorderRadius.circular(6),
//                                   child:Image.network(
//                                     "${imageUrl()}${scrapModel!.data![index].image}",
//                                     fit: BoxFit.fill,
//                                   )))
//                         ],
//                       ),
//                     ),
//                   );
//                 }),
//       ),
//       // Container(
//       //   child: ListView(
//       //     padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
//       //     children: [
//       //    scrapList.isNotEmpty ? SizedBox.shrink() :
//       //  /// main form
//       //    Container(
//       //         child: Column(
//       //           children: [
//       //             Container(
//       //               height: 60,
//       //               padding: EdgeInsets.only(left: 10),
//       //               decoration: BoxDecoration(
//       //                   borderRadius: BorderRadius.circular(7),
//       //                   border: Border.all(color: appColorBlack.withOpacity(0.3))
//       //               ),
//       //               child: DropdownButton(
//       //                 // Initial Value
//       //                 value: selectedCategory,
//       //                 underline: Container(),
//       //                 // Down Arrow Icon
//       //                 icon: Icon(Icons.keyboard_arrow_down),
//       //                 hint: Container(
//       //                     width: MediaQuery.of(context).size.width/1.25,
//       //                     child: Text("Select category")),
//       //                 // Array list of items
//       //                 items: catlist.map((items) {
//       //                   return DropdownMenuItem(
//       //                     value: items.id,
//       //                     child: Container(
//       //                         child: Text(items.cName.toString())),
//       //                   );
//       //                 }).toList(),
//       //                 // After selecting the desired option,it will
//       //                 // change button value to selected value
//       //                 onChanged: (String? newValue) {
//       //                   setState(() {
//       //                     print("catName here ${catName}");
//       //                     selectedCategory = newValue!;
//       //                     getSubCategory();
//       //                     print("selected category ${selectedCategory}");
//       //                   });
//       //                 },
//       //               ),
//       //             ),
//       //             SizedBox(height: 10,),
//       //             Container(
//       //               height: 60,
//       //               padding: EdgeInsets.only(left: 10),
//       //               decoration: BoxDecoration(
//       //                   borderRadius: BorderRadius.circular(7),
//       //                   border: Border.all(color: appColorBlack.withOpacity(0.3))
//       //               ),
//       //               child: DropdownButton(
//       //                 // Initial Value
//       //                 value: selectedSubcategory,
//       //                 underline: Container(),
//       //                 // Down Arrow Icon
//       //                 icon: Container(
//       //                   // width: MediaQuery.of(context).size.width/1.5,
//       //                     alignment: Alignment.centerRight,
//       //                     child: Icon(Icons.keyboard_arrow_down)),
//       //                 hint: Container(width: MediaQuery.of(context).size.width/1.25, child: Text("Select sub category")),
//       //                 // Array list of items
//       //                 items: subCatList.map((items) {
//       //                   return DropdownMenuItem(
//       //                     value: items.id,
//       //                     child: Container(
//       //                         child: Text(items.cName.toString())),
//       //                   );
//       //                 }).toList(),
//       //                 // After selecting the desired option,it will
//       //                 // change button value to selected value
//       //                 onChanged: (String? newValue) {
//       //                   setState(() {
//       //                     selectedSubcategory = newValue!;
//       //                     print("selected sub category ${selectedSubcategory}");
//       //                   });
//       //                 },
//       //               ),
//       //             ),
//       //             SizedBox(height: 10,),
//       //             TextFormField( controller: quantityController,
//       //               keyboardType: TextInputType.number,
//       //               validator: (v){
//       //                 if(v!.isEmpty){
//       //                   return "Enter quantity";
//       //                 }
//       //               },
//       //               decoration: InputDecoration(
//       //                   hintText: "Enter quantity in kg",
//       //                   border: OutlineInputBorder(
//       //                       borderRadius: BorderRadius.circular(7),
//       //                       borderSide: BorderSide(color: appColorBlack.withOpacity(0.5))
//       //                   )
//       //               ),),
//       //             SizedBox(height: 20,),
//       //             Row(
//       //               mainAxisAlignment: MainAxisAlignment.center,
//       //               children: [
//       //                 InkWell(
//       //                   onTap: (){
//       //                     showDialog(context: context, builder: (context){
//       //                       return AlertDialog(
//       //                         content: Column(
//       //                           crossAxisAlignment: CrossAxisAlignment.start,
//       //                           mainAxisAlignment: MainAxisAlignment.center,
//       //                           mainAxisSize: MainAxisSize.min,
//       //                           children: [
//       //                             InkWell(
//       //                               onTap:()async{
//       //                                 // String fileUrl = await storageReference.getDownloadURL();
//       //                                 PickedFile? image = await ImagePicker.platform
//       //                                     .pickImage(source: ImageSource.gallery);
//       //                                 imageFiles = File(image!.path);
//       //                                 setState(() {
//       //
//       //                                 });
//       //                                 print("image files here ${imageFiles!.path.toString()}");
//       //                                 Navigator.of(context).pop();
//       //                               },
//       //                               child: Row(
//       //                                 crossAxisAlignment: CrossAxisAlignment.start,
//       //                                 children: [
//       //                                   Icon(Icons.photo),
//       //                                   SizedBox(width: 5,),
//       //                                   Text("Gallery")
//       //                                 ],
//       //                               ),
//       //                             ),
//       //                             SizedBox(height: 10,),
//       //                             InkWell(
//       //                               onTap:()async{
//       //                                 PickedFile? image = await ImagePicker.platform
//       //                                     .pickImage(source: ImageSource.camera);
//       //                                 imageFiles = File(image!.path);
//       //                                 print("image files here ${imageFiles!.path.toString()}");
//       //                                 setState(() {
//       //
//       //                                 });
//       //                                 Navigator.of(context).pop();
//       //                               },
//       //                               child: Row(
//       //                                 crossAxisAlignment: CrossAxisAlignment.start,
//       //                                 children: [
//       //                                   Icon(Icons.camera_alt),
//       //                                   SizedBox(width: 5,),
//       //                                   Text("Camera")
//       //                                 ],
//       //                               ),
//       //                             ),
//       //                           ],
//       //                         ),
//       //                       );
//       //                     });
//       //                   },
//       //                   child: Container(
//       //                     height: 90,
//       //                     width: 80,
//       //                     decoration: BoxDecoration(
//       //                         border: Border.all(color: Colors.grey)
//       //                     ),
//       //                     child:imageFiles == null ?  Icon(Icons.photo) : Image.file(imageFiles!,fit: BoxFit.fill,) ,
//       //                   ),
//       //                 ),
//       //
//       //               ],
//       //             ),
//       //             SizedBox(height: 15,),
//       //             InkWell(
//       //               onTap: (){
//       //                 setState(() {
//       //                   scrapList.add(
//       //                     ScrapModel(
//       //                       id: "1",
//       //                       image: imageFiles!.path.toString(),
//       //                       category: selectedCategory.toString(),
//       //                       subCategory: selectedSubcategory.toString(),
//       //                       qty: quantityController.text.toString(),
//       //                     ),
//       //                   );
//       //
//       //                 });
//       //               },
//       //               child: Container(
//       //                 height: 45,
//       //                 alignment: Alignment.center,
//       //                 decoration: BoxDecoration(
//       //                     color: backgroundblack,
//       //                     borderRadius: BorderRadius.circular(6)
//       //                 ),
//       //                 child: Text("Add",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w600),),
//       //               ),
//       //             ),
//       //           ],
//       //         ),
//       //       ),
//       //       /// show added list data
//       //       Container(
//       //         child: ListView.builder(
//       //             shrinkWrap: true,
//       //             itemCount: scrapList.length,
//       //             physics: ScrollPhysics(),
//       //             itemBuilder: (context,index){
//       //           return Card(
//       //             child: Padding(
//       //               padding: EdgeInsets.all(8.0),
//       //               child: Column(
//       //                 crossAxisAlignment: CrossAxisAlignment.start,
//       //                 children: [
//       //                   Row(
//       //                     crossAxisAlignment: CrossAxisAlignment.start,
//       //                     children: [
//       //                       Expanded(child: Text("Category Name : ")),
//       //                       Expanded(child: Text("${scrapList[index].category}")),
//       //                     ],
//       //                   ),
//       //                   SizedBox(height: 6,),
//       //                   Row(
//       //                     crossAxisAlignment: CrossAxisAlignment.start,
//       //                     children: [
//       //                       Expanded(child: Text("SubCategory Name : ")),
//       //                       Expanded(child: Text("${scrapList[index].subCategory}")),
//       //                     ],
//       //                   ),
//       //                   SizedBox(height: 6,),
//       //                   Row(
//       //                     crossAxisAlignment: CrossAxisAlignment.start,
//       //                     children: [
//       //                       Expanded(child: Text("Quantity : ",style: TextStyle(fontSize: 14),)),
//       //                       Expanded(child: Text("${scrapList[index].qty} Kg")),
//       //                     ],
//       //                   ),
//       //                   SizedBox(height: 6,),
//       //                   //
//       //                   // Text("SubCategory Name : ${scrapList[index].subCategory}"),
//       //                   // Text("Quantity : ${scrapList[index].qty}"),
//       //                   Container(
//       //                       height:70,
//       //                       width:80,
//       //                       child: ClipRRect(
//       //                           borderRadius:BorderRadius.circular(6),
//       //                           child: Image.file( File(scrapList[index].image.toString()),fit: BoxFit.fill,)))
//       //                 ],
//       //               ),
//       //             ),
//       //           );
//       //         }),
//       //       ),
//       //       SizedBox(height: 10,),
//       //
//       //     /// add more button with form functionality
//       //     scrapList.isEmpty ? SizedBox.shrink() :   InkWell(
//       //       onTap: ()async{
//       //         setState(() {
//       //           selectedSubcategory =  null;
//       //           selectedCategory = null;
//       //           quantityController.clear();
//       //           imageFiles = null;
//       //         });
//       //        await showDialog(context: context, builder: (context){
//       //           return StatefulBuilder(
//       //               builder: (BuildContext context, StateSetter setState) {
//       //                 return AlertDialog(
//       //                   content: Column(
//       //                     mainAxisSize: MainAxisSize.min,
//       //                     children: [
//       //                       Container(
//       //                         height: 60,
//       //                         padding: EdgeInsets.only(left: 10),
//       //                         decoration: BoxDecoration(
//       //                             borderRadius: BorderRadius.circular(7),
//       //                             border: Border.all(color: appColorBlack.withOpacity(0.3))
//       //                         ),
//       //                         child: DropdownButton(
//       //                           // Initial Value
//       //                           value: selectedCategory,
//       //                           underline: Container(),
//       //                           // Down Arrow Icon
//       //                           icon: Icon(Icons.keyboard_arrow_down),
//       //                           hint: Container(
//       //                               width: MediaQuery.of(context).size.width/1.9,
//       //                               child: Text("Select category")),
//       //                           // Array list of items
//       //                           items: catlist.map((items) {
//       //                             return DropdownMenuItem(
//       //                               value: items.id,
//       //                               child: Container(
//       //                                   child: Text(items.cName.toString())),
//       //                             );
//       //                           }).toList(),
//       //                           // After selecting the desired option,it will
//       //                           // change button value to selected value
//       //                           onChanged: (String? newValue){
//       //                             setState(() {
//       //                               selectedCategory = newValue!;
//       //                               getSubCategory();
//       //                               print("selected category ${selectedCategory}");
//       //                             });
//       //                           },
//       //                         ),
//       //                       ),
//       //                       SizedBox(height: 10,),
//       //                       Container(
//       //                         height: 60,
//       //                         padding: EdgeInsets.only(left: 10),
//       //                         decoration: BoxDecoration(
//       //                             borderRadius: BorderRadius.circular(7),
//       //                             border: Border.all(color: appColorBlack.withOpacity(0.3))
//       //                         ),
//       //                         child: DropdownButton(
//       //                           // Initial Value
//       //                           value: selectedSubcategory,
//       //                           underline: Container(),
//       //                           // Down Arrow Icon
//       //                           icon: Container(
//       //                             // width: MediaQuery.of(context).size.width/1.5,
//       //                               alignment: Alignment.centerRight,
//       //                               child: Icon(Icons.keyboard_arrow_down)),
//       //                           hint: Container(width: MediaQuery.of(context).size.width/1.9, child: Text("Select sub category")),
//       //                           // Array list of items
//       //                           items: subCatList.map((items) {
//       //                             return DropdownMenuItem(
//       //                               value: items.id,
//       //                               child: Container(
//       //                                   child: Text(items.cName.toString())),
//       //                             );
//       //                           }).toList(),
//       //                           // After selecting the desired option,it will
//       //                           // change button value to selected value
//       //                           onChanged: (String? newValue) {
//       //                             setState(() {
//       //                               selectedSubcategory = newValue!;
//       //                               print("selected sub category ${selectedSubcategory}");
//       //                             });
//       //                           },
//       //                         ),
//       //                       ),
//       //                       SizedBox(height: 10,),
//       //                       TextFormField( controller: quantityController,
//       //                         keyboardType: TextInputType.number,
//       //                         validator: (v){
//       //                           if(v!.isEmpty){
//       //                             return "Enter quantity";
//       //                           }
//       //                         },
//       //                         decoration: InputDecoration(
//       //                             hintText: "Enter quantity in kg",
//       //                             border: OutlineInputBorder(
//       //                                 borderRadius: BorderRadius.circular(7),
//       //                                 borderSide: BorderSide(color: appColorBlack.withOpacity(0.5))
//       //                             )
//       //                         ),),
//       //                       SizedBox(height: 20,),
//       //                       Row(
//       //                         children: [
//       //                           InkWell(
//       //                             onTap: (){
//       //                               showDialog(context: context, builder: (context){
//       //                                 return AlertDialog(
//       //                                   content: Column(
//       //                                     crossAxisAlignment: CrossAxisAlignment.start,
//       //                                     mainAxisAlignment: MainAxisAlignment.center,
//       //                                     mainAxisSize: MainAxisSize.min,
//       //                                     children: [
//       //                                       InkWell(
//       //                                         onTap:()async{
//       //                                           // String fileUrl = await storageReference.getDownloadURL();
//       //                                           PickedFile? image = await ImagePicker.platform
//       //                                               .pickImage(source: ImageSource.gallery);
//       //                                           imageFiles = File(image!.path);
//       //                                           setState(() {
//       //
//       //                                           });
//       //                                           print("image files here ${imageFiles!.path.toString()}");
//       //                                           Navigator.of(context).pop();
//       //                                         },
//       //                                         child: Row(
//       //                                           crossAxisAlignment: CrossAxisAlignment.start,
//       //                                           children: [
//       //                                             Icon(Icons.photo),
//       //                                             SizedBox(width: 5,),
//       //                                             Text("Gallery")
//       //                                           ],
//       //                                         ),
//       //                                       ),
//       //                                       SizedBox(height: 10,),
//       //                                       InkWell(
//       //                                         onTap:()async{
//       //                                           PickedFile? image = await ImagePicker.platform
//       //                                               .pickImage(source: ImageSource.camera);
//       //                                           imageFiles = File(image!.path);
//       //                                           print("image files here ${imageFiles!.path.toString()}");
//       //                                           setState(() {
//       //
//       //                                           });
//       //                                           Navigator.of(context).pop();
//       //                                         },
//       //                                         child: Row(
//       //                                           crossAxisAlignment: CrossAxisAlignment.start,
//       //                                           children: [
//       //                                             Icon(Icons.camera_alt),
//       //                                             SizedBox(width: 5,),
//       //                                             Text("Camera")
//       //                                           ],
//       //                                         ),
//       //                                       ),
//       //                                     ],
//       //                                   ),
//       //                                 );
//       //                               });
//       //                             },
//       //                             child: Container(
//       //                               height: 90,
//       //                               width: 80,
//       //                               decoration: BoxDecoration(
//       //                                   border: Border.all(color: Colors.grey)
//       //                               ),
//       //                               child:imageFiles == null ?  Icon(Icons.photo) : Image.file(imageFiles!,fit: BoxFit.fill,) ,
//       //                             ),
//       //                           ),
//       //
//       //                         ],
//       //                       ),
//       //                       SizedBox(height: 15,),
//       //                       InkWell(
//       //                         onTap: ()async{
//       //                           setState(() {
//       //                             scrapList.add(
//       //                               ScrapModel(
//       //                                 id: "1",
//       //                                 image: imageFiles!.path.toString(),
//       //                                 category: selectedCategory.toString(),
//       //                                 subCategory: selectedSubcategory.toString(),
//       //                                 qty: quantityController.text.toString(),
//       //                               ),
//       //                             );
//       //                           });
//       //                         Navigator.pop(context);
//       //                         },
//       //                         child: Container(
//       //                           height: 45,
//       //                           alignment: Alignment.center,
//       //                           decoration: BoxDecoration(
//       //                             borderRadius: BorderRadius.circular(6),
//       //                             color: backgroundblack
//       //                           ),
//       //                           child: Text("Add",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w600),),
//       //                         ),
//       //                       ),
//       //                     ],
//       //                   ),
//       //                 );
//       //               }
//       //           );
//       //         });
//       //        setState(() {
//       //
//       //        });
//       //       },
//       //       child: Container(
//       //         height: 35,
//       //         margin: EdgeInsets.only(left: 30,right: 30,bottom: 50),
//       //         padding: EdgeInsets.symmetric(horizontal: 3),
//       //         alignment: Alignment.center,
//       //         decoration: BoxDecoration(
//       //           color: backgroundblack,
//       //           borderRadius: BorderRadius.circular(6),
//       //         ),
//       //         child: Row(
//       //           crossAxisAlignment: CrossAxisAlignment.start,
//       //           mainAxisAlignment: MainAxisAlignment.center,
//       //           children: [
//       //             Icon(Icons.add,color: Colors.white,),
//       //             SizedBox(width: 3,),
//       //             Text("Add more",style: TextStyle(color: Colors.white),),
//       //           ],
//       //         ),
//       //       ),
//       //     ),
//       //
//       //     ],
//       //   ),
//       // ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:io';

import 'package:ez/Helper/session.dart';
import 'package:ez/models/GetScrapModel.dart';
import 'package:ez/screens/view/models/CoupanModel.dart';
import 'package:ez/screens/view/models/GetCoupanModel.dart';
import 'package:ez/screens/view/models/scrapModel.dart';
import 'package:ez/screens/view/newUI/CouponList.dart';
import 'package:ez/screens/view/newUI/ScrapForm.dart';
import 'package:ez/screens/view/newUI/newTabbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constant/global.dart';
import '../../../models/getScrapInCartModel.dart';
import '../models/OfferModel.dart';
import '../models/address_model.dart';
import '../models/categories_model.dart';
import 'manage_address.dart';

class PaymentMethod {
  String name;
  String imagePath;

  PaymentMethod({required this.name, required this.imagePath});
}

class AddScrapPage extends StatefulWidget {
  const AddScrapPage({Key? key}) : super(key: key);

  @override
  State<AddScrapPage> createState() => _AddScrapPageState();
}

class _AddScrapPageState extends State<AddScrapPage> {
  TextEditingController serviceNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  String? selectedCategory;
  String? selectedSubcategory;

  AllCateModel? collectionModal;
  List paymentType = ['Cash', 'Online'];
  var paymentValue;
  PaymentMethod? selectPaymentMethood;
  String? selectPaymentType;
  // selectPaymentMethood == "Phone Pay";
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  // List<String> _onlinePaymentMethood = [
  //   'Phone Pay',
  //   'Paytm',
  //   'Google Pay',
  //   'bank detail'
  // ];

  final List<PaymentMethod> paymentMethods = [
    PaymentMethod(name: 'Phone Pay', imagePath: 'assets/images/Phone pay.png'),
    PaymentMethod(name: 'Paytm', imagePath: 'assets/images/paytm.png'),
    PaymentMethod(
        name: 'Google Pay', imagePath: 'assets/images/google pay.png'),
    PaymentMethod(
        name: 'bank detail', imagePath: 'assets/images/bank detail.png'),
  ];

  List<Categories> catlist = [];
  _getCollection() async {
    var uri = Uri.parse('${baseUrl()}/get_all_cat');
    var request = new http.MultipartRequest("GET", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    print(baseUrl.toString());

    request.headers.addAll(headers);
    // request.fields['vendor_id'] = userID;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);

    if (mounted) {
      setState(() {
        collectionModal = AllCateModel.fromJson(userData);
        catlist = AllCateModel.fromJson(userData).categories!;
        print(
            "ooooo ${collectionModal!.status} and ${collectionModal!.categories!.length} and ${userID}");
      });
    }
    print(responseData);
  }

  List<Categories> subCatList = [];

  PaymentMethod? paymentMethod;

  getSubCategory() async {
    var uri = Uri.parse('${baseUrl()}/get_all_cat');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    print("checking id here $selectedCategory");
    print(baseUrl.toString());
    request.headers.addAll(headers);
    request.fields['category_id'] = selectedCategory.toString();
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);

    if (mounted) {
      setState(() {
        subCatList = AllCateModel.fromJson(userData).categories!;
        collectionModal = AllCateModel.fromJson(userData);
      });
    }
    print(responseData);
  }

  @override
  void initState() {
    print("===my technic=======this is cart screen===============");
    // TODO: implement initState
    super.initState();
    getCoupans();
    _getCollection();
    getScrapData();
    getData();
  }

  String? selectpayment;
  String _dateValue = '';
  String addId = '';
  var dateFormate;
  String _pickedLocation = '';
  // Future getAddress(id) async {
  //   var request =
  //   http.MultipartRequest('POST', Uri.parse('${baseUrl()}/get_address'));
  //   request.fields.addAll({'id': '$id', 'user_id': '$userID'});
  //
  //   print(request);
  //   print(request.fields);
  //
  //   http.StreamedResponse response = await request.send();
  //   if (response.statusCode == 200) {
  //     final str = await response.stream.bytesToString();
  //     final jsonResponse = AddressModel.fromJson(json.decode(str));
  //     if (jsonResponse.responseCode == "1") {
  //       setState(() {
  //         _pickedLocation =
  //         "${jsonResponse.data![0].address!}, ${jsonResponse.data![0].building}";
  //       });
  //     }
  //     print(_pickedLocation);
  //     return AddressModel.fromJson(json.decode(str));
  //   } else {
  //     return null;
  //   }
  // }
  // final _formKey = GlobalKey<FormState>();
  // Future _selectDate() async {
  //   DateTime? picked = await showDatePicker(
  //       context: context,
  //       initialDate: new DateTime.now(),
  //       firstDate: DateTime.now(),
  //       lastDate: DateTime(2025),
  //       //firstDate: DateTime.now().subtract(Duration(days: 1)),
  //       // lastDate: new DateTime(2022),
  //       builder: (BuildContext context, Widget? child) {
  //         return Theme(
  //           data: ThemeData.light().copyWith(
  //               primaryColor: Colors.black, //Head background
  //               accentColor: Colors.black,
  //               colorScheme:
  //               ColorScheme.light(primary: const Color(0xFFEB6C67)),
  //               buttonTheme:
  //               ButtonThemeData(textTheme: ButtonTextTheme.accent)),
  //           child: child!,
  //         );
  //       });
  //   if (picked != null)
  //     setState(() {
  //       String yourDate = picked.toString();
  //       _dateValue = convertDateTimeDisplay(yourDate);
  //       print(_dateValue);
  //       dateFormate =
  //           DateFormat("dd/MM/yyyy").format(DateTime.parse(_dateValue ?? ""));
  //       sDate = DateFormat("dd-MM-yyyy").format(DateTime.parse(_dateValue ?? ""));
  //       dateController.text = dateFormate;
  //     });
  // }
  //
  // String convertDateTimeDisplay(String date) {
  //   final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
  //   final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
  //   final DateTime displayDate = displayFormater.parse(date);
  //   final String formatted = serverFormater.format(displayDate);
  //   return formatted;
  // }

  String? catName;
  String? subCatName;
  TimeOfDay? _selectedTimeNew;

  var selectTime;
  // var selectedTime;
  Future<void> selectTimeStart(BuildContext context) async {
    final TimeOfDay pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTimeNew ?? TimeOfDay.now(),
    ) as TimeOfDay;

    if (pickedTime != null && pickedTime != _selectedTimeNew) {
      setState(() {
        _selectedTimeNew = pickedTime;
      });
    }
  }

  void gettotalPrice() {
    for (int i = 0; i < scrapModel!.data.length; i++) {
      totalprice =
          totalprice + int.parse(scrapModel!.data[i].total.toString() ?? "");
    }
    print("=======================$totalprice");
  }

  Future<void> chooseTimeEnd(BuildContext context) async {
    final TimeOfDay pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTimeNew ?? TimeOfDay.now(),
    ) as TimeOfDay;
    if (pickedTime != null && pickedTime != _selectedTimeNew) {
      setState(() {
        _selectedTimeNew = pickedTime;
      });
    }
  }

  String? promoCodeId, promoCode, promoDiscount;
  // Future<TimeOfDay?> selectTimeEE(BuildContext context) async {
  //
  //   final TimeOfDay? picked = await showTimePicker(
  //       context: context,
  //       initialTime: TimeOfDay.now(),
  //       builder: (BuildContext? context, Widget? child) {
  //         return MediaQuery(
  //           data: MediaQuery.of(context!).copyWith(alwaysUse24HourFormat:false
  //           ),
  //           child: child!,
  //         );
  //       });
  //
  //   return picked;
  // }

  Future<void> selectTimeEE(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext? context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context!).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // Convert to 12-hour format with AM/PM
      selectTime = formatTime(picked);
      setState(() {});
      print("===my technic=======$selectTime===============");
    }
  }

  String formatTime(TimeOfDay time) {
    int hour = time.hourOfPeriod ?? 0;
    int minute = time.minute ?? 0;
    String period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:${minute.toString().padLeft(2, '0')} $period';
  }

  Widget MorningShiftStart() {
    return InkWell(
      onTap: () {
        selectTimeStart(context);
      },
      child: Container(
        // Customize the container as needed
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              _selectedTimeNew != null
                  ? '${_selectedTimeNew!.format(context)}'
                  : 'Evening Shift Time',
            ),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
  // _selectTime(BuildContext context) async {
  //   final TimeOfDay? timeOfDay = await showTimePicker(
  //       context: context,
  //       useRootNavigator: true,
  //       initialTime: TimeOfDay.now(),
  //       builder: (BuildContext context, Widget? child) {
  //         return Theme(
  //           data: ThemeData.light().copyWith(
  //               colorScheme: ColorScheme.light(primary: backgroundblack),
  //               buttonTheme: ButtonThemeData(
  //                   colorScheme: ColorScheme.light(primary: backgroundblack))),
  //           child: MediaQuery(
  //               data: MediaQuery.of(context)
  //                   .copyWith(alwaysUse24HourFormat: false),
  //               child: child!),
  //         );
  //       });
  //   if (timeOfDay != null && timeOfDay != selectedTime) {
  //     setState(() {
  //       selectedTime = timeOfDay.replacing(hour: timeOfDay.hourOfPeriod);
  //       print('__________________>>>>>>>>>>>>>>>>>>>>${selectedTime}');
  //       timeController.text = selectedTime!.format(context);
  //     });
  //   }
  //   var per = selectedTime!.period.toString().split(".");
  //   print(
  //       "selected time here ${selectedTime!.format(context).toString()} and ${per[1]}");
  // }

  String? sDate;

  File? imageFiles;

  // GetScrapModel? scrapModel;
  GetScrapCartModel? scrapModel;
  String? catData, subCatData, imageData, qtyData, scrpNameData, totalData, unitData;
  String? currentAddress;
  String? masterCatData;
  List<String> totalList = [];
  String? priceValue;
  getScrapData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? latitude = prefs.getString('lati');
    String? longitude = prefs.getString('longi');
    print("latitude and longitude $latitude and $longitude");

    print("user id $userID");
    var headers = {
      'Cookie': 'ci_session=09ce4c54a28ddd34fbb121d896a5c2f033453c7c'
    };
    var request =
        http.MultipartRequest('POST', Uri.parse('${baseUrl()}/get_scrap_data'));
    request.fields.addAll({'user_id': '$userID'});
    print("user id here ${request.fields} and ${baseUrl()}/get_scrap_data");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    print("checking status code ${response.statusCode}");
    if (response.statusCode == 200) {
      var finalResult = await response.stream.bytesToString();
      final jsonResponse = GetScrapCartModel.fromJson(json.decode(finalResult));
      setState(() {
        scrapModel = jsonResponse;
      });
      gettotalPrice();
      print("model value ${scrapModel!.data}");
      print("checking data length here ${scrapModel!.data.length}");
      for (var i = 0; i < scrapModel!.data.length; i++) {
        categoryNameList.add(scrapModel!.data[i].categoryId.toString());
        subCategoryNameList.add(scrapModel!.data[i].subcategoryId.toString());
        quantityList.add(scrapModel!.data[i].qty.toString());
        unitList.add(scrapModel!.data[i].unit.toString());
        scrapImageList.add(scrapModel!.data[i].image.toString());
        scrapNameList.add(scrapModel!.data[i].name.toString());
        totalList.add(scrapModel!.data[i].total.toString());
        masterCategoryList.add(scrapModel!.data[i].msid.toString());
      }
      setState(() {
        currentAddress = prefs.getString('address');
        catData = categoryNameList.join(",");
        print("cat data here $catData");
        subCatData = subCategoryNameList.join(",");
        print("subCat data here $subCatData");
        qtyData = quantityList.join(",");
        print("qty data here $qtyData");
        unitData = unitList.join(",");
        print("qty data here $unitData");
        imageData = scrapImageList.join(",");
        print("image data here $imageData");
        scrpNameData = scrapNameList.join(",");
        print("name data here $scrpNameData");
        totalData = totalList.join(",");
        print("total data here $totalData");
        masterCatData = masterCategoryList.join(",");
        print("master category data $masterCatData");
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  String? latit, longit;
  Future getAddress(id) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('${baseUrl()}/get_address'));
    request.fields.addAll({'id': '$id', 'user_id': '$userID'});

    print(request);
    print(request.fields);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();
      final jsonResponse = AddressModel.fromJson(json.decode(str));
      if (jsonResponse.responseCode == "1") {
        setState(() {
          _pickedLocation =
              "${jsonResponse.data![0].address!}, ${jsonResponse.data![0].building}";
          latit = jsonResponse.data![0].lat.toString();
          longit = jsonResponse.data![0].lng.toString();
        });
        print(
            "checking lat and long here ${jsonResponse.data![0].lat} and $jsonResponse");
      }
      print(_pickedLocation);
      return AddressModel.fromJson(json.decode(str));
    } else {
      return null;
    }
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  Future _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2025),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
                primaryColor: Colors.black, //Head background
                // accentColor: Colors.black,
                // colorScheme:
                //     ColorScheme.light(primary: const Color(0xFFEB6C67)),
                buttonTheme:
                    ButtonThemeData(textTheme: ButtonTextTheme.accent)),
            child: child!,
          );
        });
    if (picked != null)
      setState(() {
        String yourDate = picked.toString();
        _dateValue = convertDateTimeDisplay(yourDate);
        dateFormate = DateFormat("dd/MM/yyyy").format(picked);
        print("==================================$dateFormate");
      });
  }

  List<String> categoryNameList = [];
  List<String> subCategoryNameList = [];
  List<String> quantityList = [];
  List<String> unitList = [];
  List<String> scrapImageList = [];
  List<String> scrapNameList = [];
  List<String> masterCategoryList = [];

  SharedPreferences? prefs;
  getData() async {
    prefs = await SharedPreferences.getInstance();
  }

  bookingApi() async {
    var finalprice;
    if (codestatus == "Promo Code Applied") {
      finalprice = discountPrice;
      print("with discoiunt==============$finalprice");
    } else {
      finalprice = totalprice;
      print("without discount================$finalprice");
    }
    print("raj1");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? FcurrentAddress = prefs.getString('address');
    var headers = {
      'Cookie': 'ci_session=9e41b47705375091ce81aa4468ff141e6b1df32a'
    };
    var request =
        http.MultipartRequest('POST', Uri.parse('${baseUrl()}/booking'));
    request.fields.addAll({
      // 'price': "${finalprice.toString()}",
      'user_id': '$userID',
      'category_id': '$catData',
      'subcategory_id': '$subCatData',
      'date': '$dateFormate',
      'address': '${_pickedLocation.toString()}',
      'image': '$imageData',
      'qty': '$qtyData',
      'unit': '$unitData',
       // 'slot': '${_selectedTimeNew!.format(context)}',
      'slot': '$selectTime',
      'total': '$totalData',
      'scrap_name': "$scrpNameData",
      "address_id": addId.toString(),
      'master_category': "$masterCatData",
      "langitude": "$longit",
      "latitude": "$latit",
      'payment_type': paymentValue.toString(),
      "payemnt_method": "${selectPaymentType.toString()}",
      "mobile_number": "${mobilecontroller.text}",
      "acc_holder": "${accountHoldernamecontroller.text}",
      "acc_number": "${accountnumbercontroller.text}",
      "acc_ifsc": "${ifsccontroller.text}",
      "bank_name": "${banknamecontroller.text}",
      "bank_branch": "${branchcontroller.text}",
      'discount': "$priceOffValue" == null || "$priceOffValue" == "" ? "0" : '$priceOffValue',
      "subtotal": "$totalprice" == null || "$totalprice" == "" ? "0" : '$totalprice',
      "final_total": "${finalprice.toString()}",
      "coupon_id": "$promoCodeId" == null || "$promoCodeId" == "" ? "0" : '$promoCodeId',
    });

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    print("code here ${response.statusCode}");
    print("===place order=======${request.fields}===============");
    print("===my technic=======${request.url}===============");
    if (response.statusCode == 200) {
      var finalResult = await response.stream.bytesToString();
      print("===my technic=======$finalResult===============");
      final jsonResponse = jsonDecode(finalResult);

      if (jsonResponse['response_code'] == "1") {
        Fluttertoast.showToast(msg: "${jsonResponse['message']}");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => TabbarScreen()),
            (route) => false);
      }
    } else {
      setState(() {
        isLoading = false;
      });
      // Fluttertoast.showToast(msg: "Somthing went wrong");
      print(response.reasonPhrase);
    }
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

  deleteScrap(String id) async {
    var headers = {
      'Cookie': 'ci_session=4e56c94e80a8f2c5e9d2016dcd96999842dfeab5'
    };
    var request =
        http.MultipartRequest('POST', Uri.parse('${baseUrl()}/delete_scrap'));
    request.fields.addAll({'scrap_id': '${id}'});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResponse);
      if (jsonResponse['response_code'] == "1") {
        Fluttertoast.showToast(msg: "Deleted successfully");
        getScrapData();
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  TextEditingController coupanCodeController = TextEditingController();
  TextEditingController mobilecontroller = TextEditingController();
  TextEditingController accountHoldernamecontroller = TextEditingController();
  TextEditingController accountnumbercontroller = TextEditingController();
  TextEditingController ifsccontroller = TextEditingController();
  TextEditingController banknamecontroller = TextEditingController();
  TextEditingController branchcontroller = TextEditingController();
  TextEditingController confirmaccnumbercontroller = TextEditingController();

  var codestatus = "";
  String? priceOffValue, discountPrice;
  applyCode() async {
    print("${coupanCodeController.text}");

    print("oooo");
    var headers = {'Cookie': 'ci_session=59dd1a84elpmmaiabkhq5mujfuf1f0ja'};
    var request = http.MultipartRequest(
        'POST', Uri.parse('${baseUrl()}/check_promo_code'));
    request.fields.addAll(
        {'code': '${coupanCodeController.text}', 'amount': '$totalprice'});

    request.headers.addAll(headers);
    print('THIS is requestttttt___________________${request.fields}');

    http.StreamedResponse response = await request.send();
    print("lll ${response.statusCode}");
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();

      print("raj=================");

      var jsonResponse = CoupanModel.fromJson(json.decode(finalResponse));
      print("raj=================");
      print("ok now ${jsonResponse.msg} and ${jsonResponse.data}");
      setState(() {
        priceOffValue = jsonResponse.data!.discountAmount.toString();
        discountPrice = jsonResponse.data!.amountAfterDiscount.toString();
        print("promodiscount price is $discountPrice $priceOffValue");
        // restaurants!.restaurant!.price = discountPrice;
        //  restaurants!.restaurant!.price = discountPrice;
        Fluttertoast.showToast(msg: "Promo Code Applied");
        setState(() {
          codestatus = "Promo Code Applied";
        });
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  GetCoupanModel? coupanModel;
  getCoupans() async {
    var headers = {
      'Cookie': 'ci_session=ae0ca90b33a496d4bca4e32529bd9d8ef80cc12d'
    };
    var request =
        http.MultipartRequest('POST', Uri.parse('${baseUrl()}/coupans'));
    request.fields.addAll(
        {'user_id': '$userID',});
    print("user id in promo code ${request.fields}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    print("===my technic=======${request.url}===============");
    print("===my technic=======${request.fields}===============");
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      print("===my technic=======$finalResponse===============");
      var result = jsonDecode(finalResponse);
      if (result['response_code'] == "1") {
        coupanModel = GetCoupanModel.fromJson(result);
        setState(() {});
      } else {
        coupanModel = null;
        setState(() {});
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  // Future _selectPaymentMethod() async {
  //
  // }

  Future showPaymentPopup() async {
    return await showDialog(
      //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      builder: (context) => StatefulBuilder(
        builder:
            (BuildContext context, void Function(void Function()) setState) {
          return Column(
            children: [
              AlertDialog(
                title: Text('How You want To Receive Payment'),
                content: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                          onTap: () {
                            setState(() {
                              selectpayment = "Cash";
                            });
                            Navigator.pop(context, selectpayment);
                          },
                          child: Text(
                            'Cash',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                          onTap: () {
                            setState(() {
                              selectpayment = "Online";
                            });
                            Navigator.pop(context, selectpayment);
                          },
                          child: Text(
                            'Online',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          )),
                    ],
                  ),
                ),

                // actions: [
                //   ElevatedButton(
                //     // onPressed: () => Navigator.of(context).pop(text),
                //     onPressed: (){
                //       setState(()
                //       {
                //         text = "cash";
                //       });
                //     },
                //     //return false when click on "NO"
                //     child: Text('Cash'),
                //   ),
                //   ElevatedButton(
                //     onPressed: () => Navigator.of(context).pop(text),
                //     //return true when click on "Yes"
                //     child: Text('Online'),
                //   ),
                // ],
              ),
            ],
          );
        },
      ),
    ); //if showDialouge had returned null, then return false
  }

  int totalprice = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: Align(
      //   alignment: Alignment.bottomRight,
      //   child: FloatingActionButton(
      //       backgroundColor: backgroundblack,
      //       onPressed: () async {
      //         await Navigator.push(context,
      //             MaterialPageRoute(builder: (context) => ScrapForm()));
      //         setState(() {
      //           getScrapData();
      //         });
      //       },
      //       child: Text(
      //         "${getTranslated(context, 'addScrap')}",
      //         style: TextStyle(
      //           fontSize: 12,
      //         ),
      //         textAlign: TextAlign.center,
      //       )),
      // ),
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          scrapModel == null
              ? SizedBox.shrink()
              : scrapModel!.data.isEmpty
                  ? SizedBox.shrink()
                  : Container(
                      height: 200,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xffF7F7F7),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Card(
                        color: Color(0xffF7F7F7),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: ListView(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 5, top: 5),
                              child: Text(
                                "${getTranslated(context, 'selectDataTime')}",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 5, right: 5),
                              child: InkWell(
                                onTap: () async {
                                  await _selectDate();
                                },
                                child: Container(
                                  height: 60,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 0.5, color: Colors.grey),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                        ),
                                        child: Icon(Icons.date_range),
                                      ),
                                      Expanded(
                                          child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                        ),
                                        child: new Text(
                                          _dateValue.length > 0
                                              ? dateFormate
                                              : "${getTranslated(context, 'pickADate')}",
                                          textAlign: TextAlign.start,
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 5, right: 5),
                              child: InkWell(
                                onTap: () async {
                                  selectTimeEE(context);
                                },
                                child: Container(
                                  height: 60,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 0.5, color: Colors.grey),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Icon(Icons.timer_sharp),
                                      ),
                                      Expanded(
                                          child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: new Text(
                                          selectTime == null
                                              ? "${getTranslated(context, 'chooseTime')}"
                                              : "$selectTime",
                                          textAlign: TextAlign.start,
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            _pickedLocation != ''
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5, top: 10, bottom: 5),
                                    child: InkWell(
                                      onTap: () async {
                                        // _getLocation();
                                        var result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ManageAddress(
                                                      resid: "1",
                                                      aId: addId,
                                                    )));
                                        print("address id ${result}");
                                        if (result != '') {
                                          setState(() {
                                            addId = result;
                                            getAddress(result);
                                          });
                                          print(
                                              "checing address id here ${addId.toString()}");
                                        }
                                      },
                                      child: Container(
                                        height: 60,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 0.5, color: Colors.grey),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          color: Colors.white,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Icon(
                                                  Icons.location_on_outlined),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20),
                                                child: new Text(
                                                  _pickedLocation.length > 0
                                                      ? _pickedLocation
                                                      : "${getTranslated(context, 'findLocation')}",
                                                  maxLines: 2,
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : InkWell(
                                    onTap: () async {
                                      var result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ManageAddress(
                                                    resid: "1",
                                                    aId: addId,
                                                  )));
                                      print("gibvkjbdgv === $result");
                                      if (result != '') {
                                        setState(() {
                                          addId = result;
                                          getAddress(result);
                                        });
                                        print("address id here $addId");
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5, top: 10),
                                      child: SizedBox(
                                          height: 60,
                                          width: double.infinity,
                                          child: Container(
                                            height: 60,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 0.5,
                                                  color: Colors.grey),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                              color: Colors.white,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Icon(Icons
                                                      .location_on_outlined),
                                                ),
                                                Expanded(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20),
                                                  child: new Text(
                                                    _pickedLocation.length > 0
                                                        ? _pickedLocation
                                                        : "${getTranslated(context, 'findLocation')}",
                                                    maxLines: 2,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                )),
                                              ],
                                            ),
                                          )
                                          // Container(
                                          //   decoration: BoxDecoration(
                                          //       color: backgroundblack,
                                          //       border: Border.all(color: Colors.grey),
                                          //       borderRadius:
                                          //           BorderRadius.all(Radius.circular(15))),
                                          //   height: 50.0,
                                          //   // ignore: deprecated_member_use
                                          //   child: Center(
                                          //     child: Stack(
                                          //       children: [
                                          //         Align(
                                          //           alignment: Alignment.center,
                                          //           child: Text(
                                          //             "SELECT ADDRESS",
                                          //             textAlign: TextAlign.center,
                                          //             style: TextStyle(
                                          //                 color: appColorWhite,
                                          //                 fontWeight: FontWeight.bold,
                                          //                 fontSize: 15),
                                          //           ),
                                          //         ),
                                          //       ],
                                          //     ),
                                          //   ),
                                          // )

                                          ),
                                    ),
                                  ),

                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 10),
                              child: Container(
                                height: 60,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.5, color: Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Icon(Icons.local_offer),
                                    ),
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: TextField(
                                        controller: coupanCodeController,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText:
                                                "${getTranslated(context, 'enterCouponCode')}"),
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return Container(
                                                padding: EdgeInsets.all(10),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      "${getTranslated(context, 'CouponCode')}",
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    coupanModel == null
                                                        ? Center(
                                                            child: Text(
                                                                "${getTranslated(context, 'NOCOUPANcODE')}"),
                                                          )
                                                        : ListView.builder(
                                                            shrinkWrap: true,
                                                            physics:
                                                                ScrollPhysics(),
                                                            itemCount:
                                                                coupanModel!
                                                                    .data!
                                                                    .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 8,
                                                                        left:
                                                                            8),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                            "Coupon Name: ",
                                                                            style:
                                                                                TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                                                        Text(
                                                                          "${coupanModel!.data![index].name}",
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                          "Coupon Code: ",
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                        InkWell(
                                                                          onTap: () {
                                                                            coupanCodeController.text = coupanModel!.data![index].code ?? "";
                                                                            promoCodeId = coupanModel!.data![index].id;
                                                                            promoCode = coupanModel!.data![index].code ?? "";
                                                                            Navigator.pop(context);
                                                                            if(int.parse(priceOffValue!) < totalprice){
                                                                              Fluttertoast.showToast(msg: "Coupon Not applied");
                                                                            }
                                                                          },
                                                                          child: Container(
                                                                            height: 35,
                                                                            width: 70,
                                                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: backgroundblack),
                                                                            child: Center(
                                                                              child: Text(
                                                                                "${coupanModel!.data![index].code}",
                                                                                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            }),
                                                  ],
                                                ));
                                          });
                                    },
                                    child: Text(
                                        "${getTranslated(context, 'getCouponCode')}")),
                                InkWell(
                                    onTap: () {
                                      // Navigator.push(context, MaterialPageRoute(builder: (context) => CouponList()));
                                      applyCode();
                                    },
                                    child: Text(
                                        "${getTranslated(context, 'applyCode')}")),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 5, bottom: 10),
                              child: Container(
                                padding: EdgeInsets.only(left: 10),
                                height: 60,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.5, color: Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 8, top: 5, bottom: 10),
                                  child: codestatus == "Promo Code Applied"
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${getTranslated(context, 'Total Price After Discount - ')}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              "\u{20B9} $discountPrice/-",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 18),
                                            )
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${getTranslated(context, 'Total Price - ')}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              "\u{20B9} $totalprice/-",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 18),
                                            )
                                          ],
                                        ),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ),

                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 5, bottom: 10),
                              child: Container(
                                padding: EdgeInsets.only(left: 10),
                                height: 60,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.5, color: Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Colors.white,
                                ),
                                child: DropdownButton(
                                  // Initial Value
                                  value: paymentValue,
                                  underline: Container(),
                                  isExpanded: true,
                                  // Down Arrow Icon
                                  icon: Icon(Icons.keyboard_arrow_down),

                                  hint: Text(
                                      "${getTranslated(context, 'selectpayment')}"),
                                  // Array list of items
                                  items: paymentType.map((items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Container(
                                        child: Text(items.toString()),
                                      ),
                                    );
                                  }).toList(),
                                  // After selecting the desired option,it will
                                  // change button value to selected value
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectPaymentMethood = null;
                                      paymentValue = newValue!;
                                      print(
                                          "selected category======================== ${paymentValue.toString()}");
                                    });
                                  },
                                ),
                              ),
                            ),
                            paymentValue == "Online"
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8, top: 5, bottom: 10),
                                    child: Container(
                                      padding: EdgeInsets.only(left: 10),
                                      height: 60,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5, color: Colors.grey),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                        ),
                                        color: Colors.white,
                                      ),
                                      child: DropdownButton<PaymentMethod>(
                                        hint: Text('Select Payment Method'),
                                        onChanged: (PaymentMethod? value) {
                                          print('Selected: ${value!.name}');
                                          setState(() {
                                            selectPaymentMethood = value;
                                            selectPaymentType = value.name;
                                            paymentMethod = selectPaymentMethood;
                                          });
                                        },
                                        underline: Container(),
                                        value: selectPaymentMethood,
                                        isExpanded: true,
                                        items: paymentMethods.map((PaymentMethod paymentMethod) {
                                          return DropdownMenuItem<PaymentMethod>(
                                            value: paymentMethod,
                                            child: Row(
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 30,
                                                  height: 30,
                                                  child: Image.asset(
                                                      paymentMethod.imagePath),
                                                ),
                                                SizedBox(width: 10),
                                                Text(paymentMethod.name),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                      // DropdownButton<PaymentMethod>(
                                      //   // Initial Value
                                      //   value: selectPaymentMethood,
                                      //   underline: Container(),
                                      //   isExpanded: true,
                                      //   // Down Arrow Icon
                                      //   icon: Icon(Icons.keyboard_arrow_down),
                                      //   hint: Text(
                                      //       "${getTranslated(context, 'selectpayment')}"),
                                      //   // Array list of items
                                      //   items:
                                      //       _onlinePaymentMethood.map((items) {
                                      //     return DropdownMenuItem(
                                      //       value: items ?? "",
                                      //       child: Container(
                                      //         child: Text(items.toString()),
                                      //       ),
                                      //     );
                                      //   }).toList(),
                                      //   // After selecting the desired option,it will
                                      //   // change button value to selected value
                                      //   onChanged: (newValue) {
                                      //     setState(() {
                                      //       selectPaymentMethood =
                                      //           newValue ?? "";
                                      //     });
                                      //   },
                                      // ),
                                    ),
                                  )
                                : SizedBox(),
                            selectPaymentType == "Phone Pay" || selectPaymentType == "Google Pay" || selectPaymentType == "Paytm"
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 10),
                                    child: Container(
                                      height: 60,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5, color: Colors.grey),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        color: Colors.white,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Icon(Icons.call),
                                          ),
                                          Expanded(
                                              child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 20),
                                            child: TextField(
                                              controller: mobilecontroller,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText:
                                                      "${getTranslated(context, 'MobileNumber')}"),
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            paymentValue == "Cash"? SizedBox():
                            selectPaymentType == "bank detail"
                                ? Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10, top: 10),
                                          child: Container(
                                            height: 60,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 0.5,
                                                  color: Colors.grey),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              color: Colors.white,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child:
                                                      Icon(Icons.arrow_forward),
                                                ),
                                                Expanded(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20),
                                                  child: TextField(
                                                    controller:
                                                        accountHoldernamecontroller,
                                                    decoration: InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            "${getTranslated(context, 'AccountHolderName')}"),
                                                  ),
                                                )),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10, top: 10),
                                          child: Container(
                                            height: 60,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 0.5,
                                                  color: Colors.grey),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              color: Colors.white,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child:
                                                      Icon(Icons.other_houses),
                                                ),
                                                Expanded(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20),
                                                  child: TextField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    controller:
                                                        accountnumbercontroller,
                                                    decoration: InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            "${getTranslated(context, 'AccountNumber')}"),
                                                  ),
                                                )),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10, top: 10),
                                          child: Container(
                                            height: 60,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 0.5,
                                                  color: Colors.grey),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              color: Colors.white,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child:
                                                      Icon(Icons.other_houses),
                                                ),
                                                Expanded(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20),
                                                  child: TextFormField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please Enter Confirm Account Number';
                                                      } else if (confirmaccnumbercontroller
                                                              .text !=
                                                          "${accountnumbercontroller.text}") {
                                                        return 'Account Number Not Match';
                                                      }
                                                    },
                                                    controller:
                                                        confirmaccnumbercontroller,
                                                    decoration: InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            "${getTranslated(context, 'AccountConfirm')}"),
                                                  ),
                                                )),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10, top: 10),
                                          child: Container(
                                            height: 60,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 0.5,
                                                  color: Colors.grey),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              color: Colors.white,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child:
                                                      Icon(Icons.other_houses),
                                                ),
                                                Expanded(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20),
                                                  child: TextField(
                                                    controller: ifsccontroller,
                                                    decoration: InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            "${getTranslated(context, 'IfscCode')}"),
                                                  ),
                                                )),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10, top: 10),
                                          child: Container(
                                            height: 60,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 0.5,
                                                  color: Colors.grey),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              color: Colors.white,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child:
                                                      Icon(Icons.other_houses),
                                                ),
                                                Expanded(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20),
                                                  child: TextField(
                                                    controller:
                                                        banknamecontroller,
                                                    decoration: InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            "${getTranslated(context, 'Bankname')}"),
                                                  ),
                                                )),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10, top: 10),
                                          child: Container(
                                            height: 60,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 0.5,
                                                  color: Colors.grey),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              color: Colors.white,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child:
                                                      Icon(Icons.other_houses),
                                                ),
                                                Expanded(child: Padding(
                                                  padding: const EdgeInsets.only(left: 20),
                                                  child: TextField(
                                                    controller: branchcontroller,
                                                    decoration: InputDecoration(
                                                        border: InputBorder.none,
                                                        hintText:
                                                            "${getTranslated(context, 'BankBranch')}"),
                                                  ),
                                                )),
                                              ],
                                            ),
                                          ),
                                        ),
                                        paymentValue == "Cash" ? SizedBox():
                                        Visibility(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10, top: 10),
                                            child: Container(
                                              height: 60,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 0.5,
                                                    color: Colors.grey),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                color: Colors.white,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: Icon(Icons.call),
                                                  ),
                                                  Expanded(
                                                      child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20),
                                                    child: TextField(
                                                      maxLength: 10,
                                                      controller:
                                                          mobilecontroller,
                                                      decoration: InputDecoration(
                                                          counterText: "",
                                                          border:
                                                              InputBorder.none,
                                                          hintText:
                                                              "${getTranslated(context, 'MobileNumber')}"),
                                                    ),
                                                  )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : SizedBox()
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 8, right:8, top: 5,bottom: 10),
                            //   child: SizedBox(
                            //     height: 60,
                            //     width: double.infinity,
                            //     child:
                            //     InkWell(
                            //       onTap: () async{
                            //       await showPaymentPopup();
                            //         },
                            //       child: Container(
                            //         height: 60,
                            //         width: double.infinity,
                            //         decoration: BoxDecoration(
                            //           border: Border.all(width: 0.5, color: Colors.grey),
                            //           borderRadius: BorderRadius.all(Radius.circular(10)),
                            //           color: Colors.white,
                            //         ),
                            //         child: Row(
                            //           children: [
                            //             // Padding(
                            //             //   padding: const EdgeInsets.only(left: 10),
                            //             //   child: Icon(Icons.payment),
                            //             // ),
                            //
                            //            // Expanded(
                            //            //   child: Padding(
                            //            //     padding: const EdgeInsets.only(left: 15.0),
                            //            //     child: Text(
                            //            //       selectpayment == ""?
                            //            //         "${getTranslated(context, 'selectpayment')}"
                            //            //     : "${selectpayment.toString()}"
                            //            //     ),
                            //            //   ),
                            //            // ),
                            //          //  AlertDialog(
                            //          //  title: Text("Notice"),
                            //          //   content: Text("Launching this missile will destroy the entire universe. Is this what you intended to do?"),
                            //          //    actions: [
                            //          //   // remindButton,
                            //          //   // cancelButton,
                            //          // // launchButton,
                            //          //    ],
                            //          //
                            //          //    )
                            //
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // )
                            // Align(
                            //     alignment: Alignment.centerRight,
                            //     child: Padding(
                            //       padding: EdgeInsets.only(right: 30, top: 8),
                            //       child: InkWell(
                            //           onTap: () {
                            //             applyCode();
                            //             print("working");
                            //           },
                            //           child: Text(
                            //             "Apply Code",
                            //           )),
                            //     )),
                          ],
                        ),
                      ),
                    ),
              scrapModel?.data.isEmpty ?? true
              ? SizedBox.shrink()
              : InkWell(
                  onTap: () {
                    if (dateFormate == null || dateFormate == "") {
                      Fluttertoast.showToast(msg: "Please Select Date");
                    } else if (selectTime == null) {
                      Fluttertoast.showToast(msg: "Please Select Time");
                    } else if (_pickedLocation == null ||
                        _pickedLocation == "") {
                      Fluttertoast.showToast(msg: "Please Fill Location");
                    } else if (paymentValue == null || paymentValue == "") {
                      Fluttertoast.showToast(msg: "Please Select Payment Type");
                    } else {
                      if (selectPaymentMethood == "bank detail") {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          bookingApi();
                        }
                      } else {
                        setState(() {
                          isLoading = true;
                        });
                        bookingApi();
                      }
                    }
                  },
                  child: Container(
                    height: 45,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: backgroundblack,
                        borderRadius: BorderRadius.circular(6)),
                    child: isLoading == true
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            "${getTranslated(context, 'placeOrder')}",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ),
                  ),
                ),
        ],
      ),
      // appBar: AppBar(
      //   backgroundColor: backgroundblack,
      //   elevation: 0,
      //   shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.only(
      //           bottomLeft: Radius.circular(20),
      //           bottomRight: Radius.circular(20))),
      //   // bottom:
      //   title: Text(
      //     "Add Scrap",      //   automaticallyImplyLeading: false,
      //     style: TextStyle(color: appColorWhite),
      //   ),
      //   centerTitle: true,
      // ),
      body: Container(
        height: MediaQuery.of(context).size.height / 1.6,
        child: scrapModel == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : scrapModel!.data.isEmpty
                ? Center(
                    child: Text(
                      "${getTranslated(context, 'ScrapNOTfOUNDInCart')}",
                      style: TextStyle(
                        color: appColorBlack,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: scrapModel!.data.length,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        child: Stack(
                          children: [
                            Card(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Text(
                                                "${getTranslated(context, 'Scrap Name :')}")),
                                        scrapModel!.data[index].scrapName ==
                                                null
                                            ? SizedBox.shrink()
                                            : Expanded(
                                                child: Text(
                                                    "${scrapModel!.data[index].scrapName}")),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Text(
                                                "${getTranslated(context, 'Categories Name :')}")),
                                        Expanded(
                                            child: Text(
                                                "${scrapModel!.data[index].cName}")),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Text(
                                                "${getTranslated(context, 'Subscrap Name : ')}")),
                                        Expanded(
                                            child: Text(
                                                "${scrapModel!.data[index].subName}")),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "${getTranslated(context, 'Quantity :')}",
                                          style: TextStyle(fontSize: 14),
                                        )),
                                        Expanded(
                                            child: Text(
                                                "${scrapModel!.data[index].qty} Kg")),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "${getTranslated(context, 'Price : ')}",
                                          style: TextStyle(fontSize: 14),
                                        )),
                                        Expanded(
                                            child: Text(
                                                " \u{20B9} ${scrapModel!.data[index].total.toString()} ")),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    //
                                    // Text("SubCategory Name : ${scrapList[index].subCategory}"),
                                    // Text("Quantity : ${scrapList[index].qty}"),
                                    Container(
                                        height: 70,
                                        width: 80,
                                        child: scrapModel!.data[index].image ==
                                                null
                                            ? Icon(Icons.photo)
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                child: Image.network(
                                                  "${scrapModel?.imagePath}${scrapModel!.data[index].image}",
                                                  fit: BoxFit.fill,
                                                ),
                                        ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10, right: 10),
                                child: InkWell(
                                  onTap: () {
                                    deleteScrap(
                                        scrapModel!.data[index].id.toString());
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
      ),
      // Container(
      //   child: ListView(
      //     padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      //     children: [
      //    scrapList.isNotEmpty ? SizedBox.shrink() :
      //  /// main form
      //    Container(
      //         child: Column(
      //           children: [
      //             Container(
      //               height: 60,
      //               padding: EdgeInsets.only(left: 10),
      //               decoration: BoxDecoration(
      //                   borderRadius: BorderRadius.circular(7),
      //                   border: Border.all(color: appColorBlack.withOpacity(0.3))
      //               ),
      //               child: DropdownButton(
      //                 // Initial Value
      //                 value: selectedCategory,
      //                 underline: Container(),
      //                 // Down Arrow Icon
      //                 icon: Icon(Icons.keyboard_arrow_down),
      //                 hint: Container(
      //                     width: MediaQuery.of(context).size.width/1.25,
      //                     child: Text("Select category")),
      //                 // Array list of items
      //                 items: catlist.map((items) {
      //                   return DropdownMenuItem(
      //                     value: items.id,
      //                     child: Container(
      //                         child: Text(items.cName.toString())),
      //                   );
      //                 }).toList(),
      //                 // After selecting the desired option,it will
      //                 // change button value to selected value
      //                 onChanged: (String? newValue) {
      //                   setState(() {
      //                     print("catName here ${catName}");
      //                     selectedCategory = newValue!;
      //                     getSubCategory();
      //                     print("selected category ${selectedCategory}");
      //                   });
      //                 },
      //               ),
      //             ),
      //             SizedBox(height: 10,),
      //             Container(
      //               height: 60,
      //               padding: EdgeInsets.only(left: 10),
      //               decoration: BoxDecoration(
      //                   borderRadius: BorderRadius.circular(7),
      //                   border: Border.all(color: appColorBlack.withOpacity(0.3))
      //               ),
      //               child: DropdownButton(
      //                 // Initial Value
      //                 value: selectedSubcategory,
      //                 underline: Container(),
      //                 // Down Arrow Icon
      //                 icon: Container(
      //                   // width: MediaQuery.of(context).size.width/1.5,
      //                     alignment: Alignment.centerRight,
      //                     child: Icon(Icons.keyboard_arrow_down)),
      //                 hint: Container(width: MediaQuery.of(context).size.width/1.25, child: Text("Select sub category")),
      //                 // Array list of items
      //                 items: subCatList.map((items) {
      //                   return DropdownMenuItem(
      //                     value: items.id,
      //                     child: Container(
      //                         child: Text(items.cName.toString())),
      //                   );
      //                 }).toList(),
      //                 // After selecting the desired option,it will
      //                 // change button value to selected value
      //                 onChanged: (String? newValue) {
      //                   setState(() {
      //                     selectedSubcategory = newValue!;
      //                     print("selected sub category ${selectedSubcategory}");
      //                   });
      //                 },
      //               ),
      //             ),
      //             SizedBox(height: 10,),
      //             TextFormField( controller: quantityController,
      //               keyboardType: TextInputType.number,
      //               validator: (v){
      //                 if(v!.isEmpty){
      //                   return "Enter quantity";
      //                 }
      //               },
      //               decoration: InputDecoration(
      //                   hintText: "Enter quantity in kg",
      //                   border: OutlineInputBorder(
      //                       borderRadius: BorderRadius.circular(7),
      //                       borderSide: BorderSide(color: appColorBlack.withOpacity(0.5))
      //                   )
      //               ),),
      //             SizedBox(height: 20,),
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [
      //                 InkWell(
      //                   onTap: (){
      //                     showDialog(context: context, builder: (context){
      //                       return AlertDialog(
      //                         content: Column(
      //                           crossAxisAlignment: CrossAxisAlignment.start,
      //                           mainAxisAlignment: MainAxisAlignment.center,
      //                           mainAxisSize: MainAxisSize.min,
      //                           children: [
      //                             InkWell(
      //                               onTap:()async{
      //                                 // String fileUrl = await storageReference.getDownloadURL();
      //                                 PickedFile? image = await ImagePicker.platform
      //                                     .pickImage(source: ImageSource.gallery);
      //                                 imageFiles = File(image!.path);
      //                                 setState(() {
      //
      //                                 });
      //                                 print("image files here ${imageFiles!.path.toString()}");
      //                                 Navigator.of(context).pop();
      //                               },
      //                               child: Row(
      //                                 crossAxisAlignment: CrossAxisAlignment.start,
      //                                 children: [
      //                                   Icon(Icons.photo),
      //                                   SizedBox(width: 5,),
      //                                   Text("Gallery")
      //                                 ],
      //                               ),
      //                             ),
      //                             SizedBox(height: 10,),
      //                             InkWell(
      //                               onTap:()async{
      //                                 PickedFile? image = await ImagePicker.platform
      //                                     .pickImage(source: ImageSource.camera);
      //                                 imageFiles = File(image!.path);
      //                                 print("image files here ${imageFiles!.path.toString()}");
      //                                 setState(() {
      //
      //                                 });
      //                                 Navigator.of(context).pop();
      //                               },
      //                               child: Row(
      //                                 crossAxisAlignment: CrossAxisAlignment.start,
      //                                 children: [
      //                                   Icon(Icons.camera_alt),
      //                                   SizedBox(width: 5,),
      //                                   Text("Camera")
      //                                 ],
      //                               ),
      //                             ),
      //                           ],
      //                         ),
      //                       );
      //                     });
      //                   },
      //                   child: Container(
      //                     height: 90,
      //                     width: 80,
      //                     decoration: BoxDecoration(
      //                         border: Border.all(color: Colors.grey)
      //                     ),
      //                     child:imageFiles == null ?  Icon(Icons.photo) : Image.file(imageFiles!,fit: BoxFit.fill,) ,
      //                   ),
      //                 ),
      //
      //               ],
      //             ),
      //             SizedBox(height: 15,),
      //             InkWell(
      //               onTap: (){
      //                 setState(() {
      //                   scrapList.add(
      //                     ScrapModel(
      //                       id: "1",
      //                       image: imageFiles!.path.toString(),
      //                       category: selectedCategory.toString(),
      //                       subCategory: selectedSubcategory.toString(),
      //                       qty: quantityController.text.toString(),
      //                     ),
      //                   );
      //
      //                 });
      //               },
      //               child: Container(
      //                 height: 45,
      //                 alignment: Alignment.center,
      //                 decoration: BoxDecoration(
      //                     color: backgroundblack,
      //                     borderRadius: BorderRadius.circular(6)
      //                 ),
      //                 child: Text("Add",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w600),),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //       /// show added list data
      //       Container(
      //         child: ListView.builder(
      //             shrinkWrap: true,
      //             itemCount: scrapList.length,
      //             physics: ScrollPhysics(),
      //             itemBuilder: (context,index){
      //           return Card(
      //             child: Padding(
      //               padding: EdgeInsets.all(8.0),
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Row(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Expanded(child: Text("Category Name : ")),
      //                       Expanded(child: Text("${scrapList[index].category}")),
      //                     ],
      //                   ),
      //                   SizedBox(height: 6,),
      //                   Row(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Expanded(child: Text("SubCategory Name : ")),
      //                       Expanded(child: Text("${scrapList[index].subCategory}")),
      //                     ],
      //                   ),
      //                   SizedBox(height: 6,),
      //                   Row(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Expanded(child: Text("Quantity : ",style: TextStyle(fontSize: 14),)),
      //                       Expanded(child: Text("${scrapList[index].qty} Kg")),
      //                     ],
      //                   ),
      //                   SizedBox(height: 6,),
      //                   //
      //                   // Text("SubCategory Name : ${scrapList[index].subCategory}"),
      //                   // Text("Quantity : ${scrapList[index].qty}"),
      //                   Container(
      //                       height:70,
      //                       width:80,
      //                       child: ClipRRect(
      //                           borderRadius:BorderRadius.circular(6),
      //                           child: Image.file( File(scrapList[index].image.toString()),fit: BoxFit.fill,)))
      //                 ],
      //               ),
      //             ),
      //           );
      //         }),
      //       ),
      //       SizedBox(height: 10,),
      //
      //     /// add more button with form functionality
      //     scrapList.isEmpty ? SizedBox.shrink() :   InkWell(
      //       onTap: ()async{
      //         setState(() {
      //           selectedSubcategory =  null;
      //           selectedCategory = null;
      //           quantityController.clear();
      //           imageFiles = null;
      //         });
      //        await showDialog(context: context, builder: (context){
      //           return StatefulBuilder(
      //               builder: (BuildContext context, StateSetter setState) {
      //                 return AlertDialog(
      //                   content: Column(
      //                     mainAxisSize: MainAxisSize.min,
      //                     children: [
      //                       Container(
      //                         height: 60,
      //                         padding: EdgeInsets.only(left: 10),
      //                         decoration: BoxDecoration(
      //                             borderRadius: BorderRadius.circular(7),
      //                             border: Border.all(color: appColorBlack.withOpacity(0.3))
      //                         ),
      //                         child: DropdownButton(
      //                           // Initial Value
      //                           value: selectedCategory,
      //                           underline: Container(),
      //                           // Down Arrow Icon
      //                           icon: Icon(Icons.keyboard_arrow_down),
      //                           hint: Container(
      //                               width: MediaQuery.of(context).size.width/1.9,
      //                               child: Text("Select category")),
      //                           // Array list of items
      //                           items: catlist.map((items) {
      //                             return DropdownMenuItem(
      //                               value: items.id,
      //                               child: Container(
      //                                   child: Text(items.cName.toString())),
      //                             );
      //                           }).toList(),
      //                           // After selecting the desired option,it will
      //                           // change button value to selected value
      //                           onChanged: (String? newValue){
      //                             setState(() {
      //                               selectedCategory = newValue!;
      //                               getSubCategory();
      //                               print("selected category ${selectedCategory}");
      //                             });
      //                           },
      //                         ),
      //                       ),
      //                       SizedBox(height: 10,),
      //                       Container(
      //                         height: 60,
      //                         padding: EdgeInsets.only(left: 10),
      //                         decoration: BoxDecoration(
      //                             borderRadius: BorderRadius.circular(7),
      //                             border: Border.all(color: appColorBlack.withOpacity(0.3))
      //                         ),
      //                         child: DropdownButton(
      //                           // Initial Value
      //                           value: selectedSubcategory,
      //                           underline: Container(),
      //                           // Down Arrow Icon
      //                           icon: Container(
      //                             // width: MediaQuery.of(context).size.width/1.5,
      //                               alignment: Alignment.centerRight,
      //                               child: Icon(Icons.keyboard_arrow_down)),
      //                           hint: Container(width: MediaQuery.of(context).size.width/1.9, child: Text("Select sub category")),
      //                           // Array list of items
      //                           items: subCatList.map((items) {
      //                             return DropdownMenuItem(
      //                               value: items.id,
      //                               child: Container(
      //                                   child: Text(items.cName.toString())),
      //                             );
      //                           }).toList(),
      //                           // After selecting the desired option,it will
      //                           // change button value to selected value
      //                           onChanged: (String? newValue) {
      //                             setState(() {
      //                               selectedSubcategory = newValue!;
      //                               print("selected sub category ${selectedSubcategory}");
      //                             });
      //                           },
      //                         ),
      //                       ),
      //                       SizedBox(height: 10,),
      //                       TextFormField( controller: quantityController,
      //                         keyboardType: TextInputType.number,
      //                         validator: (v){
      //                           if(v!.isEmpty){
      //                             return "Enter quantity";
      //                           }
      //                         },
      //                         decoration: InputDecoration(
      //                             hintText: "Enter quantity in kg",
      //                             border: OutlineInputBorder(
      //                                 borderRadius: BorderRadius.circular(7),
      //                                 borderSide: BorderSide(color: appColorBlack.withOpacity(0.5))
      //                             )
      //                         ),),
      //                       SizedBox(height: 20,),
      //                       Row(
      //                         children: [
      //                           InkWell(
      //                             onTap: (){
      //                               showDialog(context: context, builder: (context){
      //                                 return AlertDialog(
      //                                   content: Column(
      //                                     crossAxisAlignment: CrossAxisAlignment.start,
      //                                     mainAxisAlignment: MainAxisAlignment.center,
      //                                     mainAxisSize: MainAxisSize.min,
      //                                     children: [
      //                                       InkWell(
      //                                         onTap:()async{
      //                                           // String fileUrl = await storageReference.getDownloadURL();
      //                                           PickedFile? image = await ImagePicker.platform
      //                                               .pickImage(source: ImageSource.gallery);
      //                                           imageFiles = File(image!.path);
      //                                           setState(() {
      //
      //                                           });
      //                                           print("image files here ${imageFiles!.path.toString()}");
      //                                           Navigator.of(context).pop();
      //                                         },
      //                                         child: Row(
      //                                           crossAxisAlignment: CrossAxisAlignment.start,
      //                                           children: [
      //                                             Icon(Icons.photo),
      //                                             SizedBox(width: 5,),
      //                                             Text("Gallery")
      //                                           ],
      //                                         ),
      //                                       ),
      //                                       SizedBox(height: 10,),
      //                                       InkWell(
      //                                         onTap:()async{
      //                                           PickedFile? image = await ImagePicker.platform
      //                                               .pickImage(source: ImageSource.camera);
      //                                           imageFiles = File(image!.path);
      //                                           print("image files here ${imageFiles!.path.toString()}");
      //                                           setState(() {
      //
      //                                           });
      //                                           Navigator.of(context).pop();
      //                                         },
      //                                         child: Row(
      //                                           crossAxisAlignment: CrossAxisAlignment.start,
      //                                           children: [
      //                                             Icon(Icons.camera_alt),
      //                                             SizedBox(width: 5,),
      //                                             Text("Camera")
      //                                           ],
      //                                         ),
      //                                       ),
      //                                     ],
      //                                   ),
      //                                 );
      //                               });
      //                             },
      //                             child: Container(
      //                               height: 90,
      //                               width: 80,
      //                               decoration: BoxDecoration(
      //                                   border: Border.all(color: Colors.grey)
      //                               ),
      //                               child:imageFiles == null ?  Icon(Icons.photo) : Image.file(imageFiles!,fit: BoxFit.fill,) ,
      //                             ),
      //                           ),
      //
      //                         ],
      //                       ),
      //                       SizedBox(height: 15,),
      //                       InkWell(
      //                         onTap: ()async{
      //                           setState(() {
      //                             scrapList.add(
      //                               ScrapModel(
      //                                 id: "1",
      //                                 image: imageFiles!.path.toString(),
      //                                 category: selectedCategory.toString(),
      //                                 subCategory: selectedSubcategory.toString(),
      //                                 qty: quantityController.text.toString(),
      //                               ),
      //                             );
      //                           });
      //                         Navigator.pop(context);
      //                         },
      //                         child: Container(
      //                           height: 45,
      //                           alignment: Alignment.center,
      //                           decoration: BoxDecoration(
      //                             borderRadius: BorderRadius.circular(6),
      //                             color: backgroundblack
      //                           ),
      //                           child: Text("Add",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w600),),
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 );
      //               }
      //           );
      //         });
      //        setState(() {
      //
      //        });
      //       },
      //       child: Container(
      //         height: 35,
      //         margin: EdgeInsets.only(left: 30,right: 30,bottom: 50),
      //         padding: EdgeInsets.symmetric(horizontal: 3),
      //         alignment: Alignment.center,
      //         decoration: BoxDecoration(
      //           color: backgroundblack,
      //           borderRadius: BorderRadius.circular(6),
      //         ),
      //         child: Row(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             Icon(Icons.add,color: Colors.white,),
      //             SizedBox(width: 3,),
      //             Text("Add more",style: TextStyle(color: Colors.white),),
      //           ],
      //         ),
      //       ),
      //     ),
      //
      //     ],
      //   ),
      // ),
    );
  }
}
