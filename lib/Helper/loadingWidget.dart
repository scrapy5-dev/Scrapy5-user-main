import 'package:date_picker_timeline/extra/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../constant/global.dart';


Widget LoadingWidget(BuildContext context){

  return SpinKitThreeInOut(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: index.isEven ?appColorGreen : backgroundblack,
        ),
      );
    },
    // color: Colors.white,
    size: 20.0,
  );
}

