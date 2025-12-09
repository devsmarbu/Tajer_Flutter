import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/core/constants/app_constants.dart';
import 'package:tajer/app/modules/product_detail/shop_detail_view/shop_detail_controller.dart';
import 'package:tajer/utils/pref_store.dart';

import '../../../../common/widgets/common_text_field.dart';
import '../../Account/models/profile_data.dart';

class AskQuestionPageView extends StatefulWidget {
  final bool showAppBar;
  final String? shopId;
  final String? shopName;

  const AskQuestionPageView({
    super.key,
    this.showAppBar = true,
    this.shopId,
    this.shopName,
  });

  @override
  State<AskQuestionPageView> createState() => _AskQuestionPageViewState();
}

class _AskQuestionPageViewState extends State<AskQuestionPageView> {
  final subjectController = TextEditingController();
  final commentController = TextEditingController();
  final controller = Get.put(ShopDetailController());

  String? userToken;
  String? shopId;
  String? shopName;
  ProfileData? profile;
  bool isLoading = true;
  RxString? subjectError = "".obs;
  RxString? messageError = "".obs;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final params = Get.arguments;
    shopId = params["shopId"];
    shopName = params["shopName"];
    userToken = PrefStore().loadString(AppConstants.sessionToken);
    profile = await PrefStore.getProfile();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: widget.showAppBar
          ? AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "APP_ASK_A_QUESTIONS".tr,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: "Nunito",
            fontSize: 18,
          ),
        ),
      )
          : null,

      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Colors.black),
      )
          : (userToken == null || userToken!.isEmpty)
          ? _buildLoginRequiredUI()
          : _buildFormUI(),
    );
  }

  bool validateForm() {
    subjectError?.value = "";
    messageError?.value = "";

    if (subjectController.text.trim().isEmpty) {
      subjectError?.value = "APP_PLEASE_ENTER_SUBJECT".tr;
    }

    if (commentController.text.trim().isEmpty) {
      messageError?.value = "APP_PLEASE_ENTER_MESSAGE".tr;
    }

    setState(() {});

    return subjectError!.value.isEmpty && messageError!.value.isEmpty;
  }

  // -------------------------
  // LOGIN REQUIRED UI
  // -------------------------
  Widget _buildLoginRequiredUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "APP_PLEASE_SIGNIN_FOR_MORE_OPTIONS".tr,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              fontFamily: "Nunito",
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 140,
            height: 45,
            child: ElevatedButton(
              onPressed: () => Get.toNamed('/login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "APP_LOGIN".tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: "Nunito",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------
  // QUESTION FORM UI
  // -------------------------
  Widget _buildFormUI() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "APP_YOUR_CONTACT_INFORMATION_WILL_NOT_BE_SHARED_WITH_THE_MERCHANT".tr,
                style: const TextStyle(
                  fontFamily: "Nunito",
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),

              // FROM
              Row(
                children: [
                  Text(
                    "${"APP_FROM".tr}: ",
                    style: const TextStyle(
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    profile?.personalInfo?.userName ?? "N/A",
                    style: const TextStyle(
                      fontFamily: "Nunito",
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // TO
              Row(
                children: [
                  Text(
                    "${"APP_TO".tr}: $shopName",
                    style: const TextStyle(
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    widget.shopName ?? "",
                    style: const TextStyle(
                      fontFamily: "Nunito",
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Obx(() =>
              CommonTextField(
                controller: subjectController,
                label: "",
                errorText: subjectError?.value,
                hint: "APP_SUBJECT".tr,
              )),

              const SizedBox(height: 20),
          Obx(() =>
              CommonTextField(
                controller: commentController,
                label: "",
                hint: "APP_WRITE_YOUR_MESSAGE".tr,
                errorText: messageError?.value,
                maxLines: 4,
              )),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: send API here
                    print("Send message to shop...");
                    if (!validateForm()) return;

                    controller.sendMessageToShop(threadSubject: subjectController.text, messageText: commentController.text, shopId: shopId ?? "0");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "APP_CAPTION_SEND_MESSAGE".tr,
                    style: const TextStyle(
                      fontFamily: "Nunito",
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}