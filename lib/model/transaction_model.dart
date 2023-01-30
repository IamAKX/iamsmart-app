import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:iamsmart/model/transaction_activity_model.dart';

class TransactionModel {
  String? id;
  double? amount;
  String? userId;
  String? status;
  String? assignedTo;
  List<TransactionActivityModel>? transactionActivity;
  String? transactionMode;
  String? transactionScreenshot;
  String? creditParty;
  String? debitParty;
  DateTime? createdAt;
  TransactionModel({
    this.id,
    this.amount,
    this.userId,
    this.status,
    this.assignedTo,
    this.transactionActivity,
    this.transactionMode,
    this.transactionScreenshot,
    this.creditParty,
    this.debitParty,
    this.createdAt,
  });

  TransactionModel copyWith({
    String? id,
    double? amount,
    String? userId,
    String? status,
    String? assignedTo,
    List<TransactionActivityModel>? transactionActivity,
    String? transactionMode,
    String? transactionScreenshot,
    String? creditParty,
    String? debitParty,
    DateTime? createdAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      assignedTo: assignedTo ?? this.assignedTo,
      transactionActivity: transactionActivity ?? this.transactionActivity,
      transactionMode: transactionMode ?? this.transactionMode,
      transactionScreenshot:
          transactionScreenshot ?? this.transactionScreenshot,
      creditParty: creditParty ?? this.creditParty,
      debitParty: debitParty ?? this.debitParty,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'userId': userId,
      'status': status,
      'assignedTo': assignedTo,
      'transactionActivity':
          transactionActivity?.map((x) => x.toMap()).toList(),
      'transactionMode': transactionMode,
      'transactionScreenshot': transactionScreenshot,
      'creditParty': creditParty,
      'debitParty': debitParty,
      'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      amount: map['amount']?.toDouble(),
      userId: map['userId'],
      status: map['status'],
      assignedTo: map['assignedTo'],
      transactionActivity: map['transactionActivity'] != null
          ? List<TransactionActivityModel>.from(map['transactionActivity']
              ?.map((x) => TransactionActivityModel.fromMap(x)))
          : null,
      transactionMode: map['transactionMode'],
      transactionScreenshot: map['transactionScreenshot'],
      creditParty: map['creditParty'],
      debitParty: map['debitParty'],
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionModel.fromJson(String source) =>
      TransactionModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TransactionModel(id: $id, amount: $amount, userId: $userId, status: $status, assignedTo: $assignedTo, transactionActivity: $transactionActivity, transactionMode: $transactionMode, transactionScreenshot: $transactionScreenshot, creditParty: $creditParty, debitParty: $debitParty, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransactionModel &&
        other.id == id &&
        other.amount == amount &&
        other.userId == userId &&
        other.status == status &&
        other.assignedTo == assignedTo &&
        listEquals(other.transactionActivity, transactionActivity) &&
        other.transactionMode == transactionMode &&
        other.transactionScreenshot == transactionScreenshot &&
        other.creditParty == creditParty &&
        other.debitParty == debitParty &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        amount.hashCode ^
        userId.hashCode ^
        status.hashCode ^
        assignedTo.hashCode ^
        transactionActivity.hashCode ^
        transactionMode.hashCode ^
        transactionScreenshot.hashCode ^
        creditParty.hashCode ^
        debitParty.hashCode ^
        createdAt.hashCode;
  }
}
