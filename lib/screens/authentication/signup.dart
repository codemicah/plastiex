import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plastiex/screens/authentication/signin.dart';
import 'package:plastiex/services/auth_service.dart';
import 'package:plastiex/size_configuration/size_config.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Form(
            child: SingleChildScrollView(
              child: Container(
                height: SizeConfig.screenheight,
                width: SizeConfig.screenWidth,
                child: Column(
                  children: [
                    SizedBox(
                      height: GetHeight(148),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Container(
                        height: GetHeight(64),
                        width: GetWidth(305),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Getting Started",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: GetHeight(8),
                            ),
                            Text("Create an account to continue!")
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: GetHeight(40),
                    ),
                    SizedBox(
                      width: GetWidth(305),
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle().copyWith(color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: GetHeight(40),
                    ),
                    SizedBox(
                      width: GetWidth(305),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle().copyWith(color: Colors.black),
                        ),
                        validator: (value) => value.length < 6
                            ? "Password must not be less than 6 chars"
                            : null,
                      ),
                    ),
                    SizedBox(
                      height: GetHeight(100),
                    ),
                    InkWell(
                      onTap: () async {
                        try {
                          final newUser = await Authentication()
                              .Register_With_Email_password(
                            email: emailController.text,
                            password: passwordController.text,
                            context: context,
                          );
                          print(newUser.uid);
                          //TODO - SnackBar
                        } catch (e) {
                          print(e);
                          //TODO - SnackBar
                        }
                      },
                      child: Container(
                        height: GetHeight(44),
                        width: GetWidth(305),
                        decoration: BoxDecoration(
                            color: Color(0xffFFDB47),
                            borderRadius: BorderRadius.circular(6)),
                        child: Center(
                          child: Text(
                            'REGISTER',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: GetHeight(16),
                    ),
                    InkWell(
                      onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen())),
                      child: Text("Alreadyhave an account? Sign In"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
