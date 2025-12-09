import 'package:get/get.dart';
import 'package:tajer/app/data/respository/category_repository.dart';
import 'models/category.dart';

class CategoryController extends GetxController {
  final _repository = CategoryRepository();

  var isLoading = true.obs;
  var categories = <NewCategory>[].obs;
  var selectedIndex = 0.obs;
  var selectedTab = 0.obs;
  final Rxn<CategoryModel> categoryModel = Rxn<CategoryModel>();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading(true);
      final response = await _repository.fetchCategoryListData(parentId: "");
      if (response != null) {
        categoryModel.value = response;
        categories.assignAll(response.data?.categories ?? []);
        if (categories.isNotEmpty) {
          categories.removeAt(0);
        }
      }
    } catch (e) {
      print("❌ fetchCategories error: $e");
    } finally {
      isLoading(false);
    }
  }
}