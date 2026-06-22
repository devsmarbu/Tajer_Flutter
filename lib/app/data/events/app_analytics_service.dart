import 'dart:io';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:tajer/app/Extensions/convert_extension.dart';
import 'package:tajer/app/modules/Cart/cart_shipping/cart_listing_model/cart_listing_model.dart';
import 'package:tiktok_events_sdk/tiktok_events_sdk.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

import '../../../utils/pref_store.dart';
import '../../modules/Cart/order_success_page/order_success_model.dart';

class AppAnalyticsService {
  static final FacebookAppEvents _facebook = FacebookAppEvents();
  static final FirebaseAnalytics _firebase = FirebaseAnalytics.instance;

  /// ================= INITIALIZE =================

  static Future<void> initialize() async {
    if (Platform.isIOS) {
      await _handleATT();
    } else {
      await _facebook.setAdvertiserTracking(enabled: true);
    }
  }

  static Future<void> _handleATT() async {
    TrackingStatus status =
    await AppTrackingTransparency.trackingAuthorizationStatus;

    if (status == TrackingStatus.notDetermined) {
      status =
      await AppTrackingTransparency.requestTrackingAuthorization();
    }

    await _facebook.setAdvertiserTracking(
        enabled: status == TrackingStatus.authorized);
  }

  static Map<String, dynamic> _getUtmParams() {
    final utmCampaign = PrefStore().loadString("utm_campaign");
    final utmSource = PrefStore().loadString("utmSource");
    final utmId = PrefStore().loadString("utm_id");

    final Map<String, dynamic> utmData = {};

    if (utmCampaign != null && utmCampaign.isNotEmpty) {
      utmData["utm_campaign"] = utmCampaign;
    }

    if (utmSource != null && utmSource.isNotEmpty) {
      utmData["utm_source"] = utmSource;
    }

    if (utmId != null && utmId.isNotEmpty) {
      utmData["utm_id"] = utmId;
    }

    return utmData;
  }

  static Future<void> setCampaignUserProperty() async {
    final utmCampaign = PrefStore().loadString("utm_campaign");
    final utmSource = PrefStore().loadString("utmSource");
    final utmId = PrefStore().loadString("utm_id");

    if (utmId != null && utmId.isNotEmpty) {
      await _firebase.setUserProperty(
        name: "campaign_id",
        value: utmId,
      );
    }

    if (utmCampaign != null && utmCampaign.isNotEmpty) {
      await _firebase.setUserProperty(
        name: "campaign_name",
        value: utmCampaign,
      );
    }

    if (utmSource != null && utmSource.isNotEmpty) {
      await _firebase.setUserProperty(
        name: "source",
        value: utmSource,
      );
    }

    // Optional: force immediate sync by logging a dummy event
    debugPrint('this event is also triggered');
    await _firebase.logEvent(name: "campaign_attached");
  }

  /// ================= VIEW ITEM =================

  static Future<void> viewItem({
    required String productId,
    required String name,
    required String currency,
    required double value,
    String? category,
  }) async {
    final utm = _getUtmParams();
    /// Facebook
    debugPrint('this is utm params:- $utm');
    await _facebook.logEvent(
      name: 'ViewItem',
      parameters: {
        'content_id': productId,
        'content_name': name,
        'content_type': 'product',
        'value': value,
        'currency': currency,
        ...utm
      },
    );

    /// Firebase
    await _firebase.logEvent(
      name: 'view_item',
      parameters: {
        'currency': currency,
        'value': value,
        'item_id': productId,
        'item_name': name,
        'item_category': category ?? '',
      },
    );

    /// TikTok
    await TikTokEventsSdk.logEvent(
      event: TikTokEvent(
        eventName: 'ViewItem',
        properties: EventProperties(
          contentId: productId,
          contentName: name,
          value: value,
          customProperties: {'currency': currency,...utm},
        ),
      ),
    );
  }

  /// ================= ADD TO CART =================

  static Future<void> addToCart({
    required String productId,
    required String name,
    required String currency,
    required double value,
  }) async {
    final utm = _getUtmParams();

    /// Facebook
    await _facebook.logEvent(
      name: 'AddToCart',
      parameters: {
        'content_id': productId,
        'value': value,
        'currency': currency,
        ...utm
      },
    );

    await _firebase.logEvent(
      name: 'add_to_cart',
      parameters: {
        'currency': currency,
        'value': value,
        'item_id': productId,
        'item_name': name,
      },
    );

    /// TikTok
    await TikTokEventsSdk.logEvent(
      event: TikTokEvent(
        eventName: 'AddToCart',
        properties: EventProperties(
          contentId: productId,
          contentName: name,
          value: value,
          customProperties: {'currency': currency,...utm},
        ),
      ),
    );
  }

