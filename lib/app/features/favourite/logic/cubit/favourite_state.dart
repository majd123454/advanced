part of 'favourite_cubit.dart';

abstract class FavouriteState extends Equatable {
  const FavouriteState();

  @override
  List<Object?> get props => [];
}

class FavouriteInitial extends FavouriteState {}

class FavouriteLoading extends FavouriteState {}

class FavouriteLoaded extends FavouriteState {
  const FavouriteLoaded({required this.products});

  final List<ProductEntity> products;

  @override
  List<Object?> get props => [products];
}

class FavouriteError extends FavouriteState {
  const FavouriteError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
