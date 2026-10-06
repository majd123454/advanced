import 'package:dartz/dartz.dart';
import 'package:swb_advance/app/core/helper/exceptions/exceptions.dart';
import 'package:swb_advance/app/features/home/data/models/product_entity.dart';
import 'package:swb_advance/app/features/home/data/repositories/product_repository.dart';

class GetProductsListUsecase {
  final ProductRepository productRepository;

  GetProductsListUsecase({required this.productRepository});
  Future<Either<TExceptions, List<ProductEntity>>> call({
    int page = 0,
    int limit = 10,
  }) async {
    return await productRepository.getProductsList(page: page, limit: limit);
  }
}
