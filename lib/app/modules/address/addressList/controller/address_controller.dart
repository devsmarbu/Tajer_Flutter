import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/address/addressList/models/address_data.dart';
import 'package:tajer/app/modules/address/address_api_client.dart';
import 'package:tajer/app/modules/orders/orderDetail/models/address.dart';
import 'package:tajer/common/functions/app_function.dart';
import 'package:tajer/utils/app_loader.dart';
import '../../../../../common/widgets/app_dialog.dart';
import '../../../../../utils/app_dialog.dart';
import '../../../../../utils/app_strings.dart';
import '../../../../../utils/base_response.dart';
import '../../../../../utils/common_data.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/routes/app_routes.dart';

class AddressController extends GetxController
    with AddressApiClient, AppLoader {
  var isLoading = false.obs;

  var addresses = <Address>[].obs;
  Map<String, String> verifiedNumbers = {};

  var selectedIndex = (0).obs;
  var comeFromCartValue = "0";
  var addressIsDefault = "0";

  @override
  void onInit() {
    super.onInit();
    final comeFromCart = (Get.arguments != null && Get.arguments is Map)
        ? Get.arguments["comeFromCart"] ?? "0"
        : "0";
    debugPrint("come from cart value $comeFromCart");
    comeFromCartValue = comeFromCart;
    getAddressList();
  }

  void selectAddress(String addrId,String addIsDefault) {
    addressIsDefault = addIsDefault;
    selectedIndex.value = 0;
    setDefaultAddress(addrId);
  }

  void editAddress(int index) async {
    final result = await Get.toNamed(
      AppRoutes.addNewAddress,
      arguments: {
        "verifiedNumbers": verifiedNumbers,
        "addressDetail": addresses[index],
        "addressIsDefault": addresses[index].addrIsDefault,
      },
    );

    // ✅ Refresh list automatically after address added
    if (result == true) {
      await getAddressList();
    }
  }

  Future<void> addAddress() async {
    final result = await Get.toNamed(
      AppRoutes.addNewAddress,
      arguments: {"verifiedNumbers": verifiedNumbers},
    );

    // ✅ Refresh list automatically after address added
    if (result == true) {
      await getAddressList();
    }
  }

  void deleteAddressDialog(Address address, BuildContext context) async {
    final result = await AppDialogs.showConfirmationDialog(
      context,
      message: AppStrings.app_want_to_delete,
    );

    if (result == true) {
      deleteAddress(address);
    }
  }

  Future<void> getAddressList() async {
    if (await AppFunction.isInternetAvailable()) {
      try {
        isLoading.value = true;
        // showLoader(Get.context!);

        final response = await getAddressListApi();

        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final addressData = BaseResponse<AddressData>.fromJson(
          body,
          fromJsonT: (data) => AddressData.fromJson(data),
        );

        if (addressData.responseCode == "200") {
          if (addressData.status == AppConstants.SUCCESS) {
            addresses.assignAll(
              addressData.data?.addresses as Iterable<Address>,
            );
            if (addressData.data?.verifiedNumbers != null) {
              verifiedNumbers = Map<String, String>.from(
                addressData.data!.verifiedNumbers!,
              );
            }
          } else {
            isLoading.value = false;
            debugPrint(addressData.msg);
            addresses.assignAll([]);
            // AppDialog.showMessage(addressData.msg);
          }
        } else {
          isLoading.value = false;
          debugPrint("qwertyu");
          debugPrint(addressData.msg);
          addresses.value = [];
          verifiedNumbers = {};
          AppDialog.showMessage(addressData.msg);
        }
      } catch (e) {
        print('❌ Exception in fetchSplashScreenData: $e');
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> setDefaultAddress(String id) async {
    if (await AppFunction.isInternetAvailable()) {
      try {
        isLoading.value = true;

        final response = await setDefaultAddressApi(id);

        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final data = BaseResponse<CommonData>.fromJson(
          body,
          fromJsonT: (data) => CommonData.fromJson(data),
        );

        if (data.responseCode == "200") {
          if (data.status == AppConstants.SUCCESS) {
            debugPrint("come from cart value$comeFromCartValue");
            if (comeFromCartValue == "1") {
              debugPrint("come from cart");
              Future.delayed(Duration(milliseconds: 100), () {
                // Get.back(result: comeFromCartValue);
                Navigator.of(Get.context!).pop(comeFromCartValue);
              });
            } else {
              getAddressList();
            }
          } else {
            AppDialog.showMessage(data.msg);
          }
        } else {
          AppDialog.showMessage(data.msg);
        }
      } catch (e) {
        print('❌ Exception in fetchSplashScreenData: $e');
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> deleteAddress(Address address) async {
    if (await AppFunction.isInternetAvailable()) {
      try {
        isLoading.value = true;

        final response = await deleteAddressApi(address.addrId ?? "");

        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final data = BaseResponse<CommonData>.fromJson(
          body,
          fromJsonT: (data) => CommonData.fromJson(data),
        );

        if (data.responseCode == "200") {
          if (data.status == AppConstants.SUCCESS) {
            addresses.remove(address);
          } else {
            AppDialog.showMessage(data.msg);
          }
        } else {
          AppDialog.showMessage(data.msg);
        }
      } catch (e) {
        print('❌ Exception in fetchSplashScreenData: $e');
      } finally {
        isLoading.value = false;
      }
    }
  }
}
