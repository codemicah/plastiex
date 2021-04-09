import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plastiex/services/database_service.dart';
import 'package:plastiex/size_configuration/size_config.dart';

class Rankings extends StatefulWidget {
  @override
  _RankingsState createState() => _RankingsState();
}

class _RankingsState extends State<Rankings> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Color(0xffFFDB47),
        statusBarIconBrightness: Brightness.dark,
      ),
      child: SafeArea(
          child: Container(
        height: SizeConfig.screenheight,
        child: DatabaseService(uid: _auth.currentUser.uid)
            .getAllSubmissions(context),
      )
          // Container(
          //   width: SizeConfig.screenWidth,
          //   child: SingleChildScrollView(
          //     physics: AlwaysScrollableScrollPhysics(),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.stretch,
          //       children: rankings.map((rank) => _getRank(rank)).toList(),
          //     ),
          //   ),
          // ),
          ),
    );
  }
}
