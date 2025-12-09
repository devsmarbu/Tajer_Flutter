class NetPayable {
  String? key;
  String? value;

  NetPayable({this.key, this.value});

  factory NetPayable.fromJson(Map<String, dynamic> json) {
    return NetPayable(
      key: json['key'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() => {
    'key': key,
    'value': value,
  };
}