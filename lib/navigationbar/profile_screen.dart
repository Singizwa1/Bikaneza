import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String _username = 'User Name';
  bool _showMenu = false;

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _Setting() {
    Navigator.pushNamed(context, '/change-password');
  }

  void _openNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notifications panel coming soon!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double menuWidth = MediaQuery.of(context).size.width * 0.5;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              AppBar(
                leading: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    setState(() {
                      _showMenu = !_showMenu;
                    });
                  },
                ),
                title: Text(''),
                actions: [
                  IconButton(
                    icon: Icon(Icons.notifications),
                    onPressed: _openNotifications,
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: Text('Welcome, $_username!'),
                ),
              ),
            ],
          ),

          // Custom dropdown menu panel
          if (_showMenu)
            Positioned(
              top: kToolbarHeight,
              left: 0,
              width: menuWidth,
              bottom: 0,
              child: Material(
                elevation: 4,
                color: Colors.deepOrangeAccent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings'),
                      onTap: () {
                        setState(() => _showMenu = false);
                        _Setting();
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Logout'),
                      onTap: () {
                        setState(() => _showMenu = false);
                        _logout();
                      },
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
