class TaxOption {
  String? name;
  String? value;

  TaxOption({this.name, this.value});

  factory TaxOption.fromJson(Map<String, dynamic> json) => TaxOption(
    name: json['name']?.toString(),
    value: json['value']?.toString(),
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'value': value,
  };
}
