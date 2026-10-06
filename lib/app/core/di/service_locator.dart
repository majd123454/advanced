import 'package:get_it/get_it.dart';
import 'package:swb_advance/app/features/auth/data/repositories/auth_repo.dart';
import 'package:swb_advance/app/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:swb_advance/app/features/auth/logic/cubit/auth_cubit.dart';
import 'package:swb_advance/app/features/auth/logic/usecase/login_usecase.dart';
import 'package:swb_advance/app/features/auth/logic/usecase/signup_usecase.dart';
import 'package:swb_advance/app/features/home/data/data_source_remote/product_remote_data_source.dart';
import 'package:swb_advance/app/features/home/data/repositories/product_repository.dart';
import 'package:swb_advance/app/features/home/data/repositories/product_repository_impl.dart';
import 'package:swb_advance/app/features/home/logic/cubit/product_cubit.dart';
import 'package:swb_advance/app/features/home/logic/use_cases/get_products_list_usecase.dart';
import 'package:swb_advance/app/features/navigation_bar/logic/cubit/navigation_cubit.dart';

import '../services/auth/secure_token_storage.dart';
import '../services/auth/token_storage.dart';
import '../services/network/api_service.dart';
import '../services/network/dio_client.dart';
import '../services/supabase/supabase_service.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ==================== Core ====================
  sl.registerLazySingleton<SupabaseService>(() => SupabaseService.instance);
  sl.registerLazySingleton<TokenStorage>(() => const SecureTokenStorage());

  // ==================== Auth ====================
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );
  sl.registerFactory(() => AuthCubit(loginUseCase: sl(), signUpUseCase: sl()));

  // ==================== Login & Sign Up ====================
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));

  // ==================== ApiService ====================
  sl.registerLazySingleton<ApiService>(
    () => ApiService.fromEnvironment(tokenStorage: sl()),
  );

  // ==================== Bottom Navigation Bar ====================
  sl.registerFactory(() => NavigationCubit());

  // ==================== Products ====================
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(dio: sl()),
  );

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(
    () => GetProductsListUsecase(productRepository: sl()),
  );

  // Cubit
  sl.registerFactory(() => ProductCubit(getProductsListUsecase: sl()));
}
