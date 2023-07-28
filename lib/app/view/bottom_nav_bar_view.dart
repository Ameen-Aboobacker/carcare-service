
import 'package:carcareservice/app/view/services.dart';
import 'package:carcareservice/app/view/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../utils/global_colors.dart';
import '../view_model/bottom_bar_provider.dart';
import 'bookings_view.dart';
import 'home_screen_view.dart';

class BottomNavBarView extends StatelessWidget {
  BottomNavBarView({super.key});

  final List views = [
    const HomeScreenView(),
    const BookingsView(),
    const ServiceDetails(),
    const SettingsView(),

  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    final bottomBarVieModel = Provider.of<BottomBarProvider>(context);
    return Scaffold(
      body: views[bottomBarVieModel.newIndex],
      backgroundColor: AppColors.white,
      bottomNavigationBar: BottomNavigationBar(
        onTap: bottomBarVieModel.bottomOnChanged,
        currentIndex: bottomBarVieModel.newIndex,
        iconSize: 24,
        showSelectedLabels: true,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        backgroundColor: AppColors.appColor,
        elevation: 5,
        selectedItemColor: AppColors.white,
        unselectedItemColor: AppColors.yellow,
        items: const [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(
              Icons.home_outlined,
            ),
          ),
          BottomNavigationBarItem(
            label: "Bookings",
            icon: Icon(
              Icons.book_online_outlined,
            ),
          ),
              BottomNavigationBarItem(
            label: "services",
            icon: Icon(
              Icons.list,
            ),
          ),
             BottomNavigationBarItem(
            label: "settings",
            icon: Icon(
              Icons.settings_sharp,
            ),
          ),
        ],
      ),
    );
  }
}