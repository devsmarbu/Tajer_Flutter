enum EmployeeVerificationStatus {
  verified,
  emailConfirmed,
  pending,
  expired,
  unknown,
}

extension EmployeeVerificationStatusExtension on EmployeeVerificationStatus {
  static EmployeeVerificationStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case "verified":
        return EmployeeVerificationStatus.verified;

      case "email_confirmed":
        return EmployeeVerificationStatus.emailConfirmed;

      case "pending":
        return EmployeeVerificationStatus.pending;

      case "expired":
        return EmployeeVerificationStatus.expired;

      default:
        return EmployeeVerificationStatus.unknown;
    }
  }

  String get value {
    switch (this) {
      case EmployeeVerificationStatus.verified:
        return "verified";

      case EmployeeVerificationStatus.emailConfirmed:
        return "email_confirmed";

      case EmployeeVerificationStatus.pending:
        return "pending";

      case EmployeeVerificationStatus.expired:
        return "expired";

      case EmployeeVerificationStatus.unknown:
        return "unknown";
    }
  }
}
