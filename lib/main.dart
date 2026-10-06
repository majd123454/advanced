import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:swb_advance/app/core/di/service_locator.dart';
import 'package:swb_advance/app/core/routing/app_routes.dart';
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

  runApp(ShopApp(appRoutes: AppRoutes()));
}
