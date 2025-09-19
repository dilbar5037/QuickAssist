// employee_add_screen.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quickassitnew/models/employee_model.dart';
import 'package:quickassitnew/services/employee_service.dart';
import 'package:quickassitnew/widgets/apptext.dart';
import 'package:url_launcher/url_launcher.dart';

class AddEmployeeScreen extends StatefulWidget {
  final String shopId;

  AddEmployeeScreen({required this.shopId});

  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController jobTypeController = TextEditingController();
  final TextEditingController adharNoController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController accountInfoController = TextEditingController();
  final TextEditingController imgController = TextEditingController();

  final EmployeeService _employeeService = EmployeeService();

  String? _servicetype = "";
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          data: 'Add Employee',
          color: Colors.white,
          size: 16,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name'),
                TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Name is Mandatory";
                      }
                    },
                    controller: nameController),
                SizedBox(height: 16.0),
                Text('Location'),
                TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Location is Mandatory";
                      }
                    },
                    controller: locationController),
                SizedBox(height: 16.0),
                Text('Address'),
                TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Location is Mandatory";
                      }
                    },
                    controller: addressController),
                SizedBox(height: 16.0),
                Text('Email'),
                TextFormField(
                    validator: (value) {
                      var pattern =
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                      RegExp regex = new RegExp(pattern);
                      if (!regex.hasMatch(value!)) {
                        return 'Email format is invalid';
                      } else {
                        return null;
                      }
                    },
                    controller: emailController),
                SizedBox(height: 16.0),
                Text('Password'),
                TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Password is Mandatory";
                      }
                    },
                    controller: passwordController),
                SizedBox(height: 16.0),
                DropdownMenu(
                    hintText: "Select Service Type",
                    width: 275,
                    controller: jobTypeController,
                    enableSearch: true,
                    enableFilter: true,
                    requestFocusOnTap: true,
                    onSelected: (String? country) {
                      if (country != null) {
                        setState(() {
                          _servicetype = country;
                        });
                      }
                    },
                    dropdownMenuEntries: [
                      "Cars",
                      "Motor Bikes",
                      "Heavy Vehicles",
                      "Towing",
                      "Washing",
                      "Accident",
                      "Fuel"
                    ]
                        .map((country) =>
                            DropdownMenuEntry(value: country, label: country))
                        .toList()),
                SizedBox(height: 16.0),
                Text('Adhar Number'),
                TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Adhar No is Mandatory";
                      }

                      if (value.length < 12) {
                        return "Enter a valid AdharID";
                      }
                    },
                    controller: adharNoController),
                SizedBox(height: 16.0),
                Text('Phone'),
                TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Phone is Mandatory";
                      }

                      if (value!.length < 10) {
                        return 'Mobile Number is invalid';
                      }
                    },
                    controller: phoneController),
                SizedBox(height: 16.0),
                Text('Account Info'),
                TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "A/c No is Mandatory";
                      }
                    },
                    controller: accountInfoController),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_key.currentState!.validate()) {
                      await _addEmployee();
                    }
                  },
                  child: const Text('Add Employee'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addEmployee() async {
    final newEmployee = Employee(
      name: nameController.text,
      shopId: widget.shopId,
      location: locationController.text,
      address: addressController.text,
      email: emailController.text,
      password: passwordController.text,
      jobType: jobTypeController.text,
      adharNo: adharNoController.text,
      phone: phoneController.text,
      accountInfo: accountInfoController.text,
      //img: imgController.text,
    );

    await _employeeService.addEmployee(newEmployee);

    await _openWhatsapp(
      context: context,
      text:
          'Hi Greetings From DriveX\nYour login credentials\nUsername: ${newEmployee.email}\nPassword: ${newEmployee.password}',
      number: '+91${newEmployee.phone}',
    );

    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> _openWhatsapp({
    required BuildContext context,
    required String text,
    required String number,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    final sanitizedNumber = number.replaceAll(RegExp(r'[^0-9+]'), '');
    final webNumber = sanitizedNumber.startsWith('+')
        ? sanitizedNumber.substring(1)
        : sanitizedNumber;
    final encodedText = Uri.encodeComponent(text);

    final androidUri =
        Uri.parse('whatsapp://send?phone=$sanitizedNumber&text=$encodedText');
    final universalUri =
        Uri.parse('https://wa.me/$webNumber?text=$encodedText');

    Future<void> showNotAvailable() async {
      messenger.showSnackBar(
        const SnackBar(content: Text('WhatsApp not available')),
      );
    }

    Future<bool> launchExternal(Uri uri) async {
      return launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }

    try {
      if (Platform.isAndroid) {
        if (await canLaunchUrl(androidUri) &&
            await launchExternal(androidUri)) {
          return;
        }
        if (await canLaunchUrl(universalUri) &&
            await launchExternal(universalUri)) {
          return;
        }
      } else {
        if (await canLaunchUrl(universalUri) &&
            await launchExternal(universalUri)) {
          return;
        }
        if (await canLaunchUrl(androidUri) &&
            await launchExternal(androidUri)) {
          return;
        }
      }
      await showNotAvailable();
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Unable to open WhatsApp: $e')),
      );
    }
  }
}
