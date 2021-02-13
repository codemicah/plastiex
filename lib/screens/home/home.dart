import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:plastiex/screens/home/profile.dart';
import 'package:plastiex/ui/appbar.dart';
import 'package:plastiex/ui/colors.dart';

class Home extends StatelessWidget {
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
    Text('Rankings'),
    Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _selectedIndex,
      builder: (context, __, ___) => Scaffold(
        body: Column(
          children: [
            _widgetOptions.elementAt(_selectedIndex.value),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex.value,
          onTap: _onItemTapped,
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
