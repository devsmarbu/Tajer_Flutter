// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

import 'package:tajer/app/modules/orders/orderDetail/models/net_payable.dart';
import 'package:tajer/app/modules/orders/orderDetail/models/price_detail.dart';
import 'package:flutter/material.dart';

import 'order_detail.dart';

class ChildOrderDetailItem {
  String? selprod_title;
  String? orderstatus_color_code;
  String? canCancelOrder;
  String? prod_rating;
  String? canReturnOrder;
  String? canExchangeOrder;
  String? canMissingProductRequest;
  String? canSubmitFeedback;
  String? selprod_urlrewrite_id;
  String? credential_password;
  String? op_order_id;
  String? reviewsAllowed;
  String? op_product_dimension_unit;
  String? selprod_features;
  String? order_affiliate_user_id;
  String? order_discount_coupon_code;
  String? product_image_url;
  String? order_discount_value;
  String? user_registered_initially_for;
  String? op_review_reminder_count;
  String? opcharge_op_id;
  String? op_selprod_sku;
  String? order_status;
  String? op_refund_amount;
  String? pmethod_active;
  String? op_product_weight;
  String? oplang_order_id;
  String? opship_tracking_url;
  String? order_tax_charged;
  String? selprodlang_selprod_id;
  String? user_referral_code;
  String? selprod_condition;
  String? order_referral_reward_points;
  String? selprod_active;
  String? orderstatus_type;
  String? selprod_url_keyword;
  String? op_refund_commission;
  String? order_site_commission;
  String? op_shop_owner_email;
  String? op_shop_owner_phone_dcode;
  String? order_discount_total;
  String? orderstatus_identifier;
  String? op_product_model;
  String? selprodlang_lang_id;
  String? op_shop_id;
  String? op_completion_date;
  String? selprod_price;
  String? op_brand_name;
  String? order_pmethod_id;
  String? user_affiliate_commission;
  String? order_shippingapi_id;
  String? user_id;
  String? selprod_track_inventory;
  String? op_product_name;
  String? op_comments;
  String? selprod_sku;
  String? op_selprod_download_validity_in_days;
  String? order_wallet_amount_charge;
  String? order_id;
  String? op_refund_affiliate_commission;
  String? op_products_dimension_unit_name;
  String? user_name;
  String? selprod_stock;
  String? op_commission_include_shipping;
  String? op_shipped_date;
  String? pmethodlang_pmethod_id;
  String? op_affiliate_commission_charged;
  String? order_cart_data;
  String? op_commission_percentage;
  String? op_batch_selprod_id;
  String? op_status_id;
  String? orderstatuslang_orderstatus_id;
  String? op_tax_collected_by_seller;
  String? op_shop_owner_username;
  String? order_user_id;
  String? selprod_subtract_stock;
  String? selprod_available_from;
  String? orderstatuslang_lang_id;
  String? op_product_length;
  String? order_affiliate_total_commission;
  String? op_unit_price;
  String? op_selprod_price;
  String? order_language_code;
  String? selprod_downloadable_link;
  String? credential_email;
  String? user_regdate;
  String? op_id;
  String? order_discount_info;
  String? user_city;
  String? user_phone_dcode;
  String? op_product_type;
  String? order_user_comments;
  String? pmethod_code;
  String? op_affiliate_commission_percentage;
  String? op_product_weight_unit;
  String? pmethod_description;
  String? op_shipping_durations;
  String? order_volume_discount_total;
  String? user_profile_info;
  String? user_googleplus_id;
  String? selprod_sold_count;
  List<PriceDetail>? priceDetail;
  List<dynamic>? orderProgress;
  String? op_selprod_id;
  String? user_referrer_user_id;
  String? orderstatus_is_active;
  String? selprod_cost;
  String? pmethod_identifier;
  String? oplang_op_id;
  int? orderstatus_id;
  String? order_is_wallet_selected;
  String? order_is_paid;
  String? order_referrer_reward_points;
  String? user_zip;
  String? selprod_min_order_qty;
  String? order_referrer_user_id;
  String? order_discount_type;
  String? order_reward_point_used;
  String? user_autorenew_subscription;
  String? user_preferred_dashboard;
  String? order_currency_id;
  String? op_qty;
  String? credential_username;
  String? order_type;
  String? orderstatus_is_digital;
  String? user_company;
  String? op_commission_include_tax;
  String? selprod_code;
  String? order_date_added;
  String? op_is_batch;
  String? user_affiliate_referrer_user_id;
  String? credential_verified;
  String? opsetting_op_id;
  String? selprod_comments;
  NetPayable? totalAmount; // replace with concrete class if needed
  String? selprod_added_on;
  String? user_country_id;
  String? op_shop_name;
  String? op_selprod_title;
  String? user_fb_access_token;
  String? op_sent_review_reminder;
  String? op_selprod_code;
  String? oplang_lang_id;
  String? user_is_supplier;
  String? selprod_download_validity_in_days;
  String? op_selprod_condition;
  String? credential_active;
  String? op_commission_charged;
  String? op_product_width;
  String? selprod_user_id;
  String? user_is_affiliate;
  String? op_selprod_max_download_times;
  String? order_date_updated;
  String? user_is_shipping_company;
  String? order_reward_point_value;
  String? order_net_amount;
  String? order_currency_value;
  String? order_shippingapi_code;
  String? pmethod_name;
  String? op_product_height;
  String? credential_user_id;
  String? selprod_product_id;
  String? user_is_buyer;
  String? selprod_threshold_stock_level;
  String? op_invoice_number;
  String? user_is_advertiser;
  String? op_refund_shipping;
  String? order_admin_comments;
  String? order_renew;
  String? op_product_weight_unit_name;
  String? op_sent_last_reminder;
  String? user_phone;
  String? op_selprod_user_id;
  String? op_shop_owner_name;
  String? addr_phone_dcode;
  String? user_facebook_id;
  String? selprod_cod_enabled;
  String? user_order_tracking_url;
  String? selprod_max_download_times;
  String? op_free_ship_upto;
  String? op_other_charges;
  String? user_dob;
  String? op_refund_qty;
  String? selprod_id;
  String? orderstatus_priority;
  String? pmethod_display_order;
  String? op_sduration_id;
  String? op_shipping_duration_name;
  String? user_state_id;
  String? orderstatus_name;
  String? op_actual_shipping_charges;
  String? pmethodlang_lang_id;
  String? op_unit_cost;
  String? user_address2;
  String? op_shop_owner_phone;
  String? user_address1;
  String? user_products_services;
  String? order_language_id;
  String? selprod_warranty;
  String? op_selprod_options;
  String? selprod_return_policy;
  String? pmethod_id;
  String? user_deleted;
  String? order_currency_code;
  String? selprod_deleted;
  String? plugin_code;
  String? plugin_name;
  String? opshipping_label;

