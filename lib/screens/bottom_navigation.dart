import 'package:flutter/material.dart';
import 'package:notchai_frontend/screens/ai_chat_screen.dart';
import 'package:notchai_frontend/pages/doctor_home.dart';
// import 'package:notchai_frontend/screens/game.dart';
import 'package:notchai_frontend/screens/health_news.dart';
import 'package:notchai_frontend/screens/home_screen.dart';
import 'package:notchai_frontend/screens/scan_skin.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentpageIndex = 0;
  final List<Widget> _widgetScreen = <Widget>[
    const HomeScreen(),
    const ScanTech(),
    const AiChatScreen(),
    const DoctorHomePage(),
    const HealthNews()
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
        elevation: 8,
        onTap: initTapIcon,
        currentIndex: currentpageIndex,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 11, 140, 123),
        unselectedItemColor: const Color(0xff00c6ad), // Changed unselected color to grey
        items: [
          _buildNavBarItem(Icons.home, "Home", 0),
          _buildNavBarItem(Icons.scanner_rounded, "Scan Skin", 1),
          _buildNavBarItem(Icons.assistant, "AI Doctor", 2),
          _buildNavBarItem(Icons.map_outlined, "Booking", 3),
          _buildNavBarItem(Icons.newspaper_rounded, "News", 4),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavBarItem(
      IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Column(
        children: [
          Icon(icon),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      label: "", // Set label to empty string to hide default label
      activeIcon: Column(
        children: [
          Icon(icon),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }
}