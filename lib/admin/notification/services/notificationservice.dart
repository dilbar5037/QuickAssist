
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/notificationmodel.dart';

class NotificationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _notification =
  FirebaseFirestore.instance.collection('notification');

  Future<void> sendNotification(NotificationModel message) async {


    await _notification.doc(message.msgid).set({
      'msgid': message.msgid,
      'title': message.title,
      'message': message.message,
      'sender': message.sender,

      'createdat': DateTime.now(),
      'status': message.status
    }).then((value) => null);
  }

  Future<List<NotificationModel>> getAllNotification() async {
    QuerySnapshot snap =
    await _notification.get();

    List<NotificationModel> data = [];

    for (var snapshot in snap.docs) {
      NotificationModel notification =NotificationModel.fromSnapshot(snapshot);
      data.add(notification);
    }

    return data;
  }




  Future<List<NotificationModel>> getAllActiveNotification() async {
    QuerySnapshot snap =
    await _notification.where('status',isEqualTo:1).get();

    List<NotificationModel> data = [];

    for (var snapshot in snap.docs) {
      NotificationModel notification =NotificationModel.fromSnapshot(snapshot);
      data.add(notification);
    }

    return data;
  }

  Future<void> deleteMessage(String? id) async {
    await _notification.doc(id).update({'status': 0});
  }



}