  String? cancel_until_date;
  String? return_until_date;
  String? exchange_until_date;
  String? missing_until_date;
  String? message_count;
  String? return_request_date;
  String? exchange_request_date;
  String? return_request;
  String? exchange_request;
  String? oshistory_date_added;
  String? missing_request;
  int? availableInLocation;
  RequestInfo? requestInfo;

  ChildOrderDetailItem({
    this.selprod_title,
    this.orderstatus_color_code,
    this.canCancelOrder,
    this.prod_rating,
    this.canReturnOrder,
    this.canExchangeOrder,
    this.canMissingProductRequest,
    this.canSubmitFeedback,
    this.selprod_urlrewrite_id,
    this.credential_password,
    this.op_order_id,
    this.reviewsAllowed,
    this.op_product_dimension_unit,
    this.selprod_features,
    this.order_affiliate_user_id,
    this.order_discount_coupon_code,
    this.product_image_url,
    this.order_discount_value,
    this.user_registered_initially_for,
    this.op_review_reminder_count,
    this.opcharge_op_id,
    this.op_selprod_sku,
    this.order_status,
    this.op_refund_amount,
    this.pmethod_active,
    this.op_product_weight,
    this.oplang_order_id,
    this.opship_tracking_url,
    this.order_tax_charged,
    this.selprodlang_selprod_id,
    this.user_referral_code,
    this.selprod_condition,
    this.order_referral_reward_points,
    this.selprod_active,
    this.orderstatus_type,
    this.selprod_url_keyword,
    this.op_refund_commission,
    this.order_site_commission,
    this.op_shop_owner_email,
    this.op_shop_owner_phone_dcode,
    this.order_discount_total,
    this.orderstatus_identifier,
    this.op_product_model,
    this.selprodlang_lang_id,
    this.op_shop_id,
    this.op_completion_date,
    this.selprod_price,
    this.op_brand_name,
    this.order_pmethod_id,
    this.user_affiliate_commission,
    this.order_shippingapi_id,
    this.user_id,
    this.selprod_track_inventory,
    this.op_product_name,
    this.op_comments,
    this.selprod_sku,
    this.op_selprod_download_validity_in_days,
    this.order_wallet_amount_charge,
    this.order_id,
    this.op_refund_affiliate_commission,
    this.op_products_dimension_unit_name,
    this.user_name,
    this.selprod_stock,
    this.op_commission_include_shipping,
    this.op_shipped_date,
    this.pmethodlang_pmethod_id,
    this.op_affiliate_commission_charged,
    this.order_cart_data,
    this.op_commission_percentage,
    this.op_batch_selprod_id,
    this.op_status_id,
    this.orderstatuslang_orderstatus_id,
    this.op_tax_collected_by_seller,
    this.op_shop_owner_username,
    this.order_user_id,
    this.selprod_subtract_stock,
    this.selprod_available_from,
    this.orderstatuslang_lang_id,
    this.op_product_length,
    this.order_affiliate_total_commission,
    this.op_unit_price,
    this.op_selprod_price,
    this.order_language_code,
    this.selprod_downloadable_link,
    this.credential_email,
    this.user_regdate,
    this.op_id,
    this.order_discount_info,
    this.user_city,
    this.user_phone_dcode,
    this.op_product_type,
    this.order_user_comments,
    this.pmethod_code,
    this.op_affiliate_commission_percentage,
    this.op_product_weight_unit,
    this.pmethod_description,
    this.op_shipping_durations,
    this.order_volume_discount_total,
    this.user_profile_info,
    this.user_googleplus_id,
    this.selprod_sold_count,
    this.priceDetail,
    this.orderProgress,
    this.op_selprod_id,
    this.user_referrer_user_id,
    this.orderstatus_is_active,
    this.selprod_cost,
    this.pmethod_identifier,
    this.oplang_op_id,
    this.orderstatus_id,
    this.order_is_wallet_selected,
    this.order_is_paid,
    this.order_referrer_reward_points,
    this.user_zip,
    this.selprod_min_order_qty,
    this.order_referrer_user_id,
    this.order_discount_type,
    this.order_reward_point_used,
    this.user_autorenew_subscription,
    this.user_preferred_dashboard,
    this.order_currency_id,
    this.op_qty,
    this.credential_username,
    this.order_type,
    this.orderstatus_is_digital,
    this.user_company,
    this.op_commission_include_tax,
    this.selprod_code,
    this.order_date_added,
    this.op_is_batch,
    this.user_affiliate_referrer_user_id,
    this.credential_verified,
    this.opsetting_op_id,
    this.selprod_comments,
    this.totalAmount,
    this.selprod_added_on,
    this.user_country_id,
    this.op_shop_name,
    this.op_selprod_title,
    this.user_fb_access_token,
    this.op_sent_review_reminder,
    this.op_selprod_code,
    this.oplang_lang_id,
    this.user_is_supplier,
    this.selprod_download_validity_in_days,
    this.op_selprod_condition,
    this.credential_active,
    this.op_commission_charged,
    this.op_product_width,
    this.selprod_user_id,
    this.user_is_affiliate,
    this.op_selprod_max_download_times,
    this.order_date_updated,
    this.user_is_shipping_company,
    this.order_reward_point_value,
    this.order_net_amount,
    this.order_currency_value,
    this.order_shippingapi_code,
    this.pmethod_name,
    this.op_product_height,
    this.credential_user_id,
    this.selprod_product_id,
    this.user_is_buyer,
    this.selprod_threshold_stock_level,
    this.op_invoice_number,
    this.user_is_advertiser,
    this.op_refund_shipping,
    this.order_admin_comments,
    this.order_renew,
    this.op_product_weight_unit_name,
    this.op_sent_last_reminder,
    this.user_phone,
    this.op_selprod_user_id,
    this.op_shop_owner_name,
    this.addr_phone_dcode,
    this.user_facebook_id,
    this.selprod_cod_enabled,
    this.user_order_tracking_url,
    this.selprod_max_download_times,
    this.op_free_ship_upto,
    this.op_other_charges,
    this.user_dob,
    this.op_refund_qty,
    this.selprod_id,
    this.orderstatus_priority,
    this.pmethod_display_order,
    this.op_sduration_id,
    this.op_shipping_duration_name,
    this.user_state_id,
    this.orderstatus_name,
    this.op_actual_shipping_charges,
    this.pmethodlang_lang_id,
    this.op_unit_cost,
    this.user_address2,
    this.op_shop_owner_phone,
    this.user_address1,
    this.user_products_services,
    this.order_language_id,
    this.selprod_warranty,
    this.op_selprod_options,
    this.selprod_return_policy,
    this.pmethod_id,
    this.user_deleted,
    this.order_currency_code,
    this.selprod_deleted,
    this.plugin_code,
    this.plugin_name,
    this.opshipping_label,
    this.availableInLocation,
    this.cancel_until_date,
    this.exchange_until_date,
    this.return_until_date,
    this.missing_until_date,
    this.message_count,
    this.exchange_request_date,
    this.return_request_date,
    this.exchange_request,
    this.return_request,
    this.oshistory_date_added,
    this.requestInfo,
    this.missing_request
  });

