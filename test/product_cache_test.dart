import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swb_advance/app/features/home/data/data_source_local/product_local_data_source.dart';
import 'package:swb_advance/app/features/home/data/models/product_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('cached products can be restored with their product details', () async {
    final dataSource = ProductLocalDataSourceImpl();
    final product = ProductModel(
      id: 'product-1',
      name: 'Desk Lamp',
      description: 'A compact lamp',
      price: 34.5,
      salePrice: 29.5,
      categoryId: 'lighting',
      brandId: 'brand-1',
      stock: 12,
      images: const ['https://example.com/lamp.png'],
      thumbnail: 'https://example.com/lamp-thumb.png',
      rating: 4.7,
      reviewsCount: 18,
      isFeatured: true,
      attributes: const {'color': 'black'},
      createdAt: DateTime.utc(2026, 1, 1),
      categoryName: 'Lighting',
      brandName: 'Home Co',
    );

    await dataSource.cacheProducts([product]);
    final cachedProducts = await dataSource.getCachedProducts();

    expect(cachedProducts, hasLength(1));
    expect(cachedProducts.single.toJson(), product.toJson());
  });
}
