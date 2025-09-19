import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickassitnew/models/feedback_model.dart';

class FeedbackService {
  FeedbackService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _collection =
            (firestore ?? FirebaseFirestore.instance).collection('feedback');

  final FirebaseFirestore _firestore;
  final CollectionReference<Map<String, dynamic>> _collection;

  Future<void> submitFeedback({
    required String bookingId,
    required String shopId,
    required String userId,
    required double rating,
    required String review,
    required String userName,
    required String userImage,
    required String offerTitle,
  }) async {
    final docRef = _collection.doc(bookingId);
    final payload = <String, dynamic>{
      'bookingId': bookingId,
      'shopId': shopId,
      'userId': userId,
      'rating': rating,
      'review': review,
      'userName': userName,
      'userImage': userImage,
      'offerTitle': offerTitle,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    final snapshot = await docRef.get();
    if (snapshot.exists) {
      await docRef.update(payload);
    } else {
      payload['createdAt'] = FieldValue.serverTimestamp();
      payload['updatedAt'] = FieldValue.serverTimestamp();
      await docRef.set(payload);
    }
  }

  Future<FeedbackModel?> getFeedbackForBooking(String bookingId) async {
    final snapshot = await _collection.doc(bookingId).get();
    if (!snapshot.exists) {
      return null;
    }
    return FeedbackModel.fromSnapshot(snapshot);
  }

  Stream<List<FeedbackModel>> streamFeedbackForShop(String shopId) {
    return _collection.where('shopId', isEqualTo: shopId).snapshots().map(
      (query) {
        final feedback =
            query.docs.map((doc) => FeedbackModel.fromSnapshot(doc)).toList();
        feedback.sort((a, b) {
          final aDate = a.updatedAt ??
              a.createdAt ??
              DateTime.fromMillisecondsSinceEpoch(0);
          final bDate = b.updatedAt ??
              b.createdAt ??
              DateTime.fromMillisecondsSinceEpoch(0);
          return bDate.compareTo(aDate);
        });
        return feedback;
      },
    );
  }

  Future<double> fetchAverageRating(String shopId) async {
    final snapshot = await _collection.where('shopId', isEqualTo: shopId).get();
    if (snapshot.docs.isEmpty) {
      return 0;
    }
    final total = snapshot.docs.fold<double>(
      0,
      (previousValue, doc) =>
          previousValue + ((doc.data()['rating'] as num?)?.toDouble() ?? 0),
    );
    return total / snapshot.docs.length;
  }
}
