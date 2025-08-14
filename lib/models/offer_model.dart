import 'package:cloud_firestore/cloud_firestore.dart';

class Offer {
  String? id; // Firestore document ID
  String ?title;
  String ?description;
  String ?email;
  String ?phone;
  String ?shopId;
  String ?shopName;
  Timestamp? createdAt;
  int ?status;
  var price;

  Offer({
    this.id,
    this.title,
    this.description,
    this.email,
    this.phone,
    this.shopId,
    this.shopName,
    this.createdAt,
    this.status,
    this.price,
  });

  // Factory constructor to create an Offer instance from a Firestore document snapshot
  factory Offer.fromSnapshot(DocumentSnapshot snapshot) {
    return Offer(
      id: snapshot.id,
      title: snapshot['title'],
      description: snapshot['description'],
      email: snapshot['email'],
      phone: snapshot['phone'],
      shopId: snapshot['shopid'],
      shopName: snapshot['shopname'],
      createdAt: snapshot['createdat'],
      status: snapshot['status'],
      price: snapshot['price']?.toDouble() ?? 0.0,
    );
  }

  // Convert Offer instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'email': email,
      'phone': phone,
      'shopid': shopId,
      'shopname': shopName,
      'createdat': FieldValue.serverTimestamp(),
      'status': status,
      'price': price,
    };
  }
}
