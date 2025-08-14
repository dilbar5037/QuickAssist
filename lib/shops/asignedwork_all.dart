import 'package:flutter/material.dart';
import 'package:quickassitnew/services/booking_service.dart';
import 'package:quickassitnew/widgets/apptext.dart';


class AssignedWorkPage extends StatefulWidget {
  @override
  _AssignedWorkPageState createState() => _AssignedWorkPageState();
}

class _AssignedWorkPageState extends State<AssignedWorkPage> {
  List<Map<String, dynamic>> assignedBookings = [];

  @override
  void initState() {
    super.initState();
    // Fetch assigned bookings
    fetchAssignedBookings();
  }

  Future<void> fetchAssignedBookings() async {
    // Call the booking service to fetch assigned bookings
    BookingService bookingService = BookingService();
    List<Map<String, dynamic>> bookings = await bookingService.getAssignedWork();

    setState(() {
      assignedBookings = bookings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: AppText(data:'Assigned Work',color: Colors.white,),
      ),  
      body: Container(
        child: ListView.builder(
          itemCount: assignedBookings.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(assignedBookings[index]['offerTitle'] as String),
                subtitle: Text('Status: ${assignedBookings[index]['status']}'),
                onTap: () {
                  // Show details dialog when tapped
                  showBookingDetailsDialog(assignedBookings[index]);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> showBookingDetailsDialog(Map<String, dynamic> booking) async {
    // Fetch employee details for the assigned booking
    String empId = booking['empid'] as String;
   final employee = await BookingService().getEmployeeDetails(empId);

    // Show details dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Booking Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Offer: ${booking['offerTitle']}'),
              Text('Employee: ${employee!['name']}'),
              Text('Employee Email: ${employee['email']}'),
              // Add more details as needed
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
