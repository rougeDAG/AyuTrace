import '../entities/product_summary.dart';

abstract class HomeRepository {
  Future<List<ProductSummary>> getProducts();
  Future<List<ProductSummary>> searchProducts(String query);
}
