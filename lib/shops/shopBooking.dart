
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickassitnew/constans/colors.dart';
import 'package:quickassitnew/shops/confirm_assign_age.dart';
import 'package:quickassitnew/widgets/apptext.dart';
import 'package:quickassitnew/services/booking_service.dart';

class ShopBookings extends StatefulWidget {
  final String? uid;
  const ShopBookings({Key? key,this.uid}) : super(key: key);

  @override
  _ShopBookingsState createState() => _ShopBookingsState();
}

class _ShopBookingsState extends State<ShopBookings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(data:'Shop Bookings',color: Colors.white,),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('bookings').where('shopid',isEqualTo: widget.uid.toString()).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if(snapshot.hasData && snapshot.data!.docs!.length==0){
              return Center(child: AppText(data: "No Bookings Found",color: Colors.black,));
            }
        
            if (snapshot.hasData) {
              final bookings = snapshot.data!.docs;
              return ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  return Card(
                    color:booking['status']=='Pending'?Colors.blueGrey
                    :AppColors.appBarColor,
                    child: ListTile(
                      title: AppText(data:'Id: ${booking['offerId']}',color: Colors.white,size: 16,),
                      subtitle:AppText(data:'Status: ${booking['status']}',color: Colors.white,size: 14,),
                      // Add more details as needed
                      trailing: booking['status'] == 'Pending'
                          ? IconButton(
                        onPressed: () async {
                          // Confirm Booking
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ConfirmAssign(booking: booking,uid: widget.uid,)));
                          // Add additional logic if needed
                        },
                        icon: Icon(Icons.check),
                      )
                          : Icon(Icons.check, color: Colors.green),
                    ),
                  );
                },
              );
            }
        
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}