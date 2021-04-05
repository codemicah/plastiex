import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plastiex/screens/authentication/signup.dart';
import 'package:plastiex/size_configuration/size_config.dart';
import 'package:plastiex/ui/colors.dart';
import 'package:plastiex/widgets/submission_table.dart';

class Profile extends StatelessWidget {
  List<DataRow> dataRows = [
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
  ];

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
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterScreen()),
                        );
                      },
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
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xffFFDB47)),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Withdraw',
                      style: TextStyle().copyWith(color: Colors.black),
                    ),
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
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: buildSubmissionModalSheet);
                        },
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
                          child: SubmissionTable(rows: dataRows).makeTable()),
                    ),
                  ),
                  Divider(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pending submissions',
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ],
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
                          child: SubmissionTable(rows: dataRows).makeTable()),
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

Widget buildSubmissionModalSheet(BuildContext context) {
  //number of bottles
  //location in school
  TextEditingController bottlesController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  return Container(
    color: Color(0xff757575),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: Center(
        child: Column(
          children: [
            TextFormField(
              controller: bottlesController,
              decoration: InputDecoration(labelText: "Number of bottles"),
            ),
            TextFormField(
              controller: locationController,
              decoration: InputDecoration(labelText: "Location in school"),
            ),
            SizedBox(
              height: GetHeight(20),
            ),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () async {
                //TODO - submit to cloud_firestore
              },
            )
          ],
        ),
      ),
    ),
  );
}
