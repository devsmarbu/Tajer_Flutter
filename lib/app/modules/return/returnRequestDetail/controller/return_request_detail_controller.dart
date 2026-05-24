import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image/image.dart';
import 'package:tajer/app/core/routes/app_routes.dart';
import 'package:tajer/utils/app_strings.dart';
import 'package:tajer/utils/common_data.dart';
import 'package:tajer/utils/pref_store.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../common/functions/app_function.dart';
import '../../../../../common/widgets/app_dialog.dart';
import '../../../../../utils/app_params.dart';
import '../../../../../utils/base_response.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../data/service/return_request_api_client.dart';
import '../model/exchange_detail_data.dart';
import '../model/request_detail_response.dart';
import '../model/vendor_return_address.dart';


class ReturnRequestDetailController extends GetxController with ReturnRequestApiClient,AppFunction {

  var isLoading = false.obs;
  var downloadLink='';
  var canWithdrawRequest=''.obs;
  var requestId='';
  final pref=PrefStore();
  var screenTitle = ''.obs;
  var uraName=''.obs;
  var address=''.obs;
  var requestReference=''.obs;
  var qty=''.obs;
  var date=''.obs;
  var productName=''.obs;
  var reasonTitle=''.obs;
  var requestType=''.obs;
  var amount=''.obs;
  var requestStatusTitle=''.obs;


  @override
  void onInit() {
    super.onInit();

    // Read arguments once
    final args = Get.arguments ?? {};
    requestId = args['requestId'] ?? '';
    screenTitle.value = args['title'] ?? '';

    // Call appropriate API
    debugPrint(screenTitle.value);
    debugPrint('requestId $requestId');
    if (screenTitle.value == 'APP_RETURN_REQUEST_DETAILS'.tr) {
      getReturnRequestDetail(requestId);
    }else if (screenTitle.value == 'APP_EXCHANGE_REQUEST_DETAILS'.tr) {
      getExchangeRequestDetail(requestId);
    }else if (screenTitle.value == 'APP_MISSING_REQUEST_DETAIL'.tr) {
      getMissingRequestDetail(requestId);
    } else {
      getCancelRequestDetail(requestId);
    }
  }

  void withdrawRequestClick() {
   withdrawReturnRequest(requestId);
  }

  void openMessages() {
    Get.toNamed(AppRoutes.chatScreen,arguments: {
      AppParams.threadId:'',
      AppParams.title:requestReference.value,
      AppParams.orRequestId:requestId,
      AppParams.getCanWithdrawRequest:canWithdrawRequest,
      AppParams.screenTitle:screenTitle,
    });
  }

  void downloadAttachment() {
    getTempToken();
  }

