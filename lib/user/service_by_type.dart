import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:quickassitnew/constans/colors.dart';
import 'package:quickassitnew/services/booking_service.dart';
import 'package:quickassitnew/user/service_detail_page.dart';
import 'package:quickassitnew/widgets/appbutton.dart';
import 'package:quickassitnew/widgets/apptext.dart';
import 'package:quickassitnew/widgets/customcontainer.dart';
import 'package:quickassitnew/widgets/mydivider.dart';
import 'package:quickassitnew/widgets/shimmer_effect.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:uuid/uuid.dart';

class ShopList extends StatefulWidget {
  final String? selectionData;
  final String? city;
  final String? uid;

  const ShopList({Key? key, this.selectionData, this.city, this.uid})
      : super(key: key);

  @override
  State<ShopList> createState() => _ShopListState();
}

class _ShopListState extends State<ShopList> {
  TextEditingController _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(widget.city);
    return Scaffold(
      backgroundColor: AppColors.contColor2,
      appBar: AppBar(
        backgroundColor: AppColors.contColor2,
        title: Text("${widget.selectionData ?? "Service"} Service Near You"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
                  child: Container(
                    child: TextField(
                      controller: _locationController,
                      onChanged: (value) {
                        // You can perform live search as the user types
                        // For simplicity, I'm updating the query when the user presses Enter
                      },
                      onSubmitted: (value) {
                        // Update Firestore query based on the entered location (value)
                        setState(() {
                          // You can update the Firestore query here
                          // For example, you can use 'value' to update the query
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Enter location",
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
              ),
              // Text("${widget.city}"),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('services')
                      .where('status', isEqualTo: 1)
                      .where('type', isEqualTo: widget.selectionData)
                      .where(
                    'shopLocation',
                    whereIn: [
                      _locationController.text.toLowerCase(),
                      widget.city?.toLowerCase()
                    ],
                  ).snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ShimmerList();
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Lottie.asset('assets/json/nohouse.json'),
                      );
                    }

                    if (snapshot.hasData && snapshot.data!.docs.length == 0) {
                      return Center(
                        child: Lottie.asset('assets/json/cat.json'),
                      );
                    }

                    if (snapshot.hasData) {
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final data = snapshot.data!.docs[index];
                          return Card(
                            elevation: 8.0,
                            child: CustomContainer(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              ontap: () {

                              },
                              width: 120,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      buildSvgPicture(widget.selectionData),
                                      Expanded(
                                          child: Text(
                                        "${data['title']}",
                                        textAlign: TextAlign.center,
                                      ))
                                    ],
                                  ),
                                  MyDivider(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  AppButton(onTap: (){

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ServiceDetailPage(
                                          serviceId: data.id,
                                          title: data['title'],
                                          price: data['price'].toString(),
                                          shopId: data['shopid'],
                                          shoplocation: data['shopLocation'],
                                          desc: data['desc'],
                                          uid: widget.uid!,

                                        ),),);
                                  }, child: AppText(data: "View Details",color: Colors.green,))

                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }

                    return Center(
                      child: Lottie.asset('assets/json/cat.json'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SvgPicture buildSvgPicture(String? type) {
    return SvgPicture.asset(
      type == "Cars"
          ? 'assets/svg/cardriver.svg'
          : type == "Motor Bikes"
              ? 'assets/svg/bikes.svg'
              : type == "Heavy Vehicles"
                  ? 'assets/svg/trucks.svg'
                  : type == "Towing"
                      ? 'assets/svg/towing.svg'
                      : type == "Accident"
                          ? 'assets/svg/carcrash.svg'
                          : type == "Fuel"
                              ? 'assets/svg/fuel.svg'
                              : 'assets/svg/bikes.svg',
      height: 80,
      width: 120,
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
