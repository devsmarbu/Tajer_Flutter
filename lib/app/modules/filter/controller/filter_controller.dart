import 'package:get/get.dart';
import 'package:tajer/app/modules/product_detail/GetFiltersModel.dart';
import '../../../data/respository/product_repository.dart';
import '../views/brand_list_widget.dart';

enum FilterType { brands, price, size }

class FilterController extends GetxController {
  var selectedFilter = FilterType.brands.obs;
  final _repository = ProductRepository();
  var productFilters = Rxn<GetFiltersModel>();
  var brandSearchText = "".obs;
  // Selected checkboxes
  var selectedOptions = <String>{}.obs;

  void toggleSelection(String value) {
    if (selectedOptions.contains(value)) {
      selectedOptions.remove(value);
    } else {
      selectedOptions.add(value);
    }
  }

  Future<GetFiltersModel?> getFilters(
    String keyword,
    String category,
    String shop_id,
    String featured,
    String top_products,
    String brand_id,
  ) async {
    try {
      final response = await _repository.getFilters(
        keyword,
        category,
        shop_id,
        featured,
        top_products,
        brand_id,
      );
      productFilters.value = response;
      if (response != null) {
        print("✅ get filter success");
        return response;
      }
    } catch (e) {
      print("❌ get filter error: $e");
    }
    return null;
  }

  void clearSelections() {
    selectedOptions.clear();
  }

  List<OptionsList> getFilteredBrands(List<OptionsList> brands) {
    if (brandSearchText.value.isEmpty) return brands;

    return brands
        .where((b) =>
        b.optionName.toLowerCase().contains(brandSearchText.value.toLowerCase()))
        .toList();
  }
}
