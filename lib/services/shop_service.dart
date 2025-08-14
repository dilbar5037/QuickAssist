import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickassitnew/models/shop_model.dart';
import 'package:quickassitnew/services/userservice.dart';

class ShopService {
  final CollectionReference _shopsCollection =
  FirebaseFirestore.instance.collection('shops');
  final CollectionReference _login =
  FirebaseFirestore.instance.collection('login');


  Future<void> addShop(Shop shop) async {

    UserCredential userCredential=await FirebaseAuth.instance.createUserWithEmailAndPassword(email: shop.email.toString(), password: shop.password.toString());

    if(userCredential!=null){


      await FirebaseFirestore.instance.collection('login').doc(userCredential.user!.uid).set(
          {

            'usertype':"shop",
            'uid': userCredential.user!.uid,
            'email': userCredential.user!.email,
            'password':shop.password,
            'status':1
          });
      await _shopsCollection.doc(userCredential.user!.uid).set(shop.toMap());
    }

  }

  Future<List<Shop>> getShops() async {
    final QuerySnapshot snapshot = await _shopsCollection.get();

    return snapshot.docs.map((doc) => Shop.fromSnapshot(doc)).toList();
  }

  Future<Shop> getShopById(String shopId) async {
    final DocumentSnapshot doc =
    await _shopsCollection.doc(shopId).get();

    return Shop.fromSnapshot(doc);
  }

  Future<void> updateShop(Shop shop) async {
    await _shopsCollection.doc(shop.id).update(shop.toMap());
  }

  Future<void> deleteShop(String shopId) async {
    await _shopsCollection.doc(shopId).delete();
  }
}
