import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plastiex/models/ranking.dart';
import 'package:plastiex/models/submission.dart';
import 'package:plastiex/models/user.dart';
import 'package:plastiex/ui/alert.dart';
import 'package:plastiex/ui/colors.dart';

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

  CollectionReference settingCollection =
      FirebaseFirestore.instance.collection("settings");

  Future createSubmission(Submission submission) async {
    try {
      final double worth =
          await (await settingCollection.doc("price_setting").get())
              .get(submission.capacity.toString());

      dynamic price = worth * submission.capacity;
      price = price.toStringAsFixed(2);

      final data = {
        "user": uid,
        "capacity": submission.capacity,
        "quantity": submission.quantity,
        "is_pending": submission.isPending,
        "location": submission.location,
        "created_at": DateTime.now(),
        "submission_date": submission.date,
        "type": submission.type,
        "price": price,
      };
      Map<String, Object> subData = HashMap.from(data);
      final document = await submissionCollection.add(subData);

      return document;
    } catch (e) {
      return null;
    }
  }

  Future getUser(userId) async {
    final user = await userCollection.doc(userId).get();
  }

  Widget getUserData(value) {
    return StreamBuilder(
        stream: userCollection.doc(uid).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError)
            return Text("Error");
          else if (!snapshot.hasData)
            return Text("Loading...");
          else if (!snapshot.data.exists)
            return Text("Loading...");
          else
            return Text(snapshot.data.get(value) == ""
                ? snapshot.data.get("email")
                : snapshot.data.get(value));
        });
  }

  Future updateUser(UserModel user) async {
    try {
      Map data = {
        "email": user.email,
        "uid": user.uid,
        "displayName": user.displayName,
        "createdAt": Timestamp.now()
      };

      HashMap<String, Object> userData = HashMap.from(data);
      await userCollection.doc(uid).set(userData);
    } catch (e) {
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
      return null;
    }
  }

  Widget getBalance(BuildContext context) {
    return StreamBuilder(
      stream: balanceCollection.doc(uid).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError)
          return Text("Error");
        else if (!snapshot.hasData)
          return SizedBox(
            height: 10.0,
            width: 10.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(primaryColor),
            ),
          );
        else if (snapshot.data.data() == null || snapshot.data.data().isEmpty)
          return Text("...");
        else
          return Text("N${snapshot.data.get('balance')}");
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
      else if (int.parse(amount) < 1000)
        return Alert().showAlert(
            isSuccess: false,
            context: context,
            message: 'Minimum withdrawal amount is N1000');
      else {
        await balanceCollection
            .doc(uid)
            .update({"balance": balance - int.parse(amount)});

        await Alert().showAlert(
            context: context, message: "Withdrawal of N$amount successful");
        return true;
      }
    } catch (e) {
      return null;
    }
  }

  Widget getDisplayName(Ranking ranking) {
    return StreamBuilder(
        stream: userCollection.doc(ranking.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return SizedBox();
          else if (!snapshot.hasData)
            return SizedBox();
          else
            return Text(
              snapshot.data.get("displayName") != ""
                  ? snapshot.data.get("displayName")
                  : "User", //
              style: TextStyle().copyWith(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            );
        });
  }

  Widget getAllSubmissions(BuildContext context) {
    return StreamBuilder(
      stream: submissionCollection
          .where("is_pending", isEqualTo: false)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return Center(child: Text("An error occurred"));
        else if (!snapshot.hasData)
          return Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(primaryColor),
          ));
        else if (snapshot.data.docs.isEmpty)
          return Center(child: Text("Nothing here yet😢"));
        else {
          List<String> users = snapshot.data.docs
              .map((doc) => doc.data()["user"].toString())
              .toList();

          // make sure a user only appears once
          users = users.toSet().toList();

          // generate a list of submissions
          List<Submission> submissions = snapshot.data.docs.map((doc) {
            final data = doc.data();
            return Submission(
                quantity: data["quantity"],
                user: data["user"],
                capacity: data["capacity"],
                price: data["price"].toString(),
                isPending: data["is_pending"],
                date: data["date"],
                location: data["location"],
                type: data["type"]);
          }).toList();

          List<Ranking> rankings = [];
          for (int i = 0; i < users.length; i++) {
            List<Submission> count = submissions
                .where((element) => element.user == users[i])
                .toList();

            rankings.add(
              Ranking(
                  uid: users[i],
                  totalSubmissions: count.length,
                  avatar: count[0].avartar),
            );
          }

          // sort from highest to lowest
          rankings
              .sort((a, b) => b.totalSubmissions.compareTo(a.totalSubmissions));

          return ListView.builder(
              itemCount: rankings.length,
              itemBuilder: (context, i) {
                if (i == 0) {
                  return Container(
                    color: Color(0xffFFDB47),
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Column(
                      children: [
                        Text(
                          '${i + 1}',
                          style: TextStyle().copyWith(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage('assets/imgs/avatar.jpg'),
                        ),
                        getDisplayName(rankings[i]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Total submissions: ',
                              style: TextStyle().copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 15.0,
                              ),
                            ),
                            Text(
                              '${rankings[i].totalSubmissions}',
                              style: TextStyle().copyWith(
                                fontSize: 15.0,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                } else {
                  return Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              '${i + 1}',
                              style: TextStyle().copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            CircleAvatar(
                              radius: 25.0,
                              backgroundImage:
                                  AssetImage('assets/imgs/avatar.jpg'),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                getDisplayName(rankings[i]),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Total submissions: ',
                                      style: TextStyle().copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    Text(
                                      '${rankings[i].totalSubmissions}',
                                      style: TextStyle().copyWith(
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                        Divider(),
                      ],
                    ),
                  );
                }
              });
        }
      },
    );
  }

  Future confirmSubmission(Submission submission, BuildContext context) async {
    try {
      await submissionCollection
          .doc(submission.id)
          .update({"is_pending": false});

      final double balance =
          await (await balanceCollection.doc(submission.user).get())
              .data()["balance"];

      double newBalance = double.parse(submission.price) + balance;
      newBalance = double.parse(newBalance.toStringAsFixed(2));

      await balanceCollection
          .doc(submission.user)
          .update({"balance": newBalance});
      return Alert().showAlert(message: "Success", context: context);
    } on FirebaseException catch (e) {
      Alert().showAlert(message: e.message, context: context, isSuccess: false);
      return null;
    }
  }

  // check if user is an admin
  Future<bool> isAdmin() async {
    try {
      final document = await adminCollection.doc(uid).get();
      if (document.exists)
        return true;
      else
        return false;
    } on FirebaseException catch (e) {
      return false;
    }
  }
}
