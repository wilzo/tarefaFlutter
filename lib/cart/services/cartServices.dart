import 'package:flutter/material.dart';

class CartServices extends ChangeNotifier {
  // Lista de itens no carrinho
  final List<CartItem> _items = [];

  // Obtém a lista de itens
  List<CartItem> get items => _items;

  // Calcula o preço total
  double get totalPrice =>
      _items.fold(0, (total, item) => total + (item.price * item.quantity));

  // Adiciona um item ao carrinho
  void addItem(CartItem item) {
    _items.add(item);
    notifyListeners(); // Notifica os ouvintes sobre a mudança de estado
  }

  // Remove um item do carrinho
  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  // Limpa o carrinho
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

class CartItem {
  final String id;
  final String name;
  final double price;
  final int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });
}
