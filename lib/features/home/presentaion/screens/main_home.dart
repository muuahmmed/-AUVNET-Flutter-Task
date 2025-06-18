import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

import '../home_cubit/home_cubit.dart';
import '../home_cubit/home_states.dart';

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFF5F6FA);
    const Color primaryColor = Color(0xFF6C63FF); // Purple-Blue
    const Color activeTabColor = Color(0xFFDDE6FF); // Soft tab highlight

    return BlocProvider(
      create: (context) => HomeShopCubit()..resetIndex(),
      child: BlocConsumer<HomeShopCubit, HomeShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = HomeShopCubit.get(context);
          return Scaffold(
            backgroundColor: backgroundColor,
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              child: cubit.bottomScreens[cubit.currentIndex],
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(blurRadius: 12, color: Colors.black12)],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 10,
                  ),
                  child: GNav(
                    selectedIndex: cubit.currentIndex,
                    onTabChange: (index) => cubit.changeBottomNav(index),
                    rippleColor: primaryColor.withOpacity(0.2),
                    hoverColor: primaryColor.withOpacity(0.1),
                    haptic: true,
                    tabBorderRadius: 12,
                    tabShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    curve: Curves.easeOutExpo,
                    duration: const Duration(milliseconds: 600),
                    gap: 10,
                    color: Colors.grey[600],
                    activeColor: primaryColor,
                    iconSize: 24,
                    tabBackgroundColor: activeTabColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    tabs: const [
                      GButton(icon: LineIcons.home, text: 'Home'),
                      GButton(icon: LineIcons.heartAlt, text: 'Likes'),
                      GButton(icon: LineIcons.shoppingCart, text: 'Cart'),
                      GButton(icon: LineIcons.user, text: 'Profile'),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}