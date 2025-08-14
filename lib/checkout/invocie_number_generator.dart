import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class YourInvoiceGenerator {
  String generateInvoiceNumber() {
    // Use the uuid package to generate a random identifier
    var uuid = Uuid();
    String randomId = uuid.v4();

    // Use the current date and time components
    DateTime now = DateTime.now();
    String formattedDate = '${now.day}${now.month}${now.year}';
    String formattedTime = '${now.hour}${now.minute}';

    // Combine the components to create a unique invoice number
    String invoiceNumber = 'INV-MU$formattedTime/$formattedDate-$randomId';

    return invoiceNumber;
  }
}

void main() {
  YourInvoiceGenerator invoiceGenerator = YourInvoiceGenerator();
  String uniqueInvoiceNumber = invoiceGenerator.generateInvoiceNumber();
  print(uniqueInvoiceNumber);
}
