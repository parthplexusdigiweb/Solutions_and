import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class loadingView extends StatelessWidget {
  bool isLoading;
  loadingView(this.isLoading, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isLoading ? Colors.white : null,
      height: double.infinity,
      child: isLoading
          ? const Center(
              child: SpinKitThreeBounce(
              color: Colors.blue,
              size: 25.0,
            ))
          : Container(),
    );
  }
}
