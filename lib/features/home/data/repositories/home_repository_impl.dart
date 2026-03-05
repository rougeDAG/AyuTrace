import '../../domain/entities/product_summary.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/firestore_home_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final FirestoreHomeDatasource _datasource;

  HomeRepositoryImpl(this._datasource);

  @override
  Future<List<ProductSummary>> getProducts() {
    return _datasource.getProducts();
  }

  @override
  Future<List<ProductSummary>> searchProducts(String query) {
    return _datasource.searchProducts(query);
  }
}
