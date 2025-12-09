
class ShopReviewModel {
  final String? msg;
  final String? responseCode;
  final String? status;
  final ReviewData? data;

  ShopReviewModel({
    this.msg,
    this.responseCode,
    this.status,
    this.data,
  });

  factory ShopReviewModel.fromJson(Map<String, dynamic> json) => ShopReviewModel(
    msg: json["msg"],
    responseCode: json["responseCode"],
    status: json["status"],
    data: json["data"] == null ? null : ReviewData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "responseCode": responseCode,
    "status": status,
    "data": data?.toJson(),
  };
}

class ReviewData {
  final PostedData? postedData;
  final String? currencySymbol;
  final String? page;
  final String? totalUnreadMessageCount;
  final String? totalRecords;
  final String? pageCount;
  final List<ReviewsList>? reviewsList;
  final String? startRecord;
  final String? cartItemsCount;
  final String? totalFavouriteItems;
  final String? totalUnreadNotificationCount;

  ReviewData({
    this.postedData,
    this.currencySymbol,
    this.page,
    this.totalUnreadMessageCount,
    this.totalRecords,
    this.pageCount,
    this.reviewsList,
    this.startRecord,
    this.cartItemsCount,
    this.totalFavouriteItems,
    this.totalUnreadNotificationCount,
  });

  factory ReviewData.fromJson(Map<String, dynamic> json) => ReviewData(
    postedData: json["postedData"] == null ? null : PostedData.fromJson(json["postedData"]),
    currencySymbol: json["currencySymbol"],
    page: json["page"],
    totalUnreadMessageCount: json["totalUnreadMessageCount"],
    totalRecords: json["totalRecords"],
    pageCount: json["pageCount"],
    reviewsList: json["reviewsList"] == null ? [] : List<ReviewsList>.from(json["reviewsList"]!.map((x) => ReviewsList.fromJson(x))),
    startRecord: json["startRecord"],
    cartItemsCount: json["cartItemsCount"],
    totalFavouriteItems: json["totalFavouriteItems"],
    totalUnreadNotificationCount: json["totalUnreadNotificationCount"],
  );

  Map<String, dynamic> toJson() => {
    "postedData": postedData?.toJson(),
    "currencySymbol": currencySymbol,
    "page": page,
    "totalUnreadMessageCount": totalUnreadMessageCount,
    "totalRecords": totalRecords,
    "pageCount": pageCount,
    "reviewsList": reviewsList == null ? [] : List<dynamic>.from(reviewsList!.map((x) => x.toJson())),
    "startRecord": startRecord,
    "cartItemsCount": cartItemsCount,
    "totalFavouriteItems": totalFavouriteItems,
    "totalUnreadNotificationCount": totalUnreadNotificationCount,
  };
}

class PostedData {
  final String? page;
  final String? pageSize;
  final String? shopId;
  final String? shopUserId;
  final String? orderBy;

  PostedData({
    this.page,
    this.pageSize,
    this.shopId,
    this.shopUserId,
    this.orderBy,
  });

  factory PostedData.fromJson(Map<String, dynamic> json) => PostedData(
    page: json["page"],
    pageSize: json["pageSize"],
    shopId: json["shop_id"],
    shopUserId: json["shop_user_id"],
    orderBy: json["orderBy"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "pageSize": pageSize,
    "shop_id": shopId,
    "shop_user_id": shopUserId,
    "orderBy": orderBy,
  };
}

class ReviewsList {
  final String? spreviewPostedbyUserId;
  final String? userName;
  final String? spreviewDescription;
  final String? helpful;
  final String? usersMarked;
  final String? spreviewSellerUserId;
  final String? countUsersMarked;
  final String? selprodTitle;
  final String? productName;
  final String? spreviewId;
  final String? userUpdatedOn;
  final String? spreviewPostedOn;
  final String? userImage;
  final String? spreviewTitle;
  final List<dynamic>? images;
  final String? notHelpful;
  final String? shopRating;
  final String? selprodId;
  final String? sprhHelpful;
  final List<RatingAspect>? ratingAspects;

  ReviewsList({
    this.spreviewPostedbyUserId,
    this.userName,
    this.spreviewDescription,
    this.helpful,
    this.usersMarked,
    this.spreviewSellerUserId,
    this.countUsersMarked,
    this.selprodTitle,
    this.productName,
    this.spreviewId,
    this.userUpdatedOn,
    this.spreviewPostedOn,
    this.userImage,
    this.spreviewTitle,
    this.images,
    this.notHelpful,
    this.shopRating,
    this.selprodId,
    this.sprhHelpful,
    this.ratingAspects,
  });

