import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swb_advance/app/core/di/service_locator.dart';
import 'package:swb_advance/app/core/routing/routes.dart';
import 'package:swb_advance/app/core/services/network/api_service.dart';
import 'package:swb_advance/app/core/services/auth/secure_token_storage.dart';
import 'package:swb_advance/app/features/auth/auth_features/login/ui/login_screen.dart';
import 'package:swb_advance/app/features/auth/auth_features/signup/signup_screen.dart';
import 'package:swb_advance/app/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:swb_advance/app/features/auth/logic/cubit/auth_cubit.dart';
import 'package:swb_advance/app/features/auth/logic/usecase/login_usecase.dart';
import 'package:swb_advance/app/features/auth/logic/usecase/signup_usecase.dart';
import 'package:swb_advance/app/features/boarding/logic/on_boarding_cubit.dart';
import 'package:swb_advance/app/features/boarding/ui/boarding.dart';
import 'package:swb_advance/app/features/navigation_bar/logic/cubit/navigation_cubit.dart';
import 'package:swb_advance/app/features/navigation_bar/ui/navigation_bar.dart';

class AppRoutes {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.boarding:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) => OnBoardingCubit(),
            child: BoardingScreen(),
          ),
        );
      case Routes.login:
        return MaterialPageRoute(builder: (_) => _authScreen(LoginScreen()));
      case Routes.signup:
        return MaterialPageRoute(
          builder: (_) => _authScreen(const SignUpView()),
        );
      case Routes.navigation:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) =>
                sl<NavigationCubit>()..initializeScreensList(),
            child: NavigationButton(),
          ),
        );

      default:
        return MaterialPageRoute(builder: (_) => Text('No Route Found'));
    }
  }

  Widget _authScreen(Widget child) {
    final tokenStorage = const SecureTokenStorage();
    final repository = AuthRepositoryImpl(
      ApiService.fromEnvironment(tokenStorage: tokenStorage),
      tokenStorage,
    );

    return BlocProvider(
      create: (BuildContext context) => AuthCubit(
        loginUseCase: LoginUseCase(repository),
        signUpUseCase: SignUpUseCase(repository),
      ),
      child: child,
    );
  }
}

// class AppRoutes {
  // Route? generateRoute(RouteSettings settings) {
    // switch (settings.name) {
      // case Routes.onBoarding:
      //   return MaterialPageRoute(
      //     builder: (_) => BlocProvider(
      //       create: (BuildContext context) => OnBoardingCubit(),
      //       child: OnBoardingScreen(),
      //     ),
      //   );
      // case Routes.login:
      //   return MaterialPageRoute(
      //     builder: (_) => BlocProvider(
      //       create: (BuildContext context) => sl<AuthCubit>(),
      //       child: LoginScreen(),
      //     ),
      //   );
      // case Routes.signup:
      //   return MaterialPageRoute(
      //     builder: (_) => BlocProvider(
      //       create: (BuildContext context) => sl<AuthCubit>(),
      //       child: SignUpView(),
      //     ),
      //   );
      // case Routes.emailVerifiedSuccessfully:
      //   return MaterialPageRoute(builder: (_) => EmailVerifiedSuccessfully());
      // case Routes.navigation:
      //   return MaterialPageRoute(
      //     builder: (_) => BlocProvider(
      //       create: (BuildContext context) =>
      //           sl<NavigationCubit>()..initializeScreensList(),
      //       child: NavigationButton(),
      //     ),
      //   );
      // case Routes.productDetails:
      //   return MaterialPageRoute(builder: (_) => ProductDetailsView());
//       default:
//         return MaterialPageRoute(builder: (_) => Text('No Route Found'));
//     }
//   }
// }
