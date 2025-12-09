import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/data/service/order_api_client.dart';
import 'package:tajer/app/modules/orders/orderDetail/models/order_detail.dart';
import 'package:tajer/utils/app_loader.dart';
import '../../../../../common/functions/app_function.dart';
import '../../../../../common/widgets/app_dialog.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_params.dart';
import '../../../../../utils/app_strings.dart';
import '../../../../../utils/base_response.dart';
import '../../../../../utils/pref_store.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/routes/app_routes.dart';
import '../../orderDetail/models/child_order_detail_item.dart';
import '../../orderDetail/models/order_detail_data.dart';
import '../models/order_list_response.dart';

class MyOrdersController extends GetxController with OrderApiClient,AppLoader {
  var orders = <OrderDetail>[].obs;
  var filterList = <OrderStatusModel>[].obs;
  var ordersChild = <ChildOrderDetailItem>[].obs;
  var isLoading = false.obs;
  final pref = PrefStore();

  final TextEditingController searchController = TextEditingController();
  final RxBool isListening = false.obs;

  int currentPage = 1;
  int selectedFilterIndex = 0;
  int lastPage = 1;
  String status = '';
  var orderId=''.obs;
  var orderNumber=''.obs;

  final scrollController = ScrollController();
  late String sessionToken=pref.loadString(AppConstants.sessionToken)??"";

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments ?? {};
    if (args is Map && args[AppParams.orderId] != null) {
      orderId.value = args[AppParams.orderId]?.toString() ?? '';
      orderNumber.value = args[AppParams.orderNumber]?.toString() ?? '';
    }
    fetchOrders();
    if(orderId.value.isEmpty){
       filterList.assign(OrderStatusModel(orderStatusId: "-1", orderstatusName: "ALL"));
      _paginationSetup();
    }else{
      debugPrint('orderIdContollerCheck: $orderId');
      fetchViewOrder(orderId.value);
    }

  }

  void _paginationSetup() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent &&
          !isLoading.value &&
          currentPage < lastPage) {
       // fetchMoreOrders();
        currentPage++;
        fetchOrders();
      }
    });
  }

  void onSearchChanged(String query) {
    currentPage = 1;
    status = ""; // remove filter during search
    fetchOrders();
  }

  void startListening() {
    isListening.value = true;
  }

  void stopListening() {
    isListening.value = false;
  }

  Future<void> fetchOrders() async {

  //  if (currentPage >= lastPage) return;

    if(await AppFunction.isInternetAvailable()){
      try {
        isLoading.value = true;

        final response =await getMyOrders(sessionToken,currentPage,status,searchController.text);

        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final responseOrderList = BaseResponse<OrderListResponse>.fromJson(
          body,
          fromJsonT: (data) => OrderListResponse.fromJson(data),
        );

        if(responseOrderList.responseCode=="200"){
          if(responseOrderList.status==AppConstants.SUCCESS){

            if(currentPage==1){
              orders.assignAll(responseOrderList.data!.orders);
              filterList.clear();
              filterList.addAll(responseOrderList.data!.orderStatuses);
              lastPage = int.parse(responseOrderList.data!.pageCount);
            }else{
              orders.addAll(responseOrderList.data!.orders);
            }


          }else{
            AppDialog.showMessage(responseOrderList.msg);
          }
        }else{
          AppDialog.showMessage(responseOrderList.msg);
        }


      } catch (e) {
        print('❌ Exception in fetchSplashScreenData: $e');
      } finally {
        isLoading.value = false;
      }
    }

  }

  Future<void> fetchViewOrder(String orderId) async {

    //  if (currentPage >= lastPage) return;

    if(await AppFunction.isInternetAvailable()){
      try {
        isLoading.value = true;
        final response =await getOrderDetail('',orderId);

        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final responseOrder = BaseResponse<OrderDetailData>.fromJson(
          body,
          fromJsonT: (data) => OrderDetailData.fromJson(data),
        );

        if(responseOrder.responseCode=="200"){
          if(responseOrder.status==AppConstants.SUCCESS){

            ordersChild.value=responseOrder.data!.childOrderDetail!;

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
        isLoading.value = false;
      }
    }

  }

  void openFilterBottomSheet(
      BuildContext context, List<OrderStatusModel> filterList) {


    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: filterList.length,
                        itemBuilder: (context, index) {
                          final name = filterList[index].orderstatusName;

                          return RadioListTile<int>(
                            title: Text(name,
                                style:
                                TextStyle(fontSize: 14, fontFamily:'Nunito',fontWeight: FontWeight.w500)),
                            value: index,
                            groupValue: selectedFilterIndex, // PRE-SELECT HERE
                            activeColor: AppColors.black1,
                            onChanged: (value) {
                              setState(() {
                                selectedFilterIndex = value!;
                                currentPage=1;
                                status=filterList[index].orderStatusId=="-1"?"":
                                filterList[index].orderStatusId;
                                Get.back();
                                fetchOrders();

                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
