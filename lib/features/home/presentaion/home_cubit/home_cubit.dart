import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_states.dart';
import '../screens/cart.dart';
import '../screens/categories.dart';
import '../screens/delivery.dart';
import '../screens/profile.dart';
import '../screens/layout.dart';

class HomeShopCubit extends Cubit<HomeShopStates> {
  HomeShopCubit() : super(HomeShopInitialState());

  static HomeShopCubit get(BuildContext context) =>
      BlocProvider.of<HomeShopCubit>(context);

  int currentIndex = 0;
  int selectedCategoryIndex = 0;
  double deliveryFee = 5.0;

  final SupabaseClient _client = Supabase.instance.client;

  // Get the current user's UID from Supabase
  String? get uid => _client.auth.currentUser?.id;

  final List<Widget> bottomScreens = [
    LayoutScreen(),
    const CategoriesScreen(),
    const DeliveryScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(HomeShopSuccessState('Index changed to $index'));
  }

  void resetIndex() {
    currentIndex = 0;
    emit(HomeShopSuccessState('Index reset to 0'));
  }

  void changeBottomNav(int index) {
    if (currentIndex != index) {
      currentIndex = index;
      emit(ShopChangeBottomNavState());
    }
  }

  // Example: Load user-specific data (e.g., cart, favorites)
  Future<void> loadUserCartItems() async {
    if (uid == null) {
      emit(HomeShopErrorState('User not logged in'));
      return;
    }

    try {
      final response = await _client
          .from('cart_items')
          .select()
          .eq('user_id', uid!);

      // Handle the data
      emit(HomeShopSuccessState('Cart loaded: ${response.length} items'));
    } catch (e) {
      emit(HomeShopErrorState('Failed to load cart: $e'));
    }
  }
}
