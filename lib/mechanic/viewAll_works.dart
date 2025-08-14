import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quickassitnew/checkout/checkout_page.dart';
import 'package:quickassitnew/constans/colors.dart';
import 'package:quickassitnew/services/userservice.dart';
import 'package:quickassitnew/widgets/appbutton.dart';
import 'package:quickassitnew/widgets/apptext.dart';
import 'package:quickassitnew/services/booking_service.dart';
import 'package:quickassitnew/widgets/mydivider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import your BookingService class

class WorkAssigned extends StatefulWidget {
  const WorkAssigned({Key? key});

  @override
  State<WorkAssigned> createState() => _WorkAssignedState();
}

class _WorkAssignedState extends State<WorkAssigned> {
  String? _type;
  String? uid;
  String? name;
  String? email;
  String? phone;
  String? img;

  getData() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _type = await _pref.getString('type');
    email = await _pref.getString('email');
    name = await _pref.getString('name');
    phone = await _pref.getString('phone');
    uid = await _pref.getString('uid');
    img = await _pref.getString('imgurl');

    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(data: "My Works", color: Colors.white),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                // Replace with the actual method in BookingService to get all bookings
                future: BookingService().getAllBookingsForEmpolee(uid.toString()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: AppText(data: 'Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: AppText(data: 'No bookings found.'));
                  }

                  List<Map<String, dynamic>> bookings = snapshot.data!;

                  return ListView.builder(
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];

                      return Card(
                        child: ListTile(
                          trailing: Container(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [

                                IconButton(
                                  onPressed: () async {
                                    if (booking['status'] == 'Confirmed') {
                                      // Fetch QR code data for the confirmed booking
                                      Map<String,dynamic>? qrCodeData = await BookingService()
                                          .getQRCodeData(booking['bookingId']);
                                      
                                      final userdata=await UserService().getUSerById(booking['userId']);

                                      if (qrCodeData != null) {
                                        // Display QR code when button is pressed
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            var splitData=qrCodeData['data'].split(";");
                                            return AlertDialog(

                                              content: Container(
                                                height:590,
                                                width: 200,
                                                child: Column(
                                                  children: [
                                                    AppText(data: "Your Gate Pass"),
                                                    AppText(data: "${booking['status']}",size: 14,color: Colors.green,),
                                                    MyDivider(),
                                                    QrImageView(
                                                      data: qrCodeData['data'],
                                                      version: QrVersions.auto,
                                                      size: 200.0,
                                                    ),
                                                    MyDivider(),
                                                    AppText(data: "${splitData[0]}",size: 12,),
                                                    MyDivider(),
                                                    AppText(data: "${splitData[1].toUpperCase()}",size: 12,),
                                                    MyDivider(),
                                                    AppText(data: "${splitData[2].toUpperCase()}",size: 12,),

                                                    MyDivider(),

                                                    AppText(data: "${splitData[3].toUpperCase()}",size: 12,),
                                                    MyDivider(),

                                                    AppText(data: "Thank You for your Business",size: 12,color: Colors.teal,),
                                                  SizedBox(height: 20,),
                                                    booking['status']=="Completed"?AppText(data: "Payment Completed"):AppText(data: "Payment Pending")

                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      } else {
                                        // Handle case where QR code data is not available
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("QR code data not available"),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  icon: Icon(Icons.qr_code),
                                )
                              ],
                            ),
                          ),
                          title: Text('Offer: ${booking['offerTitle']}'),
                          subtitle: Text('Status: ${booking['status']}'),
                          // Add more details as needed
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
