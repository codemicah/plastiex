import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SubmissionTable {
  @required
  List<DataRow> rows;

  SubmissionTable({this.rows});
  CollectionReference submissionCollection =
      FirebaseFirestore.instance.collection("submissions");

  Widget makeTable({bool is_pending = true}) {
    return StreamBuilder(
        stream: submissionCollection
            .where("is_pending", isEqualTo: is_pending)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) =>
                DataTable(
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
                    return DataRow(cells: [
                      DataCell(Text("${document.data()['type']}")),
                      DataCell(Text("${document.data()['quantity']}")),
                      DataCell(Text("${document.data()['price']}"))
                    ]);
                  }).toList(),
                ));
  }
}
