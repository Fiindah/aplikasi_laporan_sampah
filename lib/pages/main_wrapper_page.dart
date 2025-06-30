import 'package:aplikasi_laporan_sampah/constant/app_color.dart';
import 'package:aplikasi_laporan_sampah/pages/home_page.dart';
import 'package:flutter/material.dart';

class MainWrapperPage extends StatefulWidget {
  const MainWrapperPage({super.key});
  static const String id =
      "/main_wrapper_page"; // This will be your new initial route

  @override
  State<MainWrapperPage> createState() => _MainWrapperPageState();
}

class _MainWrapperPageState extends State<MainWrapperPage> {
  int _selectedIndex = 0; // Index for the selected tab in BottomNavigationBar
  late PageController _pageController; // Controller to manage page transitions

  // List of pages to be displayed in the BottomNavigationBar
  final List<Widget> _pages = [
    const HomePage(),
    // const HistoryPage(),
    // const StatisticPage(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Handles the tap on a BottomNavigationBar item.
  /// It updates the selected index and animates to the corresponding page.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The AppBar will be managed by each individual page now,
      // so we remove it from here.
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex =
                index; // Keep BottomNavigationBar in sync if user swipes pages
          });
        },
        children: _pages, // Display the list of pages
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistik',
          ),
        ],
        currentIndex: _selectedIndex, // Current selected item
        selectedItemColor: AppColor.mygreen, // Color for selected icon/label
        unselectedItemColor: Colors.grey, // Color for unselected icon/label
        onTap: _onItemTapped, // Callback when an item is tapped
        type: BottomNavigationBarType.fixed, // Ensures all labels are shown
        backgroundColor: Colors.white,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      ),
    );
  }
}
