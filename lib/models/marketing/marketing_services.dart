import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mercadinho/models/marketing/marketing.dart';

class MarketingServices {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final CollectionReference _collectionRef = FirebaseFirestore.instance.collection('marketing');

  Future<DocumentReference> add(Marketing marketing) {
    return _collectionRef.add(marketing.toJson());
  }

  void update(Marketing marketing) async {
    await _collectionRef.doc(marketing.id).update(marketing.toJson());
  }

  void delete(String id) async {
    await _collectionRef.doc(id).delete();
  }

  Stream<QuerySnapshot> getMarketings() {
    return _collectionRef.snapshots();
  }

  Future<String> getMarketingsByID(String id) async {
    DocumentReference documentReference = _collectionRef.doc(id);
    var snapshot = await documentReference.get();
    return snapshot["title"];
  }

  //método para obter dados da commodity no firebase
  Future<List<Marketing>> getListMarketings() async {
    QuerySnapshot querySnapshot = await _collectionRef.where('marketing.title').get();
    return querySnapshot.docs.map((doc) {
      return Marketing(id: doc.id, title: doc['title']);
    }).toList();
  }
}
