import 'package:flutter/material.dart';
import 'package:mercadinho/models/product/product.dart';

class CartServices with ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => _items;

  void addToCart(Product item) {
    _items.add(item);
    notifyListeners();
  }

  double get total {
    return items.fold(0.0, (double currentTotal, Product nextProduct) {
      return currentTotal + (nextProduct.price! * nextProduct.quantity!);
    });
  }

  void removeFromCart(Product item) {
    _items.remove(item);
    notifyListeners();
  }
}
