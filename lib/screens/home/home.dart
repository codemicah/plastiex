import 'package:flutter/material.dart';
import 'package:plastiex/screens/home/profile.dart';
import 'package:plastiex/screens/home/rankings.dart';
import 'package:plastiex/size_configuration/size_config.dart';
import 'package:plastiex/ui/appbar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ValueNotifier _selectedIndex = ValueNotifier<int>(0);

  void _onItemTapped(int index) {
    _selectedIndex.value = index;
  }

  final List<Widget> _widgetOptions = [
    Column(
      children: [
        CustomAppBar(
          title: 'Home',
          color: Colors.blue,
          items: [
            PopupMenuButton(
                padding: EdgeInsets.zero,
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text("Settings"),
                      )
                    ])
          ],
        ),
      ],
    ),
    Rankings(),
    Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _selectedIndex,
      builder: (context, __, ___) => Scaffold(
        body: Container(
          height: SizeConfig.screenheight,
          child: Column(
            children: [
              _widgetOptions.elementAt(_selectedIndex.value),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex.value,
          onTap: _onItemTapped,
          selectedItemColor: Colors.black,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.equalizer_rounded),
              label: 'Rankings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            )
          ],
        ),
      ),
    );
  }
}
