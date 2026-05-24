class ReasonsItem {
  String? value;
  String? key;
  String? isImageRequired;
  bool? selected;

  ReasonsItem({this.value, this.key, this.selected,this.isImageRequired});

  factory ReasonsItem.fromJson(Map<String, dynamic> json) {
    return ReasonsItem(
      value: json['value'],
      key: json['key'],
      isImageRequired: json['isImageRequired'],
      selected: json['selected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "value": value,
    "key": key,
    "isImageRequired": isImageRequired,
    "selected": selected,
  };
}