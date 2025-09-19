import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:quickassitnew/constans/text.dart';
import 'package:quickassitnew/services/booking_service.dart';
import 'package:quickassitnew/services/location_provider.dart';

import 'package:quickassitnew/user/all_notifications.dart';
import 'package:quickassitnew/user/edit_profile.dart';
import 'package:quickassitnew/user/service_by_type.dart';
import 'package:quickassitnew/widgets/appbutton.dart';

import 'package:quickassitnew/user/servicetype_list_page.dart';
import 'package:quickassitnew/user/mybookings.dart';

import 'package:quickassitnew/widgets/apptext.dart';
import 'package:quickassitnew/widgets/customcontainer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:svg_flutter/svg.dart';
import 'package:uuid/uuid.dart';

import '../../constans/colors.dart';

class Homepage extends StatefulWidget {
  const Homepage({
    super.key,
  });

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String? _type;
  String? uid;
  String? name;
  String? email;
  String? phone;
  String? img;
  String? profileLocation;

  getData() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _type = await _pref.getString('type');
    email = await _pref.getString('email');
    name = await _pref.getString('name');
    phone = await _pref.getString('phone');
    uid = await _pref.getString('uid');
    img = await _pref.getString('imgurl');
    profileLocation = await _pref.getString('location');

    setState(() {});
  }

  var locationCity;
  @override
  void initState() {
    getData();

    Provider.of<LocationProvider>(context, listen: false).determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    final themedata = Theme.of(context);

    return Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
      if (profileLocation != null &&
          profileLocation!.trim().isNotEmpty &&
          profileLocation!.toLowerCase() != 'location') {
        locationCity = profileLocation;
      } else if (locationProvider.currentLocationName != null) {
        locationCity = locationProvider.currentLocationName!.locality;
      } else {
        locationCity = "Unknown Location";
      }
      return Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50,
                  child: Consumer<LocationProvider>(
                      builder: (context, locationProvider, child) {
                    if (profileLocation != null &&
                        profileLocation!.trim().isNotEmpty &&
                        profileLocation!.toLowerCase() != 'location') {
                      locationCity = profileLocation;
                    } else if (locationProvider.currentLocationName != null) {
                      locationCity =
                          locationProvider.currentLocationName!.locality;
                    } else {
                      locationCity = "Unknown Location";
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_pin,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    locationCity,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
//                 InkWell(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => AllNotifications()),
//                     );
//                   },
//                   child: Icon(
//                     Icons.notification_important,
//                     color: Colors.orangeAccent,
//                     size: 30,
//                   ),
//                 ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      Text(
                        "Hi",
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "${name.toString()}",
                        style: TextStyle(fontSize: 26, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 220,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('offers')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.hasData) {
                      final offers = snapshot.data;
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: offers!.docs.length,
                          itemBuilder: (context, index) {
                            final offer = offers.docs[index];

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomContainer(
                                ontap: () async {},
                                height: 230,
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    color: AppColors.contColor1,
                                    borderRadius: BorderRadius.circular(15)),
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppText(
                                            data: "${offer['title']}",
                                            size: 22,
                                            color: Colors.white,
                                          ),
                                          AppText(
                                            data: "${offer['description']}",
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          AppButton(
                                              height: 40,
                                              width: 150,
                                              color: AppColors.btnPrimaryColor,
                                              onTap: () async {
                                                var bookingid = Uuid().v1();
                                                BookingService bookingService =
                                                    BookingService();

                                                // Replace the following line with your actual offer data retrieval method
                                                Map<String, dynamic> offerData =
                                                    {
                                                  'id': offer.id,
                                                  'title': offer['title'],
                                                  'price': offer['price'],
                                                  'shopid': offer['shopid'],
                                                  'bookingid': bookingid
                                                };

                                                // Show Date and Time Picker
                                                await _showDateTimePicker(
                                                    context);

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
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content: Text(
                                                                "Booking Already Exists for the selected date and Time")));
                                                  } else {
                                                    // Book Offer
                                                    await bookingService
                                                        .bookOffer(
                                                            uid!,
                                                            offerData,
                                                            selectedDateTime!)
                                                        .then((value) {
                                                      ScaffoldMessenger.of(
                                                              context)
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
                                    Expanded(
                                        child: SvgPicture.asset(
                                            'assets/svg/carwash.svg'))
                                  ],
                                ),
                              ),
                            );
                          });
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ),
            _buildCategorySection(
              context: context,
              title: "Select Vehicle Type",
              items: serviceType,
            ),
            _buildCategorySection(
              context: context,
              title: "Select Service Type",
              items: otherserviceType,
            ),
            const SizedBox(height: 16),
            _FeedbackPromptCard(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyBookings(),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 32,
            ),
          ],
        )),
      );
    });
  }

  Widget _buildCategorySection({
    required BuildContext context,
    required String title,
    required List<Map<String, dynamic>> items,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          title,
          style: theme.textTheme.displayMedium,
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.05,
          ),
          itemBuilder: (context, index) {
            final service = items[index];
            final titleText = service['title']?.toString() ?? '';
            final assetPath = service['img']?.toString() ?? '';

            return _ServiceCategoryCard(
              title: titleText,
              assetPath: assetPath,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShopList(
                      selectionData: titleText,
                      city: locationCity,
                      uid: uid,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
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

class _FeedbackPromptCard extends StatelessWidget {
  const _FeedbackPromptCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.contColor5,
              AppColors.btnPrimaryColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.white.withOpacity(0.18),
              child: const Icon(
                Icons.star_rounded,
                size: 30,
                color: Colors.amber,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Share your feedback',
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rate your recent services to help us improve recommendations.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceCategoryCard extends StatelessWidget {
  const _ServiceCategoryCard({
    required this.title,
    required this.assetPath,
    required this.onTap,
  });

  final String title;
  final String assetPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.displaySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        );

    return Card(
      color: AppColors.contColor2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: assetPath.isNotEmpty
                      ? SvgPicture.asset(
                          assetPath,
                          height: 80,
                          fit: BoxFit.contain,
                        )
                      : const SizedBox.shrink(),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: textStyle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
