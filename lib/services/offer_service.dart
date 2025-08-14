import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickassitnew/models/offer_model.dart';

class OfferService {
  final CollectionReference _offersCollection =
  FirebaseFirestore.instance.collection('offers');

  Future<void> addOffer(Offer offer) async {
    await _offersCollection.add(offer.toMap());
  }

  Future<List<Offer>> getOffers() async {
    final QuerySnapshot snapshot = await _offersCollection.get();

    return snapshot.docs.map((doc) => Offer.fromSnapshot(doc)).toList();
  }

  Future<Offer> getOfferById(String offerId) async {
    final DocumentSnapshot doc =
    await _offersCollection.doc(offerId).get();

    return Offer.fromSnapshot(doc);
  }

  Future<void> updateOffer(Offer offer) async {
    await _offersCollection.doc(offer.id).update(offer.toMap());
  }

  Future<void> deleteOffer(String offerId) async {
    await _offersCollection.doc(offerId).delete();
  }
}
