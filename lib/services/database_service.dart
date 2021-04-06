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

  Future getAllSubmissions() async {}
}
