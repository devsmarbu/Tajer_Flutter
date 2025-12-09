class RewardModel {
  final int points;
  final String orderId;
  final DateTime addedDate;
  final DateTime expiryDate;

  RewardModel({
    required this.points,
    required this.orderId,
    required this.addedDate,
    required this.expiryDate,
  });
}
