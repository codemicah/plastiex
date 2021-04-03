import 'package:cloud_firestore/cloud_firestore.dart';

class Firestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SendSubmissionToFirestore({String numberOfBottles, String location}) {
    Map submission = {numberOfBottles: numberOfBottles, location: location};
    _firestore.collection('submissions').add(submission);
  }
}
