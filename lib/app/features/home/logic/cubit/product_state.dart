part of 'product_cubit.dart';


abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductEntity> products;
  const ProductLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

class ProductLoadedById extends ProductState {
  final ProductEntity product;
  const ProductLoadedById({required this.product});

  @override
  List<Object> get props => [product];
}

class ProductSortedProductsLoaded extends ProductState {
  final List<ProductEntity> productsList;
  const ProductSortedProductsLoaded({required this.productsList});
}

class ProductSearchProductsLoaded extends ProductState {
  final List<ProductEntity> productsList;
  const ProductSearchProductsLoaded({required this.productsList});
}
class ProductCategoryProductsLoaded extends ProductState {
  final List<ProductEntity> productsList;
  const ProductCategoryProductsLoaded({required this.productsList});
}
class ProductError extends ProductState {
  final TExceptions error;
  const ProductError({required this.error});
}
