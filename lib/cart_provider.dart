import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String name;
  final int price;
  final String? image; // Added image field
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.image,
    this.quantity = 1,
  });
}

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  int get itemCount => _items.length;

  int get totalQuantity {
    int total = 0;
    for (var item in _items.values) {
      total += item.quantity;
    }
    return total;
  }
  
  // Helper to calculate total price
  int get totalPrice {
      int total = 0;
      for (var item in _items.values) {
          total += (item.price * item.quantity);
      }
      return total;
  }

  void addItem({
      required String id, 
      required String name, 
      required double price, 
      String? image, 
  }) {
    if (_items.containsKey(id)) {
      _items[id]!.quantity++;
    } else {
      _items[id] = CartItem(id: id, name: name, price: price.toInt(), image: image);
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }
  
  void removeSingleItem(String id) {
      if (!_items.containsKey(id)) return;
      
      if (_items[id]!.quantity > 1) {
          _items[id]!.quantity--;
      } else {
          _items.remove(id);
      }
      notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
