import 'package:dio/dio.dart';
import 'package:swb_advance/app/core/services/network/api_service.dart';
import 'package:swb_advance/app/core/services/supabase/supabase_config.dart';
import 'package:swb_advance/app/core/services/supabase/supabase_table.dart';

abstract class FavouriteRemoteDataSource {
  Future<List<Map<String, dynamic>>> fetchFavourites();
}

class FavouriteRemoteDataSourceImpl implements FavouriteRemoteDataSource {
  FavouriteRemoteDataSourceImpl({required this.apiService});

  final ApiService apiService;

  Options get _supabaseOptions => Options(
    headers: {
      'apikey': SupabaseConfig.supabaseAnonKey,
      'Authorization': 'Bearer ${SupabaseConfig.supabaseAnonKey}',
      'Accept': 'application/json',
    },
  );

  String _tableUrl(String table) => Uri.parse(
    SupabaseConfig.supabaseUrl,
  ).resolve('/rest/v1/$table').toString();

  @override
  Future<List<Map<String, dynamic>>> fetchFavourites() async {
    final wishlistResponse = await apiService.dio.get<dynamic>(
      _tableUrl(SupabaseTables.wishlist),
      queryParameters: {'select': '*'},
      options: _supabaseOptions,
    );
    final wishlistRows = _asRows(wishlistResponse.data);
    final productIds = wishlistRows
        .map((row) => row[SupabaseColumns.productId]?.toString())
        .whereType<String>()
        .where((id) => id.isNotEmpty)
        .toSet();
    if (productIds.isEmpty) return [];

    final productsResponse = await apiService.dio.get<dynamic>(
      _tableUrl(SupabaseTables.products),
      queryParameters: {'select': '*', 'id': 'in.(${productIds.join(',')})'},
      options: _supabaseOptions,
    );
    final productsById = {
      for (final product in _asRows(productsResponse.data))
        product[SupabaseColumns.id]?.toString(): product,
    };

    return [
      for (final row in wishlistRows)
        if (productsById[row[SupabaseColumns.productId]?.toString()] != null)
          productsById[row[SupabaseColumns.productId].toString()]!,
    ];
  }

  List<Map<String, dynamic>> _asRows(dynamic data) {
    if (data is! List) {
      throw const FormatException(
        'Supabase returned an invalid table response',
      );
    }
    return data
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .toList();
  }
}
