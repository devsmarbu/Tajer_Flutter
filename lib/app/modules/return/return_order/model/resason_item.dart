class ReasonsItem {
  String? value;
  String? key;
  bool? selected;

  ReasonsItem({this.value, this.key, this.selected});

  factory ReasonsItem.fromJson(Map<String, dynamic> json) {
    return ReasonsItem(
      value: json['value'],
      key: json['key'],
      selected: json['selected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "value": value,
    "key": key,
    "selected": selected,
  };
}