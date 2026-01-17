enum UserType { passenger, admin }

class User {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final UserType userType;
  final String? busCompanyName; // For admin users
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.userType,
    this.busCompanyName,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      userType: UserType.values.byName(json['userType']),
      busCompanyName: json['busCompanyName'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'userType': userType.name,
      'busCompanyName': busCompanyName,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Firestore methods
  factory User.fromMap(Map<String, dynamic> map, String documentId) {
    return User(
      id: documentId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      userType: UserType.values.byName(map['userType'] ?? 'passenger'),
      busCompanyName: map['busCompanyName'],
      createdAt: (map['createdAt'] as dynamic).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'userType': userType.name,
      'busCompanyName': busCompanyName,
      'createdAt': createdAt,
    };
  }
}
