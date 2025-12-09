class AddressModel {
  String title;
  String name;
  String address;
  String phone;
  String? tag;

  AddressModel({
    required this.title,
    required this.name,
    required this.address,
    required this.phone,
    this.tag,
  });
}
