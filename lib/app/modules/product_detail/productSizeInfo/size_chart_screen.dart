import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/core/constants/app_constants.dart';
import 'package:tajer/app/modules/product_detail/productSizeInfo/size_chart_controller.dart';
import 'package:tajer/app/modules/product_detail/productSizeInfo/size_chart_model.dart';
import 'package:tajer/app/modules/product_detail/product_detail_model.dart';

import '../../../../utils/app_strings.dart';
import '../select_size/select_size_controller.dart';

class SizeChartScreen extends StatefulWidget {
  final String productId;
  final String productName;
  final String productPrice;
  final List<OptionValue> productOptions;

  const SizeChartScreen({
    super.key,
    required this.productId,
    required this.productOptions,
    required this.productName,
    required this.productPrice,
  });

  @override
  State<SizeChartScreen> createState() => _SizeChartScreenState();
}

/// Merged row (chart + option)
class MergedChartRow {
  final List<ChartValue> chartValues;
  final OptionValue? option;

  const MergedChartRow({required this.chartValues, required this.option});
}

class _SizeChartScreenState extends State<SizeChartScreen> {
  late final SizeChartController controller;

  int? selectedSizeIndex;
  bool isCmSelected = true;
  bool _scrollHintShown = false;
  final ScrollController _horizontalScrollController = ScrollController();

  // static const _kFirstColWidth = 120.0;
  static const _kColWidth = 80.0;