  factory ChildOrderDetailItem.fromJson(Map<String, dynamic> json) {
    final model = ChildOrderDetailItem(
      selprod_title: json['selprod_title'] as String?,
      orderstatus_color_code: json['orderstatus_color_code'] as String?,
      canCancelOrder: json['canCancelOrder'] as String?,
      prod_rating: json['prod_rating'] as String?,
      canReturnOrder: json['canReturnOrder'] as String?,
      canExchangeOrder: json['canExchangeOrder'] as String?,
      canMissingProductRequest: json['canMissingProductRequest'] as String?,
      canSubmitFeedback: json['canSubmitFeedback'] as String?,
      selprod_urlrewrite_id: json['selprod_urlrewrite_id'] as String?,
      credential_password: json['credential_password'] as String?,
      op_order_id: json['op_order_id'] as String?,
      reviewsAllowed: json['reviewsAllowed'] as String?,
      op_product_dimension_unit: json['op_product_dimension_unit'] as String?,
      selprod_features: json['selprod_features'] as String?,
      order_affiliate_user_id: json['order_affiliate_user_id'] as String?,
      order_discount_coupon_code: json['order_discount_coupon_code'] as String?,
      product_image_url: json['product_image_url'] as String?,
      order_discount_value: json['order_discount_value'] as String?,
      user_registered_initially_for:
          json['user_registered_initially_for'] as String?,
      op_review_reminder_count: json['op_review_reminder_count'] as String?,
      opcharge_op_id: json['opcharge_op_id'] as String?,
      op_selprod_sku: json['op_selprod_sku'] as String?,
      order_status: json['order_status'] as String?,
      op_refund_amount: json['op_refund_amount'] as String?,
      pmethod_active: json['pmethod_active'] as String?,
      op_product_weight: json['op_product_weight'] as String?,
      oplang_order_id: json['oplang_order_id'] as String?,
      opship_tracking_url: json['opship_tracking_url'] as String?,
      order_tax_charged: json['order_tax_charged'] as String?,
      selprodlang_selprod_id: json['selprodlang_selprod_id'] as String?,
      user_referral_code: json['user_referral_code'] as String?,
      selprod_condition: json['selprod_condition'] as String?,
      order_referral_reward_points:
          json['order_referral_reward_points'] as String?,
      selprod_active: json['selprod_active'] as String?,
      orderstatus_type: json['orderstatus_type'] as String?,
      selprod_url_keyword: json['selprod_url_keyword'] as String?,
      op_refund_commission: json['op_refund_commission'] as String?,
      order_site_commission: json['order_site_commission'] as String?,
      op_shop_owner_email: json['op_shop_owner_email'] as String?,
      op_shop_owner_phone_dcode: json['op_shop_owner_phone_dcode'] as String?,
      order_discount_total: json['order_discount_total'] as String?,
      orderstatus_identifier: json['orderstatus_identifier'] as String?,
      op_product_model: json['op_product_model'] as String?,
      selprodlang_lang_id: json['selprodlang_lang_id'] as String?,
      op_shop_id: json['op_shop_id'] as String?,
      op_completion_date: json['op_completion_date'] as String?,
      selprod_price: json['selprod_price'] as String?,
      op_brand_name: json['op_brand_name'] as String?,
      order_pmethod_id: json['order_pmethod_id'] as String?,
      user_affiliate_commission: json['user_affiliate_commission'] as String?,
      order_shippingapi_id: json['order_shippingapi_id'] as String?,
      user_id: json['user_id'] as String?,
      selprod_track_inventory: json['selprod_track_inventory'] as String?,
      op_product_name: json['op_product_name'] as String?,
      op_comments: json['op_comments'] as String?,
      selprod_sku: json['selprod_sku'] as String?,
      op_selprod_download_validity_in_days:
          json['op_selprod_download_validity_in_days'] as String?,
      order_wallet_amount_charge: json['order_wallet_amount_charge'] as String?,
      order_id: json['order_id'] as String?,
      op_refund_affiliate_commission:
          json['op_refund_affiliate_commission'] as String?,
      op_products_dimension_unit_name:
          json['op_products_dimension_unit_name'] as String?,
      user_name: json['user_name'] as String?,
      selprod_stock: json['selprod_stock'] as String?,
      op_commission_include_shipping:
          json['op_commission_include_shipping'] as String?,
      op_shipped_date: json['op_shipped_date'] as String?,
      pmethodlang_pmethod_id: json['pmethodlang_pmethod_id'] as String?,
      op_affiliate_commission_charged:
          json['op_affiliate_commission_charged'] as String?,
      order_cart_data: json['order_cart_data'] as String?,
      op_commission_percentage: json['op_commission_percentage'] as String?,
      op_batch_selprod_id: json['op_batch_selprod_id'] as String?,
      op_status_id: json['op_status_id'] as String?,
      orderstatuslang_orderstatus_id:
          json['orderstatuslang_orderstatus_id'] as String?,
      op_tax_collected_by_seller: json['op_tax_collected_by_seller'] as String?,
      op_shop_owner_username: json['op_shop_owner_username'] as String?,
      order_user_id: json['order_user_id'] as String?,
      selprod_subtract_stock: json['selprod_subtract_stock'] as String?,
      selprod_available_from: json['selprod_available_from'] as String?,
      orderstatuslang_lang_id: json['orderstatuslang_lang_id'] as String?,
      op_product_length: json['op_product_length'] as String?,
      order_affiliate_total_commission:
          json['order_affiliate_total_commission'] as String?,
      op_unit_price: json['op_unit_price'] as String?,
      op_selprod_price: json['op_selprod_price'] as String?,
      order_language_code: json['order_language_code'] as String?,
      selprod_downloadable_link: json['selprod_downloadable_link'] as String?,
      credential_email: json['credential_email'] as String?,
      user_regdate: json['user_regdate'] as String?,
      op_id: json['op_id'] as String?,
      order_discount_info: json['order_discount_info'] as String?,
      user_city: json['user_city'] as String?,
      user_phone_dcode: json['user_phone_dcode'] as String?,
      op_product_type: json['op_product_type'] as String?,
      order_user_comments: json['order_user_comments'] as String?,
      pmethod_code: json['pmethod_code'] as String?,
      op_affiliate_commission_percentage:
          json['op_affiliate_commission_percentage'] as String?,
      op_product_weight_unit: json['op_product_weight_unit'] as String?,
      pmethod_description: json['pmethod_description'] as String?,
      op_shipping_durations: json['op_shipping_durations'] as String?,
      order_volume_discount_total:
          json['order_volume_discount_total'] as String?,
      user_profile_info: json['user_profile_info'] as String?,
      user_googleplus_id: json['user_googleplus_id'] as String?,
      selprod_sold_count: json['selprod_sold_count'] as String?,
      priceDetail: json['priceDetail'] != null
          ? (json['priceDetail'] as List)
                .map((e) => PriceDetail.fromJson(e))
                .toList()
          : [],
      orderProgress: json['orderProgress'] is List
          ? List<dynamic>.from(json['orderProgress'])
          : null,
      op_selprod_id: json['op_selprod_id'] as String?,
      user_referrer_user_id: json['user_referrer_user_id'] as String?,
      orderstatus_is_active: json['orderstatus_is_active'] as String?,
      selprod_cost: json['selprod_cost'] as String?,
      pmethod_identifier: json['pmethod_identifier'] as String?,
      oplang_op_id: json['oplang_op_id'] as String?,
      orderstatus_id: json['orderstatus_id'] is int
          ? json['orderstatus_id'] as int
          : int.tryParse(json['orderstatus_id']?.toString() ?? ''),
      order_is_wallet_selected: json['order_is_wallet_selected'] as String?,
      order_is_paid: json['order_is_paid'] as String?,
      order_referrer_reward_points:
          json['order_referrer_reward_points'] as String?,
      user_zip: json['user_zip'] as String?,
      selprod_min_order_qty: json['selprod_min_order_qty'] as String?,
      order_referrer_user_id: json['order_referrer_user_id'] as String?,
      order_discount_type: json['order_discount_type'] as String?,
      order_reward_point_used: json['order_reward_point_used'] as String?,
      user_autorenew_subscription:
          json['user_autorenew_subscription'] as String?,
      user_preferred_dashboard: json['user_preferred_dashboard'] as String?,
      order_currency_id: json['order_currency_id'] as String?,
      op_qty: json['op_qty'] as String?,
      credential_username: json['credential_username'] as String?,
      order_type: json['order_type'] as String?,
      orderstatus_is_digital: json['orderstatus_is_digital'] as String?,
      user_company: json['user_company'] as String?,
      op_commission_include_tax: json['op_commission_include_tax'] as String?,
      selprod_code: json['selprod_code'] as String?,
      order_date_added: json['order_date_added'] as String?,
      op_is_batch: json['op_is_batch'] as String?,
      user_affiliate_referrer_user_id:
          json['user_affiliate_referrer_user_id'] as String?,
      credential_verified: json['credential_verified'] as String?,
      opsetting_op_id: json['opsetting_op_id'] as String?,
      selprod_comments: json['selprod_comments'] as String?,
      totalAmount: json['totalAmount'] != null
          ? NetPayable.fromJson(json['totalAmount'])
          : null,
      selprod_added_on: json['selprod_added_on'] as String?,
      user_country_id: json['user_country_id'] as String?,
      op_shop_name: json['op_shop_name'] as String?,
      op_selprod_title: json['op_selprod_title'] as String?,
      user_fb_access_token: json['user_fb_access_token'] as String?,
      op_sent_review_reminder: json['op_sent_review_reminder'] as String?,
      op_selprod_code: json['op_selprod_code'] as String?,
      oplang_lang_id: json['oplang_lang_id'] as String?,
      user_is_supplier: json['user_is_supplier'] as String?,
      selprod_download_validity_in_days:
          json['selprod_download_validity_in_days'] as String?,
      op_selprod_condition: json['op_selprod_condition'] as String?,
      credential_active: json['credential_active'] as String?,
      op_commission_charged: json['op_commission_charged'] as String?,
      op_product_width: json['op_product_width'] as String?,
      selprod_user_id: json['selprod_user_id'] as String?,
      user_is_affiliate: json['user_is_affiliate'] as String?,
      op_selprod_max_download_times:
          json['op_selprod_max_download_times'] as String?,
      order_date_updated: json['order_date_updated'] as String?,
      user_is_shipping_company: json['user_is_shipping_company'] as String?,
      order_reward_point_value: json['order_reward_point_value'] as String?,
      order_net_amount: json['order_net_amount'] as String?,
      order_currency_value: json['order_currency_value'] as String?,
      order_shippingapi_code: json['order_shippingapi_code'] as String?,
      pmethod_name: json['pmethod_name'] as String?,
      op_product_height: json['op_product_height'] as String?,
      credential_user_id: json['credential_user_id'] as String?,
      selprod_product_id: json['selprod_product_id'] as String?,
      user_is_buyer: json['user_is_buyer'] as String?,
      selprod_threshold_stock_level:
          json['selprod_threshold_stock_level'] as String?,
      op_invoice_number: json['op_invoice_number'] as String?,
      user_is_advertiser: json['user_is_advertiser'] as String?,
      op_refund_shipping: json['op_refund_shipping'] as String?,
      order_admin_comments: json['order_admin_comments'] as String?,
      order_renew: json['order_renew'] as String?,
      op_product_weight_unit_name:
          json['op_product_weight_unit_name'] as String?,
      op_sent_last_reminder: json['op_sent_last_reminder'] as String?,
      user_phone: json['user_phone'] as String?,
      op_selprod_user_id: json['op_selprod_user_id'] as String?,
      op_shop_owner_name: json['op_shop_owner_name'] as String?,
      addr_phone_dcode: json['addr_phone_dcode'] as String?,
      user_facebook_id: json['user_facebook_id'] as String?,
      selprod_cod_enabled: json['selprod_cod_enabled'] as String?,
      user_order_tracking_url: json['user_order_tracking_url'] as String?,
      selprod_max_download_times: json['selprod_max_download_times'] as String?,
      op_free_ship_upto: json['op_free_ship_upto'] as String?,
      op_other_charges: json['op_other_charges'] as String?,
      user_dob: json['user_dob'] as String?,
      op_refund_qty: json['op_refund_qty'] as String?,
      selprod_id: json['selprod_id'] as String?,
      orderstatus_priority: json['orderstatus_priority'] as String?,
      pmethod_display_order: json['pmethod_display_order'] as String?,
      op_sduration_id: json['op_sduration_id'] as String?,
      op_shipping_duration_name: json['op_shipping_duration_name'] as String?,
      user_state_id: json['user_state_id'] as String?,
      orderstatus_name: json['orderstatus_name'] as String?,
      op_actual_shipping_charges: json['op_actual_shipping_charges'] as String?,
      pmethodlang_lang_id: json['pmethodlang_lang_id'] as String?,
      op_unit_cost: json['op_unit_cost'] as String?,
      user_address2: json['user_address2'] as String?,
      op_shop_owner_phone: json['op_shop_owner_phone'] as String?,
      user_address1: json['user_address1'] as String?,
      user_products_services: json['user_products_services'] as String?,
      order_language_id: json['order_language_id'] as String?,
      selprod_warranty: json['selprod_warranty'] as String?,
      op_selprod_options: json['op_selprod_options'] as String?,
      selprod_return_policy: json['selprod_return_policy'] as String?,
      pmethod_id: json['pmethod_id'] as String?,
      user_deleted: json['user_deleted'] as String?,
      order_currency_code: json['order_currency_code'] as String?,
      selprod_deleted: json['selprod_deleted'] as String?,
      plugin_code: json['plugin_code'] as String?,
      plugin_name: json['plugin_name'] as String?,
      opshipping_label: json['opshipping_label'] as String?,

      cancel_until_date: json['cancel_until_date'] as String?,
      return_until_date: json['return_until_date'] as String?,
      exchange_until_date: json['exchange_until_date'] as String?,
      missing_until_date: json['missing_until_date'] as String?,
      message_count: json['message_count'] as String?,
      return_request_date: json['return_request_date'] as String?,
      exchange_request_date: json['exchange_request_date'] as String?,
      return_request: json['return_request'] as String?,
      exchange_request: json['exchange_request'] as String?,
      oshistory_date_added: json['oshistory_date_added'] as String?,
      missing_request: json['missing_request'] as String?,

      availableInLocation: json['availableInLocation'] is int
          ? json['availableInLocation'] as int
          : int.tryParse(json['availableInLocation']?.toString() ?? ''),
      requestInfo: (json['request_info'] != null &&
          json['request_info'] is Map<String, dynamic>)
          ? RequestInfo.fromJson(json['request_info'])
          : null,
    );
    return model;
  }

