import '../../data/service/api_service/api_service.dart';
import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';

mixin AddressApiClient{
  final ApiService _api = ApiService();

  Future<Response> getAddressListApi() async {
    return await _api.dio.get(
      AppConstants.searchAddress
    );
  }

  Future<Response> setDefaultAddressApi(String id) async {
    return await _api.dio.post(
      AppConstants.setDefaultAddress,
        data: FormData.fromMap({"id": id})

    );
  }

  Future<Response> deleteAddressApi(String id) async {
    return await _api.dio.post(
      AppConstants.deleteRecord,
        data: FormData.fromMap({"id": id})

    );
  }


  Future<Response> setUpAddress(
      String addressTitle,String addressName,String addressLine1,String addressLine2,
      String addCountryId,String addStateId,String addCity,String addZip,
      String addPhone,String addId,String isDefault,String addPhoneDcode,
      String addZone,String addStreet,String addBuildingNo,String addUnitNo,
      String addPhoneOtp
      ) async {
    return await _api.dio.post(
        AppConstants.setUpAddress,
        data: FormData.fromMap({
          "addr_title": addressTitle, "addr_name": addressName,
          "addr_address1": addressLine1, "addr_address2": addressLine2,
          "addr_country_id": addCountryId, "addr_state_id": addStateId,
          "addr_city": addCity, "addr_zip": addZip,
          "addr_phone": addPhone, "addr_id": addId,
          "isDefault": isDefault, "addr_phone_dcode": addPhoneDcode,
          "addr_zone": addZone, "addr_street": addStreet,
          "addr_building_no": addBuildingNo, "addr_unit_no": addUnitNo,
          "addr_phone_otp": addPhoneOtp,
        })

    );
  }

  Future<Response> getCountryListApi() async {
    return await _api.dio.post(
        AppConstants.getCountryList
    );
  }

  Future<Response> getStateListApi(String id) async {
    return await _api.dio.post(
        AppConstants.getStateList+id
    );
  }

  Future<Response> verifyPhoneCodeApi(
      String phoneCode,String phoneNumber
      ) async {
    return await _api.dio.post(
        AppConstants.verifyPhoneApi,
        data: FormData.fromMap({
          "phone_code": phoneCode, "phone_number": phoneNumber
        })

    );
  }

}