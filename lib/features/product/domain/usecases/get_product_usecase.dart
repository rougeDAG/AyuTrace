import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductUseCase {
  final ProductRepository _repository;

  GetProductUseCase(this._repository);

  Future<Product> call(String id) {
    return _repository.getProductById(id);
  }
}
