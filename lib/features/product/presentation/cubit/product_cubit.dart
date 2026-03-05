import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_product_usecase.dart';

// States
abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final Product product;

  const ProductLoaded(this.product);

  @override
  List<Object?> get props => [product];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class ProductCubit extends Cubit<ProductState> {
  final GetProductUseCase _getProductUseCase;

  ProductCubit({required GetProductUseCase getProductUseCase})
    : _getProductUseCase = getProductUseCase,
      super(ProductLoading());

  Future<void> loadProduct(String id) async {
    emit(ProductLoading());
    try {
      final product = await _getProductUseCase(id);
      emit(ProductLoaded(product));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
