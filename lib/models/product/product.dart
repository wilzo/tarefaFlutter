import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String? id;
  String? name;
  String? description;
  String? brand;
  bool? deleted;
  String? categoryId;
  String? offerId;
  String? image;
  String? url;
  double? price;
  String? unity;
  int? quantity;
  // final List<String> updateImages = [];
  bool _loading = false;

  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
  }

  Product(
      {this.id,
      this.name,
      this.description,
      this.brand,
      this.image,
      this.categoryId,
      this.offerId,
      this.price,
      this.unity,
      this.quantity = 0,
      this.deleted = false}) {
    name = name ?? '';
    image = image; // ?? [];
  }

  //método construtor para salvar os dados do documento firebase
  Product.fromDocument(DocumentSnapshot doc) {
    id = doc.id;
    name = doc.get('name');
    description = doc.get('description');
    brand = doc.get('brand');
    quantity = doc.get('quantity') as int;
    unity = doc.get('unity') as String;
    price = doc.get('price') as double;
    offerId = doc.get('offerId');
    categoryId = doc.get('categoryId') as String;
    deleted = (doc.get('deleted') ?? false) as bool;
    image = doc.get('image');
  }

  Product.fromSnapshot(DocumentSnapshot doc)
      : id = doc.id,
        name = doc.get('name'),
        description = doc.get('description'),
        brand = doc.get('brand'),
        quantity = doc.get('quantity') as int,
        unity = doc.get('unity') as String,
        price = doc.get('price') as double,
        offerId = doc.get('offerId'),
        categoryId = doc.get('categoryId') as String,
        deleted = (doc.get('deleted') ?? false) as bool,
        image = doc.get('image');

//convert to map (Json) -> preparação do formato compatível com o JSON (FIREBASE)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'brand': brand,
      'quantity': quantity,
      'unity': unity,
      'price': price,
      'image': image,
      // 'categoryId': categoryId,
      // 'offerId': offerId,
      'deleted': deleted,
    };
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, description: $description, quantity: $quantity,unity:$unity, price:$price, categoryId: $categoryId, offerId: $offerId, image: $image)';
  }
}
