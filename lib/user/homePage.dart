

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

import 'package:quickassitnew/widgets/apptext.dart';
import 'package:quickassitnew/widgets/customcontainer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:svg_flutter/svg.dart';
import 'package:uuid/uuid.dart';


import '../../constans/colors.dart';


class Homepage extends StatefulWidget {

  const Homepage({super.key,});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  String? _type;
  String?uid;
  String?name;
  String?email;
  String?phone;
  String?img;


  getData() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _type = await _pref.getString('type');
    email= await _pref.getString('email');
    name = await _pref.getString('name');
    phone = await _pref.getString('phone');
    uid = await _pref.getString('uid');
    img = await _pref.getString('imgurl');

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
    User? user=FirebaseAuth.instance.currentUser;
    final themedata=Theme.of(context);

    return Consumer<LocationProvider>(
        builder: (context, locationProvider, child){
          if (locationProvider.currentLocationName != null) {
            locationCity = locationProvider.currentLocationName!.locality;
            print(locationCity);
          } else {
            locationCity = "Unknown Location";
          }
          return Container(

            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
                child:Column(
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

                                if (locationProvider.currentLocationName != null) {
                                  locationCity = locationProvider.currentLocationName!.locality;
                                  print(locationCity);
                                } else {
                                  locationCity = "Unknown Location";
                                }

                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:MainAxisAlignment.start,
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
                        InkWell(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>AllNotifications()),
                            );

                          },
                          child: Icon(
                            Icons.notification_important,
                            color: Colors.orangeAccent,
                            size: 30,
                          ),
                        ),

                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Text("Hi",style: TextStyle(fontSize: 22,color: Colors.white),),
                              SizedBox(width: 8,),
                              Text("${name.toString()}",style: TextStyle(fontSize: 26,color: Colors.white),),
                            ],
                          ),
                        ),

                      ],
                    ),

                    SizedBox(height: 10,),


                    Container(
                      height: 220,
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('offers').snapshots(),
                          builder: (context,snapshot){
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            if(snapshot.hasData){

                              final offers=snapshot.data;
                              return ListView.builder(scrollDirection: Axis.horizontal,
                                  itemCount: offers!.docs.length,
                                  itemBuilder: (context,index){

                                    final offer=offers.docs[index];

                                    return  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CustomContainer(

                                        ontap: () async{

                                        },

                                        height: 230,
                                        padding: EdgeInsets.all(15),
                                        decoration: BoxDecoration(  color: AppColors.contColor1,

                                            borderRadius: BorderRadius.circular(15)),
                                        width: MediaQuery.of(context).size.width,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  AppText(data: "${offer['title']}",size: 22,color: Colors.white,),
                                                  AppText(data: "${offer['description']}",size: 16,color: Colors.white,)
                                                  ,SizedBox(height: 10,),
                                                  AppButton(
                                                      height: 40,
                                                      width: 150,
                                                      color: AppColors.btnPrimaryColor,
                                                      onTap: () async{
                                                        var bookingid=Uuid().v1();
                                                        BookingService bookingService = BookingService();

                                                        // Replace the following line with your actual offer data retrieval method
                                                        Map<String, dynamic> offerData = {'id': offer.id, 'title': offer['title'], 'price': offer['price'],'shopid':offer['shopid'],'bookingid':bookingid};

                                                        // Show Date and Time Picker
                                                        await _showDateTimePicker(context);

                                                        // Check if the user selected a date and time
                                                        if (selectedDateTime != null) {
                                                          // Check if a booking already exists for the selected date and time
                                                          bool bookingExists = await bookingService.checkBookingExists(offerData['id'], selectedDateTime!,);

                                                          if (bookingExists) {
                                                            // Display a message or take appropriate action
                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Booking Already Exists for the selected date and Time")));
                                                          } else {
                                                            // Book Offer
                                                            await bookingService.bookOffer(uid!, offerData, selectedDateTime!).then((value) {
                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Booking Done")));
                                                            });


                                                          }
                                                        }

                                                      }, child: AppText(data: "Book Now",color: Colors.white,))
                                                ],
                                              ),
                                            ),
                                            Expanded(child: SvgPicture.asset('assets/svg/carwash.svg'))
                                          ],

                                        ),
                                      ),
                                    );
                                  });
                            }
                            return Center(child: CircularProgressIndicator(),);
                          }),
                    ),

                    SizedBox(height: 10,),
                    Text(
                      "Select Vehicle Type",
                      style: themedata.textTheme.displayMedium,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                          itemCount: serviceType.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final service=serviceType[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: CustomContainer(
                                decoration: BoxDecoration(
                                    color: AppColors.contColor2,
                                    borderRadius: BorderRadius.circular(10)),
                                ontap: () {

                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ShopList(selectionData: service['title'],city:locationCity ,uid: uid,)));

                                  final Map<String,dynamic>data={

                                  "type":"${service['title']}",
                                  'location':locationCity,
                                  };

                                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewServicebyType(data: data,)));

                                },
                                height: 150,
                                width: 120,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      '${service['img']}',
                                      height: 80,
                                      width: 120,
                                    ),
                                    Text("${service['title']}",textAlign: TextAlign.center,)
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),


                    SizedBox(height: 10,),
                    Text(
                      "Select Service Type",
                      style: themedata.textTheme.displayMedium,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                          itemCount: otherserviceType.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final service=otherserviceType[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: CustomContainer(
                                decoration: BoxDecoration(
                                    color: AppColors.contColor2,
                                    borderRadius: BorderRadius.circular(10)),
                                ontap: () {

                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ShopList(selectionData: service['title'],city:locationCity ,uid: uid,)));



                                },
                                height: 150,
                                width: 120,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      '${service['img']}',
                                      height: 80,
                                      width: 120,
                                    ),
                                    Text("${service['title']}",textAlign: TextAlign.center,)
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                )
            ),
          );
        }
    );


  }
  DateTime? selectedDateTime;
  Future<void> _showDateTimePicker(BuildContext context) async {
    // 3. Show Date Picker
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)), // Set an appropriate end date
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