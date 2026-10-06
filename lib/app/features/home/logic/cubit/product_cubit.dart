import 'package:equatable/equatable.dart';
import 'package:swb_advance/app/core/helper/exceptions/exceptions.dart';
import 'package:swb_advance/app/features/home/data/models/product_entity.dart';
import 'package:swb_advance/app/features/home/logic/use_cases/get_products_list_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit({required this.getProductsListUsecase})
    : super(ProductInitial());

  final GetProductsListUsecase getProductsListUsecase;

  int _page = 0;
  final int _limit = 10;
  bool _isFetching = false;
  bool _hasMore = true;

  final List<ProductEntity> _products = [];

  List<ProductEntity> get products => _products;
  bool get hasMore => _hasMore;

  Future<void> getProducts({bool refresh = false}) async {
    if (_isFetching) return;

    if (refresh) {
      _page = 0;
      _hasMore = true;
      _products.clear();
      emit(ProductLoading());
    }

    if (!_hasMore) return;

    _isFetching = true;

    final result = await getProductsListUsecase.call(
      page: _page,
      limit: _limit,
    );

    result.fold(
      (error) {
        emit(ProductError(error: error));
      },
      (newProducts) {
        if (newProducts.length < _limit) {
          _hasMore = false;
        }

        _products.addAll(newProducts);
        _page++;

        emit(ProductLoaded(products: List.from(_products)));
      },
    );

    _isFetching = false;
  }
}
