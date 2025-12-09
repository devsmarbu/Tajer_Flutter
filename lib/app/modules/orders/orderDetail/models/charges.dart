class Charges {
  String? opchargeType;
  String? opchargeAmount;

  Charges({this.opchargeType, this.opchargeAmount});

  factory Charges.fromJson(Map<String, dynamic> json) => Charges(
    opchargeType: json['opcharge_type']?.toString(),
    opchargeAmount: json['opcharge_amount']?.toString(),
  );

  Map<String, dynamic> toJson() => {
    'opcharge_type': opchargeType,
    'opcharge_amount': opchargeAmount,
  };
}