  double cmToInch(num cm) => cm / 2.54;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SizeChartController());
    controller
      ..fetchSizeChart(widget.productId)
      ..loadProductDetail(widget.productId);
  }

  double _calculateFirstColumnWidth(
    List<MergedChartRow> mergedRows,
    TextStyle style,
  ) {
    double maxWidth = 0;

    for (final row in mergedRows) {
      final text = row.chartValues.first.value ?? "";
      final tp = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout();

      if (tp.width > maxWidth) {
        maxWidth = tp.width;
      }
    }

    // Add space for Radio button + padding
    return maxWidth + 60;
  }

  void _runScrollHintAfterBuild() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerScrollHintOnce();
    });
  }

  void _triggerScrollHintOnce() async {
    if (_scrollHintShown) return;
    if (!_horizontalScrollController.hasClients) return;

    final maxScroll = _horizontalScrollController.position.maxScrollExtent;
    if (maxScroll <= 0) return; // no overflow = no animation

    _scrollHintShown = true;

    await Future.delayed(const Duration(milliseconds: 300));

    await _horizontalScrollController.animateTo(
      100,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
    );

    await Future.delayed(const Duration(milliseconds: 200));

    await _horizontalScrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  void _animateHorizontalHint() async {
    if (!_horizontalScrollController.hasClients) return;

    await Future.delayed(const Duration(milliseconds: 300));

    // Scroll right a bit
    await _horizontalScrollController.animateTo(
      80, // 👈 small hint distance
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
    );

    await Future.delayed(const Duration(milliseconds: 200));

    // Scroll back
    await _horizontalScrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.black),
          );
        }

        final data = controller.sizeChartModel.value?.data;
        final tables = data?.tableChartData ?? [];
        final hasChart = tables.any(
          (t) => t.chartData?.values?.isNotEmpty == true,
        );

        if (hasChart) {
          _runScrollHintAfterBuild(); // ✅ THIS is the key
        }

        final mergedRows = _mergeChartWithOptions(
          chartRows: tables.first.chartData?.values ?? [],
          options: widget.productOptions,
        );

        final firstColumnWidth = _calculateFirstColumnWidth(
          mergedRows,
          const TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600),
        );

        selectedSizeIndex ??= mergedRows.indexWhere(
          (e) => e.option?.isSelected == "1",
        );

        final sizeChartUrl = data?.sizeChartUrl;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          // 👆 bottom padding so content doesn’t hide behind button
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasChart) ...[
                _header(), // ✅ cm / inch toggle stays
                const SizedBox(height: 20),

                /// 🔁 MULTIPLE TABLES
                ...tables.map((table) {
                  final chartData = table.chartData;
                  if (chartData == null || chartData.values?.isEmpty != false) {
                    return const SizedBox();
                  }

                  final mergedRows = _mergeChartWithOptions(
                    chartRows: chartData.values!,
                    options: widget.productOptions,
                  );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Table title (Dress / Cape)
                      if (tables.length > 1)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            table.sctblName ?? "",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Nunito",
                            ),
                          ),
                        ),
                      SizedBox(height: 10),

                      /// Scrollable table
                      Scrollbar(
                        controller: _horizontalScrollController,
                        thumbVisibility: true,
                        trackVisibility: true,
                        interactive: true,
                        thickness: 4,
                        radius: const Radius.circular(8),
                        child: SingleChildScrollView(
                          controller: _horizontalScrollController,
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _tableHeader(chartData, firstColumnWidth),
                              const Divider(),
                              ..._buildRows(mergedRows, firstColumnWidth),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  );
                }).toList(),

                /// ✅ still shown once
                _measureProduct(data),
              ],

              const SizedBox(height: 24),

              /// ✅ unchanged
              if (sizeChartUrl?.isNotEmpty == true)
                _measureYourself(sizeChartUrl),
            ],
          ),
        );
      }),

      /// 🔒 FIXED ADD TO CART
      bottomNavigationBar: Obx(() {
        if (controller.isLoading.value) {
          return const SizedBox.shrink();
        }

        final data = controller.sizeChartModel.value?.data;
        // final chartData = data?.tableChartData?.first.chartData;
        final chartData =
            (data?.tableChartData != null &&
                (data?.tableChartData ?? []).isNotEmpty)
            ? data?.tableChartData?.first.chartData
            : null;
        final hasChart = chartData?.values?.isNotEmpty == true;

        debugPrint('this is ${hasChart.toString()}');
        if (!hasChart) return const SizedBox.shrink();

        final mergedRows = _mergeChartWithOptions(
          chartRows: chartData!.values!,
          options: widget.productOptions,
        );

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _addToCartButton(mergedRows),
          ),
        );
      }),
    );
  }

  // ────────────────────────────────────────────────────────────────
  // 🔹 MERGE LOGIC
  // ────────────────────────────────────────────────────────────────

  List<MergedChartRow> _mergeChartWithOptions({
    required List<List<ChartValue>> chartRows,
    required List<OptionValue> options,
  }) {
    return chartRows.map((row) {
      final sizeName = row.first.value?.toString().trim().toUpperCase();

      final matchedOption = options.firstWhereOrNull(
        (o) => o.optionvalueName?.trim().toUpperCase() == sizeName,
      );

      return MergedChartRow(chartValues: row, option: matchedOption);
    }).toList();
  }

  // ────────────────────────────────────────────────────────────────
  // 🔹 UI SECTIONS
  // ────────────────────────────────────────────────────────────────

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "APP_SIZE_CHART".tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: "Nunito",
              ),
            ),
            const SizedBox(height: 4),
            Container(width: 100, height: 2.5, color: Colors.black),
          ],
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              _unitButton(
                "in",
                !isCmSelected,
                () => setState(() => isCmSelected = false),
              ),
              _unitButton(
                "cm",
                isCmSelected,
                () => setState(() => isCmSelected = true),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tableHeader(ChartData chartData, double firstColumnWidth) {
    final titles = chartData.titles;
    if (titles == null || titles.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < titles.length; i++)
            SizedBox(
              width: i == 0 ? firstColumnWidth : _kColWidth,
              child: Center(
                child: Text(
                  (titles[i].title ?? "").toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: "Nunito",
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildRows(
    List<MergedChartRow> mergedRows,
    double firstColumnWidth,
  ) {
    return [
      for (int rowIndex = 0; rowIndex < mergedRows.length; rowIndex++)
        _buildRow(mergedRows, rowIndex, firstColumnWidth),
    ];
  }

  Widget _buildRow(
    List<MergedChartRow> mergedRows,
    int rowIndex,
    double firstColumnWidth,
  ) {
    final row = mergedRows[rowIndex];
    final isDisabled = row.option?.isAvailable == "0";

    void onSizeSelected(int? index) {
      if (index == null) return;
      setState(() => selectedSizeIndex = index);
      final selprodId = mergedRows[index].option?.selprodId ?? "";
      controller
        ..fetchSizeChart(selprodId)
        ..loadProductDetail(selprodId);
    }

    return InkWell(
      onTap: isDisabled ? null : () => onSizeSelected(rowIndex),
      child: Opacity(
        opacity: isDisabled ? 0.4 : 1,
        child: Row(
          children: [
            for (
              int colIndex = 0;
              colIndex < row.chartValues.length;
              colIndex++
            )
              _buildCell(
                row.chartValues[colIndex],
                colIndex,
                rowIndex,
                isDisabled,
                firstColumnWidth,
                onSizeSelected,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCell(
    ChartValue cell,
    int colIndex,
    int rowIndex,
    bool isDisabled,
    double firstColumnWidth,
    void Function(int?) onChanged,
  ) {
    if (colIndex == 0) {
      return SizedBox(
        width: firstColumnWidth,
        child: Row(
          children: [
            Radio<int>(
              activeColor: Colors.black,
              value: rowIndex,
              groupValue: selectedSizeIndex,
              onChanged: isDisabled ? null : onChanged,
            ),
            Text(
              cell.value ?? "",
              style: const TextStyle(
                fontFamily: "Nunito",
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: _kColWidth,
      child: Center(
        child: Text(
          _displayValue(cell.value),
          style: const TextStyle(
            fontFamily: "Nunito",
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _measureProduct(SizeChart? data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const Text(
        //   "How to measure the product size?",
        //   style: TextStyle(
        //     fontSize: 16,
        //     fontWeight: FontWeight.w600,
        //     fontFamily: "Nunito",
        //   ),
        // ),
        const SizedBox(height: 8),
        ...(data?.measurementsJson ?? []).map(
          (m) => MeasureSelector(
            title: m.title ?? "",
            adjectives: m.adjectives ?? [],
          ),
        ),
      ],
    );
  }

  Widget _measureYourself(String? imageUrl) {
    if (imageUrl == null) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "APP_HOW_TO_MEASURE_YOURSELF".tr,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: "Nunito",
          ),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            AppConstants.imageBaseURLPath + imageUrl,
            width: double.infinity,
            fit: BoxFit.fitWidth, // width fixed, height auto
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "APP_SIZE_CHART_HELPER_TEXT".tr,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontFamily: "Nunito",
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _addToCartButton(List<MergedChartRow> mergedRows) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: Obx(
        () => ElevatedButton(
          onPressed: (controller.inStock.value == "0")
              ? null
              : () {
                  final selected = mergedRows[selectedSizeIndex!].option;
                  if (selected?.selprodId == null) return;
                  final sizeController = Get.put(
                    SelectSizeController(selected?.selprodId ?? ''),
                  );
                  sizeController.addToCart(
                    selected?.selprodId ?? '',
                    widget.productName,
                    widget.productPrice,
                    comeFromSizeChart: "1",
                  );
                  debugPrint(
                    "ADD TO CART → selProdId = ${selected!.selprodId}",
                  );
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: (controller.inStock.value == "0")
                ? Colors.grey.shade400
                : Colors.black,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                controller.inStock.value == "1"
                    ? AppStrings.appAddToCart.tr
                    : AppStrings.appSoldOut.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: "Nunito",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────
  // 🔹 HELPERS
  // ────────────────────────────────────────────────────────────────

  Widget _unitButton(String text, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: "Nunito",
            color: selected ? Colors.white : Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _displayValue(dynamic value) {
    final numValue = num.tryParse(value?.toString() ?? "");
    if (numValue == null) return value.toString();

    return isCmSelected
        ? numValue.toString()
        : cmToInch(numValue).toStringAsFixed(1);
  }
}

class MeasureSelector extends StatelessWidget {
  final String title;
  final List<MeasurementsJsonAdjective> adjectives;

  const MeasureSelector({
    super.key,
    required this.title,
    required this.adjectives,
  });

  @override
  Widget build(BuildContext context) {
    final selectedIndex = adjectives.indexWhere((a) => a.selected == "1");
    final itemCount = adjectives.length;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          Text(
            title,
            style: const TextStyle(
              fontFamily: "Nunito",
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),

          /// Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: adjectives.map<Widget>((a) {
              return Text(
                a.value ?? "",
                style: const TextStyle(
                  fontFamily: "Nunito",
                  fontSize: 12,
                  color: Colors.grey,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),

          /// Track + Thumb
          LayoutBuilder(
            builder: (context, constraints) {
              final trackWidth = constraints.maxWidth;
              final thumbPosition = itemCount > 1
                  ? (trackWidth / (itemCount - 1)) * selectedIndex
                  : 0.0;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  /// Track
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  /// Thumb
                  Positioned(
                    left: selectedIndex == 0
                        ? thumbPosition
                        : thumbPosition - 25,
                    top: -4,
                    child: Container(
                      width: 30,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
