import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:swb_advance/app/core/helper/constants/api_constants.dart';
import 'package:swb_advance/app/core/helper/exceptions/exceptions.dart';
import 'package:swb_advance/app/core/services/network/dio_client.dart';
import 'package:swb_advance/app/features/home/data/models/product_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class ProductRemoteDataSource {
  Future<Either<TExceptions, List<ProductModel>>> getProductsList({
    int page = 0,
    int limit = 10,
  });

  Future<Either<TExceptions, ProductModel>> getProductById({
    required int productId,
  });

  Future<Either<TExceptions, List<ProductModel>>> getProductsByCategory({
    required String categoryName,
  });
  Future<Either<TExceptions, List<ProductModel>>> getProductsBySearch({
    String? search = "",
  });

  Future<Either<TExceptions, List<ProductModel>>> getSortedProducts({
    required String sortBy,
    required String sortType,
  });
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final DioClient dio;
  ProductRemoteDataSourceImpl({required this.dio});
  final String supabaseUrl = dotenv.env['SUPABASE_URL']!;
  final String supabaseKey = dotenv.env['SUPABASE_ANON_KEY']!;
  @override
  Future<Either<TExceptions, ProductModel>> getProductById({
    required int productId,
  }) async {
    try {
      var response = await dio.get(ApiConstants.getDummyProductById(productId));
      if (response.statusCode == 200) {
        var product = ProductModel.fromJson(response.data);
        return Right(product);
      } else {
        return Left(TExceptions.fromCode(response.statusCode.toString()));
      }
    } on DioException catch (e) {
      return Left(TExceptions.fromCode(e.response.toString()));
    } catch (e) {
      return Left(TExceptions(e.toString()));
    }
  }

  Future<Either<TExceptions, List<ProductModel>>> getProductsList({
    int page = 0,
    int limit = 10,
  }) async {
    try {
      final offset = page * limit;

      final response = await dio.get(
        "$supabaseUrl/rest/v1/products?select=*",
        queryParameters: {
          "select": "*",
          "order": "id.asc",
          "limit": limit,
          "offset": offset,
        },
        // options: Options(
        //   headers: {
        //     "apikey": supabaseKey,
        //     "Authorization": "Bearer $supabaseKey",
        //     "Content-Type": "application/json",
        //   },
        // ),
      );

      if (response.statusCode == 200) {
        final products = (response.data as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();
        return Right(products);
      } else {
        return Left(TExceptions.fromCode(response.statusCode.toString()));
      }
    } on DioException catch (e) {
      return Left(
        TExceptions.fromCode(e.response?.statusCode.toString() ?? "0"),
      );
    } catch (e) {
      return Left(TExceptions(e.toString()));
    }
  }

  @override
  Future<Either<TExceptions, List<ProductModel>>> getProductsByCategory({
    required String categoryName,
  }) async {
    try {
      var response = await dio.get(
        ApiConstants.getDummyProductsByCategory(categoryName: categoryName),
      );
      if (response.statusCode == 200) {
        var products = (response.data['products'] as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();
        return Right(products);
      } else {
        return Left(TExceptions.fromCode(response.statusCode.toString()));
      }
    } on DioException catch (e) {
      return Left(TExceptions.fromCode(e.response.toString()));
    } catch (e) {
      return Left(TExceptions(e.toString()));
    }
  }

  @override
  Future<Either<TExceptions, List<ProductModel>>> getProductsBySearch({
    String? search,
  }) async {
    try {
      var response = await dio.get(
        ApiConstants.getDummyProductsBySearch(search: search),
      );
      if (response.statusCode == 200) {
        var products = (response.data['products'] as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();
        return Right(products);
      } else {
        return Left(TExceptions.fromCode(response.statusCode.toString()));
      }
    } on DioException catch (e) {
      return Left(TExceptions.fromCode(e.response.toString()));
    } catch (e) {
      return Left(TExceptions(e.toString()));
    }
  }

  @override
  Future<Either<TExceptions, List<ProductModel>>> getSortedProducts({
    required String sortBy,
    required String sortType,
  }) async {
    try {
      var response = await dio.get(
        ApiConstants.getDummySortedProducts(sortBy: sortBy, sortType: sortType),
      );
      if (response.statusCode == 200) {
        var products = (response.data['products'] as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();
        return Right(products);
      } else {
        return Left(TExceptions.fromApi(response.data));
      }
    } on DioException catch (e) {
      return Left(TExceptions.fromCode(e.response.toString()));
    } catch (e) {
      return Left(TExceptions(e.toString()));
    }
  }
}