  /// ================= VIEW CART =================

  static Future<void> viewCart({
    required String currency,
    required double totalValue,
    required List<Available>? items
  }) async {
    final utm = _getUtmParams();

    /// Facebook
    await _facebook.logEvent(
      name: 'ViewCart',
      parameters: {
        'value': totalValue,
        'currency': currency,
        ...utm
      },
    );

    /// Firebase
    final cartItems = (items?.map((item) {
      return {
        'item_id': item.productId ?? '',
        'item_name': item.productName ?? '',
        'quantity': item.quantity?.toIntSafe() ?? 0,
        'price': double.tryParse(item.selprodPrice ?? '0') ?? 0.0,
      };
    }).toList() ?? []);
    await _firebase.logEvent(
      name: 'view_cart',
      parameters: {
        'currency': currency,
        'value': totalValue,
        'items': cartItems as Object,
      },
    );

    /// TikTok
    await TikTokEventsSdk.logEvent(
      event: TikTokEvent(
        eventName: 'ViewCart',
        properties: EventProperties(
          value: totalValue,
          customProperties: {'currency': currency,...utm},
        ),
      ),
    );
  }

  /// ================= REMOVE FROM CART =================

  static Future<void> removeFromCart({
    required String productId,
    required String name,
    required double value,
  }) async {
    final utm = _getUtmParams();

    /// Facebook
    await _facebook.logEvent(
      name: 'RemoveFromCart',
      parameters: {
        'content_id': productId,
        'value': value,
        'name':name,
        ...utm
      },
    );

    /// Firebase
    await _firebase.logEvent(
      name: 'remove_from_cart',
      parameters: {
        'value': value,
        'item_id': productId,
        'item_name': name,
        'price': value,
        'quantity': 1,
      },
    );

    /// TikTok
    await TikTokEventsSdk.logEvent(
      event: TikTokEvent(
        eventName: 'RemoveFromCart',
        properties: EventProperties(
          contentId: productId,
          contentName: name,
          value: value,
          customProperties: {...utm},
        ),
      ),
    );
  }


/// ================= Purchase =================

  static Future<void> logPurchase({
    required String currency,
    required double value,
    required List<Map<String, dynamic>> items,
  }) async {

    final utm = _getUtmParams();

    /// Facebook
    await _facebook.logPurchase(
      amount: value,
      currency: currency,
      parameters: {
        "content_type": "product",
        "contents": items.map((item) {
          return {
            "id": item["item_id"],
            "quantity": item["quantity"],
          };
        }).toList(),
        ...utm
      },
    );


    final firebaseItems = items.map((item) {
      debugPrint('this is logged price of product');
      debugPrint('${(item["price"] as num?)?.toDouble()}');
      return AnalyticsEventItem(
        itemId: item["item_id"].toString(),
        itemName: item["item_name"].toString(),
        price: (item["price"] as num?)?.toDouble(),
        quantity: (item["quantity"] as num?)?.toInt(),
      );
    }).toList();

    /// Firebase
    // await _firebase.logEvent(
    //   name: 'purchase',
    //   parameters: {
    //     'currency': currency,
    //     'value': value,
    //     'items': items,
    //   },
    // );

    await FirebaseAnalytics.instance.logPurchase(
      currency: currency,
      value: value,
      items: firebaseItems,
    );

    /// TikTok
    await TikTokEventsSdk.logEvent(
      event: TikTokEvent(
        eventName: 'Purchase',
        properties: EventProperties(
          value: value,
          contentType: 'product',
          customProperties: {
            'contents': items.map((item) {
              return {
                'content': '${item["item_name"]} ${item["quantity"]}',
              };
            }).toList(),
            ...utm
          },
        ),
      ),
    );
  }





  /// ================= LOGIN =================

  static Future<void> login() async {
    final utm = _getUtmParams();

    await _firebase.logLogin(loginMethod: 'email');

    await _facebook.logEvent(name: 'Login',parameters: {...utm});

    await TikTokEventsSdk.logEvent(
      event: TikTokEvent(eventName: 'Login',properties: EventProperties(customProperties: {...utm})),
    );
  }

  /// ================= REGISTER =================

  static Future<void> register() async {
    final utm = _getUtmParams();

    await _firebase.logSignUp(signUpMethod: 'email');

    await _facebook.logEvent(name: 'CompleteRegistration',parameters: { ...utm });

    await TikTokEventsSdk.logEvent(
      event: TikTokEvent(eventName: 'CompleteRegistration',properties: EventProperties(customProperties: {...utm})),
    );
  }

  static void clearUtm() {
    PrefStore().saveString("utm_campaign", "");
    PrefStore().saveString("utm_source", "");
    PrefStore().saveString("utm_id", "");
  }
}