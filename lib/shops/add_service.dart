import 'package:flutter/material.dart';
import 'package:quickassitnew/models/shopService_model.dart';
import 'package:quickassitnew/services/shopService_service.dart';
import 'package:quickassitnew/widgets/apptext.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddServiceScreen extends StatefulWidget {
  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController typeController = TextEditingController();

  final TextEditingController priceController = TextEditingController();

  final TextEditingController offerController = TextEditingController();

  final TextEditingController statusController = TextEditingController();

  final TextEditingController shopIdController = TextEditingController();

  final ShopServiceService _serviceService = ShopServiceService();
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
  String?_servicetype;
  @override
  void initState() {
    getData();
    super.initState();
  }
  final _key=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(data:'Add Service',color: Colors.white,size: 16,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            SizedBox(height: 16,),

              DropdownMenu(
                 hintText: "Select Service Type",
                  width: 275,

                  controller: typeController,
                  enableSearch: true,

                  enableFilter: true,
                  requestFocusOnTap: true,
                  onSelected: (String ?country){
                    if(country!=null){
                      setState(() {
                        _servicetype=country;
                      });
                    }
                  },
                  dropdownMenuEntries: ["Cars","Motor Bikes","Heavy Vehicles","Towing","Washing","Accident","Fuel"]
                      .map((country) =>
                      DropdownMenuEntry(value: country, label: country))
                      .toList()),

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
              TextFormField(
                validator: (value){
                  if(value!.isEmpty){
                    return "Offer is Mandatory";
                  }
                },
                controller: offerController,
                decoration: InputDecoration(labelText: 'Offer'),
              ),


              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                 if(_key.currentState!.validate()){
                   Service newService = Service(
                     title: titleController.text,
                     description: descriptionController.text,
                     type: typeController.text,
                     price: double.parse(priceController.text),
                     offer: int.parse(offerController.text),
                     status: 1,
                     shopId: uid,
                     shopPhone: phone,
                     shopLocation: location,
                     shopEmail: email
                   );

                   await _serviceService.addService(newService);

                   Navigator.pop(context);
                 }
                },
                child: Text('Add Service'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}