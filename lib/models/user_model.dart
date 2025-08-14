import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;

  String? email;
  String? name;
  String? phone;
  String? password;
  String? imgurl;
  String? location;
  var dob;



  int? status;
  DateTime? createdAt;

  UserModel(
      {this.createdAt,


        this.dob,


        this.status,
        this.uid,
        this.email,
        this.name,
        this.password,
        this.phone,
        this.imgurl,
        this.location});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      status: json['status'],

      uid: json['uid'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      location: json['location'],
      imgurl: json['imgurl'],


      dob: json['dob'],
      createdAt: json['createdAt'],
      // skills: List<String>.from(json['skills'])??[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'uid': uid,
      'name': name,
      'email': email,
      'location': location,
      'dob': dob.toIso8601String(),


      'imgurl': imgurl,
      'createdAt': createdAt!.toIso8601String(),

    };
  }

  static UserModel fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    data['uid'] = snapshot.id;
    return UserModel.fromJson(data);
  }

  Map<String, dynamic> toDocument() {
    final data = toJson();

    return data;
  }
}
