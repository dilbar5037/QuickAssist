import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickassitnew/widgets/apptext.dart';

class PaymentListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(data:'Payment List',color: Colors.white,),
      ),  
      body: Container(
        padding: EdgeInsets.all(20),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('payment').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
        
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
        
            List<DocumentSnapshot>? payments = snapshot.data?.docs;
            double totalPayment = 0;
        
            // Loop through each payment document and sum up the 'bookingprice'
            for (var paymentDoc in payments ?? []) {
              var payment = paymentDoc.data() as Map<String, dynamic>?;
              if (payment != null) {
                print('Booking price: ${payment['bookingprice']}');
                totalPayment += double.parse(payment['bookingprice'].toString());
              }
            }
        
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: payments?.length ?? 0,
                    itemBuilder: (context, index) {
                      var payment = payments?[index].data() as Map<String, dynamic>?;
        
                      if (payment != null) {
                        // Ensure payment is of type Map<String, dynamic>
                        // Access payment properties safely using null-aware operators
                        totalPayment += double.parse(payment['bookingprice'].toString());
        
                        return Card(
                          child: ListTile(
                            title: Text('Username: ${payment['username']}'),
                            subtitle: Text('Amount: ${payment['bookingprice']}'),
                          ),
                        );
                      } else {
                        return SizedBox(); // Placeholder for empty list item
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Total Payment: $totalPayment',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
