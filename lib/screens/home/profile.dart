import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plastiex/ui/appbar.dart';
import 'package:plastiex/ui/colors.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarBrightness: Brightness.dark,
        statusBarColor: white,
        systemNavigationBarColor: white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  tooltip: 'edit profile',
                  icon: Icon(
                    Icons.edit,
                  ),
                  onPressed: () {},
                ),
                Row(
                  children: [
                    IconButton(
                      tooltip: 'settings',
                      icon: Icon(
                        Icons.settings,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      tooltip: 'sign out',
                      icon: Icon(Icons.power_settings_new_rounded),
                      onPressed: () {},
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 52,
                    backgroundColor: Colors.black,
                    child: CircleAvatar(
                      backgroundColor: white,
                      radius: 50,
                      backgroundImage: AssetImage('assets/imgs/avatar.jpg'),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    "Micah Gidado",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text("N5,000"),
                  SizedBox(height: 5.0),
                  RaisedButton(
                    color: Color(0xffFFDB47),
                    onPressed: () {},
                    child: Text('Withdraw'),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent submissions',
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      IconButton(
                        tooltip: 'new request',
                        icon: Icon(Icons.add),
                        onPressed: () {},
                      )
                    ],
                  ),
                  Divider(
                    height: 5.0,
                  ),
                  Container(
                    margin: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                    ),
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          sortColumnIndex: 1,
                          showBottomBorder: true,
                          headingRowColor:
                              MaterialStateProperty.all(Color(0xffFFDB47)),
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
                          rows: [
                            DataRow(cells: [
                              DataCell(Text('Bottle')),
                              DataCell(Text('20')),
                              DataCell(Text('50')),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('Bottle')),
                              DataCell(Text('40')),
                              DataCell(Text('100')),
                            ]),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
