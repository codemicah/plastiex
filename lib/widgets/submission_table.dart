import 'package:flutter/material.dart';

class SubmissionTable {
  @required
  List<DataRow> rows;

  SubmissionTable({this.rows});

  DataTable makeTable() {
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
      rows: rows,
    );
  }
}
