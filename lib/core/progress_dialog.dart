import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';



class ProgressDialog {

  static OverlayEntry? currentLoader;
  static bool isShowing = false;



  static void show(BuildContext context, String? textToShow,IconData? icon) {
    if (!isShowing) {
      currentLoader = OverlayEntry(
        builder: (context) => WillPopScope(
          onWillPop: () async => false,
          child: GestureDetector(
            child: Container(
              color: Colors.black87,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child:getCircularProgressIndicator(Icon(icon,color: primaryColorOfApp,size: 60)),
                      width: 150,
                      height: 150,
                      padding: const EdgeInsets.all(8.0),
                    ),
                    SizedBox(height: 20,),
                    Text(textToShow??"Please Wait",style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.headline5,fontWeight: FontWeight.bold,color: Colors.white),textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              // do nothing
            },
            onDoubleTap: () {
              ProgressDialog.hide();
            },
          ),
        ),
      );
      Overlay.of(context)?.insert(currentLoader!);
      isShowing = true;
    }
  }

  static void hide() {
    if (currentLoader != null) {
      currentLoader?.remove();
      isShowing = false;
      currentLoader = null;
    }
  }

  static getCircularProgressIndicator(Icon icon ) {

    return Container(
      alignment: Alignment.center,
      child: Stack(
        children: [
          Center(child: icon),
          SizedBox(
            height: 150,width: 150,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColorOfApp),
            ),
          ),
        ],
      ),
    );
  }

  static getErrorWidget() {
    return Container(
      alignment: Alignment.center,
      child: const SizedBox(
        child: Text("Oops! Something went wrong."),
      ),
    );
  }
}
