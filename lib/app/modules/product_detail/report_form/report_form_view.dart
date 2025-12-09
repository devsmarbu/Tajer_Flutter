import 'package:flutter/material.dart';
import '../../../../common/widgets/common_text_field.dart';
import 'package:get/get.dart';
import '../product_detail_controller.dart';

class ReportFormPopover extends StatefulWidget {
  final String productName;
  final String selprodId;

  const ReportFormPopover({
    super.key,
    required this.productName,
    required this.selprodId,
  });

  @override
  State<ReportFormPopover> createState() => _ReportFormPopoverState();
}

class _ReportFormPopoverState extends State<ReportFormPopover> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  final controller = Get.put(ProductDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.5),
      // transparent overlay
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Tap outside to dismiss
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(color: Colors.transparent),
          ),

          // Popover bottom sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 30, 16, 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Report Form",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Nunito",
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Product name
                    TextField(
                      style: TextStyle(color: Colors.black54),
                      enabled: false,
                      controller: TextEditingController(
                        text: widget.productName,
                      ),
                      // decoration: const InputDecoration(
                      //   filled: true,
                      //   fillColor: Color(0xFFF5F5F5),
                      //   border: OutlineInputBorder(
                      //     borderSide: BorderSide.none,
                      //     borderRadius: BorderRadius.all(Radius.circular(8)),
                      //   ),
                      // ),
                    ),
                    SizedBox(height: 10),
                    CommonTextField(
                      maxLines: 1,
                      label: "",
                      hint: "Report Title",
                      controller: titleController,
                      backgroundColor: Colors.grey[200],
                    ),
                    SizedBox(height: 10),

                    // Report Comments
                    CommonTextField(
                      maxLines: 4,
                      label: "",
                      hint: "Report Comments",
                      controller: commentController,
                      backgroundColor: Colors.grey[200],
                    ),
                    const SizedBox(height: 20),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          final title = titleController.text.trim();
                          final comment = commentController.text.trim();
                          debugPrint(title);
                          debugPrint(comment);
                          debugPrint(widget.productName);
                          debugPrint(widget.selprodId);
                          if (title.isEmpty || comment.isEmpty) {
                            Get.snackbar("Error", "Please fill all fields",
                                backgroundColor: Colors.redAccent, colorText: Colors.white);
                            return;
                          }
                          // Call API via controller
                          await controller.reportProduct(
                            widget.productName,
                            title,
                            comment,
                            widget.selprodId,
                          );
                          Get.back(); // close popover
                          Get.snackbar(
                            "Success",
                            "Report submitted successfully",
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                          debugPrint(
                            "Report submitted: ${titleController.text} - ${commentController.text}",
                          );
                        },
                        child: const Text(
                          "Submit",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Floating Close Button
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.5,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, size: 28, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
