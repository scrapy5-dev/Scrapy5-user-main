// import 'dart:io';
// import 'package:flutter/material.dart';
//
// class Internet extends StatefulWidget {
//   const Internet({Key? key}) : super(key: key);
//
//   @override
//   State<Internet> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<Internet> {
//   bool ActiveConnection = false;
//   String T = "";
//   Future CheckUserConnection() async {
//     try {
//       final result = await InternetAddress.lookup('google.com');
//       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//         setState(() {
//           ActiveConnection = true;
//           T = "Turn off the data and repress again";
//         });
//       }
//     } on SocketException catch (_) {
//       setState(() {
//         ActiveConnection = false;
//         T = "Turn On the data and repress again";
//       });
//     }
//   }
//   @override
//   void initState() {
//     CheckUserConnection();
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("GeeksforGeeks"),
//       ),
//       body: Column(
//         children: [
//           Text("Active Connection? $ActiveConnection"),
//           const Divider(),
//           Text(T),
//           OutlinedButton(
//               onPressed: () {
//                 CheckUserConnection();
//               },
//               child: const Text("Check"))
//         ],
//       ),
//     );
//   }
// }
