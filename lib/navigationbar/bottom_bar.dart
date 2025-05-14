import 'package:flutter/material.dart';
import 'package:stock_management/navigationbar/stock_screen.dart';
import 'package:stock_management/navigationbar/report_screen.dart';
import 'package:stock_management/navigationbar/profile_screen.dart';

class BarScreen extends StatefulWidget {
  const BarScreen({super.key});

  @override
  State<BarScreen> createState() => _BottomBarState();
}

class _BottomBarState extends State<BarScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    StockScreen(),
    ReportsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.deepOrangeAccent,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Stock'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
