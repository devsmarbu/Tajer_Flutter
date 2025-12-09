import 'package:flutter/material.dart';
import 'package:tajer/app/Extensions/convert_extension.dart';

class PriceRangeWidget extends StatefulWidget {
  final String? minimumPriceRange;
  final String? maximumPriceRange;
  final String currencySymbol;
  final Function(RangeValues) rangeValues;

  const PriceRangeWidget({
    super.key,
    this.minimumPriceRange,
    this.maximumPriceRange,
    required this.currencySymbol,
    required this.rangeValues,
  });

  @override
  _PriceRangeWidgetState createState() => _PriceRangeWidgetState();
}

class _PriceRangeWidgetState extends State<PriceRangeWidget> {
  late final minimumRange = double.parse(widget.minimumPriceRange ?? "");
  late final maximumRange = double.parse(widget.maximumPriceRange ?? "");
  late RangeValues _currentRange = RangeValues(minimumRange, maximumRange);

  void _resetRange() {
    setState(() {
      _currentRange = RangeValues(minimumRange, maximumRange);
      widget.rangeValues(_currentRange);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title & Reset
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Price Range',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: _resetRange,
                child: const Text(
                  'Reset',
                  style: TextStyle(
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Min and Max labels
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Min. Price', style: TextStyle(fontSize: 16)),
              Text('Max Price', style: TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 10),

          // Slider
          RangeSlider(
            values: _currentRange,
            min: double.parse(widget.minimumPriceRange ?? ""),
            max: double.parse(widget.maximumPriceRange ?? ""),
            divisions: 500,
            onChanged: (RangeValues values) {
              setState(() {
                _currentRange = values;
                widget.rangeValues(_currentRange);
              });
            },
            activeColor: Colors.black,
            inactiveColor: Colors.black.withValues(alpha: 0.3),
            labels: RangeLabels(
              "${widget.currencySymbol}${_currentRange.start.toStringAsFixed(0)}",
              "${widget.currencySymbol}${_currentRange.end.toStringAsFixed(0)}",
            ),
          ),

          // Values under the slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${widget.currencySymbol}${_currentRange.start.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                "${widget.currencySymbol}${_currentRange.end.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
