import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plastiex/screens/authentication/signup.dart';
import 'package:plastiex/services/auth_service.dart';
import 'package:plastiex/size_configuration/size_config.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
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
                              "Let's Sign You In",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: GetHeight(8),
                            ),
                            Text("Welcome back, you’ve been missed!")
                          ],
                        )),
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
                    ),
                  ),
                  SizedBox(
                    height: GetHeight(100),
                  ),
                  InkWell(
                    onTap: () async {
                      print("checking cred");
                      try {
                        final userReg = await Authentication().SignInWithEmail(
                          email: emailController.text,
                          password: passwordController.text,
                          context: context,
                        );

                        final User userDetails = userReg.user;

                        print("........");
                        print("${userDetails.uid}");
                      } catch (e) {
                        print(e);
                        //TODO - a SnackBar would be nice here
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
                          'SIGN IN',
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
                            builder: (context) => RegisterScreen())),
                    child: Text("Don't have an account? Sign up"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
