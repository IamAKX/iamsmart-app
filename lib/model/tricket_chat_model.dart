import 'dart:convert';

class TicketChatModel {
  String? id;
  String? createdBy;
  DateTime? createdAt;
  String? text;
  TicketChatModel({
    this.id,
    this.createdBy,
    this.createdAt,
    this.text,
  });

  TicketChatModel copyWith({
    String? id,
    String? createdBy,
    DateTime? createdAt,
    String? text,
  }) {
    return TicketChatModel(
      id: id ?? this.id,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      text: text ?? this.text,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdBy': createdBy,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'text': text,
    };
  }

  factory TicketChatModel.fromMap(Map<String, dynamic> map) {
    return TicketChatModel(
      id: map['id'],
      createdBy: map['createdBy'],
      createdAt: map['createdAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['createdAt']) : null,
      text: map['text'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TicketChatModel.fromJson(String source) => TicketChatModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TicketChatModel(id: $id, createdBy: $createdBy, createdAt: $createdAt, text: $text)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is TicketChatModel &&
      other.id == id &&
      other.createdBy == createdBy &&
      other.createdAt == createdAt &&
      other.text == text;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      createdBy.hashCode ^
      createdAt.hashCode ^
      text.hashCode;
  }
}
