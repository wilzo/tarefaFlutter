import 'dart:convert';

import 'package:mercadinho/models/product/product.dart';

class CartItem {
  Product? product;
  int? quantity;
  double? subTotal;

  CartItem({
    this.product,
    this.quantity = 1,
    this.subTotal,
  }) {
    subTotal = product!.price! * quantity!;
  }

  CartItem copyWith({
    Product? product,
    int? quantity,
    double? subTotal,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      subTotal: subTotal ?? this.subTotal,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (product != null) {
      result.addAll({'product': product!.toMap()});
    }
    if (quantity != null) {
      result.addAll({'quantity': quantity});
    }
    if (subTotal != null) {
      result.addAll({'subTotal': subTotal});
    }

    return result;
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      product: map['product'] != null ? Product.fromDocument(map['product']) : null,
      quantity: map['quantity']?.toInt(),
      subTotal: map['subTotal']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItem.fromJson(String source) => CartItem.fromMap(json.decode(source));

  @override
  String toString() => 'CartItem(product: $product, quantity: $quantity, subTotal: $subTotal)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartItem && other.product == product && other.quantity == quantity && other.subTotal == subTotal;
  }

  @override
  int get hashCode => product.hashCode ^ quantity.hashCode ^ subTotal.hashCode;
}
