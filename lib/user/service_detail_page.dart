import 'package:flutter/material.dart';
import 'package:quickassitnew/constans/colors.dart';
import 'package:quickassitnew/services/booking_service.dart';
import 'package:quickassitnew/widgets/appbutton.dart';
import 'package:quickassitnew/widgets/apptext.dart';
import 'package:quickassitnew/widgets/mydivider.dart';
import 'package:uuid/uuid.dart';

class ServiceDetailPage extends StatefulWidget {
  final String serviceId; // Pass the service ID from the selected service
  final String title;
  final String price;
  final String shopId;
  final String desc;

  final String?shoplocation;
  final uid;

  ServiceDetailPage({
    required this.serviceId,
    required this.shoplocation,

    required this.title,
    required this.price,
    required this.shopId,
    required this.desc,
    required this.uid

  });

  @override
  State<ServiceDetailPage> createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(data: 'Service Details',size: 16,color: Colors.white,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
            data:  '${widget.title}',
              size: 14,

            ),
           MyDivider(),
            AppText(
              data:  'Details',
              fw: FontWeight.bold,

            ),
            SizedBox(height: 10,),

            AppText(
              data:  '${widget.desc}',
              size: 16,

            ),
            MyDivider(),
            AppText(
             data: 'Price: Rs ${widget.price}/- Only',
              size: 16,
              color: Colors.green,
              fw: FontWeight.bold,

            ),
            SizedBox(height: 10),
            AppText(
              data: 'Shop Location ${widget.shoplocation}',

            ),


            SizedBox(height: 20),
            AppButton(
                height: 40,
                width: 150,
                color: AppColors.btnPrimaryColor,
                onTap: () async {
                  var bookingid = Uuid().v1();
                  BookingService bookingService =
                  BookingService();

                  // Replace the following line with your actual offer data retrieval method
                  Map<String, dynamic> offerData = {
                    'id': widget.serviceId,
                    'title': widget.title,
                    'price': widget.price,
                    'shopid': widget.shopId,
                    'bookingid': bookingid
                  };

                  // Show Date and Time Picker
                  await _showDateTimePicker(context);

                  // Check if the user selected a date and time
                  if (selectedDateTime != null) {
                    // Check if a booking already exists for the selected date and time
                    bool bookingExists =
                    await bookingService
                        .checkBookingExists(
                      offerData['id'],
                      selectedDateTime!,
                    );

                    if (bookingExists) {
                      // Display a message or take appropriate action
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                          content: Text(
                              "Booking Already Exists for the selected date and Time")));
                    } else {
                      // Book Offer
                      await bookingService
                          .bookOffer(
                          widget.uid!,
                          offerData,
                          selectedDateTime!)
                          .then((value) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(
                            content: Text(
                                "Booking Done")));
                      });
                    }
                  }
                },
                child: AppText(
                  data: "Book Now",
                  color: Colors.white,
                ))
          ],
        ),
      ),
    );
  }

  DateTime? selectedDateTime;

  Future<void> _showDateTimePicker(BuildContext context) async {
    // 3. Show Date Picker
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now()
          .add(Duration(days: 365)), // Set an appropriate end date
    );

    if (pickedDate == null) {
      // User canceled the date picker
      return;
    }

    // 4. Show Time Picker
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) {
      // User canceled the time picker
      return;
    }

    // Combine date and time
    DateTime combinedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    // Update the selectedDateTime in the state
    setState(() {
      selectedDateTime = combinedDateTime;
    });

    // Now you can use 'selectedDateTime' for further processing
    print('Selected Date and Time: $selectedDateTime');
  }
}
