import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plastiex/models/submission.dart';
import 'package:plastiex/services/database_service.dart';
import 'package:plastiex/size_configuration/size_config.dart';
import 'package:plastiex/ui/colors.dart';

class SubmissionTable {
  final String uid;
  final BuildContext context;

  SubmissionTable({@required this.uid, @required this.context});

  CollectionReference submissionCollection =
      FirebaseFirestore.instance.collection("submissions");

  CollectionReference adminCollection =
      FirebaseFirestore.instance.collection("admins");

  FirebaseAuth _auth = FirebaseAuth.instance;

  Widget makeTable({bool is_pending = true}) {
    return StreamBuilder(
        stream: submissionCollection
            .where("is_pending", isEqualTo: is_pending)
            .where("user", isEqualTo: uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return SizedBox(
                height: 15.0,
                width: 15.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(primaryColor),
                ));
          } else if (snapshot.data.docs.isEmpty) {
            return Text("There's nothing to show here");
          } else {
            return DataTable(
              sortColumnIndex: 1,
              showBottomBorder: true,
              showCheckboxColumn: false,
              headingRowColor: MaterialStateProperty.all(Color(0xffFFDB47)),
              columns: [
                DataColumn(
                  label: Text('Type'),
                ),
                DataColumn(
                  numeric: true,
                  label: Text('Quantity'),
                ),
                DataColumn(
                  numeric: true,
                  label: Text('Capacity(cl)'),
                ),
                DataColumn(
                  numeric: true,
                  label: Text('Worth (N)'),
                ),
              ],
              rows: snapshot.data.docs.map((DocumentSnapshot document) {
                if (snapshot.data.docs.isEmpty)
                  return DataRow(cells: [DataCell(Text("Nothing here yet"))]);
                else if (!snapshot.hasData)
                  return DataRow(cells: [DataCell(Text("Nothing here yet"))]);
                else
                  return DataRow(
                      onSelectChanged: (value) => showBottomSheet(
                          elevation: 5,
                          context: context,
                          builder: (context) => submissionDetails(
                              parseSubmission(document.data(), document.id),
                              context)),
                      cells: [
                        DataCell(Text("${document.data()['type']}")),
                        DataCell(Text("${document.data()['quantity']}")),
                        DataCell(Text("${document.data()['capacity']}")),
                        DataCell(Text("${document.data()['price'].toString()}"))
                      ]);
              }).toList(),
            );
          }
        });
  }

  Widget adminTable() {
    return StreamBuilder(
        stream: adminCollection.doc(uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> user) {
          if (!user.hasData) return SizedBox();
          if (user.data.exists) {
            return StreamBuilder(
              stream: submissionCollection.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox(
                      height: 10.0,
                      width: 10.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(primaryColor),
                      ));
                } else if (snapshot.data.docs.isEmpty) {
                  return Text("There's nothing to show here");
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        height: 10.0,
                      ),
                      Text(
                        "All Submissions",
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      Divider(
                        height: 10.0,
                      ),
                      DataTable(
                        showCheckboxColumn: false,
                        sortColumnIndex: 1,
                        showBottomBorder: true,
                        headingRowColor:
                            MaterialStateProperty.all(Color(0xffFFDB47)),
                        columns: [
                          DataColumn(
                            numeric: true,
                            label: Text('Capacity(cl)'),
                          ),
                          DataColumn(
                            numeric: true,
                            label: Text('Quantity'),
                          ),
                          DataColumn(
                            numeric: true,
                            label: Text('Worth (N)'),
                          ),
                          DataColumn(
                            label: Text('Pending'),
                          ),
                        ],
                        rows:
                            snapshot.data.docs.map((DocumentSnapshot document) {
                          if (snapshot.data.docs.isEmpty)
                            return DataRow(
                                cells: [DataCell(Text("Nothing here yet"))]);
                          else if (!snapshot.hasData)
                            return DataRow(
                                cells: [DataCell(Text("Nothing here yet"))]);
                          else
                            return DataRow(
                                onSelectChanged: (value) => showBottomSheet(
                                    elevation: 5,
                                    context: context,
                                    builder: (context) => submissionDetails(
                                        parseSubmission(
                                            document.data(), document.id),
                                        context)),
                                cells: [
                                  DataCell(
                                      Text("${document.data()['capacity']}")),
                                  DataCell(
                                      Text("${document.data()['quantity']}")),
                                  DataCell(Text(
                                      "${document.data()['price'].toString()}")),
                                  DataCell(Text(
                                      "${document.data()['is_pending'].toString().toUpperCase()}")),
                                ]);
                        }).toList(),
                      )
                    ],
                  );
                }
                ;
              },
            );
          } else
            return SizedBox();
        });
  }

  Submission parseSubmission(Map<String, dynamic> data, String id) {
    return Submission(
        quantity: data["quantity"],
        user: data["user"],
        capacity: data["capacity"],
        price: data["price"].toString(),
        isPending: data["is_pending"],
        date: data["submission_date"].toDate(), // convert timestamp to datetime
        location: data["location"],
        type: data["type"],
        id: id);
  }

// content of bottom sheet showing submission details
  Widget submissionDetails(Submission submission, BuildContext context) {
    TextStyle __keyStyle = TextStyle().copyWith(fontWeight: FontWeight.w600);

    return Container(
      width: SizeConfig.screenWidth,
      padding: EdgeInsets.all(30.0),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 50.0)]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: DatabaseService(uid: submission.user).getUserData(
                "email",
                TextStyle().copyWith(fontSize: 22.0),
              ))
            ],
          ),
          Divider(),
          Row(children: [
            Text("Type: ", style: __keyStyle),
            Text(submission.type)
          ]),
          Row(children: [
            Text("Quantity: ", style: __keyStyle),
            Text("${submission.quantity}")
          ]),
          Row(children: [
            Text("Capacity: ", style: __keyStyle),
            Text("${submission.capacity}cl")
          ]),
          Row(children: [
            Text("Price: ", style: __keyStyle),
            Text("N${submission.price}")
          ]),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Location: ", style: __keyStyle),
            Expanded(child: Text("${submission.location}"))
          ]),
          Row(children: [
            Text("Date: ", style: __keyStyle),
            // split ti remove time from datetime
            Text("${submission.date.toString().split(' ')[0]}")
          ]),
          SizedBox(height: 20.0),
          SizedBox(
            height: 50.0,
            child: StreamBuilder<bool>(
              stream: Stream.fromFuture(
                DatabaseService(uid: _auth.currentUser.uid).isAdmin(),
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return Text("...");
                else if (!snapshot.hasData)
                  return Text("Please wait...");
                else
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        snapshot.data
                            ? ElevatedButton(
                                child: Text("Confirm"),
                                onPressed: submission.isPending
                                    ? () async {
                                        await DatabaseService(
                                                uid: _auth.currentUser.uid)
                                            .confirmSubmission(
                                                submission, context);
                                        Navigator.pop(context);
                                      }
                                    : null,
                                style: ButtonStyle().copyWith(
                                  backgroundColor:
                                      MaterialStateProperty.all(green),
                                ),
                              )
                            : SizedBox(),
                        ElevatedButton(
                          style: ButtonStyle().copyWith(
                            backgroundColor: MaterialStateProperty.all(red),
                          ),
                          child: Text("Close"),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ]);
              },
            ),
          )
        ],
      ),
    );
  }
}
