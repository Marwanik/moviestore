import 'package:flutter/material.dart';
import 'package:moviestore/presentation/constans/colors.dart';
import 'package:moviestore/presentation/constans/icons.dart';

class NavBarWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const NavBarWidget({Key? key, required this.selectedIndex, required this.onItemTapped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: mainColor,
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      items: [
        BottomNavigationBarItem(
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: selectedIndex == 0 ? SELECTEDHOME : UNSELECTEDHOME,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: selectedIndex == 1 ? SELECTEDWATCHLIST : UNSELECTEDWATCHLIST,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: selectedIndex == 2 ? UNSELECTEDUSER : UNSELECTEDUSER,
          ),
          label: '',
        ),
      ],
    );
  }
}
