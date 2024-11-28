class UserSettings {
  String? id;
  String userId;
  bool activeNotifications;
  bool activeUpdates;

  UserSettings({
    this.id,
    required this.userId,
    required this.activeNotifications,
    required this.activeUpdates,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json, id) {
    return UserSettings(
      id: id,
      userId: json['user_id'],
      activeNotifications: json['active_notifications'],
      activeUpdates: json['active_updates'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'active_notifications': activeNotifications,
      'active_updates': activeUpdates,
    };
  }
}
