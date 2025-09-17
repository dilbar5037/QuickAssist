import 'package:cloud_firestore/cloud_firestore.dart';

class BackfillNormalizer {
  static Future<void> normalizeServices() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final services = await firestore.collection('services').get();
      
      // Check if collection exists and has documents
      if (services.docs.isEmpty) {
        print('No services found in collection');
        return;
      }
      
      for (final doc in services.docs) {
        final data = doc.data();
        String type = (data['type'] ?? '').toString();
        String shopLocation = (data['shopLocation'] ?? '').toString();

        // If shopLocation is missing or looks like a placeholder, fetch from shops
        if (shopLocation.isEmpty || shopLocation.trim().toLowerCase() == 'location') {
          final String shopId = (data['shopid'] ?? '').toString();
          if (shopId.isNotEmpty) {
            try {
              final shopSnap = await firestore.collection('shops').doc(shopId).get();
              if (shopSnap.exists && shopSnap.data() != null) {
                final shopData = shopSnap.data() as Map<String, dynamic>;
                final fetched = (shopData['location'] ?? '').toString();
                if (fetched.isNotEmpty) {
                  shopLocation = fetched;
                  await doc.reference.update({'shopLocation': shopLocation});
                }
              }
            } catch (e) {
              // ignore and continue
            }
          }
        }

        await doc.reference.update({
          'typeLower': type.trim().toLowerCase(),
          'shopLocationLower': shopLocation.trim().toLowerCase(),
        });
      }
      print('Successfully normalized ${services.docs.length} services');
    } catch (e) {
      print('Error normalizing services: $e');
      // Don't rethrow to prevent app crash
    }
  }
}


