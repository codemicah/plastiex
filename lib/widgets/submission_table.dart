import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plastiex/models/submission.dart';
import 'package:plastiex/size_configuration/size_config.dart';
import 'package:plastiex/ui/colors.dart';

class SubmissionTable {
  final String uid;

  SubmissionTable({@required this.uid});

  CollectionReference submissionCollection =
      FirebaseFirestore.instance.collection("submissions");

  CollectionReference adminCollection =
      FirebaseFirestore.instance.collection("admins");

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
                  onSort: (i, b) {
                    print(i);
                    print(b);
                  },
                  numeric: true,
                  label: Text('Quantity'),
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
                              parseSubmission(document.data()), context)),
                      cells: [
                        DataCell(Text("${document.data()['type']}")),
                        DataCell(Text("${document.data()['quantity']}")),
                        DataCell(Text("${document.data()['price']}"))
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
                            onSort: (i, b) {
                              print(i);
                              print(b);
                            },
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
                                        parseSubmission(document.data()),
                                        context)),
                                cells: [
                                  DataCell(
                                      Text("${document.data()['quantity']}")),
                                  DataCell(Text("${document.data()['price']}")),
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

  Submission parseSubmission(Map<String, dynamic> data) {
    print(Timestamp.now());
    return Submission(
      quantity: data["quantity"],
      user: data["user"],
      capacity: data["capacity"],
      price: data["price"],
      isPending: data["is_pending"],
      date: data["date"],
      location: data["location"],
      type: data["type"],
    );
  }

  Widget submissionDetails(Submission submission, BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      padding: EdgeInsets.all(30.0),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 50.0)]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(children: [Text("Type: "), Text(submission.type)]),
          Row(children: [Text("Quantity: "), Text("${submission.quantity}")]),
          Row(children: [Text("Capacity: "), Text("${submission.capacity}cl")]),
          Row(children: [Text("Price: "), Text("N${submission.price}")]),
          Row(children: [Text("Location: "), Text("${submission.location}")]),
          Row(children: [Text("Date: "), Text("${submission.date}")]),
          SizedBox(height: 20.0),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ElevatedButton(
              child: Text("Confirm"),
              onPressed: submission.isPending ? () {} : null,
              style: ButtonStyle().copyWith(
                backgroundColor: MaterialStateProperty.all(green),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle().copyWith(
                backgroundColor: MaterialStateProperty.all(red),
              ),
              child: Text("Close"),
              onPressed: () => Navigator.pop(context),
            ),
          ]),
        ],
      ),
    );
  }
}
