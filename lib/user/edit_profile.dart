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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final _key = GlobalKey<FormState>();

  String? _type;
  String? uid;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? location;
  String? img;

  getData() async {
    final _pref = await SharedPreferences.getInstance();
    _type = _pref.getString('type');
    email = _pref.getString('email');
    name = _pref.getString('name');
    phone = _pref.getString('phone');
    uid = _pref.getString('uid');
    img = _pref.getString('imgurl');
    address = _pref.getString('address');
    location = _pref.getString('location');

    if (phone != null) _phoneController.text = phone!;
    if (name != null) _nameController.text = name!;
    if (location != null) _locationController.text = location!;
    if (address != null) _addressController.text = address!;
    setState(() {});
  }

  var locationCity;
  String? filename;
  XFile? image;
  String? url;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themedata = Theme.of(context);

    ImageProvider<Object> _buildProfileImageProvider() {
      if (img == null || img!.isEmpty) {
        return const AssetImage('assets/img/profile.png');
      }
      final uri = Uri.tryParse(img!);
      final isRemote = uri != null && uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
      if (isRemote) {
        return NetworkImage(img!);
      }
      return const AssetImage('assets/img/profile.png');
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldColor,
        title: Text('Edit Profile', style: themedata.textTheme.displaySmall),
      ),
      body: Container(
        height: double.infinity,
        padding: const EdgeInsets.all(20),
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
                          image: _buildProfileImageProvider(),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const Text('Name'),
                CustomTextFormField(
                  controller: _nameController,
                  hintText: 'Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter a valid name';
                    return null;
                  },
                ),
                const Text('Phone'),
                CustomTextFormField(
                  controller: _phoneController,
                  hintText: 'Phone',
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter a valid name';
                    return null;
                  },
                ),
                const Text('Location'),
                CustomTextFormField(
                  controller: _locationController,
                  hintText: 'Location',
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter a valid Location';
                    return null;
                  },
                ),
                const Text('Address'),
                CustomTextFormField(
                  controller: _addressController,
                  hintText: 'Address',
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter  valid Address';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      showimagepicker();
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                      child: image != null
                          ? Image.file(File(image!.path))
                          : const Icon(Icons.camera_alt, size: 20, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AppButton(
                  onTap: () async {
                    if (!(_key.currentState?.validate() ?? false)) return;

                    String? newUrl;
                    if (image != null) {
                      final fileName = filename ?? 'profile_${uid ?? 'user'}_${DateTime.now().millisecondsSinceEpoch}.jpg';
                      final ref = FirebaseStorage.instance.ref().child('profile/$fileName');
                      final utask = ref.putFile(File(image!.path));
                      await utask;
                      newUrl = await ref.getDownloadURL();
                    }

                    await FirebaseFirestore.instance.collection('users').doc(uid).update({
                      'imgurl': newUrl ?? img,
                      'status': 1,
                      'location': _locationController.text,
                      'address': _addressController.text,
                      'phone': _phoneController.text,
                      'name': _nameController.text,
                    });

                    final _pref = await SharedPreferences.getInstance();
                    _pref.setString('name', _nameController.text);
                    _pref.setString('phone', _phoneController.text);
                    _pref.setString('address', _addressController.text);
                    _pref.setString('location', _locationController.text);
                    if (newUrl != null) {
                      _pref.setString('imgurl', newUrl);
                      img = newUrl;
                    }

                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Updated')));
                    Navigator.pop(context);
                  },
                  child: const Text('Update', style: TextStyle(color: Colors.white)),
                  height: 52,
                  color: AppColors.contColor5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  imageFromgallery() async {
    final XFile? _image = await _picker.pickImage(source: ImageSource.gallery);
    if (_image != null) {
      setState(() {
        image = _image;
        filename = 'gallery_${uid ?? 'user'}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      });
    }
  }

  imageFromcamera() async {
    final XFile? _image = await _picker.pickImage(source: ImageSource.camera);
    if (_image != null) {
      setState(() {
        image = _image;
        filename = 'camera_${uid ?? 'user'}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      });
    }
  }

  showimagepicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                child: const Row(
                  children: [
                    Text('Gallery'),
                    Icon(Icons.photo),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  imageFromgallery();
                },
              ),
              const SizedBox(width: 20),
              InkWell(
                child: const Row(
                  children: [
                    Text('Camera'),
                    Icon(Icons.camera),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  imageFromcamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

