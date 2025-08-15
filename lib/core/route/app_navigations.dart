import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plasier/core/route/routes.dart';
import 'package:plasier/core/widgets/utils/shared_prefs.dart';
import 'package:plasier/features/home/home_screen.dart';
import 'package:plasier/features/home/widgets/edit_recipe_screen.dart';
import 'package:plasier/features/main/main_screen.dart';
import 'package:plasier/features/premium/premium_screen.dart';
import 'package:plasier/features/settings/settings_screen.dart';
import 'package:plasier/features/splash/splash_screen.dart';
import 'package:plasier/models/recipe.dart';
import 'package:plasier/service_locator.dart';

class AppRoute {
  factory AppRoute() => AppRoute._internal();

  AppRoute._internal();
  final main = Get.nestedKey(0);
  final nested = Get.nestedKey(1);

  Bindings? initialBinding() {
    return BindingsBuilder(() {
      locator<SharedPrefs>();
    });
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteLink.splash:
        return pageRouteBuilder(page: const SplashScreen());

      case RouteLink.main:
        return pageRouteBuilder(page: const MainScreen());

      case RouteLink.home:
        {
          final recipe = settings.arguments as Recipe?;
          return pageRouteBuilder(page: HomeScreen(recipe: recipe));
        }

      case RouteLink.settings:
        return pageRouteBuilder(page: SettingsScreen());

      case RouteLink.premium:
        return pageRouteBuilder(page: PremiumScreen());

      case RouteLink.edit:
        final recipe = settings.arguments as Recipe;
        return pageRouteBuilder(page: EditRecipeScreen(recipe: recipe));

      default:
        return pageRouteBuilder(
          page: Scaffold(body: Container(color: Colors.red)),
        );
    }
  }

  GetPageRoute pageRouteBuilder({
    required Widget page,
    RouteSettings? settings,
  }) => GetPageRoute(
    transitionDuration: Duration.zero,
    page: () => page,
    settings: settings,
  );
}
