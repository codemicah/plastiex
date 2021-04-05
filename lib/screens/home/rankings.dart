import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plastiex/models/ranking.dart';
import 'package:plastiex/size_configuration/size_config.dart';

class Rankings extends StatefulWidget {
  @override
  _RankingsState createState() => _RankingsState();
}

class _RankingsState extends State<Rankings> {
  List<Ranking> rankings = [
    Ranking(
      name: 'Micah Gidado',
      uid: 'ae57cfg3',
      avatar: 'assets/imgs/avatar.jpg',
      position: 1,
      totalSubmissions: 20,
    ),
    Ranking(
      name: 'Davis Brown',
      uid: 'ea26fcg5',
      avatar: 'assets/imgs/avatar.jpg',
      position: 2,
      totalSubmissions: 15,
    ),
    Ranking(
      name: 'Isah Blue',
      uid: 'ea26fcg5',
      avatar: 'assets/imgs/avatar.jpg',
      position: 3,
      totalSubmissions: 14,
    ),
    Ranking(
      name: 'Rasheed Red',
      uid: 'ea26fcg5',
      avatar: 'assets/imgs/avatar.jpg',
      position: 4,
      totalSubmissions: 12,
    ),
  ];

  Widget _getRank(Ranking rank) {
    if (rank.position == 1) {
      return Container(
        color: Color(0xffFFDB47),
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.only(bottom: 10.0),
        child: Column(
          children: [
            Text(
              '${rank.position}',
              style: TextStyle().copyWith(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(rank.avatar),
            ),
            Text(
              rank.name,
              style: TextStyle().copyWith(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Total submissions: ',
                  style: TextStyle().copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 15.0,
                  ),
                ),
                Text(
                  '${rank.totalSubmissions}',
                  style: TextStyle().copyWith(
                    fontSize: 15.0,
                  ),
                )
              ],
            )
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  '${rank.position}',
                  style: TextStyle().copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                CircleAvatar(
                  radius: 25.0,
                  backgroundImage: AssetImage(rank.avatar),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rank.name,
                      style: TextStyle().copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Total submissions: ',
                          style: TextStyle().copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 15.0,
                          ),
                        ),
                        Text(
                          '${rank.totalSubmissions}',
                          style: TextStyle().copyWith(
                            fontSize: 15.0,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
            Divider(),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Color(0xffFFDB47),
        statusBarIconBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Container(
          width: SizeConfig.screenWidth,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: rankings.map((rank) => _getRank(rank)).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
