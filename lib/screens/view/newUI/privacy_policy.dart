import 'dart:convert';
import 'package:ez/screens/view/models/privacy_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import '../../../Helper/session.dart';
import '../../../constant/global.dart';
import '../../../constant/sizeconfig.dart';
import '../models/faq_model.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFaq();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: appColorWhite,
      appBar: AppBar(
        backgroundColor: backgroundblack,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)
            )
        ),
        elevation: 2,
        title: Text('${getTranslated(context, 'Privacy&Policy')}',
          style: TextStyle(
            fontSize: 20,
            color: appColorWhite,
          ),
        ),
        centerTitle: true,
        leading:  Padding(
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
      body:

      !isLoading?

      SingleChildScrollView(
          child:

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                Html(data: faqModel?.privacyPolicy?.discription??"",

                ),

              ],
            ),
          )

      ):
      Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Center(child: CircularProgressIndicator(color: Colors.black,),)),
    );
  }

  bool isLoading=false;
  FaqModel?faqModel;
  Future getFaq() async {
    setState(() {
      isLoading=true;
    });
    var request = http.Request('GET', Uri.parse('${baseUrl()}/faq'));
    http.StreamedResponse response = await request.send();
    print(request);
    print(response.statusCode);
    print("===my technic=======${request.url}===============");
    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();
      print(str);
      var finalresult=jsonDecode(str);
      if(finalresult['status']=="1") {

        faqModel= FaqModel.fromJson(finalresult);
        setState(() {
          isLoading=false;
        });
      }
    }
    else {

    }
  }

}
