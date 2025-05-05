class AdminDetails {
  String adminId;
  String email;
  String? name;

  AdminDetails({
    required this.adminId,
    required this.email,
    this.name,
  });

  factory AdminDetails.fromJson(Map<String, dynamic> json) {
    return AdminDetails(
      adminId: json['admin_id'],
      email: json['email'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'admin_id': adminId,
      'email': email,
      'name': name
    };
  }
}
