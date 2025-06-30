
import 'package:country_code_picker/country_localizations.dart';

import 'package:ez/constant/constant.dart';
import 'package:ez/constant/global.dart';
import 'package:ez/screens/view/newUI/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Helper/demo_localization.dart';
import 'Helper/session.dart';
import 'app.dart';
import 'constant/push_notification_service.dart';
import 'package:permission_handler/permission_handler.dart';

// ...


const iOSLocalizedLabels = false;

// Future main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   var status = await Permission.location.status;
//   if (status.isGranted) {
//     await Firebase.initializeApp();
//     FirebaseMessaging.onBackgroundMessage(myForgroundMessageHandler);
//     SystemChrome.setPreferredOrientations(
//         [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
//     );
//
//     SharedPreferences.getInstance().then(
//           (prefs) async {
//         print("===my technic=======maipage===============");
//         runApp(MyApp(prefs: prefs,)
//         );
//       },
//     );
//   } else {
//     print("===my technic======lon access============");
//     // Handle the case where location permission is not granted.
//   }
//
//
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var status = await Permission.location.status;
  if (status.isGranted) {
    await initializeApp();
  } else {
    // Request location permission
    var permissionStatus = await Permission.location.request();
    if (permissionStatus.isGranted) {
      // Permission granted, proceed with initialization
      await initializeApp();
    } else {
      print("Location permission denied");
      // Handle the case where location permission is not granted.
    }
  }
}

Future<void> initializeApp() async {
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(myForgroundMessageHandler);
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  SharedPreferences.getInstance().then((prefs) {
      print("===my technic=======maipage===============");
      runApp(MyApp(prefs: prefs));
    },
  );
}


class MyApp extends StatefulWidget {
   SharedPreferences? prefs;
  MyApp({this.prefs});

  late SharedPreferences sharedPreferences;

   static void setLocale(BuildContext context, Locale newLocale) {
     _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
     state.setLocale(newLocale);
   }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    if (mounted)
      setState(() {
        _locale = locale;
      });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      if (mounted)
        setState(() {
          this._locale = locale;
        });
    });
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    if(this._locale == null){
      return Container(
        child: Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color?>(backgroundblack)),
        ),
      );
    }else{
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "scrapy5",
        locale: _locale,
        supportedLocales: [
          Locale("en", "US"),
          Locale("hi", "IN"),
        ],
        localizationsDelegates: [
          CountryLocalizations.delegate,
          DemoLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale!.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        theme: new ThemeData(
            // accentColor: Colors.black,
            primaryColor: Colors.black,
            primaryColorDark: Colors.black),
        home: SplashScreen(),
        routes: <String, WidgetBuilder>{
          App_Screen: (BuildContext context) => AppScreen(widget.prefs!),
        },
      );
    }

  }
}
