// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Product {
  // -- variáveis de instância
  String? id;
  String? name;
  String? description;
  String? image;
  double? price;
  int? quantity;
  Product({
    this.id,
    this.name,
    this.description,
    this.image,
    this.price,
    this.quantity,
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    String? image,
    double? price,
    int? quantity,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'quantity': quantity,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      price: map['price'] != null ? map['price'] as double : null,
      quantity: map['quantity'] != null ? map['quantity'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Product(id: $id, name: $name, description: $description, image: $image, price: $price, quantity: $quantity)';
  }

  @override
  bool operator ==(covariant Product other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.image == image &&
        other.price == price &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        image.hashCode ^
        price.hashCode ^
        quantity.hashCode;
  }
}
