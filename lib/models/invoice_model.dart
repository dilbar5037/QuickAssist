import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickassitnew/models/transactionmodel.dart';



enum InvoiceStatus {
  Pending,
  Paid,
  Overdue,
}

class Invoice {
  String id;
  String customerID;
  double amount;
  DateTime issueDate;
  DateTime dueDate;
  InvoiceStatus status;
  List<FinancialEntry> transactions;

  Invoice({
    required this.id,
    required this.customerID,
    required this.amount,
    required this.issueDate,
    required this.dueDate,
    required this.status,
    required this.transactions,
  });

  Map<String, dynamic> toMap() {
    return {
      'studentId': customerID,
      'amount': amount,
      'issueDate': Timestamp.fromDate(issueDate),
      'dueDate': Timestamp.fromDate(dueDate),
      'status': status.toString().split('.').last,
      'transactions': transactions.map((transaction) => transaction.toMap()).toList(),
    };
  }

  factory Invoice.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    final transactionsData = data['transactions'] as List<dynamic>;
    final transactionsList = transactionsData.map((transaction) {
      return FinancialEntry.fromDocumentSnapshot(transaction as DocumentSnapshot);
    }).toList();


    return Invoice(
        id: snapshot.id,
        customerID: data['studentId'] as String,
        amount: data['amount'] as double,
        issueDate: (data['issueDate'] as Timestamp).toDate(),
        dueDate: (data['dueDate'] as Timestamp).toDate(),
        status: InvoiceStatus.values.firstWhere((e) => e.toString() == 'InvoiceStatus.${data['status']}'),
        transactions: transactionsList
    );
  }
}
