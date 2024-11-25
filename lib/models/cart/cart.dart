import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:mercadinho/models/cart/cart_item.dart';
import 'package:mercadinho/models/users/users.dart';

class Cart {
  //Payment payment
  UserModel? userModel;
  List<CartItem>? _items;
  String? date; // dia do pedido

  Cart({this.userModel, List<CartItem>? items, this.date}) : _items = items;

  Cart copyWith({UserModel? userModel, List<CartItem>? items, String? date}) {
    return Cart(userModel: userModel ?? this.userModel, items: items ?? _items, date: date);
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (userModel != null) {
      result.addAll({'userModel': userModel!.toJson()});
    }
    if (_items != null) {
      result.addAll({'items': _items!.map((x) => x.toMap()).toList()});
    }
    if (date != null) {
      result.addAll({'date': date!});
    }

    return result;
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
        userModel: map['userModel'] != null ? UserModel.fromJson(map['userModel']) : null,
        items: map['items'] != null ? List<CartItem>.from(map['items']?.map((x) => CartItem.fromMap(x))) : null,
        date: map['date']);
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) => Cart.fromMap(json.decode(source));

  @override
  String toString() => 'Cart(userModel: $userModel, items: $_items, date:$date)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Cart && other.userModel == userModel && other.date == date && listEquals(other._items, _items);
  }

  @override
  int get hashCode => userModel.hashCode ^ _items.hashCode ^ date.hashCode;
}
