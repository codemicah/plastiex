import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid, email, displayName;
  Timestamp createdAt;

  UserModel({
    this.uid,
    this.displayName,
    this.email,
  });
}
