import 'package:flutter/material.dart';
import 'package:swb_advance/app/core/routing/app_routes.dart';
import 'package:swb_advance/app/core/routing/routes.dart';
import 'package:swb_advance/app/core/theming/theme.dart';

// ignore: must_be_immutable
class ShopApp extends StatelessWidget {
  AppRoutes appRoutes;
  ShopApp({super.key, required this.appRoutes});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop App',
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      initialRoute: Routes.boarding,
      onGenerateRoute: appRoutes.generateRoute,
    );
  }
}
