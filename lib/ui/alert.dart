import 'package:flutter/material.dart';
import 'package:plastiex/ui/colors.dart';

class Alert {
  Future showAlert(
      {bool isSuccess: true, BuildContext context, String message}) async {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            isSuccess ? Icons.info_outlined : Icons.warning_rounded,
            color: Colors.white,
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(child: Text("$message")),
        ],
      ),
      backgroundColor: isSuccess ? green : red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
