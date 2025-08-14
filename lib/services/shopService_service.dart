import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickassitnew/models/shopService_model.dart';

class ShopServiceService {
  final CollectionReference _servicesCollection =
  FirebaseFirestore.instance.collection('services');

  Future<void> addService(Service service) async {
    await _servicesCollection.add(service.toMap());
  }

  Future<List<Service>> getServices(String id) async {
    final QuerySnapshot snapshot = await _servicesCollection.where('shopid',isEqualTo: id).get();

    return snapshot.docs.map((doc) => Service.fromSnapshot(doc)).toList();
  }

  Future<Service> getServiceById(String serviceId) async {
    final DocumentSnapshot doc =
    await _servicesCollection.doc(serviceId).get();

    return Service.fromSnapshot(doc);
  }

  Future<void> updateService(Service service) async {
    await _servicesCollection.doc(service.id).update(service.toMap());
  }

  Future<void> deleteService(String serviceId) async {
    await _servicesCollection.doc(serviceId).delete();
  }


  Future<List<Service>> getServicesByType(String serviceType) async {
    final QuerySnapshot snapshot = await _servicesCollection
        .where('type', isEqualTo: serviceType)
        .get();

    return snapshot.docs.map((doc) => Service.fromSnapshot(doc)).toList();
  }
}