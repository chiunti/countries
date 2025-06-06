import 'package:countries/pages/saved_tab.dart';
import 'package:countries/pages/search_tab.dart';
import 'package:flutter/material.dart';
import 'package:countries/core/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Countries'), centerTitle: true),
      body: IndexedStack(
        index: _selectedIndex,
        children: [SearchTab(), SavedTab()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: AppColors.bottomNavigationBarSelected,
        unselectedItemColor: AppColors.bottomNavigationBarUnselected,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Saved'),
        ],
      ),
    );
  }
}
