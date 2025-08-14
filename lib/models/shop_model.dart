import 'package:cloud_firestore/cloud_firestore.dart';

class Shop {
  String? id; // Firestore document ID
  String? shopName;
  String? shopId;
  String? location;
  String ?address;
  String ?email;
  String? password; // Note: It's advisable to use a secure authentication method in production
  var serviceType;
  String ?licenseNo;
  String ?phone;
  String ?accountInfo;
  String ?gst;
  String ?img;

  Shop({
    this.id,
    this.shopName,
    this.shopId,
    this.location,
    this.address,
    this.email,
    this.password,
    this.serviceType,
    this.licenseNo,
    this.phone,
    this.accountInfo,
    this.gst,
    this.img,
  });

  // Factory constructor to create a Shop instance from a Firestore document snapshot
  factory Shop.fromSnapshot(DocumentSnapshot snapshot) {
    return Shop(
      id: snapshot.id,
      shopName: snapshot['shopname'],
      shopId: snapshot['shopid'],
      location: snapshot['location'],
      address: snapshot['address'],
      email: snapshot['email'],
      password: snapshot['password'],
      serviceType: snapshot['servicetype'] ,
      licenseNo: snapshot['licenceno'],
      phone: snapshot['phone'],
      accountInfo: snapshot['accountinfo'],
      gst: snapshot['gst'],
      img: snapshot['img'],
    );
  }

  // Convert Shop instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'shopname': shopName,
      'shopid': shopId,
      'location': location,
      'address': address,
      'email': email,
      'password': password,
      'servicetype': serviceType as List<String>,
      'licenceno': licenseNo,
      'phone': phone,
      'accountinfo': accountInfo,
      'gst': gst,
      'img': img,
    };
  }
}
