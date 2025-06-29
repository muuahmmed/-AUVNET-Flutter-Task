import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../home_cubit/home_cubit.dart';
import '../home_cubit/home_states.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeShopCubit, HomeShopStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, state) {
        var cubit = HomeShopCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.white,
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            switchInCurve: Curves.easeInOutCubic,
            switchOutCurve: Curves.easeInOutCubic,
            transitionBuilder: (Widget child, Animation<double> animation) {
              final slideAnimation = Tween<Offset>(
                begin: const Offset(0.2, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOutCubic,
                ),
              );

              return FadeTransition(
                opacity: animation,
                child: SlideTransition(position: slideAnimation, child: child),
              );
            },
            child: Container(
              key: ValueKey<int>(cubit.currentIndex),
              child: cubit.bottomScreens[cubit.currentIndex],
            ),
          ),
          bottomNavigationBar: _buildAnimatedBottomBar(cubit),
        );
      },
    );
  }

  Widget _buildAnimatedBottomBar(HomeShopCubit cubit) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 70,
          color: Colors.white,
          child: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeBottomNav(index);
            },
            selectedItemColor:  Color(0xFF8900FE),
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
            selectedFontSize: 12,
            unselectedFontSize: 11,
            type: BottomNavigationBarType.fixed,
            items: [
              _buildBottomBarItem(
                activeIcon: Icons.home,
                inactiveIcon: Icons.home_outlined,
                label: 'Home',
                isActive: cubit.currentIndex == 0,
              ),
              _buildBottomBarItem(
                activeIcon: Icons.category,
                inactiveIcon: Icons.category_outlined,
                label: 'Categories',
                isActive: cubit.currentIndex == 1,
              ),
              _buildBottomBarItem(
                activeIcon: Icons.delivery_dining,
                inactiveIcon: Icons.delivery_dining_outlined,
                label: 'deliver',
                isActive: cubit.currentIndex == 2,
              ),
              _buildBottomBarItem(
                activeIcon: Icons.shopping_cart,
                inactiveIcon: Icons.shopping_cart_outlined,
                label: 'Cart',
                isActive: cubit.currentIndex == 3,
              ),
              _buildBottomBarItem(
                activeIcon: Icons.person,
                inactiveIcon: Icons.person_outline,
                label: 'Profile',
                isActive: cubit.currentIndex == 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomBarItem({
    required IconData activeIcon,
    required IconData inactiveIcon,
    required String label,
    required bool isActive,
  }) {
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.identity()..scale(isActive ? 1.2 : 1.0),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(
              scale: animation,
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child:
              isActive
                  ? Icon(activeIcon, size: 28, key: ValueKey('active_$label'))
                  : Icon(
                    inactiveIcon,
                    size: 24,
                    key: ValueKey('inactive_$label'),
                  ),
        ),
      ),
      label: label,
    );
  }
}
