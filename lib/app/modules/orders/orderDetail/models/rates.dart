class Rates {
  final String code;
  final String totalShippingCost;
  final List<Data> data;

  Rates({
    required this.code,
    required this.totalShippingCost,
    required this.data,
  });
}

class Data {
  final String id;
  final String title;
  final String cost;
  final int productType;
  bool allCheck;
  final String carrierCode;
  final String serviceCode;
  final String mshipapiCode;
  final String mshipapiLabel;
  final String mshipapiCarrier;
  final String mshipapiType;
  final dynamic mshipapiCost;
  String currencySymbol;
  bool selected;

  Data({
    required this.id,
    required this.title,
    required this.cost,
    required this.productType,
    this.allCheck = false,
    required this.carrierCode,
    required this.serviceCode,
    required this.mshipapiCode,
    required this.mshipapiLabel,
    required this.mshipapiCarrier,
    required this.mshipapiType,
    this.mshipapiCost,
    required this.currencySymbol,
    this.selected = false,
  });

  @override
  String toString() {
    if (productType == 1 && !allCheck) { // Replace 1 with Constants.PREORDER equivalent
      return title;
    } else {
      return "$title ( $cost )";
    }
  }
}