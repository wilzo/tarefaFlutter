import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mercadinho/models/cart/cart.dart';
import 'package:mercadinho/models/cart/cart_item.dart';
import 'package:mercadinho/models/product/product.dart';
import 'package:mercadinho/models/users/users.dart';
import 'package:mercadinho/utils/utilities.dart';

class CartServices2 extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel? user;
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalPrice => _items.fold(0, (total, item) => total + item.product!.price! * item.quantity!);
  //-- FOLD é o mesmo que:
  //comando uma lista de items
  //for (var i = 0; i < _items.lenght; i++) {
  //  total = total + (items[i].product!.price * item[i].product!.quantity);
  //}
  //========================================================================
  //-- ou na iteração sobre uma coleção
  //for (var item in _items) {
  //  total = total + (item.product!.price! * item.quantity!)
  //}

  void addItemToCart(Product product, int quantity) {
    debugPrint("Adicionando item ao carrinho de compras");
    // verifica se o produto já existe no carrinho, incrementa a quantidade se houver
    // Caso contrário, adiciona um novo item no carrinho
    _items.add(CartItem(product: product, quantity: quantity));
    notifyListeners();
  }

  void removeItem(CartItem cartItem) {
    // Remove item do carrinho
    debugPrint('conteúdo do carrinho ${_items.toString()}');
    _items.removeWhere((item) => item == cartItem);
    notifyListeners();
  }

  void updateQuantity(Product product, int newQuantity) {
    // atualiza a quantidade do produto no carrinho
    // _items[_items.indexWhere((element)=> element.product == product.id)]=CartItem(product: product, quantity: newQuantity);
    for (var item in _items) {
      if (item.product == product) {
        item.quantity = newQuantity;
      }
    }

    notifyListeners();
  }

  //carregar carrinho da base de dados

  Stream<QuerySnapshot> loadAllCart() {
    // obtêm dados do carrinho da base de dados para o usuário atual
    // Atualiza o objeto _items de acordo com os requisitos
    return _firestore.collection('carts').snapshots();
  }

  //salvar o carrinho na base de dados
  Future<void> saveCart(UserModel user) async {
    // Salva os dados do carrinho na base de dados para o usuário atual
    Cart? cart = Cart(
      items: items,
      userModel: user,
      date: Utilities.getDateTime(),
    );
    _firestore.collection('carts').add(cart.toMap());
  }

  setUser(UserModel user) {
    this.user = user;
  }
}
