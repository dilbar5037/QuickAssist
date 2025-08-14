import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String? msgid;
  String? title;
  String? message;
  String? sender;
  DateTime? date;
  int? status;

  NotificationModel(
      {this.message,
        this.status,
        this.date,
        this.msgid,
        this.sender,
        this.title});



  factory NotificationModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return NotificationModel(
      msgid: snapshot['msgid'],
      title: snapshot['title'],
      message: snapshot['message'],
      sender: snapshot['sender'],

      status: snapshot['status'],


    );
  }




}
