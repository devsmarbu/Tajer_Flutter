
class PickupDetail {
  String? opshippingDate;
  String? opshippingTimeSlotFrom;
  String? opshippingTimeSlotTo;

  PickupDetail({
    this.opshippingDate,
    this.opshippingTimeSlotFrom,
    this.opshippingTimeSlotTo,
  });

  factory PickupDetail.fromJson(Map<String, dynamic> json) {
    return PickupDetail(
      opshippingDate: json["opshipping_date"],
      opshippingTimeSlotFrom: json["opshipping_time_slot_from"],
      opshippingTimeSlotTo: json["opshipping_time_slot_to"],
    );
  }

  Map<String, dynamic> toJson() => {
    "opshipping_date": opshippingDate,
    "opshipping_time_slot_from": opshippingTimeSlotFrom,
    "opshipping_time_slot_to": opshippingTimeSlotTo,
  };
}