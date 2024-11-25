import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mercadinho/user/models/user_model.dart';

class UserModelService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  UserModel? userModel;

  signup(UserModel user, dynamic image, bool platform) async {
    User? signupUser = (await _auth.createUserWithEmailAndPassword(
        email: user.email!, password: user.password!)) as User?;

    userModel!.id = signupUser!.uid;
  }

  saveDetails() async {
    await _firestore.collection('users').add(userModel!.toMap());
  }
}
