import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:plasier/core/config/theme/app_colors.dart';
import 'package:plasier/core/route/routes.dart';
import 'package:plasier/core/widgets/value_accessor_class.dart';
import 'package:plasier/features/home/widgets/checklist.dart';
import 'package:plasier/features/home/widgets/drop_down.dart';
import 'package:plasier/features/main/controller/main_controller.dart';
import 'package:plasier/models/recipe.dart';
import 'package:reactive_forms/reactive_forms.dart';

class EditRecipeScreen extends StatefulWidget {
  const EditRecipeScreen({required this.recipe, super.key});
  final Recipe recipe;

  @override
  State<EditRecipeScreen> createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  late final MainController _controller;
  final RxBool _canAdd = false.obs;
  final FormGroup form = FormGroup({'checklist': FormControl<String>()});
  late final StreamSubscription? _subscription;
  final RxList<ChecklistItem> _checklist = <ChecklistItem>[].obs;
  final RxBool _showClear = false.obs;

  @override
  void initState() {
    _controller = Get.isRegistered<MainController>()
        ? Get.find<MainController>()
        : Get.put(MainController());

    _subscription = form.control('checklist').valueChanges.listen((value) {
      _canAdd.value =
          form.control('checklist').valid &&
          (value?.toString().trim().isNotEmpty ?? false);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showClear.value = false;
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(color: AppColors.blue),
          backgroundColor: AppColors.white,
          actionsPadding: EdgeInsets.symmetric(horizontal: 16.w),
          actions: [
            DropDown(
              onTap: (value) {
                if (value == 'Löschen') {
                  _controller.removeRecipe(
                    _controller.recipes.indexOf(widget.recipe),
                  );
                } else {
                  Get.toNamed(RouteLink.home, arguments: widget.recipe);
                }
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 3.h, 16.w, 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.recipe.title,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: AppColors.black,
                    fontSize: 34.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    color: AppColors.whiteSmoke,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Trocknend   ${DurationValueAccessor().modelToViewValue(widget.recipe.dryingTime)} ',
                        style: Theme.of(context).textTheme.displayLarge
                            ?.copyWith(fontSize: 16.sp, color: AppColors.blue),
                      ),
                      Icon(
                        Icons.timer,
                        color: AppColors.blue.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Container(
                      width: 167.5.w,
                      padding: EdgeInsets.symmetric(
                        vertical: 11.h,
                        horizontal: 16.w,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        color: AppColors.whiteSmoke,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 115.w,
                            child: Text(
                              widget.recipe.temprature.toString(),
                              style: Theme.of(context).textTheme.displaySmall
                                  ?.copyWith(
                                    fontSize: 17.sp,
                                    color: AppColors.black,
                                  ),
                            ),
                          ),

                          Text(
                            'C°',
                            style: Theme.of(context).textTheme.displaySmall
                                ?.copyWith(
                                  fontSize: 17.sp,
                                  color: AppColors.payneGrey.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      width: 167.5.w,
                      padding: EdgeInsets.symmetric(
                        vertical: 11.h,
                        horizontal: 16.w,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        color: AppColors.whiteSmoke,
                      ),
                      child: Text(
                        widget.recipe.formType,
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(fontSize: 17.sp, color: AppColors.black),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 13.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    color: AppColors.whiteSmoke,
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.recipe.ingredients.length,
                    separatorBuilder: (context, index) => Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xff545456).withValues(alpha: 0.34),
                            width: 0.33,
                          ),
                        ),
                      ),
                    ),
                    itemBuilder: (context, index) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        widget.recipe.ingredients[index].name,
                        style: Theme.of(context).textTheme.displayLarge
                            ?.copyWith(fontSize: 17.sp, color: AppColors.black),
                      ),
                      trailing: Text(
                        '${widget.recipe.ingredients[index].gram} g',
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(fontSize: 17.sp, color: AppColors.blue),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                Center(
                  child: Text(
                    'Pflege und Verarbeitung Checkliste',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 16.sp,
                      height: 1.24,
                      color: AppColors.black,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                ReactiveForm(
                  formGroup: form,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 16.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: AppColors.whiteSmoke,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: ReactiveTextField<String>(
                                  formControlName: 'checklist',
                                  onTap: (control) => _showClear.value = true,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(
                                        fontSize: 17.sp,
                                        color: AppColors.black,
                                      ),

                                  showErrors: (control) => false,
                                  decoration: _inputDecoration(),
                                ),
                              ),
                              Obx(() {
                                if (_showClear.value) {
                                  return IconButton(
                                    icon: Icon(
                                      Icons.cancel,
                                      color: AppColors.payneGrey.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                                    onPressed: () =>
                                        form.control('checklist').reset(),
                                  );
                                }
                                return SizedBox();
                              }),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Obx(
                        () => InkWell(
                          onTap: () =>
                              _canAdd.value ? _addChecklistItem() : null,
                          child: Stack(
                            children: [
                              Container(
                                width: 40.w,
                                height: 44.w,
                                decoration: BoxDecoration(
                                  color: AppColors.blue,
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: Icon(
                                  CupertinoIcons.add,
                                  color: AppColors.white,
                                ),
                              ),
                              Container(
                                width: 40.w,
                                height: 44.w,
                                decoration: BoxDecoration(
                                  color: !_canAdd.value
                                      ? AppColors.white.withValues(alpha: 0.8)
                                      : null,
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Obx(
                  () => _checklist.isNotEmpty
                      ? Column(
                          children: [
                            SizedBox(height: 16.h),
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) => ChecklistCard(
                                item: _checklist[index],
                                onTap: () {
                                  _checklist[index].checked =
                                      !_checklist[index].checked;
                                  _checklist.refresh();
                                },
                              ),
                              itemCount: _checklist.length,
                            ),
                          ],
                        )
                      : SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addChecklistItem() {
    final value = form.control('checklist').value?.toString().trim();
    if (value != null &&
        value.isNotEmpty &&
        !_checklist.any((item) => item.text == value)) {
      _checklist.add(ChecklistItem(value));
      form.control('checklist').reset();
    }
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      hintText: 'Checklistenelement',
      hintStyle: Theme.of(context).textTheme.displaySmall?.copyWith(
        fontSize: 17.sp,
        color: AppColors.payneGrey.withValues(alpha: 0.6),
      ),
      border: InputBorder.none,
    );
  }
}
