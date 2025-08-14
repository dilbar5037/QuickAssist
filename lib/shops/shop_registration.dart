import 'package:flutter/material.dart';
import 'package:quickassitnew/constans/colors.dart';
import 'package:quickassitnew/models/shop_model.dart';
import 'package:quickassitnew/services/shop_service.dart';
import 'package:quickassitnew/widgets/appbutton.dart';
import 'package:quickassitnew/widgets/apptext.dart';
import 'package:quickassitnew/widgets/validator.dart';
import 'package:uuid/uuid.dart';
// Replace with the actual path

class ShopRegistrationScreen extends StatefulWidget {
  @override
  _ShopRegistrationScreenState createState() => _ShopRegistrationScreenState();
}

class _ShopRegistrationScreenState extends State<ShopRegistrationScreen> {
  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController serviceTypeController = TextEditingController();
  final TextEditingController licenseNoController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController accountInfoController = TextEditingController();
  final TextEditingController gstController = TextEditingController();
  final TextEditingController imgController = TextEditingController();

  final ShopService _shopService = ShopService();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(data:'Shop Registration',color: Colors.white,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: shopNameController,
                decoration: InputDecoration(labelText: 'Shop Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the shop name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return Validate.emailValidator(value!);
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {

                    return Validate.pwdvalidator(value!);

                },
              ),
              TextFormField(
                controller: serviceTypeController,
                decoration: InputDecoration(labelText: 'Service Type. comma separated'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the service type';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: licenseNoController,
                decoration: InputDecoration(labelText: 'License No'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the license number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                return  Validate.phnvalidator(value!);

                },
              ),
              TextFormField(
                controller: accountInfoController,
                decoration: InputDecoration(labelText: 'Account Info'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the account information';
                  }
                  return null;
                },
              ),


              SizedBox(height: 16),
             AppButton(
               height: 45,
              color: AppColors.btnPrimaryColor,
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  var id=Uuid().v1();
                  Shop newShop = Shop(
                    id: id,
                    shopId: id,
                    shopName: shopNameController.text,
                    location: locationController.text,
                    address: addressController.text,
                    email: emailController.text,
                    password: passwordController.text,
                    serviceType: serviceTypeController.text.split(','),
                    licenseNo: licenseNoController.text,
                    phone: phoneController.text,
                    accountInfo: accountInfoController.text,
                    img: imgController.text,
                    gst: ""
                  );

                  await _shopService.addShop(newShop,);

                  // You can navigate to the shop list or any other screen after registration
                  Navigator.pop(context);
                }

                },
                child: AppText(data:'Register Shop',color: Colors.white,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

