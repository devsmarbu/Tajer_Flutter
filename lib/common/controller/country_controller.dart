import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../app/modules/address/addAddress/models/custom_country.dart';

class CountryController extends GetxController {
  RxList<CustomCountry> countries = <CustomCountry>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    print("🔥 CountryController INIT");
    loadCountries();
  }

  Future<void> loadCountries() async {
    try {
      print("🚀 Loading countries...");

      final data = await rootBundle.loadString('assets/assets/countries.json');

      final List jsonList = json.decode(data);

      countries.value = jsonList.map((e) => CustomCountry(
        code: e['code'],
        dialCode: e['dial_code'],
        nameEn: e['name_en'],
        nameAr: e['name_ar'],
        flag: e['flag'],
      )).toList();

      print("✅ Loaded countries: ${countries.length}");

    } catch (e) {
      print("❌ ERROR loading countries: $e");
    } finally {
      isLoading.value = false; // 🔥 VERY IMPORTANT
    }
  }
}