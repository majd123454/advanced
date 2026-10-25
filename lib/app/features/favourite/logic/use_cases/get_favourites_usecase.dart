import 'package:dartz/dartz.dart';
import 'package:swb_advance/app/features/favourite/data/repositories/favourite_repository.dart';
import 'package:swb_advance/app/features/home/data/models/product_entity.dart';

class GetFavouritesUseCase {
  const GetFavouritesUseCase(this.repository);

  final FavouriteRepository repository;

  Future<Either<String, List<ProductEntity>>> call() =>
      repository.getFavourites();
}
