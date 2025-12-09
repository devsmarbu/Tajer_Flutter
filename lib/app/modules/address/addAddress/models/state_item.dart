class StateItem {
  String? name;
  String? id;

  StateItem({this.name, this.id});

  factory StateItem.fromJson(Map<String, dynamic> json) => StateItem(
    name: json["name"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
  };
}