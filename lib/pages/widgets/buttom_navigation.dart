import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Statistik',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.green[800],
      unselectedItemColor: Colors.grey,
      onTap: onItemTapped,
    );
  }
}
