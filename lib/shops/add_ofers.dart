import 'package:flutter/material.dart';
import 'package:quickassitnew/constans/colors.dart';
import 'package:quickassitnew/models/offer_model.dart';
import 'package:quickassitnew/services/offer_service.dart';
import 'package:quickassitnew/widgets/apptext.dart';
import 'package:shared_preferences/shared_preferences.dart';



class AddOfferScreen extends StatefulWidget {
  @override
  State<AddOfferScreen> createState() => _AddOfferScreenState();
}

class _AddOfferScreenState extends State<AddOfferScreen> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController shopNameController = TextEditingController();

  final TextEditingController statusController = TextEditingController();

  final TextEditingController priceController = TextEditingController();

  final OfferService _offerService = OfferService();

  String? _type;

  String? uid;

  String? name;

  String? email;

  String? phone;

  String? img;

  String? address;

  String? location;

  String? account;

  String? gst;

  getData() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _type = await _pref.getString('type');
    email = await _pref.getString('email');
    name = await _pref.getString('name');
    phone = await _pref.getString('phone');
    uid = await _pref.getString('uid');
    img = await _pref.getString('imgurl');
    address = await _pref.getString('address');
    location = await _pref.getString('location');
    account = await _pref.getString('account');
    gst = await _pref.getString('gst');

    setState(() {});
  }

  final _key=GlobalKey<FormState>();

  @override
  void initState() {
   getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

 backgroundColor:Colors.white,
      appBar: AppBar(
        title: AppText(data:'Add Offer',color: Colors.white,size: 16,),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  validator: (value){
                    if(value!.isEmpty){
                      return "Title is Mandatory";
                    }
                  },
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                TextFormField(
                  validator: (value){
                    if(value!.isEmpty){
                      return "Description is Mandatory";
                    }
                  },
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),



                TextFormField(
                  validator: (value){
                    if(value!.isEmpty){
                      return "Price is Mandatory";
                    }
                  },
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                   if(_key.currentState!.validate()){
                     Offer newOffer = Offer(
                       title: titleController.text,
                       description: descriptionController.text,
                       email: email,
                       phone:phone,
                       shopName: name,
                       shopId: uid,
                       status: 1,
                       price: double.parse(priceController.text),
                     );

                     await _offerService.addOffer(newOffer);

                     Navigator.pop(context);
                   }
                  },
                  child: Text('Add Offer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}