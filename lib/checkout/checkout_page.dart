import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:quickassitnew/checkout/invocie_number_generator.dart';
import 'package:quickassitnew/constans/colors.dart';
import 'package:quickassitnew/mechanic/mechanic_home_page.dart';
import 'package:quickassitnew/models/booking_model.dart';
import 'package:quickassitnew/models/transactionmodel.dart';
import 'package:quickassitnew/models/user_model.dart';
import 'package:quickassitnew/user/bottomnavigation_page.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class CheckoutPage extends StatefulWidget {
  final booking;
  UserModel? customerData;
  //final double totalPrice; // You need to calculate the total price based on your logic

  CheckoutPage({required this.booking, this.customerData});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  double estimatedTax = 0.0;
  double subtotal = 0.0;
  double total = 0.0;
  late Razorpay _razorpay = Razorpay();
  YourInvoiceGenerator invoiceGenerator = YourInvoiceGenerator();

  String? _uid;
  getData() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();



    // if (imggurl == null) {
    //   setState(() {
    //     imggurl = "assets/image/profile.png";
    //   });
    // }

    _uid = await _pref.getString(
      'uid',
    );



    setState(() {


    });
  }



  void handlePaymentErrorResponse(PaymentFailureResponse response){

    /** PaymentFailureResponse contains three values:
     * 1. Error Code
     * 2. Error Description
     * 3. Metadata
     **/
    showAlertDialog(context, "Payment Failed", "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
 print("Hello this is from jobin");
    /** Payment Success Response contains three values:
     * 1. Order ID
     * 2. Payment ID
     * 3. Signature
     **/

    if(response.paymentId!=null){


 print("helo jobinfee collected");





      try {

        // Open the generated PDF file
      collectFee(widget.customerData,widget.booking,response.paymentId);
        

        
      } catch (e) {
        print(
            'Failed to collect fee: $e');
      }
    }







    //showAlertDialog(context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  collectFee(UserModel? user, var booking,String? id)async {
    var id = Uuid().v1();
    id = id;
// Replace these values with the actual student and fee amount.
    // Specify the fee amount to collect.

    FirebaseFirestore.instance.collection('payment').doc(id).set(

        {
          'userId': user!.uid,
          'username': user!.name,
          'useremail': user!.email,
          'userphone': user!.phone,
          'shopid': booking['shopid'],
          'bookingprice': booking['offerPrice'],
          'status': 1,
          'createdAt': DateTime.now(),
          'paymentId': id
        }


    ).then((value) {
      FirebaseFirestore.instance.collection('bookings').doc(
          booking['bookingId']).update(

          {
            'paymentstatus': 1,
            'status': "Completed"
          }
      ).then((value) =>
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) => BottomNavigationPage()), (
                  route) => false));
    });
    // Generate the PDF invoice


  }



  // randomnumber



  void handleExternalWalletSelected(ExternalWalletResponse response){
    showAlertDialog(context, "External Wallet Selected", "${response.walletName}");
  }
  @override
  void dispose() {
    _razorpay.clear(); // Removes all listeners
    super.dispose();
  }

  void showAlertDialog(BuildContext context, String title, String message){
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed:  () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Map<String, dynamic> generateRazorpayOptions() {
    return {
      'key': 'rzp_test_7ERJiy5eonusNC',
      'amount': (total * 100).toInt(), // Convert total to integer (paise)
      'name': 'QuickAssit',
      'description': 'kkkk',
      'prefill': {
        'contact': '9895663498',
        'email': 'support@quickassist.com'
      }
    };
  }
  @override
  void initState() {
    getData();
    calculateTotalValues();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
    super.initState();
  }

  void calculateTotalValues() {
    // Adjust the tax rate based on your requirements


    // Calculate the subtotal, estimated tax, and total
    subtotal = double.parse(widget.booking['offerPrice']);
   // estimatedTax = subtotal;
    total = subtotal ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        title: Text('Checkout',style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cost Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal,color: Colors.white),
            ),
            SizedBox(height: 8),

            Text(
              '${widget.customerData!.name} - ${widget.customerData!.phone}',
              style: TextStyle(fontSize: 16,color: Colors.white),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Subtotal: \$${widget.booking['offerPrice']}',
                   textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ],
            ),
            Divider(
              thickness: 1.5, color: Colors.teal,
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Estimated Tax (18%): \$${estimatedTax.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16,color: Colors.white),
                ),
              ],
            ),
            Divider(
              thickness: 1.5, color: Colors.teal,
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Total: \$${total.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ],
            ),
            Divider(
              thickness: 1.5, color: Colors.teal,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                try{
                  _razorpay.open(generateRazorpayOptions());
                }catch(e){
                  print(e);
                }
                // Implement your payment logic here
                // You may want to use a payment gateway or navigate to a payment screen
                // For simplicity, let's print a message for now
                print('Payment successful.');
                // You can also call the joinCourse method here if payment is successful
                // courseService.joinCourse(course.id, userId, booking);
              },
              child: Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }
}
