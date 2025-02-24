import 'package:cammate/features/primary/view_model/primary_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';

class PrimaryView extends ConsumerStatefulWidget {
  const PrimaryView({super.key});

  @override
  ConsumerState<PrimaryView> createState() => _PrimaryViewState();
}

class _PrimaryViewState extends ConsumerState<PrimaryView> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, _) {
        final primaryState = ref.watch(primaryViewModelProvider);
        return Scaffold(
          body: primaryState.lstWidgets[primaryState.index],
          bottomNavigationBar: SnakeNavigationBar.color(
            snakeViewColor: const Color(0xFF0B2B3D),
            height: 70,
            behaviour: SnakeBarBehaviour.floating,
            snakeShape: SnakeShape.indicator,
            elevation: 8,
            selectedItemColor: const Color(0xFF0B2B3D),
            unselectedItemColor: Colors.grey[800]!,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 14),
            backgroundColor: Colors.white,
            shadowColor: Colors.grey,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            currentIndex: primaryState.index,
            onTap: (index) {
              ref.read(primaryViewModelProvider.notifier).changeIndex(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard, size: 30),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.camera, size: 30),
                label: 'Live View',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today, size: 30),
                label: 'History',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person, size: 30),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
