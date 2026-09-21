import 'package:get_it/get_it.dart';

import '../services/supabase/supabase_service.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ==================== Core ====================
  sl.registerLazySingleton<SupabaseService>(() => SupabaseService.instance);
  // ==================== Auth ====================
  //   sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  //   sl.registerFactory(() => AuthCubit(loginUseCase: sl(), signupUseCase: sl()));

  //   // ==================== Login ====================

  //   sl.registerLazySingleton(() => LoginUseCase(sl()));

  //   // ==================== SignUp ====================
  //   sl.registerLazySingleton(() => SignupUseCase(sl()));
  //   // ==================== Bottom Navigation Bar ====================
  //   sl.registerFactory(() => NavigationCubit());

  //   // Services
  //   sl.registerSingleton<DioClient>(DioClient());
  //   // DataSources
  //   sl.registerSingleton<ProductRemoteDataSource>(
  //     ProductRemoteDataSourceImpl(dio: sl()),
  //   );

  //   // ==================== Products ====================

  //   // Repository
  //   sl.registerLazySingleton<ProductRepository>(
  //     () => ProductRepositoryImpl(remoteDataSource: sl()),
  //   );

  //   // Use Cases
  //   sl.registerLazySingleton(
  //     () => GetProductsListUsecase(productRepository: sl()),
  //   );

  //   // Cubit
  //   sl.registerFactory(() => ProductCubit(getProductsListUsecase: sl()));

  //   // ==================== Chat ====================
  //   // Repository
  //   sl.registerLazySingleton<ChatRepository>(
  //     () => ChatRepositoryImpl(supabaseService: sl()),
  //   );

  //   // Cubit
  //   sl.registerFactory(() => ChatCubit(repository: sl()));

  //   // ==================== Favorites ====================
  //   // Data Source
  //   sl.registerLazySingleton<FavoritesDataSource>(
  //     () => FavoritesDataSourceImpl(dioClient: sl()),
  //   );

  //   // Repository
  //   sl.registerLazySingleton<FavoritesRepo>(
  //     () => FavoritesRepoImpl(dataSource: sl()),
  //   );

  //   // Use Case
  //   sl.registerLazySingleton(() => GetFavoritesUseCase(repository: sl()));

  //   // cubit
  //   sl.registerFactory(() => FavoritesCubit(getFavoritesUseCase: sl()));
  // }
}
