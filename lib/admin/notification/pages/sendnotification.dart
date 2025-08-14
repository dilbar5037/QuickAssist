
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickassitnew/admin/notification/models/notificationmodel.dart';
import 'package:quickassitnew/admin/notification/services/notificationservice.dart';
import 'package:quickassitnew/constans/colors.dart';
import 'package:quickassitnew/widgets/appbutton.dart';
import 'package:quickassitnew/widgets/apptext.dart';
import 'package:quickassitnew/widgets/customtextformfiled.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:uuid/uuid.dart';

import 'package:lottie/lottie.dart';


class SendNotification extends StatefulWidget {

  SendNotification({Key? key, }) : super(key: key);

  @override
  State<SendNotification> createState() => _SendNotificationState();
}

class _SendNotificationState extends State<SendNotification> {
  String? sender;
  getData() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    sender = await _pref.getString('name');
  }

  @override
  void initState() {
    getData();
    msgid = uuid.v1();
    super.initState();
  }

  // --------Text Editing Controllers..................................
  TextEditingController _titleController = TextEditingController();
  TextEditingController _messageController = TextEditingController();
  //..............End of  TextEditing Controllers......................

  //----------Form key........................
  final _messageKey = GlobalKey<FormState>();
  bool _isLoading = false;
  var msgid;
  NotificationModel _message = NotificationModel();

  var uuid = Uuid();

 NotificationService _notificationService=NotificationService();

  void _sendMessage() async {
    setState(() {
      _isLoading = true;
    });
    _message = NotificationModel(
        msgid: msgid,
        title: _titleController.text,
        message: _messageController.text,
        sender: sender,

        status: 1);

    try {
      setState(() {
        _isLoading = true;
      });
      await Future.delayed(Duration(seconds: 4));
      await _notificationService
          .sendNotification(_message)
          .then((value) => Navigator.pop(context));

      // Navigate to the next page after registration is complete
    } on FirebaseException catch (e) {
      setState(() {
        _isLoading = false;
      });

      List err = e.toString().split("]");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors.contColor3,
          duration: Duration(seconds: 3),
          content: Container(
              height: 85,
              child: Center(
                  child: Row(
                    children: [
                      CircleAvatar(
                          backgroundColor: Colors.amber,
                          child: Icon(
                            Icons.warning,
                            color: Colors.white,
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(child: Text(err[1].toString())),
                    ],
                  )))));
    }

    // Simulate registration delay
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(

        title: AppText(data: "Send Notification",color: Colors.white,)
      ),
      body: SafeArea(
        child: Container(
            decoration: const BoxDecoration(),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: _messageKey,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      height: size.height * 0.40,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomTextFormField(
                              controller: _titleController,
                              hintText: 'Enter a title',
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a Title';
                                }
                                return null;
                              },
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _titleController.clear();
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              maxlines: 5,
                              controller: _messageController,
                              hintText: 'Enter Message',
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter Message';
                                }
                                return null;
                              },
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _titleController.clear();
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: AppButton(
                                onTap: () {
                                  if (_messageKey.currentState!.validate()) {
                                    _sendMessage();
                                  }
                                },
                               child: AppText(data:"Send"),
                                height: 45,
                                width: 250,
                                color: AppColors.btnPrimaryColor,

                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                    visible: _isLoading,
                    child: Center(
                      child: Lottie.asset('assets/json/loading.json'),
                    ))
              ],
            )),
      ),
    );
  }
}
