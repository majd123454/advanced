import 'package:get_it/get_it.dart';
import 'package:swb_advance/app/features/auth/data/repositories/auth_repo.dart';
import 'package:swb_advance/app/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:swb_advance/app/features/auth/logic/cubit/auth_cubit.dart';
import 'package:swb_advance/app/features/auth/logic/usecase/login_usecase.dart';

import '../services/network/api_service.dart';
import '../services/supabase/supabase_service.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ==================== Core ====================
  sl.registerLazySingleton<SupabaseService>(() => SupabaseService.instance);

  // ==================== Auth ====================
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerFactory(() => AuthCubit(loginUseCase: sl()));

  // ==================== Login ====================
  sl.registerLazySingleton(() => LoginUseCase(sl()));

  // ==================== ApiService ====================
  sl.registerLazySingleton<ApiService>(() => ApiService());
}
