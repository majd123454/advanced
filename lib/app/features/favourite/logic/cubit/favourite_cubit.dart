import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swb_advance/app/features/favourite/logic/use_cases/get_favourites_usecase.dart';
import 'package:swb_advance/app/features/home/data/models/product_entity.dart';

part 'favourite_state.dart';

class FavouriteCubit extends Cubit<FavouriteState> {
  FavouriteCubit({required this.getFavouritesUseCase})
    : super(FavouriteInitial());

  final GetFavouritesUseCase getFavouritesUseCase;
  bool _isLoading = false;

  Future<void> getFavourites() async {
    if (isClosed || _isLoading) return;
    _isLoading = true;
    emit(FavouriteLoading());

    try {
      final result = await getFavouritesUseCase();
      if (isClosed) return;
      result.fold(
        (message) => emit(FavouriteError(message: message)),
        (products) => emit(FavouriteLoaded(products: products)),
      );
    } finally {
      _isLoading = false;
    }
  }
}
