import 'package:dartz/dartz.dart';
import 'package:swb_advance/app/core/helper/exceptions/exceptions.dart';
import 'package:swb_advance/app/features/home/data/data_source_remote/product_remote_data_source.dart';
import 'package:swb_advance/app/features/home/data/models/product_entity.dart';
import 'package:swb_advance/app/features/home/data/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<TExceptions, List<ProductEntity>>> getProductsByCategory({
    required String categoryName,
  }) async {
    return await remoteDataSource.getProductsByCategory(
      categoryName: categoryName,
    );
  }

  @override
  Future<Either<TExceptions, List<ProductEntity>>> getProductsList({
    int page = 0,
    int limit = 10,
  }) async {
    return await remoteDataSource.getProductsList(page: page, limit: limit);
  }

  @override
  Future<Either<TExceptions, ProductEntity>> getProductById({
    required int productId,
  }) async {
    return await remoteDataSource.getProductById(productId: productId);
  }

  @override
  Future<Either<TExceptions, List<ProductEntity>>> getProductsBySearch({
    String? search,
  }) async {
    return await remoteDataSource.getProductsBySearch(search: search);
  }

  @override
  Future<Either<TExceptions, List<ProductEntity>>> getSortedProducts({
    required String sortBy,
    required String sortType,
  }) async {
    return await remoteDataSource.getSortedProducts(
      sortBy: sortBy,
      sortType: sortType,
    );
  }
}
