class LoginStatus {
  final int facebookLogin;
  final int instagramLogin;
  final int appleLogin;
  final int googleLogin;

  LoginStatus({
    required this.facebookLogin,
    required this.instagramLogin,
    required this.appleLogin,
    required this.googleLogin,
  });

  factory LoginStatus.fromJson(Map<String, dynamic> json) {
    return LoginStatus(
      facebookLogin: json['FacebookLogin'] is int
          ? json['FacebookLogin']
          : int.tryParse(json['FacebookLogin']?.toString() ?? '0') ?? 0,
      instagramLogin: json['InstagramLogin'] is int
          ? json['InstagramLogin']
          : int.tryParse(json['InstagramLogin']?.toString() ?? '0') ?? 0,
      appleLogin: json['AppleLogin'] is int
          ? json['AppleLogin']
          : int.tryParse(json['AppleLogin']?.toString() ?? '0') ?? 0,
      googleLogin: json['GoogleLogin'] is int
          ? json['GoogleLogin']
          : int.tryParse(json['GoogleLogin']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'FacebookLogin': facebookLogin,
      'InstagramLogin': instagramLogin,
      'AppleLogin': appleLogin,
      'GoogleLogin': googleLogin,
    };
  }
}
