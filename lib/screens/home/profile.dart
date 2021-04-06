import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plastiex/screens/authentication/signup.dart';
import 'package:plastiex/services/auth_service.dart';
import 'package:plastiex/size_configuration/size_config.dart';
import 'package:plastiex/ui/colors.dart';
import 'package:plastiex/widgets/submission_table.dart';

class Profile extends StatelessWidget {
  final Authentication _auth = Authentication();

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
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: white,
        systemNavigationBarColor: white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
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
                        onPressed: () async {
                          await _auth.signOut();
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
                    SubmissionTable(rows: dataRows).makeTable(),
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
                    Divider(
                      height: 5.0,
                    ),
                    SubmissionTable(rows: dataRows).makeTable(),
                  ],
                ),
              )
            ],
          ),
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
  TextEditingController capacityController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  ValueNotifier _selectedDate = ValueNotifier<DateTime>(DateTime.now());

  final key = GlobalKey<FormState>();

  return GestureDetector(
    onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
    child: ValueListenableBuilder(
      valueListenable: _selectedDate,
      builder: (context, _, __) => Container(
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: key,
            child: Column(
              children: [
                TextFormField(
                  controller: bottlesController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Number of bottles"),
                ),
                TextFormField(
                  controller: capacityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Capacity (cl)"),
                ),
                TextFormField(
                  controller: locationController,
                  decoration: InputDecoration(labelText: "Location in school"),
                ),
                TextFormField(
                  controller: dateController,
                  decoration: InputDecoration(labelText: "Select Date"),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    dateController.text = date.toString().split(" ")[0];
                    _selectedDate.value = date;
                  },
                ),
                SizedBox(
                  height: GetHeight(20),
                ),
                ElevatedButton(
                  style: ButtonStyle().copyWith(
                      backgroundColor: MaterialStateProperty.all(primaryColor)),
                  child: Text(
                    'Request',
                    style: TextStyle().copyWith(color: Colors.black),
                  ),
                  onPressed: () async {
                    //TODO - submit to cloud_firestore
                  },
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
