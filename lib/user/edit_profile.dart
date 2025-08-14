import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:quickassitnew/constans/colors.dart';
import 'package:quickassitnew/widgets/appbutton.dart';
import 'package:quickassitnew/widgets/customtextformfiled.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Editprofilepage extends StatefulWidget {
  const Editprofilepage({super.key});

  @override
  State<Editprofilepage> createState() => _EditprofilepageState();
}

class _EditprofilepageState extends State<Editprofilepage> {
  TextEditingController _nameController=TextEditingController();
  TextEditingController _phoneController=TextEditingController();
  TextEditingController _locationController=TextEditingController();
  TextEditingController _addressController=TextEditingController();
  final _key=GlobalKey<FormState>();

  String? _type;

  String?uid;

  String?name;

  String?email;

  String?phone;
  String?address;
  String?location;
  String?img;

  getData() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _type = await _pref.getString('type');
    email= await _pref.getString('email');
    name = await _pref.getString('name');
    phone = await _pref.getString('phone');
    uid = await _pref.getString('uid');
    img = await _pref.getString('imgurl');
    address = await _pref.getString('address');
    location = await _pref.getString('location');

    _phoneController.text=phone!;
    _nameController.text=name!;

    if(location!=null){
      _locationController.text=location!;

    }
    if(address!=null){
      _addressController.text=address!;
    }
    setState(() {});
  }

  var locationCity;
  var filename;
  XFile? image;
  var url;
  final ImagePicker _picker=ImagePicker();

  @override
  void initState() {
    getData();







    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final themedata=Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldColor,
        title:  Text("Edit Profile",style: themedata.textTheme.displaySmall,),
      ),
      body: Container(
        height: double.infinity,
        padding: EdgeInsets.all(20),
        child: Form(
          key: _key,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Center(
                  child: SizedBox(
                    height: 240,
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: img != null
                              ? NetworkImage(img!)
                              : AssetImage('assets/img/profile.png') as ImageProvider<Object>,
                          fit: BoxFit.cover, // You can adjust the BoxFit as needed
                        ),
                      ),
                    ),
                  ),
                ),
                Text("Name"),
                CustomTextFormField(controller: _nameController, hintText: "Name",validator: (value){
                  if(value!.isEmpty){
                    return "Enter a valid name";
                  }
                },),
                Text("Phone"),
                CustomTextFormField(controller: _phoneController, hintText: "Phone",validator: (value){
                  if(value!.isEmpty){
                    return "Enter a valid name";
                  }
                }),
                Text("Location"),
                CustomTextFormField(controller: _locationController, hintText: "Location",validator: (value){
                  if(value!.isEmpty){
                    return "Enter a valid Location";
                  }
                }),
                Text("Address"),
                CustomTextFormField(controller: _addressController, hintText: "Address",validator: (value){
                  if(value!.isEmpty){
                    return "Enter  valid Address";
                  }
                }),
                SizedBox(height: 20,),



                Center(
                  child: GestureDetector(
                    onTap:(){
                      showimagepicker();

                    },
                    child: Container(
                        height:100,
                        width:100,
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            shape: BoxShape.circle
                        ),
                        child:image!=null? Image.file(File(image!.path)):
                        Container(

                          child: Icon(Icons.camera_alt,size:20,color:Colors.grey,),
                        )

                    ),
                  ),
                ),
                SizedBox(height: 20,),

                AppButton(onTap: (){


                  var ref=FirebaseStorage.instance.ref().child('profile/$filename');
                  UploadTask utask=ref.putFile(File(image!.path));
                  utask.then((res)async{
                    url=(await ref.getDownloadURL()).toString();
                  }).then((value){
                    FirebaseFirestore.instance.collection('users').doc(uid).update({

                      'imgurl': url??img,
                      'status': 1,
                      "location":_locationController.text,
                      "address":_addressController.text,
                      "phone":_phoneController.text,
                      "name":_nameController.text,




                    }).then((value) async{

                      SharedPreferences _pref=await SharedPreferences.getInstance();


                      _pref.setString('name', _nameController.text);
                      _pref.setString('phone', _phoneController.text);
                      _pref.setString('address', _addressController.text);
                      _pref.setString('location', _locationController.text);
                      _pref.setString('imgurl', url);






                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Updated")));
                      Navigator.pop(context);
                    });// common code for data saving,updating

                  } );



                }, child: Text("Update",style: TextStyle(color: Colors.white),),height: 52,color: AppColors.contColor5,)



              ],
            ),
          ),
        ),
      ),

    );
  }
  imageFromgallery()async{
    final XFile? _image = await _picker.pickImage(source: ImageSource.gallery);
    setState((){
      image=_image;
    }

    );

  }
  imageFromcamera()async{
    final XFile? _image = await _picker.pickImage(source: ImageSource.camera);
    setState((){
      image=_image;
    }

    );

  }
  showimagepicker(){
    showModalBottomSheet(context: context,
        builder: (context){
          return Container(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  child: Row(
                    children: [
                      Text("Gallery"),
                      Icon(Icons.photo),
                    ],
                  ),
                  onTap: (){
                    imageFromgallery();
                  },

                ),
                SizedBox(width: 20,),
                InkWell(
                  child:Row(
                    children: [
                      Text("Camera"),
                      Icon(Icons.camera),
                    ],
                  ),
                  onTap: (){
                    imageFromcamera();
                  },

                ),
              ],

            ),
          );
        }
    );
  }
}
