import 'package:dartz/dartz.dart';
import 'package:swb_advance/app/core/helper/exceptions/exceptions.dart';
import 'package:swb_advance/app/features/home/data/models/product_entity.dart';

abstract class ProductRepository {
  Future<Either<TExceptions, List<ProductEntity>>> getProductsList({
    int page = 0,
    int limit = 10,
  });
  Future<Either<TExceptions, ProductEntity>> getProductById({
    required int productId,
  });

  Future<Either<TExceptions, List<ProductEntity>>> getProductsByCategory({
    required String categoryName,
  });

  Future<Either<TExceptions, List<ProductEntity>>> getProductsBySearch({
    String? search,
  });

  Future<Either<TExceptions, List<ProductEntity>>> getSortedProducts({
    required String sortBy,
    required String sortType,
  });
}
