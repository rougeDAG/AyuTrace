import 'package:equatable/equatable.dart';

class ProductSummary extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final DateTime lastUpdated;

  const ProductSummary({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [id, name, imageUrl, lastUpdated];
}
