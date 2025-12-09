class CustomRateData {
  bool isSelected;
  String id;

  CustomRateData({
    required this.isSelected,
    required this.id,
  });

  factory CustomRateData.fromJson(Map<String, dynamic> json) {
    return CustomRateData(
      isSelected: json['isSelected'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isSelected': isSelected,
      'id': id,
    };
  }
}
