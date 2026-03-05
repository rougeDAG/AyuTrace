import 'package:equatable/equatable.dart';
import 'tracking_stage.dart';
import 'ayush_license.dart';

class Product extends Equatable {
  final String id;
  final String orderId;
  final String name;
  final String description;
  final String imageUrl;
  final String expiryDate;
  final AyushLicense ayushLicense;
  final List<TrackingStage> trackingStages;
  final String aiAnalytics;

  const Product({
    required this.id,
    required this.orderId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.expiryDate,
    required this.ayushLicense,
    required this.trackingStages,
    required this.aiAnalytics,
  });

  @override
  List<Object?> get props => [
    id,
    orderId,
    name,
    description,
    imageUrl,
    expiryDate,
    ayushLicense,
    trackingStages,
    aiAnalytics,
  ];
}
