import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plastiex/models/ranking.dart';
import 'package:plastiex/models/submission.dart';
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
        "price": submission.price,
      };
      Map<String, Object> subData = HashMap.from(data);
      final document = await submissionCollection.add(subData);

      return document;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getUser(userId) async {
    final user = await userCollection.doc(userId).get();
    print(user.data());
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
        if (!snapshot.hasData)
          return SizedBox(
            height: 10.0,
            width: 10.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(primaryColor),
            ),
          );
        else if (snapshot.hasError)
          return Text("Error");
        else if (snapshot.data.data().isEmpty)
          return Text("no data");
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

      await balanceCollection
          .doc(uid)
          .update({"balance": balance - int.parse(amount)});

      await Alert().showAlert(
          context: context, message: "Withdrawal of $amount successful");
      return true;
    } catch (e) {
      print(e);
      return null;
    }
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
          return Center(child: CircularProgressIndicator());
        else if (snapshot.data.docs.isEmpty)
          return Center(child: Text("No data"));
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
                price: data["price"],
                isPending: data["is_pending"],
                date: data["date"],
                location: data["location"],
                type: data["type"]);
          }).toList();

          List<Ranking> rankings = [];
          for (int i = 0; i < users.length; i++) {
            print("++++++++++++++++++++++");
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
                        Text(
                          "No Name ${i + 1}", //
                          style: TextStyle().copyWith(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                                Text(
                                  "No Name ${i + 1}",
                                  style: TextStyle().copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17,
                                  ),
                                ),
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
}
