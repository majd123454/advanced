import 'package:get_it/get_it.dart';
import 'package:swb_advance/app/core/services/auth/secure_token_storage.dart';
import 'package:swb_advance/app/core/services/auth/token_storage.dart';
import 'package:swb_advance/app/core/services/network/api_service.dart';
import 'package:swb_advance/app/core/services/network/dio_client.dart';
import 'package:swb_advance/app/core/services/supabase/supabase_config.dart';
import 'package:swb_advance/app/features/auth/logic/usecase/login_usecase.dart';
import 'package:swb_advance/app/features/auth/logic/usecase/signup_usecase.dart';
import 'package:swb_advance/app/features/chat/data/repository/chat_repository.dart';
import 'package:swb_advance/app/features/chat/data/repository/chat_repository_impl.dart';
import 'package:swb_advance/app/features/chat/logic/cubit/chat_cubit.dart';
import 'package:swb_advance/app/features/chat/logic/use_cases/get_messages_usecase.dart';
import 'package:swb_advance/app/features/chat/logic/use_cases/send_message_usecase.dart';
import 'package:swb_advance/app/features/chat/logic/use_cases/watch_chat_messages_usecase.dart';
import 'package:swb_advance/app/features/home/data/data_source_remote/product_remote_data_source.dart';
import 'package:swb_advance/app/features/home/data/repositories/product_repository.dart';
import 'package:swb_advance/app/features/home/data/repositories/product_repository_impl.dart';
import 'package:swb_advance/app/features/home/logic/cubit/product_cubit.dart';
import 'package:swb_advance/app/features/home/logic/use_cases/get_products_list_usecase.dart';
import 'package:swb_advance/app/features/navigation_bar/logic/cubit/navigation_cubit.dart';

import '../../features/auth/data/repositories/auth_repo.dart';
import '../../features/auth/data/repositories/auth_repo_impl.dart';
import '../../features/auth/logic/cubit/auth_cubit.dart';
import '../services/supabase/supabase_service.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ==================== Core ====================
  sl.registerLazySingleton<SupabaseService>(() => SupabaseService.instance);
  sl.registerLazySingleton<TokenStorage>(() => const SecureTokenStorage());
  sl.registerLazySingleton<ApiService>(
    () => ApiService.fromEnvironment(tokenStorage: sl()),
  );

  // ==================== Auth ====================
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );
  sl.registerFactory(() => AuthCubit(loginUseCase: sl(), signUpUseCase: sl()));

  // ==================== Login ====================
  sl.registerLazySingleton(() => LoginUseCase(sl()));

  // ==================== SignUp ====================
  sl.registerLazySingleton(() => SignUpUseCase(sl()));

  // ==================== Bottom Navigation Bar ====================
  sl.registerFactory(() => NavigationCubit());

  // Services
  sl.registerSingleton<DioClient>(DioClient());

  // DataSources
  sl.registerSingleton<ProductRemoteDataSource>(
    ProductRemoteDataSourceImpl(dio: sl()),
  );

  // ==================== Products ====================
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(
    () => GetProductsListUsecase(productRepository: sl()),
  );

  // Cubit
  sl.registerFactory(() => ProductCubit(getProductsListUsecase: sl()));

  // ==================== Chat ====================
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(apiService: sl()),
  );
  sl.registerLazySingleton(() => GetMessagesUseCase(sl()));
  sl.registerLazySingleton(() => SendMessageUseCase(sl()));
  sl.registerLazySingleton(() => WatchChatMessagesUseCase(sl()));

  sl.registerFactory(
    () => ChatCubit(
      getMessagesUseCase: sl(),
      sendMessageUseCase: sl(),
      watchChatMessagesUseCase: sl(),
      currentUserId: SupabaseConfig.supportUserId ?? '',
    ),
  );
}
