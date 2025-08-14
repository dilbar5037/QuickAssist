import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  String? id; // Firestore document ID
  String ?title;
  String ?description;
  String ?type;
  double ?price;
  int ?offer;
  int? status;
  String ?shopId;
  String?shopLocation;
  String?shopEmail;
  String?shopPhone;


  Service({
    this.id,
    this.title,
    this.description,
    this.type,
    this.price,
    this.offer,
    this.status,
    this.shopId,
    this.shopEmail,this.shopLocation,this.shopPhone
  });

  // Factory constructor to create a Service instance from a Firestore document snapshot
  factory Service.fromSnapshot(DocumentSnapshot snapshot) {
    return Service(
      id: snapshot.id,
      title: snapshot['title'],
      description: snapshot['desc'],
      type: snapshot['type'],
      price: (snapshot['price'] as num)?.toDouble() ?? 0.0,
      offer: snapshot['offer'] ?? false,
      status: snapshot['status'],
      shopId: snapshot['shopid'],
      shopEmail: snapshot['shopemail'],
      shopLocation: snapshot['shopLocation'],
      shopPhone: snapshot['shopPhone']
    );
  }

  // Convert Service instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'desc': description,
      'type': type,
      'price': price,
      'offer': offer,
      'status': status,
      'shopid': shopId,
      'shopemail':shopEmail,
      'shopPhone':shopPhone,
    'shopLocation':shopLocation
    };
  }
}


