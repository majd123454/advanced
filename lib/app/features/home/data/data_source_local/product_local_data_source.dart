import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:swb_advance/app/features/home/data/models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getCachedProducts();
  Future<void> cacheProducts(List<ProductModel> products);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  static const String _productsCacheKey = 'cached_products_v1';

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    final preferences = await SharedPreferences.getInstance();
    final cachedJson = preferences.getString(_productsCacheKey);
    if (cachedJson == null || cachedJson.isEmpty) return [];

    try {
      final decoded = jsonDecode(cachedJson) as List<dynamic>;
      return decoded
          .map(
            (item) =>
                ProductModel.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList();
    } catch (_) {
      await preferences.remove(_productsCacheKey);
      return [];
    }
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    final preferences = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      products.map((product) => product.toJson()).toList(),
    );
    await preferences.setString(_productsCacheKey, encoded);
  }
}
