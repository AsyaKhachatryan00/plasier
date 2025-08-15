import 'package:get/get.dart';
import 'package:plasier/core/config/constants/storage_keys.dart';
import 'package:plasier/core/widgets/utils/shared_prefs.dart';
import 'package:plasier/models/ingredient.dart';
import 'package:plasier/models/recipe.dart';
import 'package:plasier/service_locator.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:uuid/uuid.dart';

class MainController extends GetxController {
  final storage = locator<SharedPrefs>();

  RxBool isPremium = false.obs;
  RxBool isNotsOn = true.obs;

  final RxList<Recipe> _recipes = <Recipe>[].obs;
  RxList<Recipe> get recipes => _recipes;
  final RxList<String> ingredientsList = <String>[].obs;

  final RxString selctedType = ''.obs;

  @override
  void onInit() {
    super.onInit();

    storage.init().then((onValue) async {
      getPremium();
      isNotsOn.value = getNots();
      _recipes.value = getRecipes();
    });

    update();
  }

  void onClear() {
    update();
  }

  void onBackPressed() {
    Get.back();
    onClear();
  }

  void getPremium() {
    isPremium.value = storage.getBool(StorageKeys.isPremium);
  }

  Future<void> setPremium() async {
    isPremium.value = await storage.setBool(StorageKeys.isPremium, true);
    Get.back();
  }

  bool getNots() => storage.getBool(StorageKeys.isNotificationsOn);

  Future<void> setNots(bool value) async {
    await storage.setBool(StorageKeys.isNotificationsOn, value);
    isNotsOn.value = value;
  }

  List<Recipe> getRecipes() {
    List<String> storedEntries = storage.getStringList(StorageKeys.recipe);

    return storedEntries.map((entry) => Recipe.decode(entry)).toList();
  }

  Future<void> saveRecipe({final Recipe? item, required FormGroup form}) async {
    final Recipe recipe = Recipe(
      id: item?.id ?? const Uuid().v4(),
      title: form.control('title').value,
      ingredients: ingredientsList
          .map(
            (ingredient) => Ingredient(
              name: ingredient,
              gram: form.control('gram_$ingredient').value,
            ),
          )
          .toList(),
      formType: form.control('formType').value,
      temprature: form.control('temprature').value,
      dryingTime: form.control('dryingTime').value,
      createdDate: item?.createdDate ?? DateTime.now(),
      status: item?.status ?? Status.dries,
    );

    if (item != null) {
      final element = _recipes.firstWhereOrNull(
        (element) => element.id == item.id,
      );
      if (element != null) {
        final index = _recipes.indexOf(element);
        _recipes
          ..removeAt(index)
          ..insert(index, recipe);
        await _saveRecipe();
        Get.close(2);
      }
    } else {
      _recipes.add(recipe);
      await _addRecipe(recipe);
      _recipes.refresh();
      Get.back();
    }
    ingredientsList.clear();
  }

  Future<void> _addRecipe(Recipe element) async {
    List<String> existingEntries = storage.getStringList(StorageKeys.recipe);
    existingEntries.add(element.encode());

    await storage.setStringList(StorageKeys.recipe, existingEntries);
  }

  Future<void> _saveRecipe() async {
    await storage.setStringList(
      StorageKeys.recipe,
      _recipes.map((entry) => entry.encode()).toList(),
    );
  }

  Future<void> removeRecipe(int index) async {
    _recipes.removeAt(index);
    List<String> existingEntries = storage.getStringList(StorageKeys.recipe);
    existingEntries.removeAt(index);
    storage.setStringList(StorageKeys.recipe, existingEntries);
    Get.back();
  }
}
