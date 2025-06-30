// import 'package:flutter/material.dart';
//
// import '../../../constant/global.dart';
//
// class CouponList extends StatefulWidget {
//   const CouponList({Key? key}) : super(key: key);
//
//   @override
//   State<CouponList> createState() => _CouponListState();
// }
//
// class _CouponListState extends State<CouponList> {
//
// couponList
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xffF5F5F5),
//       appBar: AppBar(
//         title: Text("Coupon List", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),),
//         automaticallyImplyLeading: false,
//         leading: Padding(
//           padding: const EdgeInsets.all(12),
//           child: RawMaterialButton(
//             shape: CircleBorder(),
//             padding: const EdgeInsets.all(0),
//             fillColor: Colors.white,
//             splashColor: Colors.grey[400],
//             child: Icon(
//               Icons.arrow_back,
//               size: 20,
//               color: appColorBlack,
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//         ),
//         backgroundColor: backgroundblack,
//         elevation: 2,
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(20),
//                 bottomRight: Radius.circular(20))),
//         // title: Text(
//         //   'Categories',
//         //   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         // ),
//         centerTitle: true,
//       ),
//     );
//   }
// }
