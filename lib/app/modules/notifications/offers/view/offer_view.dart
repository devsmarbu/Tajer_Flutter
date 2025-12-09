import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/offer_controller.dart';

class OfferView extends StatelessWidget {
  final OfferController controller = Get.put(OfferController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: controller.offers.isEmpty
            ? const Center(
          child: Text("No offers available."),
        )
            : ListView.separated(
          padding: const EdgeInsets.all(16.0),
          itemCount: controller.offers.length,
          separatorBuilder: (context, index) => SizedBox(height: 16),
          itemBuilder: (context, index) {
            final item = controller.offers[index];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.pnotificationTitle.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  item.pnotificationDescription.toString(),
                  style: TextStyle(fontSize: 14),
                ),
              ],
            );
          },
        ),
      );
    });
  }
}
