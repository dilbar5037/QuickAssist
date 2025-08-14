import 'package:flutter/material.dart';
import 'package:quickassitnew/models/offer_model.dart';
import 'package:quickassitnew/services/offer_service.dart';
import 'package:quickassitnew/widgets/apptext.dart';
import 'package:quickassitnew/widgets/mydivider.dart';

class OfferDetailScreen extends StatelessWidget {
  final Offer offer;

  OfferDetailScreen(this.offer);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(data:'Offer Detail',color: Colors.white,size: 16,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(data:'Title: ${offer.title}'),
            MyDivider(),
            AppText(data:'Description: ${offer.description}'),
            MyDivider(),
            AppText(data:'Email: ${offer.email}'),
            MyDivider(),
            AppText(data:'Phone: ${offer.phone}'),
            MyDivider(),
            AppText(data:'Shop Name: ${offer.shopName}'),
            MyDivider(),
            AppText(data:'Status: ${offer.status}'),
            MyDivider(),
            AppText(data:'Price: \$${offer.price.toString()}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditOfferScreen(offer),
            ),
          );
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}



class EditOfferScreen extends StatelessWidget {
  final Offer offer;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final OfferService _offerService = OfferService();

  EditOfferScreen(this.offer) {
    titleController.text = offer.title!;
    descriptionController.text = offer.description!;
    emailController.text = offer.email!;
    phoneController.text = offer.phone!;
    shopNameController.text = offer.shopName!;

    priceController.text = offer.price.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(data:'Edit Offer',size: 16,color: Colors.white,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            TextField(
              controller: shopNameController,
              decoration: InputDecoration(labelText: 'Shop Name'),
            ),
           
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                Offer updatedOffer = Offer(
                  id: offer.id,
                  title: titleController.text,
                  description: descriptionController.text,
                  email: emailController.text,
                  phone: phoneController.text,
                  shopName: shopNameController.text,
                  price: double.parse(priceController.text),
                );

                await _offerService.updateOffer(updatedOffer);

                Navigator.pop(context);
              },
              child: Text('Update Offer'),
            ),
          ],
        ),
      ),
    );
  }
}