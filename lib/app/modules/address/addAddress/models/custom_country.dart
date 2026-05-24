class CustomCountry {
  final String code;
  final String dialCode;
  final String nameEn;
  final String nameAr;
  final String flag;

  CustomCountry({
    required this.code,
    required this.dialCode,
    required this.nameEn,
    required this.nameAr,
    required this.flag,
  });

  String getName(String lang) {
    if (lang.toLowerCase() == "ar") {
      return nameAr;
    }
    return nameEn;
  }
}