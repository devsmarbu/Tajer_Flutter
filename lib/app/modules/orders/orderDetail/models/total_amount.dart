class TotalAmount {
  String? currencySymbol;
  String? totalAmount;

  TotalAmount({this.currencySymbol, this.totalAmount});

  factory TotalAmount.fromJson(Map<String, dynamic> json) => TotalAmount(
    currencySymbol: json['currencySymbol']?.toString(),
    totalAmount: json['totalAmount']?.toString(),
  );

  Map<String, dynamic> toJson() => {
    'currencySymbol': currencySymbol,
    'totalAmount': totalAmount,
  };
}