  factory ReviewsList.fromJson(Map<String, dynamic> json) => ReviewsList(
    spreviewPostedbyUserId: json["spreview_postedby_user_id"],
    userName: json["user_name"],
    spreviewDescription: json["spreview_description"],
    helpful: json["helpful"],
    usersMarked: json["usersMarked"],
    spreviewSellerUserId: json["spreview_seller_user_id"],
    countUsersMarked: json["countUsersMarked"],
    selprodTitle: json["selprod_title"],
    productName: json["product_name"],
    spreviewId: json["spreview_id"],
    userUpdatedOn: json["user_updated_on"],
    spreviewPostedOn: json["spreview_posted_on"],
    userImage: json["user_image"],
    spreviewTitle: json["spreview_title"],
    images: json["images"] == null ? [] : List<dynamic>.from(json["images"]!.map((x) => x)),
    notHelpful: json["notHelpful"],
    shopRating: json["shop_rating"],
    selprodId: json["selprod_id"],
    sprhHelpful: json["sprh_helpful"],
    ratingAspects: json["ratingAspects"] == null ? [] : List<RatingAspect>.from(json["ratingAspects"]!.map((x) => RatingAspect.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "spreview_postedby_user_id": spreviewPostedbyUserId,
    "user_name": userName,
    "spreview_description": spreviewDescription,
    "helpful": helpful,
    "usersMarked": usersMarked,
    "spreview_seller_user_id": spreviewSellerUserId,
    "countUsersMarked": countUsersMarked,
    "selprod_title": selprodTitle,
    "product_name": productName,
    "spreview_id": spreviewId,
    "user_updated_on": userUpdatedOn,
    "spreview_posted_on": spreviewPostedOn,
    "user_image": userImage,
    "spreview_title": spreviewTitle,
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
    "notHelpful": notHelpful,
    "shop_rating": shopRating,
    "selprod_id": selprodId,
    "sprh_helpful": sprhHelpful,
    "ratingAspects": ratingAspects == null ? [] : List<dynamic>.from(ratingAspects!.map((x) => x.toJson())),
  };
}

class RatingAspect {
  final String? spratingSpreviewId;
  final String? spratingRating;
  final String? ratingtypeId;
  final String? ratingtypeName;

  RatingAspect({
    this.spratingSpreviewId,
    this.spratingRating,
    this.ratingtypeId,
    this.ratingtypeName,
  });

  factory RatingAspect.fromJson(Map<String, dynamic> json) => RatingAspect(
    spratingSpreviewId: json["sprating_spreview_id"],
    spratingRating: json["sprating_rating"],
    ratingtypeId: json["ratingtype_id"],
    ratingtypeName: json["ratingtype_name"],
  );

  Map<String, dynamic> toJson() => {
    "sprating_spreview_id": spratingSpreviewId,
    "sprating_rating": spratingRating,
    "ratingtype_id": ratingtypeId,
    "ratingtype_name": ratingtypeName,
  };
}

class MarkHelpfulModel {
  final String? status;
  final MarkHelpfulData? data;
  final String? responseCode;
  final String? msg;

  MarkHelpfulModel({
    this.status,
    this.data,
    this.responseCode,
    this.msg,
  });

  factory MarkHelpfulModel.fromJson(Map<String, dynamic> json) => MarkHelpfulModel(
    status: json["status"],
    data: json["data"] == null ? null : MarkHelpfulData.fromJson(json["data"]),
    responseCode: json["responseCode"],
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
    "responseCode": responseCode,
    "msg": msg,
  };
}

class MarkHelpfulData {
  final String? totalUnreadNotificationCount;
  final String? currencySymbol;
  final String? notHelpful;
  final String? totalUnreadMessageCount;
  final String? totalFavouriteItems;
  final String? helpful;
  final String? cartItemsCount;

  MarkHelpfulData({
    this.totalUnreadNotificationCount,
    this.currencySymbol,
    this.notHelpful,
    this.totalUnreadMessageCount,
    this.totalFavouriteItems,
    this.helpful,
    this.cartItemsCount,
  });

  factory MarkHelpfulData.fromJson(Map<String, dynamic> json) => MarkHelpfulData(
    totalUnreadNotificationCount: json["totalUnreadNotificationCount"],
    currencySymbol: json["currencySymbol"],
    notHelpful: json["notHelpful"],
    totalUnreadMessageCount: json["totalUnreadMessageCount"],
    totalFavouriteItems: json["totalFavouriteItems"],
    helpful: json["helpful"],
    cartItemsCount: json["cartItemsCount"],
  );

  Map<String, dynamic> toJson() => {
    "totalUnreadNotificationCount": totalUnreadNotificationCount,
    "currencySymbol": currencySymbol,
    "notHelpful": notHelpful,
    "totalUnreadMessageCount": totalUnreadMessageCount,
    "totalFavouriteItems": totalFavouriteItems,
    "helpful": helpful,
    "cartItemsCount": cartItemsCount,
  };
}