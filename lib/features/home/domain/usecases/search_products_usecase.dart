import '../entities/product_summary.dart';
import '../repositories/home_repository.dart';

class SearchProductsUseCase {
  final HomeRepository _repository;

  SearchProductsUseCase(this._repository);

  Future<List<ProductSummary>> call(String query) {
    return _repository.searchProducts(query);
  }
}
