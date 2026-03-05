import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/product_summary.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/search_products_usecase.dart';

// States
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<ProductSummary> products;

  const HomeLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class HomeCubit extends Cubit<HomeState> {
  final GetProductsUseCase _getProductsUseCase;
  final SearchProductsUseCase _searchProductsUseCase;

  HomeCubit({
    required GetProductsUseCase getProductsUseCase,
    required SearchProductsUseCase searchProductsUseCase,
  }) : _getProductsUseCase = getProductsUseCase,
       _searchProductsUseCase = searchProductsUseCase,
       super(HomeLoading());

  Future<void> loadProducts() async {
    emit(HomeLoading());
    try {
      final products = await _getProductsUseCase();
      emit(HomeLoaded(products));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      return loadProducts();
    }
    emit(HomeLoading());
    try {
      final products = await _searchProductsUseCase(query);
      emit(HomeLoaded(products));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
