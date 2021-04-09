import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plastiex/models/submission.dart';
import 'package:plastiex/services/auth_service.dart';
import 'package:plastiex/services/database_service.dart';
import 'package:plastiex/size_configuration/size_config.dart';
import 'package:plastiex/ui/alert.dart';
import 'package:plastiex/ui/colors.dart';
import 'package:plastiex/ui/loader.dart';
import 'package:plastiex/widgets/submission_table.dart';

class Profile extends StatelessWidget {
  final Authentication _auth = Authentication();

  final user = FirebaseAuth.instance.currentUser;

  final _formKey = GlobalKey<FormState>();

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
                      "${user.displayName == null || user.displayName.isEmpty ? user.email : user.displayName}",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    DatabaseService(uid: user.uid).getBalance(context),
                    SizedBox(height: 5.0),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xffFFDB47)),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.black),
                      ),
                      onPressed: () async {
                        await _showWithdrawalDialog(context);
                      },
                      child: Text(
                        'Withdraw',
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
                          onPressed: () async {
                            await buildSubmissionModalSheet(context);
                          },
                        )
                      ],
                    ),
                    Divider(
                      height: 10.0,
                    ),
                    SubmissionTable(uid: user.uid).makeTable(is_pending: false),
                    Divider(
                      height: 10.0,
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
                      height: 10.0,
                    ),
                    SubmissionTable(uid: user.uid).makeTable(),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SubmissionTable(uid: user.uid).adminTable(),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future _showWithdrawalDialog(BuildContext context) async {
    final _withdrawalFormKey = GlobalKey<FormState>();
    TextEditingController _withdrawalAmountController = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) => GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: Dialog(
                elevation: 0,
                child: Container(
                  padding: EdgeInsets.all(30.0),
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(color: Colors.grey[300], blurRadius: 5)
                  ]),
                  child: Form(
                    key: _withdrawalFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _withdrawalAmountController,
                          keyboardType: TextInputType.number,
                          autofocus: true,
                          decoration: InputDecoration(labelText: "Amount"),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            loader.loading(context);
                            await DatabaseService(uid: user.uid).withdraw(
                                _withdrawalAmountController.text, context);

                            int count = 0;
                            Navigator.of(context).popUntil((_) => count++ >= 2);
                          },
                          child: Text("Proceed"),
                          style: ButtonStyle().copyWith(
                            backgroundColor:
                                MaterialStateProperty.all(primaryColor),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.black),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  Future buildSubmissionModalSheet(BuildContext context) {
    //number of bottles
    //location in school
    TextEditingController bottlesController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    TextEditingController capacityController = TextEditingController();
    TextEditingController dateController = TextEditingController();

    ValueNotifier _selectedDate = ValueNotifier<DateTime>(DateTime.now());

    final dialog = Dialog(
        child: GestureDetector(
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
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: bottlesController,
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(labelText: "Number of bottles"),
                    validator: (value) => value.isEmpty || int.parse(value) < 20
                        ? "must be of 20+"
                        : null,
                  ),
                  SizedBox(height: 5.0),
                  TextFormField(
                    controller: capacityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "Capacity (cl)"),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => value.isEmpty || int.parse(value) < 50
                        ? "must be of 50cl+"
                        : null,
                  ),
                  SizedBox(height: 5.0),
                  TextFormField(
                    controller: locationController,
                    decoration: InputDecoration(labelText: "Location"),
                  ),
                  SizedBox(height: 5.0),
                  TextFormField(
                    controller: dateController,
                    decoration: InputDecoration(labelText: "Select Date"),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
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
                        backgroundColor:
                            MaterialStateProperty.all(primaryColor)),
                    child: Text(
                      'Request',
                      style: TextStyle().copyWith(color: Colors.black),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        loader.loading(context);

                        final document = await DatabaseService(uid: user.uid)
                            .createSubmission(Submission(
                          quantity: int.parse(bottlesController.text),
                          capacity: int.parse(capacityController.text),
                          date: DateTime.parse(dateController.text),
                          location: locationController.text,
                        ));

                        if (document != null) {
                          Alert().showAlert(
                              message: "Submission request added",
                              context: context);
                        } else {
                          Alert().showAlert(
                              message: "Submission request added",
                              context: context,
                              isSuccess: false);
                        }
                        int count = 0;
                        Navigator.of(context).popUntil((_) => count++ >= 2);
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ));

    return showDialog(context: context, builder: (context) => dialog);
  }
}
