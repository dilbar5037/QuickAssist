import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quickassitnew/admin/notification/services/notificationservice.dart';
import 'package:quickassitnew/constans/colors.dart';
import 'package:quickassitnew/widgets/apptext.dart';
import 'package:quickassitnew/widgets/nodata_widget.dart';


class AllNotifications extends StatefulWidget {
  const AllNotifications({super.key});

  @override
  State<AllNotifications> createState() => _AllNotificationsState();
}

class _AllNotificationsState extends State<AllNotifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,

      appBar: AppBar(
        elevation: 0.0,
        title: AppText(data: "All Notfications",color: Colors.white,size: 16,),


      ),
      body: Container(height: double.infinity,width: double.infinity,

      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          AppText(data: "Latest Notifications",size: 18,color: Colors.white,),
          SizedBox(height: 16,),
          Expanded(child: FutureBuilder(
            future: NotificationService().getAllNotification(),
            builder: (context,snapshot){

              if(snapshot.connectionState==ConnectionState.waiting){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if(snapshot.hasData && snapshot.data!.length==0){
                return NoDataWidget(errorMessage: "No Notification added");
              }

              if(snapshot.hasData){

                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context,index){

                      final notification=snapshot.data![index];

                  return Card(
                    elevation: 5.0,

                    color: AppColors.scaffoldColor.withBlue(85),
                    child: ListTile(
                      leading: FaIcon(FontAwesomeIcons.circle,color: Colors.orange,),
                      title: AppText(data: "${notification.title}",color: Colors.white,),
                      subtitle: AppText(data: "${notification.message}",color: Colors.white,),
                    ),
                  );
                });

              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ))
        ],
      ),
      ),
    );
  }
}