  Future<void> getReturnRequestDetail(String requestId) async {

    //  if (currentPage >= lastPage) return;
    this.requestId=requestId;

    if(await AppFunction.isInternetAvailable()){
      try {
        isLoading.value = true;

        final response = await getRequestDetailApi(requestId);

        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final requestData = BaseResponse<RequestDetailResponse>.fromJson(
          body,
          fromJsonT: (data) => RequestDetailResponse.fromJson(data),
        );

        if(requestData.responseCode=="200"){
          if(requestData.status==AppConstants.SUCCESS){

            final requestResponse = requestData.data!;
            setAddressValue(requestResponse.vendorReturnAddress);

            canWithdrawRequest.value=requestResponse.canWithdrawRequest??"";
            downloadLink=requestResponse.requestdetail?.attachmentFile??"";
            requestReference.value=requestResponse.requestdetail?.orrequestReference??"";
            qty.value= requestResponse.requestdetail?.orrequestQty??"";
            date.value=AppFunction.getDateFormat(requestResponse.requestdetail?.orrequestDate??"", "dd-MMM-yyyy, HH:mm");

            final detail = requestResponse.requestdetail;
            productName.value = [
              detail?.opSelprodTitle,
              (detail?.opBrandName?.trim().isNotEmpty ?? false)
                  ? "Brand: ${detail!.opBrandName}"
                  : null,
              (detail?.opSelprodSku?.trim().isNotEmpty ?? false)
                  ? "SKU: ${detail!.opSelprodSku}"
                  : null,
              (detail?.opProductModel?.toString().trim().isNotEmpty ?? false)
                  ? "Model: ${detail!.opProductModel}"
                  : null,
            ]

                .where((e) => e != null && e.trim().isNotEmpty)
                .join('\n');

            reasonTitle.value=requestResponse.requestdetail?.orReasonTitle??"";
            requestType.value=requestResponse.requestdetail?.orrequestTypeTitle??"";
            amount.value=requestResponse.requestdetail?.opRefundAmount??"";
            requestStatusTitle.value=requestResponse.requestdetail?.orRequestStatusTitle??"";

          }else{
            AppDialog.showMessage(requestData.msg);
          }
        }else{
          AppDialog.showMessage(requestData.msg);
        }

      } catch (e) {
        print('❌ Exception in fetchSplashScreenData: $e');
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> getExchangeRequestDetail(String requestId) async {

    //  if (currentPage >= lastPage) return;
    this.requestId=requestId;

    if(await AppFunction.isInternetAvailable()){
      try {
        isLoading.value = true;

        final response = await getExchangeRequestDetailApi(requestId);

        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final requestData = BaseResponse<ExchangeDetailData>.fromJson(
          body,
          fromJsonT: (data) => ExchangeDetailData.fromJson(data),
        );

        if(requestData.responseCode=="200"){
          if(requestData.status==AppConstants.SUCCESS){

            final exchangeDetailData = requestData.data!;
            setAddressValue(exchangeDetailData.vendorReturnAddress);

            canWithdrawRequest.value=exchangeDetailData.canWithdrawRequest??"";
            downloadLink=exchangeDetailData.request?.attachmentFile??"";

            requestReference.value=exchangeDetailData.request?.oerequestReference??"";
            qty.value= exchangeDetailData.request?.oerequestQty??"";
            date.value=AppFunction.getDateFormat(exchangeDetailData.request?.oerequestDate??"", "dd-MMM-yyyy, HH:mm");

            final detail = exchangeDetailData.request;
            productName.value = [
              detail?.opSelprodTitle,
              (detail?.opBrandName?.trim().isNotEmpty ?? false)
                  ? "Brand: ${detail!.opBrandName}"
                  : null,
              (detail?.opSelprodSku?.trim().isNotEmpty ?? false)
                  ? "SKU: ${detail!.opSelprodSku}"
                  : null,
              (detail?.opProductModel?.toString().trim().isNotEmpty ?? false)
                  ? "Model: ${detail!.opProductModel}"
                  : null,
            ]
                .where((e) => e != null && e.trim().isNotEmpty)
                .join('\n');

            reasonTitle.value=exchangeDetailData.request?.orreasonTitle??"";

          }else{
            AppDialog.showMessage(requestData.msg);
          }
        }else{
          AppDialog.showMessage(requestData.msg);
        }

      } catch (e) {
        print('❌ Exception in fetchSplashScreenData: $e');
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> getMissingRequestDetail(String requestId) async {

    //  if (currentPage >= lastPage) return;
    this.requestId=requestId;

    if(await AppFunction.isInternetAvailable()){
      try {
        isLoading.value = true;

        final response = await getMissingRequestDetailApi(requestId);

        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final requestData = BaseResponse<RequestDetailResponse>.fromJson(
          body,
          fromJsonT: (data) => RequestDetailResponse.fromJson(data),
        );

        if(requestData.responseCode=="200"){
          if(requestData.status==AppConstants.SUCCESS){

            final requestResponse = requestData.data!;
            setAddressValue(requestResponse.vendorReturnAddress);

            canWithdrawRequest.value=requestResponse.canWithdrawRequest??"";
            downloadLink=requestResponse.requestdetail?.attachmentFile??"";
            requestReference.value=requestResponse.requestdetail?.orrequestReference??"";
            qty.value= requestResponse.requestdetail?.orrequestQty??"";
            date.value=AppFunction.getDateFormat(requestResponse.requestdetail?.orrequestDate??"", "dd-MMM-yyyy, HH:mm");

            final detail = requestResponse.requestdetail;
            productName.value = [
              detail?.opSelprodTitle,
              (detail?.opBrandName?.trim().isNotEmpty ?? false)
                  ? "Brand: ${detail!.opBrandName}"
                  : null,
              (detail?.opSelprodSku?.trim().isNotEmpty ?? false)
                  ? "SKU: ${detail!.opSelprodSku}"
                  : null,
              (detail?.opProductModel?.toString().trim().isNotEmpty ?? false)
                  ? "Model: ${detail!.opProductModel}"
                  : null,
            ]

                .where((e) => e != null && e.trim().isNotEmpty)
                .join('\n');

            reasonTitle.value=requestResponse.requestdetail?.orReasonTitle??"";
            requestType.value=requestResponse.requestdetail?.orrequestTypeTitle??"";
            amount.value=requestResponse.requestdetail?.opRefundAmount??"";
            requestStatusTitle.value=requestResponse.requestdetail?.orRequestStatusTitle??"";

          }else{
            AppDialog.showMessage(requestData.msg);
          }
        }else{
          AppDialog.showMessage(requestData.msg);
        }

      } catch (e) {
        print('❌ Exception in fetchSplashScreenData: $e');
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> getCancelRequestDetail(String requestId) async {

    //  if (currentPage >= lastPage) return;
    this.requestId=requestId;

    if(await AppFunction.isInternetAvailable()){
      try {
        isLoading.value = true;

        final response = await getCancelRequestDetailApi(requestId);

        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final requestData = BaseResponse<RequestDetailResponse>.fromJson(
          body,
          fromJsonT: (data) => RequestDetailResponse.fromJson(data),
        );

        if(requestData.responseCode=="200"){
          if(requestData.status==AppConstants.SUCCESS){

            final requestResponse = requestData.data!;
            setAddressValue(requestResponse.vendorReturnAddress);

            canWithdrawRequest.value=requestResponse.canWithdrawRequest??"";
            downloadLink=requestResponse.requestdetail?.attachmentFile??"";
            requestReference.value=requestResponse.requestdetail?.orrequestReference??"";
            qty.value= requestResponse.requestdetail?.orrequestQty??"";
            date.value=AppFunction.getDateFormat(requestResponse.requestdetail?.orrequestDate ?? requestResponse.requestdetail?.ocrequestDate??"", "dd-MMM-yyyy, HH:mm");

            final detail = requestResponse.requestdetail;
            productName.value = [
              detail?.opSelprodTitle,
              (detail?.opBrandName?.trim().isNotEmpty ?? false)
                  ? "Brand: ${detail!.opBrandName}"
                  : null,
              (detail?.opSelprodSku?.trim().isNotEmpty ?? false)
                  ? "SKU: ${detail!.opSelprodSku}"
                  : null,
              (detail?.opProductModel?.toString().trim().isNotEmpty ?? false)
                  ? "Model: ${detail!.opProductModel}"
                  : null,
            ]

                .where((e) => e != null && e.trim().isNotEmpty)
                .join('\n');

            reasonTitle.value=requestResponse.requestdetail?.orReasonTitle??"";
            requestType.value=requestResponse.requestdetail?.orrequestTypeTitle??"";
            amount.value=requestResponse.requestdetail?.opRefundAmount??"";
            requestStatusTitle.value=requestResponse.requestdetail?.orRequestStatusTitle??"";

          }else{
            AppDialog.showMessage(requestData.msg);
          }
        }else{
          AppDialog.showMessage(requestData.msg);
        }

      } catch (e) {
        print('❌ Exception in fetchSplashScreenData: $e');
      } finally {
        isLoading.value = false;
      }
    }
  }


  Future<void> getTempToken() async {

    if(await AppFunction.isInternetAvailable()){
      try {
        isLoading.value = true;

        final response =await getTempTokenApi();

        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final requestData = BaseResponse<CommonData>.fromJson(
          body,
          fromJsonT: (data) => CommonData.fromJson(data),
        );

        if(requestData.responseCode=="200"){
          if(requestData.status==AppConstants.SUCCESS){

           var commonData = requestData.data!;

           // Get token and userId
           final tempToken = commonData.tempToken ?? '';
           final loginData=await getSavedLoginData(pref);
           final userId = loginData?.userId; // replace with your method

           // Build full URL
           final String link = "$downloadLink&ttk=$tempToken&user_id=$userId";

           // Validate and launch
           final Uri uri = Uri.parse(link);
           if (!await canLaunchUrl(uri)) {
             AppDialog.showMessage("No browser app found to open this link.");
             return;
           }

           // Try to launch in Chrome first (if available)
           final bool launched = await launchUrl(
             uri,
             mode: LaunchMode.externalApplication,
           );

           if (!launched) {
             AppDialog.showMessage("Could not open link in Chrome.");
           }

          }else{
            AppDialog.showMessage(requestData.msg);
          }
        }else{
          AppDialog.showMessage(requestData.msg);
        }

      } catch (e) {
        print('❌ Exception in fetchSplashScreenData: $e');
      } finally {
        isLoading.value = false;
      }
    }

  }

  Future<void> withdrawReturnRequest(String id) async {

    if(await AppFunction.isInternetAvailable()){
      try {
        isLoading.value = true;

        final response = screenTitle.value == 'APP_RETURN_REQUEST_DETAILS'.tr?
        await withdrawReturnReqApi(id): screenTitle.value == 'APP_EXCHANGE_REQUEST_DETAILS'.tr?
        await withdrawOrderExchangeReturnReqApi(id) : await withdrawReturnReqApi(id) ;

        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final requestData = BaseResponse<CommonData>.fromJson(
          body,
          fromJsonT: (data) => CommonData.fromJson(data),
        );

        if(requestData.responseCode=="200"){
          if(requestData.status==AppConstants.SUCCESS){

            screenTitle.value=='APP_RETURN_REQUEST_DETAILS'.tr?
            await getReturnRequestDetail(requestId) : screenTitle.value == 'APP_EXCHANGE_REQUEST_DETAILS'.tr?
            await getExchangeRequestDetail(requestId) : await getMissingRequestDetail(requestId);

          }else{
            AppDialog.showMessage(requestData.msg);
          }
        }else{
          AppDialog.showMessage(requestData.msg);
        }

      } catch (e) {
        print('❌ Exception in fetchSplashScreenData: $e');
      } finally {
        isLoading.value = false;
      }
    }

  }

  void setAddressValue(VendorReturnAddress? vendorReturnAddress){

    uraName.value=vendorReturnAddress?.uraName??"";
    final parts = [
      vendorReturnAddress?.uraAddressLine1,
      vendorReturnAddress?.uraAddressLine2,
      vendorReturnAddress?.uraCity,
      vendorReturnAddress?.stateName,
      vendorReturnAddress?.countryName,
      vendorReturnAddress?.uraZip,
    ];

    address.value=parts
        .where((e) => e != null && e.trim().isNotEmpty)
        .join('\n');
  }

}