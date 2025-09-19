import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {
  FeedbackModel({
    required this.id,
    required this.bookingId,
    required this.shopId,
    required this.userId,
    required this.rating,
    required this.review,
    required this.userName,
    required this.userImage,
    required this.offerTitle,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String bookingId;
  final String shopId;
  final String userId;
  final double rating;
  final String review;
  final String userName;
  final String userImage;
  final String offerTitle;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory FeedbackModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;
    if (data == null) {
      throw StateError('Feedback document missing data: ${snapshot.id}');
    }

    return FeedbackModel(
      id: snapshot.id,
      bookingId: data['bookingId'] as String? ?? '',
      shopId: data['shopId'] as String? ?? '',
      userId: data['userId'] as String? ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 0,
      review: data['review'] as String? ?? '',
      userName: data['userName'] as String? ?? 'Unknown user',
      userImage: data['userImage'] as String? ?? '',
      offerTitle: data['offerTitle'] as String? ?? '',
      createdAt: _dateFrom(data['createdAt']),
      updatedAt: _dateFrom(data['updatedAt']),
    );
  }

  static DateTime? _dateFrom(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    return null;
  }
}
