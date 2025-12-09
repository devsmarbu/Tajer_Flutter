import 'category_item.dart';

class CategoryModel {
  final CategoryData? data;
  final String? status;
  final String? msg;
  final String? responseCode;

  CategoryModel({
    this.data,
    this.status,
    this.msg,
    this.responseCode,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    data: json["data"] == null ? null : CategoryData.fromJson(json["data"]),
    status: json["status"],
    msg: json["msg"],
    responseCode: json["responseCode"],
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
    "status": status,
    "msg": msg,
    "responseCode": responseCode,
  };
}

class CategoryData {
  final List<NewCategory>? categories;
  final String? totalFavouriteItems;
  final String? totalUnreadMessageCount;
  final String? totalUnreadNotificationCount;
  final String? cartItemsCount;
  final String? currencySymbol;

  CategoryData({
    this.categories,
    this.totalFavouriteItems,
    this.totalUnreadMessageCount,
    this.totalUnreadNotificationCount,
    this.cartItemsCount,
    this.currencySymbol,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
    categories: json["categories"] == null ? [] : List<NewCategory>.from(json["categories"]!.map((x) => NewCategory.fromJson(x))),
    totalFavouriteItems: json["totalFavouriteItems"],
    totalUnreadMessageCount: json["totalUnreadMessageCount"],
    totalUnreadNotificationCount: json["totalUnreadNotificationCount"],
    cartItemsCount: json["cartItemsCount"],
    currencySymbol: json["currencySymbol"],
  );

  Map<String, dynamic> toJson() => {
    "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
    "totalFavouriteItems": totalFavouriteItems,
    "totalUnreadMessageCount": totalUnreadMessageCount,
    "totalUnreadNotificationCount": totalUnreadNotificationCount,
    "cartItemsCount": cartItemsCount,
    "currencySymbol": currencySymbol,
  };
}

class NewCategory {
  final String? isLastChildCategory;
  final String? prodcatContentBlock;
  final String? prodrootcatCode;
  final List<NewCategory>? children;
  final String? image;
  final String? prodcatId;
  final String? prodcatParent;
  final String? icon;
  final String? prodcatCode;
  final String? prodcatUpdatedOn;
  final String? prodcatOrdercode;
  final String? prodcatHasChild;
  final String? prodcatActive;
  final String? prodcatName;

  NewCategory({
    this.isLastChildCategory,
    this.prodcatContentBlock,
    this.prodrootcatCode,
    this.children,
    this.image,
    this.prodcatId,
    this.prodcatParent,
    this.icon,
    this.prodcatCode,
    this.prodcatUpdatedOn,
    this.prodcatOrdercode,
    this.prodcatHasChild,
    this.prodcatActive,
    this.prodcatName,
  });

  factory NewCategory.fromJson(Map<String, dynamic> json) => NewCategory(
    isLastChildCategory: json["isLastChildCategory"],
    prodcatContentBlock: json["prodcat_content_block"],
    prodrootcatCode: json["prodrootcat_code"],
    children: json["children"] == null ? [] : List<NewCategory>.from(json["children"]!.map((x) => NewCategory.fromJson(x))),
    image: json["image"],
    prodcatId: json["prodcat_id"],
    prodcatParent: json["prodcat_parent"],
    icon: json["icon"],
    prodcatCode: json["prodcat_code"],
    prodcatUpdatedOn: json["prodcat_updated_on"],
    prodcatOrdercode: json["prodcat_ordercode"],
    prodcatHasChild: json["prodcat_has_child"],
    prodcatActive: json["prodcat_active"],
    prodcatName: json["prodcat_name"],
  );

  Map<String, dynamic> toJson() => {
    "isLastChildCategory": isLastChildCategory,
    "prodcat_content_block": prodcatContentBlock,
    "prodrootcat_code": prodrootcatCode,
    "children": children == null ? [] : List<dynamic>.from(children!.map((x) => x.toJson())),
    "image": image,
    "prodcat_id": prodcatId,
    "prodcat_parent": prodcatParent,
    "icon": icon,
    "prodcat_code": prodcatCode,
    "prodcat_updated_on": prodcatUpdatedOn,
    "prodcat_ordercode": prodcatOrdercode,
    "prodcat_has_child": prodcatHasChild,
    "prodcat_active": prodcatActive,
    "prodcat_name": prodcatName,
  };
}