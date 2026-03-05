import '../entities/product_summary.dart';
import '../repositories/home_repository.dart';

class GetProductsUseCase {
  final HomeRepository _repository;

  GetProductsUseCase(this._repository);

  Future<List<ProductSummary>> call() {
    return _repository.getProducts();
  }
}
