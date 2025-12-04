import 'package:cammate/features/superuser/view_model/super_primary_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';

class SuperPrimaryView extends ConsumerStatefulWidget {
  const SuperPrimaryView({super.key});

  @override
  ConsumerState<SuperPrimaryView> createState() => _SuperPrimaryViewState();
}

class _SuperPrimaryViewState extends ConsumerState<SuperPrimaryView> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, _) {
        final primaryState = ref.watch(primaryViewModelProvider);
        return Scaffold(
          body: primaryState.lstWidgets[primaryState.index],
          bottomNavigationBar: SnakeNavigationBar.color(
            snakeViewColor: const Color(0xFF0B2B3D),
            // height: 80,
            behaviour: SnakeBarBehaviour.floating,
            snakeShape: SnakeShape.indicator,
            // elevation: 8,
            selectedItemColor: const Color(0xFF0B2B3D),
            unselectedItemColor: Colors.grey[800]!,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontSize: 14),
            // backgroundColor: Colors.white,
            shadowColor: Colors.grey,
            // shape: const RoundedRectangleBorder(
            //   borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            // ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
            currentIndex: primaryState.index,
            onTap: (index) {
              ref.read(primaryViewModelProvider.notifier).changeIndex(index);
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.shop, size: 28), label: 'Marts'),
              BottomNavigationBarItem(icon: Icon(Icons.people, size: 28), label: 'Users'),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today, size: 28),
                label: 'Activity',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.person, size: 28), label: 'Profile'),
            ],
          ),
        );
      },
    );
  }
}
