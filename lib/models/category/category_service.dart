import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mercadinho/models/category/category.dart';

class CategoryService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final CollectionReference collectionRef = FirebaseFirestore.instance.collection('category');

  Future<DocumentReference> add(Category category) {
    return collectionRef.add(category.toJson());
  }

  void update(Category category) async {
    await collectionRef.doc(category.id).update(category.toJson());
  }

  void delete(String id) async {
    await collectionRef.doc(id).delete();
  }

  Stream<QuerySnapshot> getCategories() {
    return collectionRef.snapshots();
  }

  Future<String> getCategoriesByID(String id) async {
    DocumentReference documentReference = collectionRef.doc(id);
    var snapshot = await documentReference.get();
    return snapshot["title"];
  }
}
