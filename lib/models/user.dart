import 'dart:convert';

class User {
  String name;
  String emailAddress;
  DateTime? dateSignedUp;
  DateTime? lastSeen;

  String? userType;
  User({
    required this.name,
    required this.emailAddress,
    this.dateSignedUp,
    this.lastSeen,
    this.userType,
  });

  User copyWith({
    String? name,
    String? emailAddress,
    DateTime? dateSignedUp,
    DateTime? lastSeen,
    String? userType,
  }) {
    return User(
      name: name ?? this.name,
      emailAddress: emailAddress ?? this.emailAddress,
      dateSignedUp: dateSignedUp ?? this.dateSignedUp,
      lastSeen: lastSeen ?? this.lastSeen,
      userType: userType ?? this.userType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'emailAddress': emailAddress,
      'dateSignedUp': dateSignedUp,
      'lastSeen': lastSeen,
      'userType': userType,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'],
      emailAddress: map['email'],
      dateSignedUp: map['dateSignedUp'].toDate(),
      lastSeen: map['lastSeen'].toDate(),
      userType: map['userType'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(name: $name, emailAddress: $emailAddress, dateSignedUp: $dateSignedUp, lastSeen: $lastSeen,  userType: $userType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.name == name &&
        other.emailAddress == emailAddress &&
        other.dateSignedUp == dateSignedUp &&
        other.lastSeen == lastSeen &&
        other.userType == userType;
  }

  @override
  int get hashCode {
    return name.hashCode ^ emailAddress.hashCode ^ dateSignedUp.hashCode ^ lastSeen.hashCode ^ userType.hashCode;
  }
}
