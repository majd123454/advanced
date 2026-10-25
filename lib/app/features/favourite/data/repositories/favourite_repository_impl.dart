import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:swb_advance/app/features/favourite/data/data_source_remote/favourite_remote_data_source.dart';
import 'package:swb_advance/app/features/favourite/data/repositories/favourite_repository.dart';
import 'package:swb_advance/app/features/home/data/models/product_entity.dart';
import 'package:swb_advance/app/features/home/data/models/product_model.dart';

class FavouriteRepositoryImpl implements FavouriteRepository {
  FavouriteRepositoryImpl({required this.remoteDataSource});

  final FavouriteRemoteDataSource remoteDataSource;

  @override
  Future<Either<String, List<ProductEntity>>> getFavourites() async {
    try {
      final rows = await remoteDataSource.fetchFavourites();
      return Right(rows.map(ProductModel.fromJson).toList());
    } on DioException catch (error) {
      final data = error.response?.data;
      if (data is Map) {
        final message = data['message'] ?? data['msg'] ?? data['error'];
        if (message != null) return Left(message.toString());
      }
      return Left(error.message ?? 'تعذر تحميل المفضّلة');
    } catch (error) {
      return Left(error.toString());
    }
  }
}
