import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/firestore_product_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final FirestoreProductDatasource _datasource;

  ProductRepositoryImpl(this._datasource);

  @override
  Future<Product> getProductById(String id) {
    return _datasource.getProductById(id);
  }
}
