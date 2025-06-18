import 'package:auvnet/features/home/presentaion/screens/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../screens/cart.dart';
import '../screens/favourits.dart';
import '../screens/profile.dart';
import 'home_states.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });
}

class CartItem {
  final String productId;
  final String name;
  final double price;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });
}

class Category {
  final String id;
  final String name;
  final IconData icon;

  Category({
    required this.id,
    required this.name,
    required this.icon,
  });
}

class HomeShopCubit extends Cubit<HomeShopStates> {
  HomeShopCubit() : super(HomeShopInitialState()) {
    // Initialize with sample data
    _initializeData();
  }

  static HomeShopCubit get(BuildContext context) =>
      BlocProvider.of<HomeShopCubit>(context);

  int currentIndex = 0;
  int selectedCategoryIndex = 0;

  // Sample data
  List<Product> featuredProducts = [];
  List<Product> favoriteProducts = [];
  List<CartItem> cartItems = [];
  List<Category> categories = [];
  List<Product> searchResults = [];
  String searchQuery = '';

  double deliveryFee = 5.0;

  final List<Widget> bottomScreens = [
    const LayoutScreen(),
    const FavouriteScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  void _initializeData() {
    // Sample featured products
    featuredProducts = [
      Product(
        id: '1',
        name: 'Wireless Headphones',
        price: 99.99,
        imageUrl: 'https://example.com/headphones.jpg',
      ),
      Product(
        id: '2',
        name: 'Smart Watch',
        price: 199.99,
        imageUrl: 'https://example.com/watch.jpg',
      ),
      Product(
        id: '3',
        name: 'Bluetooth Speaker',
        price: 79.99,
        imageUrl: 'https://example.com/speaker.jpg',
      ),
      Product(
        id: '4',
        name: 'Laptop Backpack',
        price: 49.99,
        imageUrl: 'https://example.com/backpack.jpg',
      ),
    ];

    // Sample categories
    categories = [
      Category(id: '1', name: 'Electronics', icon: Icons.electrical_services),
      Category(id: '2', name: 'Clothing', icon: Icons.shopping_bag),
      Category(id: '3', name: 'Home', icon: Icons.home),
      Category(id: '4', name: 'Sports', icon: Icons.sports_soccer),
      Category(id: '5', name: 'Beauty', icon: Icons.spa),
      Category(id: '6', name: 'Toys', icon: Icons.toys),
      Category(id: '7', name: 'Books', icon: Icons.book),
      Category(id: '8', name: 'Food', icon: Icons.fastfood),
    ];

    emit(HomeShopSuccessState('Data initialized'));
  }

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

  void selectCategory(int index) {
    selectedCategoryIndex = index;
    emit(ShopCategoryChangedState(index));
  }

  // Product methods
  void toggleFavorite(String productId) {
    final productIndex = featuredProducts.indexWhere((p) => p.id == productId);
    if (productIndex != -1) {
      featuredProducts[productIndex].isFavorite =
      !featuredProducts[productIndex].isFavorite;

      if (featuredProducts[productIndex].isFavorite) {
        favoriteProducts.add(featuredProducts[productIndex]);
      } else {
        favoriteProducts.removeWhere((p) => p.id == productId);
      }

      emit(HomeShopSuccessState('Favorite status changed'));
    }
  }

  void viewProductDetails(String productId) {
    // Navigation would be handled by the screen
    emit(HomeShopSuccessState('Viewing product $productId'));
  }

  // Cart methods
  void addToCart(String productId) {
    final product = featuredProducts.firstWhere((p) => p.id == productId);
    final existingItem = cartItems.indexWhere((item) => item.productId == productId);

    if (existingItem != -1) {
      cartItems[existingItem].quantity++;
    } else {
      cartItems.add(CartItem(
        productId: product.id,
        name: product.name,
        price: product.price,
        imageUrl: product.imageUrl,
      ));
    }

    emit(HomeShopSuccessState('Added to cart'));
  }

  void removeFromCart(String productId) {
    cartItems.removeWhere((item) => item.productId == productId);
    emit(HomeShopSuccessState('Removed from cart'));
  }

  void increaseQuantity(String productId) {
    final item = cartItems.firstWhere((item) => item.productId == productId);
    item.quantity++;
    emit(HomeShopSuccessState('Quantity increased'));
  }

  void decreaseQuantity(String productId) {
    final item = cartItems.firstWhere((item) => item.productId == productId);
    if (item.quantity > 1) {
      item.quantity--;
      emit(HomeShopSuccessState('Quantity decreased'));
    } else {
      removeFromCart(productId);
    }
  }

  void clearCart() {
    cartItems.clear();
    emit(HomeShopSuccessState('Cart cleared'));
  }

  void checkout() {
    // In a real app, this would process the payment
    emit(HomeShopLoadingState());
    Future.delayed(const Duration(seconds: 2), () {
      cartItems.clear();
      emit(HomeShopSuccessState('Checkout completed'));
    });
  }

  // Search methods
  void searchProducts(String query) {
    searchQuery = query;
    if (query.isEmpty) {
      searchResults.clear();
    } else {
      searchResults = featuredProducts.where((product) =>
          product.name.toLowerCase().contains(query.toLowerCase())).toList();
    }
    emit(HomeShopSuccessState('Search performed'));
  }

  // Other actions
  void viewAllOffers() {
    emit(HomeShopSuccessState('Viewing all offers'));
  }

  void viewAllProducts() {
    emit(HomeShopSuccessState('Viewing all products'));
  }

  void viewSpecialOffer() {
    emit(HomeShopSuccessState('Viewing special offer'));
  }

  void viewNotifications() {
    emit(HomeShopSuccessState('Viewing notifications'));
  }

  void applyPromoCode(String code) {
    // In a real app, this would validate the promo code
    emit(HomeShopSuccessState('Applied promo code $code'));
  }

  Future<void> refreshData() async {
    emit(HomeShopLoadingState());
    await Future.delayed(const Duration(seconds: 1));
    emit(HomeShopSuccessState('Data refreshed'));
  }

  void navigateToHome() {
    currentIndex = 0;
    emit(ShopChangeBottomNavState());
  }

  // Getters
  double get cartSubtotal => cartItems.fold(
      0, (sum, item) => sum + (item.price * item.quantity));

  double get cartTotal => cartSubtotal + deliveryFee;
}

