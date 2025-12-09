class PayoutPlugin {
  final String pluginId;
  final String pluginCode;
  final String pluginDescription;
  final String pluginName;
  final String pluginActive;
  final bool isSelected;

  PayoutPlugin({
    required this.pluginId,
    required this.pluginCode,
    required this.pluginDescription,
    required this.pluginName,
    required this.pluginActive,
    required this.isSelected,
  });

  /// ✅ Factory for JSON parsing
  factory PayoutPlugin.fromJson(Map<String, dynamic> json) {
    return PayoutPlugin(
      pluginId: json['plugin_id'] ?? 0,
      pluginCode: json['plugin_code'] ?? '',
      pluginDescription: json['plugin_description'] ?? '',
      pluginName: json['plugin_name'] ?? '',
      pluginActive: json['plugin_active'] ?? 0,
      isSelected: json['isSelected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plugin_id': pluginId,
      'plugin_code': pluginCode,
      'plugin_description': pluginDescription,
      'plugin_name': pluginName,
      'plugin_active': pluginActive,
      'isSelected': isSelected,
    };
  }
}
