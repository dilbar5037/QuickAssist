import 'package:cloud_firestore/cloud_firestore.dart';
enum FinancialEntryType {
  income,
  expense,
}


FinancialEntryType financialEntryTypeFromString(String value) {
  if (value == 'income') {
    return FinancialEntryType.income;
  } else if (value == 'expense') {
    return FinancialEntryType.expense;
  } else {
    throw ArgumentError('Unknown FinancialEntryType: $value');
  }
}
class FinancialEntry {
  String? id;
  String?usertype;
  bool?gst;
  String?customerId;
  DateTime date;
  String description;
  double amount;
  FinancialEntryType type;
  String category;
  String?gstNo;

  FinancialEntry({
    this.id,
    this.gst,
    this.usertype,
    this.gstNo,
    required this.customerId,
    required this.date,
    required this.description,
    required this.amount,
    required this.type,
    required this.category,
  });

  factory FinancialEntry.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return FinancialEntry(
      id: snapshot.id,
      usertype: data['userType'],
      gstNo: data['gstNo'],
      gst:data['gst'],
      customerId: data['customerID'],
      date: (data['date'] as Timestamp).toDate(),
      description: data['description'] as String,
      amount: data['amount'] as double,
      type:financialEntryTypeFromString(data['type']),
      category: data['category'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'gst':gst,
      'userType':usertype,
      'gstNo':gstNo,
      'date': Timestamp.fromDate(date),
      'description': description,
      'amount': amount,
      'type': type == FinancialEntryType.income ? 'income' : 'expense',
      'category': category,
      'customerID':customerId
    };
  }
}
