import 'package:flutter/material.dart';
import 'package:plastiex/services/auth_service.dart';
import 'package:plastiex/size_configuration/size_config.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Form(
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
                    decoration: InputDecoration(labelText: "Email"),
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
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                ),
                SizedBox(
                  height: GetHeight(176),
                ),
                InkWell(
                  onTap: () async {
                    try {
                      final newUser = await Authentication()
                          .Register_With_Email_password(
                              email: emailController.text,
                              password: passwordController.text);
                      Navigator.pop(context);
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
                        'Register',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: GetHeight(16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
