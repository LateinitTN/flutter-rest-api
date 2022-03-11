import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingPageWidget extends StatelessWidget {
  bool check;
  LoadingPageWidget({Key? key, this.check = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Visibility(
        visible: check,
        child: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ),
      ),
    );
  }
}
