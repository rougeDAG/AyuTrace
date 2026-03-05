import '../entities/product.dart';

abstract class ProductRepository {
  Future<Product> getProductById(String id);
}
