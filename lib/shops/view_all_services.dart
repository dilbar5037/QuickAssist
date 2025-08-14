import 'package:flutter/material.dart';
import 'package:quickassitnew/models/shopService_model.dart';
import 'package:quickassitnew/services/shopService_service.dart';
import 'package:quickassitnew/widgets/apptext.dart';

class ServiceListScreen extends StatefulWidget {
  final String?uid;
  ServiceListScreen({this.uid});
  @override
  _ServiceListScreenState createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  final ShopServiceService _serviceService = ShopServiceService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service List',style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: FutureBuilder(  
          future: _serviceService.getServices(widget.uid.toString()),
          builder: (context, AsyncSnapshot<List<Service>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

           else if(snapshot.data!.length==0){
              return Center(child: AppText(data: "No Serrvices Added",color: Colors.black,));
            }
            else {
              List<Service>? services = snapshot.data;
        
              return ListView.builder(
                itemCount: services!.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(services[index].title.toString()),
                      subtitle: Text('Type: ${services[index].type}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServiceDetailScreen(services[index]),
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

class ServiceDetailScreen extends StatelessWidget {
  final Service service;

  ServiceDetailScreen(this.service);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${service.title}'),
            Text('Description: ${service.description}'),
            Text('Type: ${service.type}'),
            Text('Price: \$${service.price.toString()}'),
            Text('Offer: ${service.offer != null ? service.offer : 'No offer'}'),
            Text('Status: ${service.status}'),
            Text('Shop ID: ${service.shopId}'),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditServiceScreen(service),
                ),
              );
            },
            child: Icon(Icons.edit),
          ),
          SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () async {
              await ShopServiceService().deleteService(service.id.toString());
              Navigator.pop(context);
            },
            child: Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}

class EditServiceScreen extends StatelessWidget {
  final Service service;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController offerController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController shopIdController = TextEditingController();

  final ShopServiceService _serviceService = ShopServiceService();

  EditServiceScreen(this.service) {
    titleController.text = service.title!;
    descriptionController.text = service.description!;
    typeController.text = service.type!;
    priceController.text = service.price.toString();
    offerController.text = service.offer.toString();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Service'),
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
              controller: typeController,
              decoration: InputDecoration(labelText: 'Type'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: offerController,
              decoration: InputDecoration(labelText: 'Offer'),
            ),


            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                Service updatedService = Service(
                  id: service.id,
                  title: titleController.text,
                  description: descriptionController.text,
                  type: typeController.text,
                  price: double.parse(priceController.text),
                  offer: int.parse(offerController.text),

                  shopId: shopIdController.text,
                );

                await _serviceService.updateService(updatedService);

                Navigator.pop(context);
              },
              child: Text('Update Service'),
            ),
          ],
        ),
      ),
    );
  }
}