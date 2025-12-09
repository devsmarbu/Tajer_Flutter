import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/Cart/cart_shipping/cart_listing_model/cart_listing_model.dart';
import 'package:tajer/utils/app_strings.dart';

// const String htmlContent = """
// <h2>Delivery and Shipping:</h2>
//
// <h3>Local Delivery &amp; Shipping</h3>
// <ul>
//   <li>Delivery within the State of Qatar takes up to 3 days.</li>
// </ul>
//
// <h3>International Delivery &amp; Shipping:</h3>
// <ul>
//   <li>Delivery time varies by country and ranges between 7 to 12 days.</li>
// </ul>
//
// <p>
//   You acknowledge and understand that taxes are not included in the listed price or shipping charges.
//   Taxes and other charges, such as fees, duties, levies, and customs charges, are determined by your
//   country’s tax regulations and policies. You undertake to pay all these charges, which are billed
//   separately. These additional costs must be paid directly to the delivery service provider before
//   you receive the products or services. If these additional costs are not paid, the products or
//   services will not be delivered. Furthermore, you will be responsible for any return costs incurred.
// </p>
// """;

class DeliveryHtmlPage extends StatefulWidget {
  final Function(bool)? onAgreeBtnTap; // Updated: Now accepts int parameter
  final ShippingGuidelines? shippingGuidelines;

  const DeliveryHtmlPage({
    super.key,
    this.onAgreeBtnTap,
    required this.shippingGuidelines,
  });

  @override
  State<DeliveryHtmlPage> createState() => _DeliveryHtmlPageState();
}

class _DeliveryHtmlPageState extends State<DeliveryHtmlPage> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Text(
                widget.shippingGuidelines?.epageLabel ?? "",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DeliveryHtmlContent(htmlContent: widget.shippingGuidelines?.epageContent ?? ""),
            // will auto-fit height
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                  child: Checkbox(
                    activeColor: Colors.black,
                    value: _agreed,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _agreed = newValue ?? false; // Toggle the state
                        widget.onAgreeBtnTap?.call(_agreed);
                      });
                    },
                  ),
                ),
                Text(AppStrings.appIAgree.toUpperCase().tr),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DeliveryHtmlContent extends StatelessWidget {
  final String htmlContent;

  const DeliveryHtmlContent({Key? key, required this.htmlContent})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Html(data: htmlContent), // auto-sizes to content height
    );
  }
}
