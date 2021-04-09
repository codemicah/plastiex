import 'package:flutter/material.dart';
import 'package:plastiex/widgets/home_widget.dart';
import 'package:plastiex/widgets/profile.dart';
import 'package:plastiex/widgets/rankings.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ValueNotifier _selectedIndex = ValueNotifier<int>(0);

  void _onItemTapped(int index) {
    _selectedIndex.value = index;
  }

  final List<Widget> _widgetOptions = [HomeWidget(), Rankings(), Profile()];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _selectedIndex,
      builder: (context, __, ___) => Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              _widgetOptions.elementAt(_selectedIndex.value),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 0,
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
