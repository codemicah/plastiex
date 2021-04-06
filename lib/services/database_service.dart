import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plastiex/models/submission.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  CollectionReference submissionCollection =
      FirebaseFirestore.instance.collection("submissions");

  Future createSubmission(Submission submission) async {
    try {
      final data = {
        "uid": submission.uid,
        "capacity": submission.capacity,
        "quantity": submission.quantity
      };
      Map<String, Object> subData = HashMap.from(data);
      submissionCollection.add(subData);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
