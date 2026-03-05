import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/tracking_stage.dart';
import '../../domain/entities/ayush_license.dart';

class FirestoreProductDatasource {
  final FirebaseFirestore _firestore;

  FirestoreProductDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<Product> getProductById(String id) async {
    final doc = await _firestore.collection('products').doc(id).get();

    if (!doc.exists) {
      throw Exception('Product not found');
    }

    final data = doc.data()!;
    return _mapProduct(doc.id, data);
  }

  Product _mapProduct(String id, Map<String, dynamic> data) {
    final stagesData = data['trackingStages'] as List<dynamic>? ?? [];
    final licenseData = data['ayushLicense'] as Map<String, dynamic>? ?? {};

    return Product(
      id: id,
      orderId: data['orderId'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      expiryDate: data['expiryDate'] ?? '',
      aiAnalytics: data['aiAnalytics'] ?? '',
      ayushLicense: AyushLicense(
        licenseNumber: licenseData['licenseNumber'] ?? '',
        companyName: licenseData['companyName'] ?? '',
        externalUrl: licenseData['externalUrl'] ?? '',
        isVerified: licenseData['isVerified'] ?? false,
      ),
      trackingStages: stagesData.map((stage) {
        final s = stage as Map<String, dynamic>;
        return TrackingStage(
          stageName: s['stageName'] ?? '',
          dateRange: s['dateRange'] ?? '',
          description: s['description'] ?? '',
          dataSource: s['dataSource'] ?? '',
        );
      }).toList(),
    );
  }
}
