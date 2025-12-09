class MainRateData {
  String title;
  String id;
  String? rating;

  MainRateData({
    required this.title,
    required this.id,
    this.rating,
  });

  factory MainRateData.fromJson(Map<String, dynamic> json) {
    return MainRateData(
      title: json['title'],
      id: json['id'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'id': id,
      'rating': rating,
    };
  }
}
