import 'package:dartz/dartz.dart';
import 'package:swb_advance/app/features/home/data/models/product_entity.dart';

abstract class FavouriteRepository {
  Future<Either<String, List<ProductEntity>>> getFavourites();
}
