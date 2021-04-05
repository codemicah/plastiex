import 'package:flutter/material.dart';
import 'package:plastiex/ui/colors.dart';

Loader loader = Loader();

class Loader {
  void loading(BuildContext context) {
    final dialog = Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 5,
          valueColor: AlwaysStoppedAnimation(primaryColor),
        ),
      ),
    );
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => dialog);
  }
}
