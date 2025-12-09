import 'dart:convert';

import 'package:get/get.dart';
import 'package:tajer/app/modules/orders/orderDetail/models/child_order_detail_item.dart';
import 'package:tajer/app/modules/orders/orderDetail/models/order_detail_data.dart';
import 'package:tajer/utils/app_loader.dart';

import '../../../../../common/functions/app_function.dart';
import '../../../../../common/widgets/app_dialog.dart';
import '../../../../../utils/base_response.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../data/service/order_api_client.dart';

class OrderDetailsController extends GetxController with OrderApiClient, AppLoader {

  var orderId = "".obs;
  var orderProductId = "".obs;
  var orderModel = Rxn<OrderDetailData>();
  var paymentConfirmedTime = "2025-09-28 15:02:14".obs;
  var cancelledTime = "2025-09-28 15:07:36".obs;

  // Rating
  var rating = 0.0.obs;


  void updateRating(double newRating) {
    rating.value = newRating;
  }

  Future<void> fetchOrders(String orderId) async {

    //  if (currentPage >= lastPage) return;

    if(await AppFunction.isInternetAvailable()){
      try {
        showLoader(Get.context!);

        final response =await getOrderDetail(orderProductId.value,orderId);

        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final responseOrder = BaseResponse<OrderDetailData>.fromJson(
          body,
          fromJsonT: (data) => OrderDetailData.fromJson(data),
        );

        if(responseOrder.responseCode=="200"){
          if(responseOrder.status==AppConstants.SUCCESS){

            orderModel.value=responseOrder.data;

          }
          else{
            AppDialog.showMessage(responseOrder.msg);
          }
        }
        else if(responseOrder.displayLoginForm=="1"){
          Get.toNamed(AppRoutes.login);
        }
        else{
          AppDialog.showMessage(responseOrder.msg);
        }


      } catch (e) {
        print('❌ Exception in fetchSplashScreenData: $e');
      } finally {
        hideLoader(Get.context!);
      }
    }

  }

  Future<void> orderReceipt() async {


    if(await AppFunction.isInternetAvailable()){
      try {
        showLoader(Get.context!);

        final response =await orderReceiptApi(orderId.value);

        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final responseOrder = BaseResponse<OrderDetailData>.fromJson(
          body,
          fromJsonT: (data) => OrderDetailData.fromJson(data),
        );

        hideLoader(Get.context!);
        if(responseOrder.responseCode=="200"){
          AppDialog.showMessage(responseOrder.msg);
        }
        else if(responseOrder.displayLoginForm=="1"){
          Get.toNamed(AppRoutes.login);
        }
        else{
          AppDialog.showMessage(responseOrder.msg);
        }


      } catch (e) {
        print('❌ Exception in fetchSplashScreenData: $e');
      } finally {
        hideLoader(Get.context!);
      }
    }

  }

  Future<void> reOrderProduct(ChildOrderDetailItem order) async {


    final selProdStock=order.selprod_stock??"";
    final selProdMinimumQty=order.selprod_min_order_qty??"";

    if(order.selprod_stock=="0" || order.selprod_stock=="" || order.selprod_min_order_qty=="0" || order.selprod_min_order_qty==""){
      return;
    }


    int minimumQty = int.parse(selProdMinimumQty);
    int stock = int.parse(selProdStock);

    if (minimumQty > stock) {
      return;
    }


    if(await AppFunction.isInternetAvailable()){
      try {
        showLoader(Get.context!);

        final response =await reOrderProductApi(orderId.value);

        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final responseOrder = BaseResponse<OrderDetailData>.fromJson(
          body,
          fromJsonT: (data) => OrderDetailData.fromJson(data),
        );

        hideLoader(Get.context!);
        if(responseOrder.responseCode=="200"){
          AppDialog.showMessage(responseOrder.msg);
        }
        else if(responseOrder.displayLoginForm=="1"){
          Get.toNamed(AppRoutes.login);
        }
        else{
          AppDialog.showMessage(responseOrder.msg);
        }


      } catch (e) {
        print('❌ Exception in fetchSplashScreenData: $e');
      } finally {
        hideLoader(Get.context!);
      }
    }

  }

}
