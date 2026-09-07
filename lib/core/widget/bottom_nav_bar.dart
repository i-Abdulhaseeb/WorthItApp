import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worthitapp/features/decisions/controllers/decisions_controller.dart';
import 'package:worthitapp/features/decisions/views/decisions_view.dart';
import 'package:worthitapp/features/home/controllers/home_controller.dart';
import 'package:worthitapp/features/home/views/home_view.dart';
import 'package:worthitapp/features/insights/controllers/insights_controller.dart';
import 'package:worthitapp/features/insights/views/insights_view.dart';
import 'package:worthitapp/features/settings/controllers/settings_controller.dart';
import 'package:worthitapp/features/settings/views/settings_view.dart';

class BottomNavBarWid extends StatefulWidget {
  const BottomNavBarWid({super.key});
  @override
  State<BottomNavBarWid> createState() {
    return _BottomNavBarWidState();
  }
}

class _BottomNavBarWidState extends State<BottomNavBarWid> {
  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<HomeController>()) {
      Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    }
    if (!Get.isRegistered<DecisionsController>()) {
      Get.lazyPut<DecisionsController>(() => DecisionsController(), fenix: true);
    }
    if (!Get.isRegistered<InsightsController>()) {
      Get.lazyPut<InsightsController>(() => InsightsController(), fenix: true);
    }
    if (!Get.isRegistered<SettingsController>()) {
      Get.lazyPut<SettingsController>(() => SettingsController(), fenix: true);
    }
  }

  final List<Widget> _pageOptions = <Widget>[
    const HomeView(),
    const DecisionsView(),
    const InsightsView(),
    const SettingsView(),
  ];
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.gavel), label: 'Decisions'),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'Insights',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 38, 102, 40),
        onTap: _onItemTapped,
        unselectedItemColor: Colors.grey,
      ),
      body: _pageOptions.elementAt(_selectedIndex),
    );
  }
}
