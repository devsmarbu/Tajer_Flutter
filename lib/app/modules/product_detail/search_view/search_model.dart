import 'package:tajer/app/modules/categories/brands_list/models/brand.dart';

class SearchModel {
  final String? status;
  final SearchData? data;
  final String? msg;
  final String? responseCode;

  SearchModel({
    this.status,
    this.data,
    this.msg,
    this.responseCode,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) => SearchModel(
    status: json["status"],
    data: json["data"] == null ? null : SearchData.fromJson(json["data"]),
    msg: json["msg"],
    responseCode: json["responseCode"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
    "msg": msg,
    "responseCode": responseCode,
  };
}

class SearchData {
  final Suggestions? suggestions;
  final String? totalFavouriteItems;
  final String? currencySymbol;
  final String? cartItemsCount;
  final String? totalUnreadNotificationCount;
  final String? totalUnreadMessageCount;

  SearchData({
    this.suggestions,
    this.totalFavouriteItems,
    this.currencySymbol,
    this.cartItemsCount,
    this.totalUnreadNotificationCount,
    this.totalUnreadMessageCount,
  });

  factory SearchData.fromJson(Map<String, dynamic> json) => SearchData(
    suggestions: json["suggestions"] == null ? null : Suggestions.fromJson(json["suggestions"]),
    totalFavouriteItems: json["totalFavouriteItems"],
    currencySymbol: json["currencySymbol"],
    cartItemsCount: json["cartItemsCount"],
    totalUnreadNotificationCount: json["totalUnreadNotificationCount"],
    totalUnreadMessageCount: json["totalUnreadMessageCount"],
  );

  Map<String, dynamic> toJson() => {
    "suggestions": suggestions?.toJson(),
    "totalFavouriteItems": totalFavouriteItems,
    "currencySymbol": currencySymbol,
    "cartItemsCount": cartItemsCount,
    "totalUnreadNotificationCount": totalUnreadNotificationCount,
    "totalUnreadMessageCount": totalUnreadMessageCount,
  };
}

class Suggestions {
  final List<Category>? categories;
  final List<AllBrand>? brands;
  final List<Tag>? tags;
  final List<SearchProduct>? products;

  Suggestions({
    this.categories,
    this.brands,
    this.tags,
    this.products,
  });

  factory Suggestions.fromJson(Map<String, dynamic> json) => Suggestions(
    categories: json["categories"] == null
        ? []
        : List<Category>.from(
      json["categories"].map((x) => Category.fromJson(x)),
    ),
    brands: json["brands"] == null
        ? []
        : List<AllBrand>.from(
      json["brands"].map((x) => AllBrand.fromJson(x)),
    ),
    tags: json["tags"] == null
        ? []
        : List<Tag>.from(
      json["tags"].map((x) => Tag.fromJson(x)),
    ),
    products: json["products"] == null
        ? []
        : List<SearchProduct>.from(
      json["products"].map((x) => SearchProduct.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "categories": categories == null
        ? []
        : List<dynamic>.from(categories!.map((x) => x.toJson())),
    "brands": brands == null
        ? []
        : List<dynamic>.from(brands!.map((x) => x.toJson())),
    "tags": tags == null
        ? []
        : List<dynamic>.from(tags!.map((x) => x.toJson())),
    "products": products == null
        ? []
        : List<dynamic>.from(products!.map((x) => x.toJson())),
  };
}


class Category {
  final String? categoryName;
  final String? categoryId;

  Category({
    this.categoryName,
    this.categoryId,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    categoryName: json["category_name"],
    categoryId: json["category_id"],
  );

  Map<String, dynamic> toJson() => {
    "category_name": categoryName,
    "category_id": categoryId,
  };
}

class SearchProduct {
  final String? selprodTitle;
  final String? keywordRelevancy;
  final String? prodcatName;
  final String? level;
  final String? selprodId;

  SearchProduct({
    this.selprodTitle,
    this.keywordRelevancy,
    this.prodcatName,
    this.level,
    this.selprodId,
  });

  factory SearchProduct.fromJson(Map<String, dynamic> json) => SearchProduct(
    selprodTitle: json["selprod_title"],
    keywordRelevancy: json["keyword_relevancy"],
    prodcatName: json["prodcat_name"],
    level: json["level"],
    selprodId: json["selprod_id"],
  );

  Map<String, dynamic> toJson() => {
    "selprod_title": selprodTitle,
    "keyword_relevancy": keywordRelevancy,
    "prodcat_name": prodcatName,
    "level": level,
    "selprod_id": selprodId,
  };
}

class Tag {
  String? tagId;
  String? tagName;
  String? prodCount;
  String? level;

  Tag({
    this.tagId,
    this.tagName,
    this.prodCount,
    this.level,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      tagId: json['tag_id'] as String?,
      tagName: json['tag_name'] as String?,
      prodCount: json['prodCount'] as String?,
      level: json['level'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tag_id': tagId,
      'tag_name': tagName,
      'prodCount': prodCount,
      'level': level,
    };
  }
}

