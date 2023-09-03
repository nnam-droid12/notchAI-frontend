import 'package:flutter/material.dart';
import 'package:notchai_frontend/screens/home_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentpageIndex = 0;
  final List<Widget> _widgetScreen = <Widget>[
    const HomeScreen(),
    const Text("AI Doctor"),
    const Text("Book"),
    const Text("News")
  ];

  void initTapIcon(int index) {
    setState(() {
      currentpageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetScreen[currentpageIndex],
      bottomNavigationBar: BottomNavigationBar(
          elevation: 10,
          onTap: initTapIcon,
          currentIndex: currentpageIndex,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blueGrey,
          unselectedItemColor: Colors.lightBlueAccent,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "home",
                activeIcon: Icon(Icons.home)),
            BottomNavigationBarItem(
                icon: Icon(Icons.assistant),
                label: "AI Doctor",
                activeIcon: Icon(Icons.assistant)),
            BottomNavigationBarItem(
                icon: Icon(Icons.map_outlined),
                label: "Book",
                activeIcon: Icon(Icons.map_outlined)),
            BottomNavigationBarItem(
                icon: Icon(Icons.newspaper_rounded),
                label: "News",
                activeIcon: Icon(Icons.newspaper_rounded))
          ]),
    );
  }
}
