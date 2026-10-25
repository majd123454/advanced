import 'package:equatable/equatable.dart';
import 'package:swb_advance/app/core/helper/exceptions/exceptions.dart';
import 'package:swb_advance/app/features/home/data/models/product_entity.dart';
import 'package:swb_advance/app/features/home/logic/use_cases/get_products_by_search_usecase.dart';
import 'package:swb_advance/app/features/home/logic/use_cases/get_products_list_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit({
    required this.getProductsListUsecase,
    required this.getProductsBySearchUsecase,
  }) : super(ProductInitial());

  final GetProductsListUsecase getProductsListUsecase;
  final GetProductsBySearchUsecase getProductsBySearchUsecase;

  int _page = 0;
  final int _limit = 10;
  bool _isFetching = false;
  bool _hasMore = true;
  bool _isSearchMode = false;
  int _searchRequestId = 0;

  final List<ProductEntity> _products = [];

  List<ProductEntity> get products => _products;
  bool get hasMore => _hasMore;

  Future<void> getProducts({bool refresh = false}) async {
    if (isClosed || _isFetching || (_isSearchMode && !refresh)) return;

    if (refresh) {
      _isSearchMode = false;
      _page = 0;
      _hasMore = true;
      _products.clear();
    }

    final shouldLoadCache = _page == 0 && _products.isEmpty;
    _isFetching = true;

    if (shouldLoadCache) {
      try {
        final cachedProducts = await getProductsListUsecase.getCachedProducts();
        if (isClosed) return;

        if (cachedProducts.isEmpty) {
          emit(ProductLoading());
        } else {
          _products.addAll(cachedProducts);
          emit(ProductLoaded(products: List.from(_products)));
        }
      } catch (_) {
        if (isClosed) return;
        emit(ProductLoading());
      }
    }

    if (!_hasMore) {
      _isFetching = false;
      return;
    }

    try {
      final result = await getProductsListUsecase.call(
        page: _page,
        limit: _limit,
      );

      if (isClosed) return;

      await result.fold<Future<void>>(
        (error) async {
          if (_products.isEmpty) {
            emit(ProductError(error: error));
          } else {
            _hasMore = false;
            emit(ProductLoaded(products: List.from(_products)));
          }
        },
        (newProducts) async {
          if (_page == 0) _products.clear();

          if (newProducts.length < _limit) {
            _hasMore = false;
          }

          _products.addAll(newProducts);
          _page++;

          try {
            await getProductsListUsecase.cacheProducts(_products);
          } catch (_) {}

          emit(ProductLoaded(products: List.from(_products)));
        },
      );
    } finally {
      _isFetching = false;
    }
  }

  Future<void> searchProducts(String search) async {
    final query = search.trim();
    if (isClosed || query.isEmpty) return;

    final requestId = ++_searchRequestId;
    _isSearchMode = true;
    _hasMore = false;
    _isFetching = true;
    emit(ProductLoading());

    try {
      final result = await getProductsBySearchUsecase.call(search: query);
      if (isClosed || requestId != _searchRequestId) return;

      result.fold(
        (error) => emit(ProductError(error: error)),
        (products) => emit(ProductSearchProductsLoaded(productsList: products)),
      );
    } finally {
      if (requestId == _searchRequestId) _isFetching = false;
    }
  }

  void resetSearch() {
    if (isClosed) return;

    _searchRequestId++;
    _isSearchMode = false;
    _isFetching = false;
    _hasMore = true;
    emit(ProductInitial());
  }
}
