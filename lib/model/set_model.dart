import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'transaction_activity_model.dart';
import 'user_profile.dart';

class SetModel {
  String? id;
  UserProfile? userProfile;
  double? amount;
  double? income;
  DateTime? createdAt;
  String? status;
  List<TransactionActivityModel>? transactionActivity;
  int? setNumber;
  SetModel({
    this.id,
    this.userProfile,
    this.amount,
    this.income,
    this.createdAt,
    this.status,
    this.transactionActivity,
    this.setNumber,
  });

  SetModel copyWith({
    String? id,
    UserProfile? userProfile,
    double? amount,
    double? income,
    DateTime? createdAt,
    String? status,
    List<TransactionActivityModel>? transactionActivity,
    int? setNumber,
  }) {
    return SetModel(
      id: id ?? this.id,
      userProfile: userProfile ?? this.userProfile,
      amount: amount ?? this.amount,
      income: income ?? this.income,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      transactionActivity: transactionActivity ?? this.transactionActivity,
      setNumber: setNumber ?? this.setNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userProfile': userProfile?.toMap(),
      'amount': amount,
      'income': income,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'status': status,
      'transactionActivity':
          transactionActivity?.map((x) => x.toMap()).toList(),
      'setNumber': setNumber,
    };
  }

  factory SetModel.fromMap(Map<String, dynamic> map) {
    return SetModel(
      id: map['id'],
      userProfile: map['userProfile'] != null
          ? UserProfile.fromMap(map['userProfile'])
          : null,
      amount: map['amount']?.toDouble(),
      income: map['income']?.toDouble(),
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : null,
      status: map['status'],
      transactionActivity: map['transactionActivity'] != null
          ? List<TransactionActivityModel>.from(map['transactionActivity']
              ?.map((x) => TransactionActivityModel.fromMap(x)))
          : null,
      setNumber: map['setNumber']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory SetModel.fromJson(String source) =>
      SetModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SetModel(id: $id, userProfile: $userProfile, amount: $amount, income: $income, createdAt: $createdAt, status: $status, transactionActivity: $transactionActivity, setNumber: $setNumber)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SetModel &&
        other.id == id &&
        other.userProfile == userProfile &&
        other.amount == amount &&
        other.income == income &&
        other.createdAt == createdAt &&
        other.status == status &&
        listEquals(other.transactionActivity, transactionActivity) &&
        other.setNumber == setNumber;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userProfile.hashCode ^
        amount.hashCode ^
        income.hashCode ^
        createdAt.hashCode ^
        status.hashCode ^
        transactionActivity.hashCode ^
        setNumber.hashCode;
  }
}
