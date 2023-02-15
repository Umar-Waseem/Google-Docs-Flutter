import 'dart:convert';

class DocumentModel {
  final String uid;
  String title;
  final List content;
  final DateTime createdAt;
  final String id;

  DocumentModel({
    required this.uid,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.id,
  });

  DocumentModel copyWith({
    String? uid,
    String? title,
    List? content,
    DateTime? createdAt,
    String? id,
  }) {
    return DocumentModel(
      uid: uid ?? this.uid,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'title': title,
      'contents': content,
      'createdAt': createdAt.millisecondsSinceEpoch,
      '_id': id,
    };
  }

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      id: map['_id'] as String,
      uid: map['uid'] as String,
      title: map['title'] as String,
      content: List.from(map['contents'] as List),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory DocumentModel.fromJson(String source) =>
      DocumentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DocumentModel(uid: $uid, title: $title, content: $content, createdAt: $createdAt, id: $id)';
  }
}
