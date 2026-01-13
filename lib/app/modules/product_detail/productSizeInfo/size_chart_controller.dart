import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/product_detail/productSizeInfo/size_chart_model.dart';
import 'package:tajer/common/widgets/app_dialog.dart';
import '../../../data/respository/product_repository.dart';
import '../product_detail_model.dart';

class SizeChartController extends GetxController {
  final ProductRepository _repository = ProductRepository();

  /// UI state
  final isLoading = false.obs;
  final selectedSizeIndex = RxnInt();
  final isCmSelected = true.obs;
  bool _isRequesting = false;
  final RxList<Datum> productSections = <Datum>[].obs;
  RxString inStock = "1".obs;


  /// API model
  final sizeChartModel = Rxn<SizeChartModel>();

  /// Shortcuts (safe access)
  SizeChart? get data => sizeChartModel.value?.data;
  ChartData? get chartData => data?.chartData;
  List<MeasurementsJson> get measurements =>
      data?.measurementsJson ?? [];
  String get sizeChartUrl => data?.sizeChartUrl ?? "";

  /// Init
  Future<void> fetchSizeChart(String productId) async {
    final hasData = sizeChartModel.value != null;

    try {
      // 🔥 Show loader ONLY if no data yet
      if (!hasData) {
        isLoading.value = true;
      }

      final response =
      await _repository.fetchSizeChartGuide(productId, 1);

      if (response == null) {
        if (!hasData) {
          AppDialog.showMessage("Failed to load size chart");
        }
        return;
      }

      if (response.status == "0") {
        if (!hasData) {
          AppDialog.showMessage(response.msg ?? "Something went wrong");
        }
        return;
      }

      sizeChartModel.value = response;
    } finally {
      // 🔥 Hide loader ONLY if it was shown
      if (!hasData) {
        isLoading.value = false;
      }
    }
  }

  Future<void> loadProductDetail(String productId) async {
    if (_isRequesting) return;
    _isRequesting = true;
    isLoading(true);

    try {
     final result = await _repository.fetchProductDetail(productId, 1);
     final productDetailSection = result?.data?.data?.firstWhereOrNull(
                   (d) => d.customType == ProductDetailType.productDetail,
             );
      inStock.value = productDetailSection?.content?.productDetail?.inStock ?? "0";
      debugPrint("here it is instock value");
      debugPrint(inStock.value);
    } catch (e, s) {
      debugPrint("❌ Error loading product detail: $e");
      debugPrint("$s");
      isLoading(false);
    } finally {
      isLoading(false);
      _isRequesting = false;
    }
  }


  /// Unit toggle
  void toggleUnit(bool isCm) {
    isCmSelected.value = isCm;
  }

  /// Select size row
  void selectSize(int index) {
    selectedSizeIndex.value = index;
  }

  /// Convert + display value
  double _cmToInch(num cm) => cm / 2.54;

  String displayValue(ChartValue value) {
    final raw = value.value;

    if (raw == null) return "-";

    final numValue = num.tryParse(raw);
    if (numValue == null) return raw;

    return isCmSelected.value
        ? numValue.toString()
        : _cmToInch(numValue).toStringAsFixed(1);
  }
}