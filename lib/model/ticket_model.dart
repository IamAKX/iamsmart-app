import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:iamsmart/model/tricket_chat_model.dart';
import 'package:iamsmart/model/user_profile.dart';

class TicketModel {
  String? id;
  String? status;
  UserProfile? user;
  DateTime? createdAt;
  DateTime? closedAt;
  String? closedBy;
  String? subject;
  String? text;
  List<TicketChatModel>? chats;
  TicketModel({
    this.id,
    this.status,
    this.user,
    this.createdAt,
    this.closedAt,
    this.closedBy,
    this.subject,
    this.text,
    this.chats,
  });

  TicketModel copyWith({
    String? id,
    String? status,
    UserProfile? user,
    DateTime? createdAt,
    DateTime? closedAt,
    String? closedBy,
    String? subject,
    String? text,
    List<TicketChatModel>? chats,
  }) {
    return TicketModel(
      id: id ?? this.id,
      status: status ?? this.status,
      user: user ?? this.user,
      createdAt: createdAt ?? this.createdAt,
      closedAt: closedAt ?? this.closedAt,
      closedBy: closedBy ?? this.closedBy,
      subject: subject ?? this.subject,
      text: text ?? this.text,
      chats: chats ?? this.chats,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'user': user?.toMap(),
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'closedAt': closedAt?.millisecondsSinceEpoch,
      'closedBy': closedBy,
      'subject': subject,
      'text': text,
      'chats': chats?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory TicketModel.fromMap(Map<String, dynamic> map) {
    return TicketModel(
      id: map['id'],
      status: map['status'],
      user: map['user'] != null ? UserProfile.fromMap(map['user']) : null,
      createdAt: map['createdAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['createdAt']) : null,
      closedAt: map['closedAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['closedAt']) : null,
      closedBy: map['closedBy'],
      subject: map['subject'],
      text: map['text'],
      chats: map['chats'] != null ? List<TicketChatModel>.from(map['chats']?.map((x) => TicketChatModel.fromMap(x))) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TicketModel.fromJson(String source) => TicketModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TicketModel(id: $id, status: $status, user: $user, createdAt: $createdAt, closedAt: $closedAt, closedBy: $closedBy, subject: $subject, text: $text, chats: $chats)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is TicketModel &&
      other.id == id &&
      other.status == status &&
      other.user == user &&
      other.createdAt == createdAt &&
      other.closedAt == closedAt &&
      other.closedBy == closedBy &&
      other.subject == subject &&
      other.text == text &&
      listEquals(other.chats, chats);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      status.hashCode ^
      user.hashCode ^
      createdAt.hashCode ^
      closedAt.hashCode ^
      closedBy.hashCode ^
      subject.hashCode ^
      text.hashCode ^
      chats.hashCode;
  }
  }
