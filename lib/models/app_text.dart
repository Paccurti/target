import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class AppText {
  final String id;
  final String appText;
  AppText({
    required this.id,
    required this.appText,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'appText': appText,
    };
  }

  factory AppText.fromMap(Map<String, dynamic> map) {
    return AppText(
      id: map['id'] as String,
      appText: map['appText'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppText.fromJson(String source) => AppText.fromMap(json.decode(source) as Map<String, dynamic>);
}
