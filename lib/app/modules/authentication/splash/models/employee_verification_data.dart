class EmployeeVerificationData {
  final String verificationStatus;
  final String workEmail;
  final String createdOn;
  final String expiresOn;
  final String verifiedOn;

  EmployeeVerificationData({
    required this.verificationStatus,
    required this.workEmail,
    required this.createdOn,
    required this.expiresOn,
    required this.verifiedOn,
  });

  factory EmployeeVerificationData.fromJson(
      Map<String, dynamic> json,
      ) {
    return EmployeeVerificationData(
      verificationStatus: json['verificationStatus'] ?? '',
      workEmail: json['workEmail'] ?? '',
      createdOn: json['createdOn'] ?? '',
      expiresOn: json['expiresOn'] ?? '',
      verifiedOn: json['verifiedOn'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'verificationStatus': verificationStatus,
      'workEmail': workEmail,
      'createdOn': createdOn,
      'expiresOn': expiresOn,
      'verifiedOn': verifiedOn,
    };
  }
}