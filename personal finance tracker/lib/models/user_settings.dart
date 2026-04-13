class UserSettings {
  final int? id;
  final String key;
  final String value;

  UserSettings({
    this.id,
    required this.key,
    required this.value,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'key': key,
      'value': value,
    };
  }

  factory UserSettings.fromMap(Map<String, dynamic> map) {
    return UserSettings(
      id: map['id'],
      key: map['key'],
      value: map['value'],
    );
  }
}
