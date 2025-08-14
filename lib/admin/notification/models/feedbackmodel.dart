import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {
  String? msgid;
  String? title;
  String? message;
  String? senderid;
  String?sendername;
  String?senderphone;

  DateTime? date;
  int? status;
  String?reply;
  int?replystatus;


  FeedbackModel(


      {

        this.message,
        this.reply,
        this.replystatus,
        this.status,
        this.date,
        this.msgid,

        this.senderid,
        this.sendername,this.senderphone,
        this.title});



  factory FeedbackModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return FeedbackModel(
      msgid: snapshot['msgid'],
      title: snapshot['title'],
      message: snapshot['message'],
      senderid: snapshot['senderid'],
      sendername: snapshot['sendername'],
      senderphone: snapshot['senderphone'],

      reply: snapshot['reply'],
      replystatus: snapshot['replystatus'],
      status: snapshot['status'],



    );
  }




}
