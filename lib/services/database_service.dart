import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plastiex/models/submission.dart';
import 'package:plastiex/ui/alert.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference submissionCollection =
      FirebaseFirestore.instance.collection("submissions");

  CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  CollectionReference balanceCollection =
      FirebaseFirestore.instance.collection("balances");

  CollectionReference adminCollection =
      FirebaseFirestore.instance.collection("admins");

  Future createSubmission(Submission submission) async {
    try {
      final data = {
        "user": uid,
        "capacity": submission.capacity,
        "quantity": submission.quantity,
        "is_pending": submission.isPending,
        "location": submission.location,
        "created_at": DateTime.now(),
        "submission_date": submission.date,
        "type": submission.type,
        "price": submission.price
      };
      Map<String, Object> subData = HashMap.from(data);
      final document = await submissionCollection.add(subData);

      return document;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future updateUser({String name, String avatar}) async {
    try {
      await _auth.currentUser
          .updateProfile(displayName: name, photoURL: avatar);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future createBalance() async {
    try {
      final Map data = {"balance": 0.0};
      final HashMap<String, Object> userData = HashMap.from(data);
      final document = await balanceCollection.doc(uid).set(userData);

      return document;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Widget getBalance(BuildContext context) {
    return StreamBuilder(
      stream: balanceCollection.doc(uid).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Error");
        } else {
          return Text("N${snapshot.data.get('balance')}");
        }
      },
    );
  }

  Future withdraw(String amount, BuildContext context) async {
    try {
      final balance =
          await (await balanceCollection.doc(uid).get()).get("balance");

      if (int.parse(amount) > balance)
        return Alert().showAlert(
            isSuccess: false,
            context: context,
            message: 'Insufficient balance');

      await balanceCollection
          .doc(uid)
          .update({"balance": balance - int.parse(amount)});

      return true;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
