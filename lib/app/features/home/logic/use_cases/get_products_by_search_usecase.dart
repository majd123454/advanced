import 'package:swb_advance/app/features/home/data/models/product_entity.dart';
import 'package:swb_advance/app/features/home/data/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:swb_advance/app/core/helper/exceptions/exceptions.dart';

class GetProductsBySearchUsecase {
  final ProductRepository productRepository;

  GetProductsBySearchUsecase({required this.productRepository});

  Future<Either<TExceptions, List<ProductEntity>>> call({
    required String search,
  }) async {
    return productRepository.getProductsBySearch(search: search);
  }
}
