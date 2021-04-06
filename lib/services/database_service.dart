import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plastiex/models/submission.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  CollectionReference submissionCollection =
      FirebaseFirestore.instance.collection("submissions");

  CollectionReference userCollection =
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

  Future updateUser(String name, String avatar) async {
    try {
      final Map userData = {"name": name, "avatar": avatar, "is_admin": false};

      final HashMap<String, Object> userDoc = HashMap.from(userData);
      final document = await userCollection.doc(uid).set(userDoc);
      return document;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
