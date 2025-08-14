
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickassitnew/admin/notification/models/feedbackmodel.dart';




class FeedbackService{



  final CollectionReference _feedback =
  FirebaseFirestore.instance.collection('feedback');

  Future<void> sendFeedback(FeedbackModel message) async {
    await _feedback.doc(message.msgid).set({
      'msgid': message.msgid,
      'title': message.title,
      'message': message.message,
      'senderid': message.senderid,
      'sendername':message.sendername,
      'senderphone':message.senderphone,
       'reply':message.reply,
      'replystatus':0,

      'createdat': DateTime.now(),
      'status': message.status,

    });
  }



  Future<void> updateFeedback(FeedbackModel message) async {
    await _feedback.doc(message.msgid).update({

      'reply':message.reply,
      'replystatus':1,

          });
  }




  Future<List<FeedbackModel>> getallFeedbacks() async {

    QuerySnapshot snap =
    await _feedback.get();
    print(snap.size);
    List<FeedbackModel> data = [];

    for (var snapshot in snap.docs) {
      print("hi jobin");
      FeedbackModel message = FeedbackModel.fromSnapshot(snapshot);
      data.add(message);
      print(message.title);
    }

    return data;
  }

  Future<void> deleteFeedback(String? id) async {
    await _feedback.doc(id).update({'status': 0});
  }



  Future<List<FeedbackModel>> getFeedbackuser(String? uid) async {

    QuerySnapshot snap =
    await _feedback.where('senderid', isEqualTo: uid.toString()).where('status',isEqualTo: 1).get();
    print(snap.size);
    List<FeedbackModel> data = [];

    for (var snapshot in snap.docs) {
      print("hi jobin");
      FeedbackModel message = FeedbackModel.fromSnapshot(snapshot);
      data.add(message);
      print(message.title);
    }

    return data;
  }

  Future<List<FeedbackModel>> getFeedbyhouse(String? houseid) async {

    QuerySnapshot snap =
    await _feedback.where('houseid', isEqualTo: houseid.toString()).get();
    print(snap.size);
    List<FeedbackModel> data = [];

    for (var snapshot in snap.docs) {
      print("hi jobin");
      FeedbackModel message = FeedbackModel.fromSnapshot(snapshot);
      data.add(message);
      print(message.title);
    }

    return data;
  }



  Future<List<FeedbackModel>> getFeedbyowner(String? ownerid) async {

    QuerySnapshot snap =
    await _feedback.where('recevier', isEqualTo: ownerid.toString()).get();
    print(snap.size);
    List<FeedbackModel> data = [];

    for (var snapshot in snap.docs) {
      print("hi jobin");
      FeedbackModel message = FeedbackModel.fromSnapshot(snapshot);
      data.add(message);
      print(message.title);
    }

    return data;
  }





}