import 'package:churchapp/screens/staus_screen.dart';
import 'package:churchapp/screens/welcome_screen.dart';
//import 'package:circle_bottom_navigation/circle_bottom_navigation.dart';
//import 'package:circle_bottom_navigation/widgets/tab_data.dart';
import 'package:flutter/material.dart';

import 'booking_screen.dart';

class MyNavBar extends StatefulWidget {
  MyNavBar({Key key}) : super(key: key);

  final String title = "MyNavBar"; //add this line

  @override
  _MyNavBarState createState() => _MyNavBarState();
}

class _MyNavBarState extends State<MyNavBar> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _pages = <Widget>[
    //Add pages to appear on the App, via Navigation Bar

    WelcomeScreen(),
    BookASeat(),
    BookingStatus(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.sentiment_very_satisfied),
            title: Text('Welcome'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            title: Text('Reservation'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            title: Text('Status'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        onTap: _onItemTapped,
      ),
    );
  }
}
