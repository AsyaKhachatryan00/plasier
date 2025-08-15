import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:plasier/core/config/theme/app_colors.dart';
import 'package:plasier/core/route/routes.dart';
import 'package:plasier/features/main/controller/main_controller.dart';
import 'package:plasier/features/main/widgets/list_item_card.dart';
import 'package:plasier/models/recipe.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  late final MainController _controller;
  final RxList<Recipe> _recipes = <Recipe>[].obs;
  Timer? _statusTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    if (Get.isRegistered<MainController>()) {
      _controller = Get.find<MainController>();
    } else {
      _controller = Get.put(MainController());
    }
    _recipes.value = _controller.recipes;
    _updateRecipeStatuses();

    _statusTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _updateRecipeStatuses(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _statusTimer?.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.resumed) {
      _updateRecipeStatuses();
    }
  }

  void _updateRecipeStatuses() {
    for (var recipe in _recipes) {
      final now = DateTime.now();
      final ready = now.difference(recipe.createdDate) >= recipe.dryingTime;
      if (ready && recipe.status != Status.ready) {
        recipe.status = Status.ready;
      } else if (!ready && recipe.status != Status.dries) {
        recipe.status = Status.dries;
      }
    }
    _recipes.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.only(right: 16.w),
        backgroundColor: AppColors.white,
        leadingWidth: 80,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: InkWell(
            onTap: () => Get.toNamed(RouteLink.settings),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(36.r),
                color: AppColors.aliceBlue,
              ),
              child: Icon(Icons.settings, color: AppColors.blue),
            ),
          ),
        ),
        actions: [
          InkWell(
            onTap: () => Get.toNamed(RouteLink.home),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(36.r),
                color: AppColors.lavanderBlush,
              ),
              child: Row(
                children: [
                  Text(
                    'Rezept hinzufügen',
                    style: Theme.of(
                      context,
                    ).textTheme.displayLarge?.copyWith(fontSize: 17.sp),
                  ),
                  SizedBox(width: 8.w),
                  Icon(Icons.add, color: AppColors.primary),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Obx(
          () => Column(
            mainAxisAlignment: _recipes.isEmpty
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              if (_recipes.isEmpty)
                Center(
                  child: Text(
                    'Your Recipes \nWill Appear Here',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontSize: 17.sp,
                      color: AppColors.darkgray,
                    ),
                  ),
                )
              else
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.h),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _recipes.length,
                        itemBuilder: (context, index) => InkWell(
                          onTap: () => Get.toNamed(
                            RouteLink.edit,
                            arguments: _recipes[index],
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: ListItemCard(recipe: _recipes[index]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
