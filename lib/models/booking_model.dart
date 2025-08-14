class Booking {
  final String userId;
  final String offerId;
  final String shopid;
  final String date;
  final String time;
  final String status;
  final String empid;
  final DateTime createdAt;

  Booking({required this.shopid,required this.empid,required this.userId, required this.offerId, required this.date, required this.time, required this.status, required this.createdAt});

  // Convert Booking instance to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'offerId': offerId,
      'date': date,
      'time': time,
      'status': status,
      'createdAt': createdAt,
      'shopid':shopid,
      'employeeid':empid
    };
  }
}