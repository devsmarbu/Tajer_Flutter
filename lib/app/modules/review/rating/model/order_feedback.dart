import 'dart:convert';

import 'main_rate_data.dart';

class OrderFeedback {
  MainRateData selProdRating;
  List<MainRateData>? otherRating;
  MainRateData shopRating;
  MainRateData deliveryRating;
  String? title;
  String? description;
  String opId;
  String opImage;
  String opName;
  List<String>? imgArray;

  OrderFeedback({
    required this.selProdRating,
    this.otherRating,
    required this.shopRating,
    required this.deliveryRating,
    this.title,
    this.description,
    required this.opId,
    required this.opImage,
    required this.opName,
    this.imgArray,
  });

  factory OrderFeedback.fromJson(Map<String, dynamic> json) {
    return OrderFeedback(
      selProdRating: MainRateData.fromJson(json['selProdRating']),
      otherRating: json['otherRating'] != null
          ? (json['otherRating'] as List)
          .map((e) => MainRateData.fromJson(e))
          .toList()
          : null,
      shopRating: MainRateData.fromJson(json['shopRating']),
      deliveryRating: MainRateData.fromJson(json['deliveryRating']),
      title: json['title'],
      description: json['description'],
      opId: json['opId'],
      opImage: json['opImage'],
      opName: json['opName'],
      imgArray: json['imgArray'] != null
          ? List<String>.from(json['imgArray'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'selProdRating': selProdRating.toJson(),
      'otherRating': otherRating?.map((e) => e.toJson()).toList(),
      'shopRating': shopRating.toJson(),
      'deliveryRating': deliveryRating.toJson(),
      'title': title,
      'description': description,
      'opId': opId,
      'opImage': opImage,
      'opName': opName,
      'imgArray': imgArray,
    };
  }
}
