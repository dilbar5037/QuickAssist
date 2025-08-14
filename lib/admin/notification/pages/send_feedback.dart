
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


import 'package:lottie/lottie.dart';
import 'package:quickassitnew/admin/notification/models/feedbackmodel.dart';
import 'package:quickassitnew/admin/notification/services/feedbackservice.dart';
import 'package:quickassitnew/constans/colors.dart';
import 'package:quickassitnew/widgets/appbutton.dart';
import 'package:quickassitnew/widgets/apptext.dart';
import 'package:quickassitnew/widgets/customcontainer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';



class AddFeedbackScreen extends StatefulWidget {
  @override
  _AddFeedbackScreenState createState() => _AddFeedbackScreenState();
}

class _AddFeedbackScreenState extends State<AddFeedbackScreen> {
  String? _name;
  String? _email;
  String? _phone;
  String? token;
  String? _location;
  var imggurl;





  Map<String, dynamic> data = {};
  String? _uid;
  getData() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    token = await _pref.getString('token');
    _name = await _pref.getString(
      'name',
    );

    _email = await _pref.getString(
      'email',
    );
    _phone = await _pref.getString(
      'phone',
    );
    _location = await _pref.getString(
      'location',
    );

    imggurl = await _pref.getString(
      'imgurl',
    );
    print(imggurl);

    // if (imggurl == null) {
    //   setState(() {
    //     imggurl = "assets/image/profile.png";
    //   });
    // }

    _uid = await _pref.getString(
      'uid',
    );


    print(data);
    setState(() {

      data = {
        "name": _name,
        "email": _email,
        "phone": _phone,
        "uid": _uid,
        "img": imggurl,
        "location": _location
      };
    });
  }




  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _senderNameController = TextEditingController();
  final TextEditingController _senderPhoneController = TextEditingController();

  FeedbackService _feedbackService=FeedbackService();



  void _submitFeedback() async {
    // You can add Firebase Firestore logic here to save the feedback
   FeedbackModel _feedback=FeedbackModel(
     msgid: Uuid().v1(),
     title: _titleController.text,
     message: _messageController.text,
     senderid: _uid,
     sendername: _name,
     senderphone: _phone,
     reply: "",
     replystatus: 0,
     status: 1,
     date: DateTime.now(),

   );

   _feedbackService.sendFeedback(_feedback);

    // Reset the controllers after submitting
    _titleController.clear();
    _messageController.clear();
    _senderNameController.clear();
    _senderPhoneController.clear();

    // You can also show a success message or navigate to another screen
  }

  @override
  void initState() {
   getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.contColor2,
      appBar: AppBar(
        backgroundColor: AppColors.contColor2,
        title: Text("Write to us"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              style: TextStyle(color: Colors.white),
              controller: _titleController,
              decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.white),
                  hintText: 'Title'),
            ),
            SizedBox(height: 16.0),
            TextField(
              style: TextStyle(color: Colors.white),
              controller: _messageController,
              decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.white),
                  hintText: 'Message'),
              maxLines: 4,
            ),


            SizedBox(height: 16.0),
            AppButton(
              height: 45,
              width: 250,
              color: AppColors.contColor5,
              onTap:(){
                _submitFeedback();
                setState(() {

                });
              },
              child: Text('Submit Feedback',style: TextStyle(color: Colors.white),),
            ),
            Expanded(child:  FutureBuilder(
                future: _feedbackService.getFeedbackuser(_uid),
                builder: (context, snapshot) {

                  if(snapshot.hasData && snapshot.data!.length==0){

                    return Center(
                      child: AppText(data: "No feeedbacks yet",color: Colors.white70,),
                    );

                  }

                  if (snapshot.hasData) {
                    List<FeedbackModel> message=
                    snapshot.data as List<FeedbackModel>;

                    return ListView.builder(
                        itemCount: message.length,
                        itemBuilder: (context, index) {
                          var msg = message[index];
                          print(msg.title);
                          return Padding(
                            padding:
                            const EdgeInsets.only(right: 10, left: 10, top: 20),
                            child: CustomContainer(
                              ontap: () {},
                              height: 150,
                              width: 220,
                              decoration: BoxDecoration(
                                //color: AppColors().textColor2.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Stack(
                                children: [


                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          color: msg.replystatus==0?AppColors.contColor4:Colors.green,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10))),

                                      child: msg.replystatus==0?Center(child: AppText(data: "Reply Pending",color: Colors.white,)):
                                      Center(child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: AppText(data: "Reply: ${msg.reply}",color: Colors.white,),
                                      ))
                                      ,

                                    ),
                                  ),

                                  Positioned(
                                      top: 25,
                                      left: 20,
                                      right: 10,
                                      child: AppText(
                                        size: 16,
                                        fw: FontWeight.bold,
                                        data: "${msg.title}",
                                        color: Colors.white,
                                      )),
                                  Positioned(
                                      top: 48,
                                      left: 20,
                                      right: 10,
                                      child: AppText(
                                        data: "${msg.message}",
                                        color: Colors.white,
                                      )),

                                  Align(
                                      alignment: Alignment.topRight,
                                      child: msg.status == 1
                                          ? IconButton(
                                          onPressed: (){


                                            _feedbackService.deleteFeedback(msg.msgid);
                                            setState(() {

                                            });


                                          },
                                          icon: FaIcon(

                                            FontAwesomeIcons.trash,
                                            color: Colors.red,
                                            size: 20,
                                          ))
                                          : SizedBox()
                                  ),

                                ],
                              ),
                            ),
                          );
                        });
                  }

                  return Center(
                    child: Text("no data"),
                  );
                }),)
          ],
        ),
      ),
    );
  }
}


