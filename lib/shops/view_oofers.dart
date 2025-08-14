
import 'package:flutter/material.dart';
import 'package:quickassitnew/constans/colors.dart';
import 'package:quickassitnew/models/offer_model.dart';
import 'package:quickassitnew/services/offer_service.dart';
import 'package:quickassitnew/shops/offer_details.dart';
import 'package:quickassitnew/widgets/apptext.dart';

class OfferListScreen extends StatefulWidget {
  @override
  _OfferListScreenState createState() => _OfferListScreenState();
}

class _OfferListScreenState extends State<OfferListScreen> {
  final OfferService _offerService = OfferService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(data:'Offer List',size: 16,color: Colors.white,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: _offerService.getOffers(),
          builder: (context, AsyncSnapshot<List<Offer>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<Offer>? offers = snapshot.data;

              return ListView.builder(
                itemCount: offers!.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: AppColors.contColor2,
                    child: ListTile(
                      trailing: IconButton(onPressed: (){
                        _offerService.deleteOffer(offers[index].id.toString());
                        setState(() {

                        });
                      } , icon: Icon(Icons.delete),),
                      title: Text(offers[index].title.toString()),
                      subtitle: Text('Price: \$${offers[index].price.toString()}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OfferDetailScreen(offers[index]),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),

    );
  }
}