  Map<String, dynamic> toJson() {
    return {
      'selprod_title': selprod_title,
      'orderstatus_color_code': orderstatus_color_code,
      'canCancelOrder': canCancelOrder,
      'prod_rating': prod_rating,
      'canReturnOrder': canReturnOrder,
      'canExchangeOrder': canExchangeOrder,
      'canMissingProductRequest': canMissingProductRequest,
      'canSubmitFeedback': canSubmitFeedback,
      'selprod_urlrewrite_id': selprod_urlrewrite_id,
      'credential_password': credential_password,
      'op_order_id': op_order_id,
      'reviewsAllowed': reviewsAllowed,
      'op_product_dimension_unit': op_product_dimension_unit,
      'selprod_features': selprod_features,
      'order_affiliate_user_id': order_affiliate_user_id,
      'order_discount_coupon_code': order_discount_coupon_code,
      'product_image_url': product_image_url,
      'order_discount_value': order_discount_value,
      'user_registered_initially_for': user_registered_initially_for,
      'op_review_reminder_count': op_review_reminder_count,
      'opcharge_op_id': opcharge_op_id,
      'op_selprod_sku': op_selprod_sku,
      'order_status': order_status,
      'op_refund_amount': op_refund_amount,
      'pmethod_active': pmethod_active,
      'op_product_weight': op_product_weight,
      'oplang_order_id': oplang_order_id,
      'opship_tracking_url': opship_tracking_url,
      'order_tax_charged': order_tax_charged,
      'selprodlang_selprod_id': selprodlang_selprod_id,
      'user_referral_code': user_referral_code,
      'selprod_condition': selprod_condition,
      'order_referral_reward_points': order_referral_reward_points,
      'selprod_active': selprod_active,
      'orderstatus_type': orderstatus_type,
      'selprod_url_keyword': selprod_url_keyword,
      'op_refund_commission': op_refund_commission,
      'order_site_commission': order_site_commission,
      'op_shop_owner_email': op_shop_owner_email,
      'op_shop_owner_phone_dcode': op_shop_owner_phone_dcode,
      'order_discount_total': order_discount_total,
      'orderstatus_identifier': orderstatus_identifier,
      'op_product_model': op_product_model,
      'selprodlang_lang_id': selprodlang_lang_id,
      'op_shop_id': op_shop_id,
      'op_completion_date': op_completion_date,
      'selprod_price': selprod_price,
      'op_brand_name': op_brand_name,
      'order_pmethod_id': order_pmethod_id,
      'user_affiliate_commission': user_affiliate_commission,
      'order_shippingapi_id': order_shippingapi_id,
      'user_id': user_id,
      'selprod_track_inventory': selprod_track_inventory,
      'op_product_name': op_product_name,
      'op_comments': op_comments,
      'selprod_sku': selprod_sku,
      'op_selprod_download_validity_in_days':
          op_selprod_download_validity_in_days,
      'order_wallet_amount_charge': order_wallet_amount_charge,
      'order_id': order_id,
      'op_refund_affiliate_commission': op_refund_affiliate_commission,
      'op_products_dimension_unit_name': op_products_dimension_unit_name,
      'user_name': user_name,
      'selprod_stock': selprod_stock,
      'op_commission_include_shipping': op_commission_include_shipping,
      'op_shipped_date': op_shipped_date,
      'pmethodlang_pmethod_id': pmethodlang_pmethod_id,
      'op_affiliate_commission_charged': op_affiliate_commission_charged,
      'order_cart_data': order_cart_data,
      'op_commission_percentage': op_commission_percentage,
      'op_batch_selprod_id': op_batch_selprod_id,
      'op_status_id': op_status_id,
      'orderstatuslang_orderstatus_id': orderstatuslang_orderstatus_id,
      'op_tax_collected_by_seller': op_tax_collected_by_seller,
      'op_shop_owner_username': op_shop_owner_username,
      'order_user_id': order_user_id,
      'selprod_subtract_stock': selprod_subtract_stock,
      'selprod_available_from': selprod_available_from,
      'orderstatuslang_lang_id': orderstatuslang_lang_id,
      'op_product_length': op_product_length,
      'order_affiliate_total_commission': order_affiliate_total_commission,
      'op_unit_price': op_unit_price,
      'op_selprod_price': op_selprod_price,
      'order_language_code': order_language_code,
      'selprod_downloadable_link': selprod_downloadable_link,
      'credential_email': credential_email,
      'user_regdate': user_regdate,
      'op_id': op_id,
      'order_discount_info': order_discount_info,
      'user_city': user_city,
      'user_phone_dcode': user_phone_dcode,
      'op_product_type': op_product_type,
      'order_user_comments': order_user_comments,
      'pmethod_code': pmethod_code,
      'op_affiliate_commission_percentage': op_affiliate_commission_percentage,
      'op_product_weight_unit': op_product_weight_unit,
      'pmethod_description': pmethod_description,
      'op_shipping_durations': op_shipping_durations,
      'order_volume_discount_total': order_volume_discount_total,
      'user_profile_info': user_profile_info,
      'user_googleplus_id': user_googleplus_id,
      'selprod_sold_count': selprod_sold_count,
      'priceDetail': priceDetail,
      'orderProgress': orderProgress,
      'op_selprod_id': op_selprod_id,
      'user_referrer_user_id': user_referrer_user_id,
      'orderstatus_is_active': orderstatus_is_active,
      'selprod_cost': selprod_cost,
      'pmethod_identifier': pmethod_identifier,
      'oplang_op_id': oplang_op_id,
      'orderstatus_id': orderstatus_id,
      'order_is_wallet_selected': order_is_wallet_selected,
      'order_is_paid': order_is_paid,
      'order_referrer_reward_points': order_referrer_reward_points,
      'user_zip': user_zip,
      'selprod_min_order_qty': selprod_min_order_qty,
      'order_referrer_user_id': order_referrer_user_id,
      'order_discount_type': order_discount_type,
      'order_reward_point_used': order_reward_point_used,
      'user_autorenew_subscription': user_autorenew_subscription,
      'user_preferred_dashboard': user_preferred_dashboard,
      'order_currency_id': order_currency_id,
      'op_qty': op_qty,
      'credential_username': credential_username,
      'order_type': order_type,
      'orderstatus_is_digital': orderstatus_is_digital,
      'user_company': user_company,
      'op_commission_include_tax': op_commission_include_tax,
      'selprod_code': selprod_code,
      'order_date_added': order_date_added,
      'op_is_batch': op_is_batch,
      'user_affiliate_referrer_user_id': user_affiliate_referrer_user_id,
      'credential_verified': credential_verified,
      'opsetting_op_id': opsetting_op_id,
      'selprod_comments': selprod_comments,
      'totalAmount': totalAmount,
      'selprod_added_on': selprod_added_on,
      'user_country_id': user_country_id,
      'op_shop_name': op_shop_name,
      'op_selprod_title': op_selprod_title,
      'user_fb_access_token': user_fb_access_token,
      'op_sent_review_reminder': op_sent_review_reminder,
      'op_selprod_code': op_selprod_code,
      'oplang_lang_id': oplang_lang_id,
      'user_is_supplier': user_is_supplier,
      'selprod_download_validity_in_days': selprod_download_validity_in_days,
      'op_selprod_condition': op_selprod_condition,
      'credential_active': credential_active,
      'op_commission_charged': op_commission_charged,
      'op_product_width': op_product_width,
      'selprod_user_id': selprod_user_id,
      'user_is_affiliate': user_is_affiliate,
      'op_selprod_max_download_times': op_selprod_max_download_times,
      'order_date_updated': order_date_updated,
      'user_is_shipping_company': user_is_shipping_company,
      'order_reward_point_value': order_reward_point_value,
      'order_net_amount': order_net_amount,
      'order_currency_value': order_currency_value,
      'order_shippingapi_code': order_shippingapi_code,
      'pmethod_name': pmethod_name,
      'op_product_height': op_product_height,
      'credential_user_id': credential_user_id,
      'selprod_product_id': selprod_product_id,
      'user_is_buyer': user_is_buyer,
      'selprod_threshold_stock_level': selprod_threshold_stock_level,
      'op_invoice_number': op_invoice_number,
      'user_is_advertiser': user_is_advertiser,
      'op_refund_shipping': op_refund_shipping,
      'order_admin_comments': order_admin_comments,
      'order_renew': order_renew,
      'op_product_weight_unit_name': op_product_weight_unit_name,
      'op_sent_last_reminder': op_sent_last_reminder,
      'user_phone': user_phone,
      'op_selprod_user_id': op_selprod_user_id,
      'op_shop_owner_name': op_shop_owner_name,
      'addr_phone_dcode': addr_phone_dcode,
      'user_facebook_id': user_facebook_id,
      'selprod_cod_enabled': selprod_cod_enabled,
      'user_order_tracking_url': user_order_tracking_url,
      'selprod_max_download_times': selprod_max_download_times,
      'op_free_ship_upto': op_free_ship_upto,
      'op_other_charges': op_other_charges,
      'user_dob': user_dob,
      'op_refund_qty': op_refund_qty,
      'selprod_id': selprod_id,
      'orderstatus_priority': orderstatus_priority,
      'pmethod_display_order': pmethod_display_order,
      'op_sduration_id': op_sduration_id,
      'op_shipping_duration_name': op_shipping_duration_name,
      'user_state_id': user_state_id,
      'orderstatus_name': orderstatus_name,
      'op_actual_shipping_charges': op_actual_shipping_charges,
      'pmethodlang_lang_id': pmethodlang_lang_id,
      'op_unit_cost': op_unit_cost,
      'user_address2': user_address2,
      'op_shop_owner_phone': op_shop_owner_phone,
      'user_address1': user_address1,
      'user_products_services': user_products_services,
      'order_language_id': order_language_id,
      'selprod_warranty': selprod_warranty,
      'op_selprod_options': op_selprod_options,
      'selprod_return_policy': selprod_return_policy,
      'pmethod_id': pmethod_id,
      'user_deleted': user_deleted,
      'order_currency_code': order_currency_code,
      'selprod_deleted': selprod_deleted,
      'plugin_code': plugin_code,
      'plugin_name': plugin_name,
      'opshipping_label': opshipping_label,
      'availableInLocation': availableInLocation,

      'cancel_until_date': cancel_until_date,
      'return_until_date': return_until_date,
      'exchange_until_date': exchange_until_date,
      'missing_until_date': missing_until_date,
      'message_count': message_count,
      'return_request_date': return_request_date,
      'exchange_request_date': exchange_request_date,
      'return_request': return_request,
      'exchange_request': exchange_request,
      'oshistory_date_added': oshistory_date_added,
      'missing_request': missing_request,
      'request_info': requestInfo?.toJson(),
    };
  }

