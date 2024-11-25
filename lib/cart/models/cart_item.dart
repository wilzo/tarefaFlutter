// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:mercadinho/product/models/product.dart';

class CartItem {
  Product? product;
  int? quantity;
  CartItem({
    this.product,
    this.quantity,
  });

  CartItem copyWith({
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'product': product?.toMap(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      product: map['product'] != null
          ? Product.fromMap(map['product'] as Map<String, dynamic>)
          : null,
      quantity: map['quantity'] != null ? map['quantity'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItem.fromJson(String source) =>
      CartItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CartItem(product: $product, quantity: $quantity)';

  @override
  bool operator ==(covariant CartItem other) {
    if (identical(this, other)) return true;

    return other.product == product && other.quantity == quantity;
  }

  @override
  int get hashCode => product.hashCode ^ quantity.hashCode;
}
