class VendorReturnAddress {
  String? uralangUserId;
  String? uralangLangId;
  String? uraName;
  String? uraCity;
  String? uraAddressLine1;
  String? uraAddressLine2;
  String? countryName;
  String? stateName;
  String? uraUserId;
  String? uraStateId;
  String? uraCountryId;
  String? uraZip;
  String? uraPhoneDcode;
  String? uraPhone;

  VendorReturnAddress({
    this.uralangUserId,
    this.uralangLangId,
    this.uraName,
    this.uraCity,
    this.uraAddressLine1,
    this.uraAddressLine2,
    this.countryName,
    this.stateName,
    this.uraUserId,
    this.uraStateId,
    this.uraCountryId,
    this.uraZip,
    this.uraPhoneDcode,
    this.uraPhone,
  });

  factory VendorReturnAddress.fromJson(Map<String, dynamic> json) =>
      VendorReturnAddress(
        uralangUserId: json["uralang_user_id"]?.toString(),
        uralangLangId: json["uralang_lang_id"]?.toString(),
        uraName: json["ura_name"]?.toString(),
        uraCity: json["ura_city"]?.toString(),
        uraAddressLine1: json["ura_address_line_1"]?.toString(),
        uraAddressLine2: json["ura_address_line_2"]?.toString(),
        countryName: json["country_name"]?.toString(),
        stateName: json["state_name"]?.toString(),
        uraUserId: json["ura_user_id"]?.toString(),
        uraStateId: json["ura_state_id"]?.toString(),
        uraCountryId: json["ura_country_id"]?.toString(),
        uraZip: json["ura_zip"]?.toString(),
        uraPhoneDcode: json["ura_phone_dcode"]?.toString(),
        uraPhone: json["ura_phone"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
    "uralang_user_id": uralangUserId,
    "uralang_lang_id": uralangLangId,
    "ura_name": uraName,
    "ura_city": uraCity,
    "ura_address_line_1": uraAddressLine1,
    "ura_address_line_2": uraAddressLine2,
    "country_name": countryName,
    "state_name": stateName,
    "ura_user_id": uraUserId,
    "ura_state_id": uraStateId,
    "ura_country_id": uraCountryId,
    "ura_zip": uraZip,
    "ura_phone_dcode": uraPhoneDcode,
    "ura_phone": uraPhone,
  };
}
