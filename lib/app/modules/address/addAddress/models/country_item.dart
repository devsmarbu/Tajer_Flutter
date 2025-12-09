class CountryItem {
  String? name;
  String? id;

  CountryItem({this.name, this.id});

  factory CountryItem.fromJson(Map<String, dynamic> json) => CountryItem(
    name: json["name"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
  };
}