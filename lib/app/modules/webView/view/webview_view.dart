import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../utils/app_colors.dart';
import '../controller/wevview_controller.dart';

class WebviewView extends GetView<WebviewController> {
  const WebviewView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.white,
        leading: const BackButton(),
        title: Obx(
              () => Text(
            controller.title.value,
            style: const TextStyle(
              fontFamily: "Nunito",
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller.webController),

          Obx(
                () => controller.isLoading.value
                ? const Center(child: CircularProgressIndicator(color: Colors.black))
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
