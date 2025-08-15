import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:plasier/core/config/theme/app_colors.dart';
import 'package:plasier/core/widgets/value_accessor_class.dart';
import 'package:plasier/features/main/controller/main_controller.dart';
import 'package:plasier/models/recipe.dart';
import 'package:reactive_forms/reactive_forms.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({this.recipe, super.key});
  final Recipe? recipe;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final MainController _controller;

  final FormGroup form = FormGroup({
    'title': FormControl<String>(validators: [Validators.required]),
    'ingredients': FormControl<String>(),
    'formType': FormControl<String>(validators: [Validators.required]),
    'temprature': FormControl<double>(validators: [Validators.required]),
    'dryingTime': FormControl<Duration>(validators: [Validators.required]),
  });

  final RxBool _canAdd = false.obs;
  late final StreamSubscription? _subscription;
  final RxList<String> _ingredientsList = <String>[].obs;
  final RxList<bool> _showClear = List.generate(2, (index) => false).obs;
  final RxString _editingGram = ''.obs;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<MainController>()) {
      _controller = Get.find<MainController>();
    } else {
      _controller = Get.put(MainController());
    }

    final recipe = widget.recipe;
    if (recipe != null) {
      form.control('title').value = recipe.title;

      _controller.ingredientsList.value = recipe.ingredients
          .map((elem) => elem.name)
          .toList();

      for (final ingredient in recipe.ingredients) {
        form.addAll({
          'gram_${ingredient.name}': FormControl<String>(
            value: ingredient.gram.toString(),
            validators: [Validators.required],
          ),
        });
      }

      form.control('formType').value = recipe.formType;
      form.control('temprature').value = recipe.temprature;
      form.control('dryingTime').value = recipe.dryingTime;
    }

    _subscription = form.control('ingredients').valueChanges.listen((value) {
      _canAdd.value =
          form.control('ingredients').valid &&
          (value?.toString().trim().isNotEmpty ?? false);
    });
    _ingredientsList.value = _controller.ingredientsList;
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

  void _addIngredient() {
    final value = form.control('ingredients').value?.toString().trim();
    if (value != null &&
        value.isNotEmpty &&
        !_ingredientsList.contains(value)) {
      _ingredientsList.add(value);

      form.addAll({
        'gram_$value': FormControl<String>(validators: [Validators.required]),
      });
      form.control('ingredients').reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showClear.value = List.generate(2, (index) => false);
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          leading: BackButton(color: AppColors.blue),
          title: Text(
            'Erstellen eines Rezepts',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: 17.sp,
              color: AppColors.black,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => form.valid
                  ? _controller.saveRecipe(item: widget.recipe, form: form)
                  : null,
              icon: Icon(
                CupertinoIcons.check_mark,
                color: form.valid
                    ? AppColors.primary
                    : AppColors.payneGrey.withValues(alpha: 0.18),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: ReactiveForm(
            formGroup: form,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 64.h,
                    width: 343.w,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: _boxDecoration(),
                    child: Row(
                      children: [
                        Expanded(
                          child: ReactiveTextField(
                            showErrors: (control) => false,
                            onChanged: (control) => setState(() {}),
                            onTap: (control) {
                              _showClear[0] = true;
                              _showClear[1] = false;
                            },
                            formControlName: 'title',
                            style: Theme.of(context).textTheme.displaySmall
                                ?.copyWith(
                                  fontSize: 20.sp,
                                  color: AppColors.black,
                                ),
                            decoration: _inputDecoration('Rezepttitel'),
                          ),
                        ),

                        Obx(() {
                          if (_showClear[0]) {
                            return IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: AppColors.payneGrey.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                              onPressed: () => form.control('title').reset(),
                            );
                          }
                          return SizedBox.shrink();
                        }),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          decoration: _boxDecoration(),
                          child: Row(
                            children: [
                              Expanded(
                                child: ReactiveTextField<String>(
                                  formControlName: 'ingredients',
                                  onChanged: (control) => setState(() {}),
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(
                                        fontSize: 17.sp,
                                        color: AppColors.black,
                                      ),
                                  onTap: (control) {
                                    _showClear[0] = false;
                                    _showClear[1] = true;
                                  },
                                  showErrors: (control) => false,
                                  decoration: _inputDecoration(
                                    "Zutat hinzufügen",
                                  ),
                                ),
                              ),
                              Obx(() {
                                if (_showClear[1]) {
                                  return IconButton(
                                    icon: Icon(
                                      Icons.cancel,
                                      color: AppColors.payneGrey.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                                    onPressed: () =>
                                        form.control('ingredients').reset(),
                                  );
                                }
                                return SizedBox.shrink();
                              }),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(width: 8),
                      Obx(
                        () => InkWell(
                          onTap: () => _canAdd.value ? _addIngredient() : null,
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

                  Obx(
                    () => _ingredientsList.isNotEmpty
                        ? Column(
                            children: [
                              SizedBox(height: 24.h),
                              ..._ingredientsList.map(
                                (ingredient) => Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.h),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 13.h,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          width: 0.33,
                                          color: Color(
                                            0xff545456,
                                          ).withValues(alpha: 0.34),
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            ingredient,
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayLarge
                                                ?.copyWith(
                                                  fontSize: 17.sp,
                                                  color: AppColors.black,
                                                ),
                                          ),
                                        ),
                                        IntrinsicWidth(
                                          child: Obx(() {
                                            final isEditing =
                                                _editingGram.value ==
                                                ingredient;
                                            final gramValue =
                                                form
                                                    .control('gram_$ingredient')
                                                    .value
                                                    ?.toString() ??
                                                '';
                                            if (isEditing) {
                                              return Container(
                                                width: 64.w,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 8.w,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.whiteSmoke,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        6.r,
                                                      ),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Expanded(
                                                      child: ReactiveTextField<String>(
                                                        formControlName:
                                                            'gram_$ingredient',
                                                        onChanged: (control) =>
                                                            setState(() {}),
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        showErrors: (control) =>
                                                            false,
                                                        onTap: (control) =>
                                                            _showClear.value =
                                                                List.generate(
                                                                  2,
                                                                  (index) =>
                                                                      false,
                                                                ),
                                                        decoration:
                                                            _inputDecoration(
                                                              '0',
                                                            ),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall
                                                            ?.copyWith(
                                                              color: AppColors
                                                                  .blue,
                                                              fontSize: 17.sp,
                                                            ),
                                                        onSubmitted: (_) =>
                                                            _editingGram.value =
                                                                '',
                                                        onEditingComplete:
                                                            (control) =>
                                                                _editingGram
                                                                        .value =
                                                                    '',
                                                      ),
                                                    ),

                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        left: 4.w,
                                                      ),
                                                      child: Text(
                                                        'g',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .displaySmall
                                                            ?.copyWith(
                                                              fontSize: 17.sp,
                                                              color: AppColors
                                                                  .blue,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            } else {
                                              return GestureDetector(
                                                onTap: () =>
                                                    _editingGram.value =
                                                        ingredient,
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 8.w,
                                                    vertical: 6.h,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.whiteSmoke,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6.r,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    gramValue.isEmpty
                                                        ? 'Gramm'
                                                        : '$gramValue g',
                                                    style: TextStyle(
                                                      color: AppColors.blue,
                                                      fontSize: 17.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                          }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : SizedBox(),
                  ),
                  SizedBox(height: 24.h),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: _boxDecoration(),
                    child: ReactiveTextField<String>(
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontSize: 20.sp,
                        color: AppColors.black,
                      ),
                      onChanged: (control) => setState(() {}),
                      onTap: (control) =>
                          _showClear.value = List.generate(2, (index) => false),
                      formControlName: 'formType',
                      showErrors: (control) => false,
                      decoration: _inputDecoration("Art der Form"),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        decoration: _boxDecoration(),
                        child: Row(
                          children: [
                            IntrinsicWidth(
                              stepWidth: 115.5.w,
                              child: ReactiveTextField<double>(
                                keyboardType: TextInputType.number,
                                onTap: (control) => _showClear.value =
                                    List.generate(2, (index) => false),
                                onChanged: (control) => setState(() {}),
                                showErrors: (control) => false,
                                formControlName: 'temprature',
                                decoration: _inputDecoration('Temperatur'),
                                style: Theme.of(context).textTheme.displayLarge
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
                      Expanded(
                        child: Container(
                          width: 167.5.w,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          decoration: _boxDecoration(),
                          child: ReactiveTextField<Duration>(
                            showErrors: (control) => false,
                            onTap: (control) => _showClear.value =
                                List.generate(2, (index) => false),
                            keyboardType: TextInputType.datetime,
                            valueAccessor: DurationValueAccessor(),
                            formControlName: 'dryingTime',
                            onChanged: (control) => setState(() {}),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^[0-9:]*$'),
                              ),
                            ],
                            decoration: _inputDecoration('Trocknungszeit'),
                            style: Theme.of(context).textTheme.displayLarge
                                ?.copyWith(
                                  fontSize: 17.sp,
                                  color: AppColors.black,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: Theme.of(context).textTheme.displaySmall?.copyWith(
        fontSize: hint != 'Title' ? 17.sp : 20.sp,
        color: hint == 'Gramm'
            ? AppColors.blue
            : hint == '0'
            ? AppColors.blue.withValues(alpha: 0.6)
            : AppColors.payneGrey.withValues(alpha: 0.6),
      ),
      border: InputBorder.none,
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: AppColors.whiteSmoke,
      borderRadius: BorderRadius.circular(16.r),
    );
  }
}
