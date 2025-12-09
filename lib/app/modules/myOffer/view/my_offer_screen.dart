import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart'; // for Clipboard
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_strings.dart';
import '../controller/my_offer_controller.dart';

class MyOfferScreen extends StatelessWidget {
  final MyOfferController offerController = Get.put(MyOfferController());

  MyOfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          AppStrings.appMyOffers.toUpperCase().tr,
          style: TextStyle(
            fontSize: 18,
            color: AppColors.black1,
            fontFamily: "Nunito",
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(() {
        if (offerController.offers.isEmpty) {
          return Center(child: Text('APP_CAPTION_NO_DATA'.tr));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: offerController.offers.length,
          itemBuilder: (context, index) {
            final offer = offerController.offers[index];

            // Defensive null checks
            final title = offer.couponTitle ?? 'Untitled Offer';
            final expiryDate = (offer.couponEndDate != null && offer.couponEndDate!.startsWith("00"))
                ? "N/A"
                : "Expire on ${offer.couponEndDate ?? "N/A"}";
            final terms = "Terms and conditions apply*";
            final imageUrl = offer.offerImage.toString();
            final userName = offer.couponCode.toString();

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: imageUrl.isNotEmpty
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.image),
                            ),
                          )
                              : const Icon(Icons.image, color: Colors.grey),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.black1,
                                  fontFamily: "Nunito",
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Expires on $expiryDate',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.black1,
                                  fontFamily: "Nunito",
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                terms,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontFamily: "Nunito",
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.info_outline, color: AppColors.black1),
                          onPressed: () {
                            print('Info clicked for: $title');
                            _showOfferDetails(context, title, expiryDate, "dfsgffd", terms, userName);
                          },
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: "Nunito",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  void _showOfferDetails(BuildContext context, String title, String expiryDate,
      String details, String terms, String userName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            color: AppColors.white,
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Enjoy $title Conditions Apply",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: "Nunito",
                      color: AppColors.black1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Expiry Date :",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.black1,
                    ),
                  ),
                  Text(
                    expiryDate,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Divider(height: 32),
                  const Text(
                    "Details",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.black1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    details.isNotEmpty ? details : "No details available",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    terms,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const Divider(height: 32),
                  const Text(
                    "Description",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.black1,
                    ),
                  ),
                  Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.black1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: title));
                      //  Navigator.pop(context);
                        Get.snackbar(
                          "Copied",
                          "Offer title copied to clipboard",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      child: const Text(
                        "Copy",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: "Nunito",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
