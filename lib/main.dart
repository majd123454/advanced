import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:swb_advance/app/core/di/service_locator.dart';
import 'package:swb_advance/app/core/routing/app_routes.dart';
import 'package:swb_advance/app/core/routing/routes.dart';
import 'package:swb_advance/app/core/services/auth/token_storage.dart';
import 'package:swb_advance/shop_app.dart';

import 'app/core/services/supabase/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // env
  await dotenv.load(fileName: '.env');

  // Supabase
  await SupabaseService.initialize();

  // DI
  await setupServiceLocator();

  final tokenStorage = sl<TokenStorage>();
  final savedTokens = await tokenStorage.read();
  final hasSavedSession =
      savedTokens != null && savedTokens.accessToken.isNotEmpty;

  runApp(
    ShopApp(
      appRoutes: AppRoutes(),
      initialRoute: hasSavedSession ? Routes.navigation : Routes.boarding,
    ),
  );
}
