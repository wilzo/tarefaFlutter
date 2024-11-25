import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:mercadinho/product/models/product.dart';
import 'package:mercadinho/utils/exceptions/my_firebase_auth_exceptions.dart';
import 'package:mercadinho/utils/exceptions/my_firebase_exceptions.dart';
import 'package:mercadinho/utils/exceptions/my_platform_exceptions.dart';
import 'package:uuid/uuid.dart';

class ProductServices {
  // -- instanciar o firebase
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // -- instanciar o firestorage
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // -- DTO
  Product? product;

  // -- save method
  save(Product product, dynamic image) {
    try {} on FirebaseAuthException catch (e) {
      throw MyFirebaseAuthExceptions(e.code).message;
    } on FirebaseException catch (e) {
      throw MyFirebaseExceptions(e.code).message;
    } on PlatformException catch (e) {
      throw MyPlatformExceptions(e.code).message;
    } catch (e) {
      throw 'Algo está errado. Por favor, tente novamente';
    }
  }


  _uploadImage(dynamic image, bool platform) async {
    //gerando uid para armazenar a image no firestore
       final uuid = Uuid().v4(); 
        // criando referencia para o produto
       Reference storageRef = _storage.ref().child('products').child(product!.id!);
       //gerenciador de tarefas para upload de imagens
       UploadTask task;
       //upload da imagem web ou mobile

      if(!platform){
        // vinculando a imagem com o uuid para identificação
        //imagem para celular
        task = storageRef.child(uuid).putFile(image);
      }else{
        //imagem para web
        task = storageRef.child(uuid).putData(image);
      }
      // fazendo upload da imagem
      String url = await (await task.whenComplete( () {} )).ref.getDownloadURL();

      product!.image = url;
      await _firestore.collection('products').doc(product!.id).set(product!.toMap());
  }
}
