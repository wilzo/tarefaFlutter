// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:mercadinho/cart/models/cart_item.dart';
import 'package:mercadinho/user/models/user_model.dart';

class Cart {
  String? id;
  UserModel? userModel;
  String? date;
  List<CartItem>? items;
  Cart({
    this.id,
    this.userModel,   
    this.date,
    this.items,
  });

  Cart copyWith({
    String? id,
    UserModel? userModel,
    String? date,
    List<CartItem>? items,
  }) {
    return Cart(
      id: id ?? this.id,
      userModel: userModel ?? this.userModel,
      date: date ?? this.date,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userModel': userModel?.toMap(),
      'date': date,
      'items': items!.map((x) => x.toMap()).toList(),
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      id: map['id'] != null ? map['id'] as String : null,
      userModel: map['userModel'] != null
          ? UserModel.fromMap(map['userModel'] as Map<String, dynamic>)
          : null,
      date: map['date'] != null ? map['date'] as String : null,
      items: map['items'] != null
          ? List<CartItem>.from(
              (map['items'] as List<int>).map<CartItem?>(
                (x) => CartItem.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) =>
      Cart.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Cart(id: $id, userModel: $userModel, date: $date, items: $items)';
  }

  @override
  bool operator ==(covariant Cart other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userModel == userModel &&
        other.date == date &&
        listEquals(other.items, items);
  }

  @override
  int get hashCode {
    return id.hashCode ^ userModel.hashCode ^ date.hashCode ^ items.hashCode;
  }
}