  String get statusIcon {
    switch (op_status_id) {
      case '2': // Payment Confirmed
        return 'assets/icons/Check.svg';

      case '3': // In Process
        return 'assets/icons/Clock.svg';

      case '4': // Shipped
        return 'assets/icons/Package.svg';

      case '5': // Delivered
        return 'assets/icons/Check.svg';

      case '7': // Completed
        return 'assets/icons/Check.svg';

      case '6': // Return Requested
        return 'assets/icons/ArrowUDownLeft.svg';

      case '20': // Exchange Requested
        return 'assets/icons/ArrowsLeftRight.svg';

      case '19': // Missing Requested
        return 'assets/icons/QuestionMark.svg';

      case '8': // Cancelled
        return 'assets/icons/X.svg';

      case '9': // Refunded/Completed
        return 'assets/icons/Check.svg';

      case '16': // Cash on Delivery
        return 'assets/icons/Money.svg';

      case '17': // Pay at Store
        return 'assets/icons/Money.svg';

      case '18': // Ready for Pickup
        return 'assets/icons/Check.svg';

      case '15': // Approved
        return 'assets/icons/Check.svg';

      default:
        return 'assets/icons/Check.svg';
    }
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class RequestInfo {
  String? reason;
  String? comments;

  RequestInfo({
    this.reason,
    this.comments,
  });

  factory RequestInfo.fromJson(Map<String, dynamic> json) {
    return RequestInfo(
      reason: json['reason'],
      comments: json['comments'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reason': reason,
      'comments': comments,
    };
  }
}