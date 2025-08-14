import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickassitnew/services/booking_service.dart';

class ConfirmAssign extends StatefulWidget {
  final DocumentSnapshot? booking;
  final uid;
  ConfirmAssign({this.booking,this.uid});

  @override
  _ConfirmAssignState createState() => _ConfirmAssignState();
}

class _ConfirmAssignState extends State<ConfirmAssign> {
  String? selectedEmployeeId;
  List<Map<String, dynamic>> employees = [];

  @override
  void initState() {
    super.initState();
    // Call method to fetch employees for the shop
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    // Fetch employees for the shop from Firestore
    BookingService bookingService = BookingService();
    List<Map<String, dynamic>> employeeList =
    await bookingService.getEmployeesForShop(widget.uid);

    // Set state to update dropdown menu
    setState(() {
      employees = employeeList;
    });
  }
  // UI code...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Booking'),
      ),
      body: Column(
        children: [
          // Other UI elements...

          // Dropdown menu to select employee
          DropdownButtonFormField<String>(
            value: selectedEmployeeId,
            onChanged: (value) {
              setState(() {
                selectedEmployeeId = value;
              });
            },
            items: employees
                .map<DropdownMenuItem<String>>((employee) {
              return DropdownMenuItem<String>(
                value: employee['id'] as String,
                child: Text(employee['name'] as String),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: 'Select Employee',
            ),
          ),

          // Button to confirm booking and assign employee
          ElevatedButton(
            onPressed: () async {
              if (selectedEmployeeId != null) {
                try {
                  // Call method to confirm booking and assign employee
                  await BookingService().confirmBooking(
                     widget.booking!.id, selectedEmployeeId!);
                  // Handle success
                } catch (e) {
                  // Handle error
                }
              }
            },
            child: Text('Confirm Booking'),
          ),
        ],
      ),
    );
  }
}
