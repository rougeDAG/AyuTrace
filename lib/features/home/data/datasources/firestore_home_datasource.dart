import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/product_summary.dart';

class FirestoreHomeDatasource {
  final FirebaseFirestore _firestore;

  FirestoreHomeDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<ProductSummary>> getProducts() async {
    // Force-update images to ensure local asset paths are in Firestore
    await forceUpdateImages();
    final snapshot = await _firestore.collection('products').get();

    if (snapshot.docs.isEmpty) {
      // Seed mock data on first run
      await _seedMockData();
      final seeded = await _firestore.collection('products').get();
      return seeded.docs.map(_mapDoc).toList();
    }

    return snapshot.docs.map(_mapDoc).toList();
  }

  Future<List<ProductSummary>> searchProducts(String query) async {
    final all = await getProducts();
    final q = query.toLowerCase();
    return all.where((p) => p.name.toLowerCase().contains(q)).toList();
  }

  ProductSummary _mapDoc(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductSummary(
      id: doc.id,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      lastUpdated:
          (data['lastUpdated'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Future<void> _seedMockData() async {
    final batch = _firestore.batch();
    final products = _getMockProducts();

    for (final product in products) {
      final ref = _firestore.collection('products').doc(product['id']);
      batch.set(ref, product);
    }

    await batch.commit();
  }

  Future<void> forceUpdateImages() async {
    final batch = _firestore.batch();
    final products = _getMockProducts();
    for (final p in products) {
      final ref = _firestore.collection('products').doc(p['id']);
      // We use set with merge: true to update or create
      batch.set(ref, {'imageUrl': p['imageUrl']}, SetOptions(merge: true));
    }
    await batch.commit();
  }

  List<Map<String, dynamic>> _getMockProducts() {
    return [
      {
        'id': 'ashwagandha_001',
        'name': 'Ashwagandha',
        'imageUrl': 'assets/images/ashwagandha.png',
        'lastUpdated': Timestamp.now(),
        'orderId': 'v5SRmop0thPzfKVK4Hux',
        'description': 'Organic Ashwagandha Root Powder, 90 Count Capsules',
        'expiryDate': 'August 2nd, 2027 - 2028',
        'aiAnalytics':
            'Ashwagandha root powder offers several health benefits, primarily due to its adaptogenic and rejuvenating properties. It is well-known for helping manage stress and anxiety by reducing cortisol levels, the body\'s primary stress hormone, thereby improving psychological well-being, sleep quality, and cognitive functions like memory and focus.',
        'ayushLicense': {
          'licenseNumber': 'AYU-2024-KA-00142',
          'companyName': 'Organic Ayurveda Pvt Ltd',
          'externalUrl': 'https://ayush.gov.in',
          'isVerified': true,
        },
        'trackingStages': [
          {
            'stageName': 'Harvesting & Curing',
            'dateRange': 'January 15 - March 31',
            'description': 'click for data input by farmers',
            'dataSource': 'farmers',
          },
          {
            'stageName': 'Drying & Grinding',
            'dateRange': 'March 31 - May 29',
            'description': 'click for data input from sensors',
            'dataSource': 'sensors',
          },
          {
            'stageName': 'Processing & Formulation',
            'dateRange': 'May 30 - July 15',
            'description': 'click for data input from sensors',
            'dataSource': 'sensors',
          },
          {
            'stageName': 'Pill Production & Bottling',
            'dateRange': 'July 15 - August 2',
            'description': 'click for data input from sensors',
            'dataSource': 'sensors',
          },
          {
            'stageName': 'Distribution',
            'dateRange': 'August 2nd onwards',
            'description': 'click for data input my distributor',
            'dataSource': 'distributor',
          },
        ],
      },
      {
        'id': 'tulsin_syrup_002',
        'name': 'Tulsin Syrup',
        'imageUrl': 'assets/images/tulsin.png',
        'lastUpdated': Timestamp.now(),
        'orderId': 'xK7TmwpQ2nRsLYM9Bvcd',
        'description': 'Herbal Tulsi Cough Syrup, 200ml Bottle',
        'expiryDate': 'December 15th, 2027 - 2028',
        'aiAnalytics':
            'Tulsi (Holy Basil) syrup is a powerful herbal remedy known for its respiratory benefits. It helps relieve cough, cold, and sore throat symptoms. Tulsi has antimicrobial, anti-inflammatory, and expectorant properties that support respiratory health and boost immunity.',
        'ayushLicense': {
          'licenseNumber': 'AYU-2024-MH-00287',
          'companyName': 'Vaidyaratnam Herbal',
          'externalUrl': 'https://ayush.gov.in',
          'isVerified': true,
        },
        'trackingStages': [
          {
            'stageName': 'Harvesting & Curing',
            'dateRange': 'February 1 - April 15',
            'description': 'click for data input by farmers',
            'dataSource': 'farmers',
          },
          {
            'stageName': 'Drying & Grinding',
            'dateRange': 'April 15 - June 10',
            'description': 'click for data input from sensors',
            'dataSource': 'sensors',
          },
          {
            'stageName': 'Processing & Formulation',
            'dateRange': 'June 10 - August 1',
            'description': 'click for data input from sensors',
            'dataSource': 'sensors',
          },
          {
            'stageName': 'Syrup Production & Bottling',
            'dateRange': 'August 1 - September 15',
            'description': 'click for data input from sensors',
            'dataSource': 'sensors',
          },
          {
            'stageName': 'Distribution',
            'dateRange': 'September 15th onwards',
            'description': 'click for data input my distributor',
            'dataSource': 'distributor',
          },
        ],
      },
      {
        'id': 'spaliv_syrup_003',
        'name': 'Spaliv Syrup',
        'imageUrl': 'assets/images/spaliv.jpeg',
        'lastUpdated': Timestamp.now(),
        'orderId': 'mN3QrwsT8kUzJXP5Gfhi',
        'description': 'Spaliv Liver Tonic Syrup, 200ml Bottle',
        'expiryDate': 'March 10th, 2028 - 2029',
        'aiAnalytics':
            'Spaliv Syrup is an Ayurvedic liver tonic that supports liver health and digestion. It contains herbs like Kalmegh, Bhringraj, and Kasni that help protect the liver from toxins, promote bile secretion, and improve appetite and digestion.',
        'ayushLicense': {
          'licenseNumber': 'AYU-2024-DL-00391',
          'companyName': 'Himalaya Ayurvedics',
          'externalUrl': 'https://ayush.gov.in',
          'isVerified': true,
        },
        'trackingStages': [
          {
            'stageName': 'Harvesting & Curing',
            'dateRange': 'March 1 - May 15',
            'description': 'click for data input by farmers',
            'dataSource': 'farmers',
          },
          {
            'stageName': 'Drying & Grinding',
            'dateRange': 'May 15 - July 20',
            'description': 'click for data input from sensors',
            'dataSource': 'sensors',
          },
          {
            'stageName': 'Processing & Formulation',
            'dateRange': 'July 20 - September 5',
            'description': 'click for data input from sensors',
            'dataSource': 'sensors',
          },
          {
            'stageName': 'Syrup Production & Bottling',
            'dateRange': 'September 5 - October 10',
            'description': 'click for data input from sensors',
            'dataSource': 'sensors',
          },
          {
            'stageName': 'Distribution',
            'dateRange': 'October 10th onwards',
            'description': 'click for data input my distributor',
            'dataSource': 'distributor',
          },
        ],
      },
      {
        'id': 'triphala_004',
        'name': 'Triphala Churna',
        'imageUrl': 'assets/images/triphala.jpeg',
        'lastUpdated': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 1)),
        ),
        'orderId': 'pR4TswuV9lWyKZQ6Hjkm',
        'description': 'Organic Triphala Powder, 200g Pack',
        'expiryDate': 'June 5th, 2028 - 2029',
        'aiAnalytics':
            'Triphala is a traditional Ayurvedic formulation made from three fruits: Amalaki, Bibhitaki, and Haritaki. It supports digestive health, detoxification, and immune function. Known for its gentle laxative effect and rich antioxidant content.',
        'ayushLicense': {
          'licenseNumber': 'AYU-2024-UP-00456',
          'companyName': 'Patanjali Ayurved',
          'externalUrl': 'https://ayush.gov.in',
          'isVerified': true,
        },
        'trackingStages': [
          {
            'stageName': 'Harvesting & Curing',
            'dateRange': 'November 1 - January 15',
            'description': 'click for data input by farmers',
            'dataSource': 'farmers',
          },
          {
            'stageName': 'Drying & Grinding',
            'dateRange': 'January 15 - March 10',
            'description': 'click for data input from sensors',
            'dataSource': 'sensors',
          },
          {
            'stageName': 'Processing & Formulation',
            'dateRange': 'March 10 - April 25',
            'description': 'click for data input from sensors',
            'dataSource': 'sensors',
          },
          {
            'stageName': 'Packaging',
            'dateRange': 'April 25 - May 15',
            'description': 'click for data input from sensors',
            'dataSource': 'sensors',
          },
          {
            'stageName': 'Distribution',
            'dateRange': 'May 15th onwards',
            'description': 'click for data input my distributor',
            'dataSource': 'distributor',
          },
        ],
      },
      {
        'id': 'brahmi_005',
        'name': 'Brahmi Vati',
        'imageUrl': 'assets/images/brahmi.png',
        'lastUpdated': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 1)),
        ),
        'orderId': 'qS5UtwvW0mXzLAR7Iklp',
        'description': 'Brahmi Brain Tonic Tablets, 60 Count',
        'expiryDate': 'September 20th, 2027 - 2028',
        'aiAnalytics':
            'Brahmi (Bacopa monnieri) is one of the most well-known nootropic herbs in Ayurveda. It enhances memory, concentration, and learning ability. It also has anxiolytic properties and supports overall neural health.',
        'ayushLicense': {
          'licenseNumber': 'AYU-2024-RJ-00523',
          'companyName': 'Dabur Ayurvedic',
          'externalUrl': 'https://ayush.gov.in',
          'isVerified': true,
        },
        'trackingStages': [
          {
            'stageName': 'Harvesting & Curing',
            'dateRange': 'April 1 - June 15',
            'description': 'click for data input by farmers',
            'dataSource': 'farmers',
          },
          {
            'stageName': 'Drying & Grinding',
            'dateRange': 'June 15 - August 10',
            'description': 'click for data input from sensors',
            'dataSource': 'sensors',
          },
          {
            'stageName': 'Processing & Formulation',
            'dateRange': 'August 10 - September 25',
            'description': 'click for data input from sensors',
            'dataSource': 'sensors',
          },
          {
            'stageName': 'Tablet Pressing & Packaging',
            'dateRange': 'September 25 - October 20',
            'description': 'click for data input from sensors',
            'dataSource': 'sensors',
          },
          {
            'stageName': 'Distribution',
            'dateRange': 'October 20th onwards',
            'description': 'click for data input my distributor',
            'dataSource': 'distributor',
          },
        ],
      },
      {
        'id': 'chyawanprash_006',
        'name': 'Chyawanprash',
        'imageUrl': 'assets/images/chyawanprash.jpeg',
        'lastUpdated': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 2)),
        ),
        'orderId': 'rT6VuxwX1nYaMAB8Jlnq',
        'description': 'Traditional Chyawanprash, 500g Jar',
        'expiryDate': 'November 1st, 2027 - 2028',
        'aiAnalytics':
            'Chyawanprash is a time-tested Ayurvedic health supplement made with Amla as the base ingredient, combined with over 40 herbs and spices. It boosts immunity, improves digestion, and enhances vitality. Regular consumption supports respiratory health and overall well-being.',
        'ayushLicense': {
          'licenseNumber': 'AYU-2024-GJ-00678',
          'companyName': 'Zandu Ayurveda',
          'externalUrl': 'https://ayush.gov.in',
          'isVerified': true,
        },
        'trackingStages': [
          {
            'stageName': 'Harvesting & Curing',
            'dateRange': 'December 1 - February 28',
            'description': 'click for data input by farmers',
            'dataSource': 'farmers',
          },
          {
            'stageName': 'Drying & Grinding',
            'dateRange': 'March 1 - April 30',
            'description': 'click for data input from sensors',
            'dataSource': 'sensors',
          },
          {
            'stageName': 'Processing & Formulation',
            'dateRange': 'May 1 - June 30',
            'description': 'click for data input from sensors',
            'dataSource': 'sensors',
          },
          {
            'stageName': 'Jar Filling & Packaging',
            'dateRange': 'July 1 - August 1',
            'description': 'click for data input from sensors',
            'dataSource': 'sensors',
          },
          {
            'stageName': 'Distribution',
            'dateRange': 'August 1st onwards',
            'description': 'click for data input my distributor',
            'dataSource': 'distributor',
          },
        ],
      },
    ];
  }
}
