class CategoryItem {
  final String title;
  final String? image;

  CategoryItem({required this.title, this.image});

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      title: json['title'],
      image: json['image'],
    );
  }
}