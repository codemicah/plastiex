import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
            return CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(primaryColor),
            );
          } else if (snapshot.data.docs.isEmpty) {
            return Text("There's nothing to show here");
          } else {
            return DataTable(
              sortColumnIndex: 1,
              showBottomBorder: true,
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
                  return DataRow(cells: [
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
                  return CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(primaryColor),
                  );
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
                          DataColumn(
                            label: Text('Action'),
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
                            return DataRow(cells: [
                              DataCell(Text("${document.data()['quantity']}")),
                              DataCell(Text("${document.data()['price']}")),
                              DataCell(
                                  Text("${document.data()['is_pending']}")),
                              DataCell(document.data()['is_pending']
                                  ? TextButton(
                                      onPressed: () {}, child: Text("Confirm"))
                                  : Text("Confirmed")),
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
}
