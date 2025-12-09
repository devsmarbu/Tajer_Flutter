class Language {
  final String languageId;
  final String languageCode;
  final String languageCountryCode;
  final String languageName;
  final String languageActive;
  final String languageCss;
  final String languageLayoutDirection;
  final String isSiteDefaultLang;

  Language({
    required this.languageId,
    required this.languageCode,
    required this.languageCountryCode,
    required this.languageName,
    required this.languageActive,
    required this.languageCss,
    required this.languageLayoutDirection,
    required this.isSiteDefaultLang,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      languageId: json['language_id'] ?? '',
      languageCode: json['language_code'] ?? '',
      languageCountryCode: json['language_country_code'] ?? '',
      languageName: json['language_name'] ?? '',
      languageActive: json['language_active'] ?? '',
      languageCss: json['language_css'] ?? '',
      languageLayoutDirection: json['language_layout_direction'] ?? 'ltr',
      isSiteDefaultLang: json['isSiteDefaultLang'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'language_id': languageId,
    'language_code': languageCode,
    'language_country_code': languageCountryCode,
    'language_name': languageName,
    'language_active': languageActive,
    'language_css': languageCss,
    'language_layout_direction': languageLayoutDirection,
    'isSiteDefaultLang': isSiteDefaultLang,
  };
}
