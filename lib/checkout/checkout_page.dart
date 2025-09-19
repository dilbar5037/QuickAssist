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
  late final Razorpay _razorpay;
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

    if (mounted) {
      setState(() {});
    }
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    /** PaymentFailureResponse contains three values:
     * 1. Error Code
     * 2. Error Description
     * 3. Metadata
     **/
    showAlertDialog(context, "Payment Failed",
        "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
    print("Hello this is from jobin");
    if (response.paymentId == null) {
      return;
    }

    print("helo jobinfee collected");

    try {
      await collectFee(widget.customerData, widget.booking, response.paymentId);
    } catch (e) {
      print('Failed to collect fee: $e');
    }
  }

  Future<void> collectFee(
      UserModel? user, dynamic booking, String? paymentId) async {
    if (user == null) {
      throw StateError('User details missing for fee collection');
    }
    if (paymentId == null || paymentId.isEmpty) {
      throw StateError('Payment id missing');
    }

    Map<String, dynamic> bookingData;
    if (booking is Map<String, dynamic>) {
      bookingData = Map<String, dynamic>.from(booking);
    } else if (booking is Map) {
      bookingData = Map<String, dynamic>.from(booking as Map);
    } else {
      throw StateError('Unsupported booking data type: ${booking.runtimeType}');
    }

    final bookingId = bookingData['bookingId'] ?? bookingData['bookingid'];
    if (bookingId == null) {
      throw StateError('Booking id missing in booking data');
    }

    final paymentDocumentId = Uuid().v1();

    await FirebaseFirestore.instance
        .collection('payment')
        .doc(paymentDocumentId)
        .set({
      'userId': user.uid,
      'username': user.name,
      'useremail': user.email,
      'userphone': user.phone,
      'shopid': bookingData['shopid'],
      'bookingprice': bookingData['offerPrice'],
      'status': 1,
      'createdAt': DateTime.now(),
      'paymentId': paymentId,
      'paymentDocId': paymentDocumentId,
    });

    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingId)
        .update({
      'paymentstatus': 1,
      'status': 'Completed',
    });

    if (!mounted) {
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const BottomNavigationPage()),
      (route) => false,
    );
  }

  // randomnumber

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {},
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

  Map<String, Object?> _buildPaymentOptions() {
    final amountInPaise = (total * 100).round().clamp(0, 999999999);
    final contact =
        (widget.customerData?.phone ?? '').replaceAll(RegExp(r'[^0-9+]'), '');
    final email = widget.customerData?.email ?? '';
    final description =
        widget.booking['offerTitle']?.toString() ?? 'Service payment';

    final prefill = <String, String>{};
    if (contact.isNotEmpty) {
      prefill['contact'] = contact;
    }
    if (email.isNotEmpty) {
      prefill['email'] = email;
    }

    return {
      'key': 'rzp_test_7ERJiy5eonusNC',
      'amount': amountInPaise,
      'name': 'Quick Assist',
      'description': description,
      'prefill': prefill,
    };
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
    getData();
    calculateTotalValues();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void calculateTotalValues() {
    // Adjust the tax rate based on your requirements

    // Calculate the subtotal, estimated tax, and total
    final rawPrice = widget.booking['offerPrice'];
    if (rawPrice != null) {
      subtotal = double.tryParse(rawPrice.toString()) ?? 0.0;
    } else {
      subtotal = 0.0;
    }
    total = subtotal;
  }

  void _startPayment() {
    final amountPaise = (total * 100).round();
    if (amountPaise <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Payment amount must be greater than zero.')),
      );
      return;
    }
    try {
      _razorpay.open(_buildPaymentOptions());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to launch Razorpay: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cost Summary',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.white),
            ),
            SizedBox(height: 8),
            Text(
              '${widget.customerData!.name} - ${widget.customerData!.phone}',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Subtotal: ₹${widget.booking['offerPrice']}',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
            Divider(
              thickness: 1.5,
              color: Colors.teal,
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Estimated Tax (18%): ₹${estimatedTax.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
            Divider(
              thickness: 1.5,
              color: Colors.teal,
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Total: ₹${total.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
            Divider(
              thickness: 1.5,
              color: Colors.teal,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _startPayment,
              child: const Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }
}
