import 'package:flutter/material.dart';
import 'package:swb_advance/app/core/routing/app_routes.dart';
import 'package:swb_advance/app/core/routing/routes.dart';
import 'package:swb_advance/app/core/theming/theme.dart';

class ShopApp extends StatelessWidget {
  final AppRoutes appRoutes;
  final String initialRoute;

  const ShopApp({
    super.key,
    required this.appRoutes,
    this.initialRoute = Routes.boarding,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop App',
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      initialRoute: initialRoute,
      onGenerateRoute: appRoutes.generateRoute,
    );
  }
}
