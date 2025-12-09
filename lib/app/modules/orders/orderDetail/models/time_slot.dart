class TimeSlot {
  final String tslotId;
  final String tslotType;
  final String tslotAvailability;
  final String tslotRecordId;
  final String tslotSubrecordId;
  final String tslotDay;
  final String tslotFromTime;
  final String tslotToTime;
  bool selected;

  TimeSlot({
    required this.tslotId,
    required this.tslotType,
    required this.tslotAvailability,
    required this.tslotRecordId,
    required this.tslotSubrecordId,
    required this.tslotDay,
    required this.tslotFromTime,
    required this.tslotToTime,
    this.selected = false,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      tslotId: json['tslot_id'] ?? '',
      tslotType: json['tslot_type'] ?? '',
      tslotAvailability: json['tslot_availability'] ?? '',
      tslotRecordId: json['tslot_record_id'] ?? '',
      tslotSubrecordId: json['tslot_subrecord_id'] ?? '',
      tslotDay: json['tslot_day'] ?? '',
      tslotFromTime: json['tslot_from_time'] ?? '',
      tslotToTime: json['tslot_to_time'] ?? '',
      selected: json['selected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tslot_id': tslotId,
      'tslot_type': tslotType,
      'tslot_availability': tslotAvailability,
      'tslot_record_id': tslotRecordId,
      'tslot_subrecord_id': tslotSubrecordId,
      'tslot_day': tslotDay,
      'tslot_from_time': tslotFromTime,
      'tslot_to_time': tslotToTime,
      'selected': selected,
    };
  }
}
