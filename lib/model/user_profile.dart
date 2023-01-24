import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  String? id;
  String? name;
  String? email;
  String? profileImage;
  String? kycDocumentType;
  String? kycId;
  String? kycDocumentImage;
  String? bankAccountName;
  String? bankIFSCCode;
  String? bankAccountNumber;
  String? bankBranchCode;
  bool? isProfileApproved;
  bool? isProfileSuspended;
  bool? isKycDone;
  double? userWalletBalance;
  double? aiWalletBalance;
  Timestamp? lastLogin;
  Timestamp? createdAt;
  UserProfile({
    this.id,
    this.name,
    this.email,
    this.profileImage,
    this.kycDocumentType,
    this.kycId,
    this.kycDocumentImage,
    this.bankAccountName,
    this.bankIFSCCode,
    this.bankAccountNumber,
    this.bankBranchCode,
    this.isProfileApproved,
    this.isProfileSuspended,
    this.isKycDone,
    this.userWalletBalance,
    this.aiWalletBalance,
    this.lastLogin,
    this.createdAt,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImage,
    String? kycDocumentType,
    String? kycId,
    String? kycDocumentImage,
    String? bankAccountName,
    String? bankIFSCCode,
    String? bankAccountNumber,
    String? bankBranchCode,
    bool? isProfileApproved,
    bool? isProfileSuspended,
    bool? isKycDone,
    double? userWalletBalance,
    double? aiWalletBalance,
    Timestamp? lastLogin,
    Timestamp? createdAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      kycDocumentType: kycDocumentType ?? this.kycDocumentType,
      kycId: kycId ?? this.kycId,
      kycDocumentImage: kycDocumentImage ?? this.kycDocumentImage,
      bankAccountName: bankAccountName ?? this.bankAccountName,
      bankIFSCCode: bankIFSCCode ?? this.bankIFSCCode,
      bankAccountNumber: bankAccountNumber ?? this.bankAccountNumber,
      bankBranchCode: bankBranchCode ?? this.bankBranchCode,
      isProfileApproved: isProfileApproved ?? this.isProfileApproved,
      isProfileSuspended: isProfileSuspended ?? this.isProfileSuspended,
      isKycDone: isKycDone ?? this.isKycDone,
      userWalletBalance: userWalletBalance ?? this.userWalletBalance,
      aiWalletBalance: aiWalletBalance ?? this.aiWalletBalance,
      lastLogin: lastLogin ?? this.lastLogin,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'kycDocumentType': kycDocumentType,
      'kycId': kycId,
      'kycDocumentImage': kycDocumentImage,
      'bankAccountName': bankAccountName,
      'bankIFSCCode': bankIFSCCode,
      'bankAccountNumber': bankAccountNumber,
      'bankBranchCode': bankBranchCode,
      'isProfileApproved': isProfileApproved,
      'isProfileSuspended': isProfileSuspended,
      'isKycDone': isKycDone,
      'userWalletBalance': userWalletBalance,
      'aiWalletBalance': aiWalletBalance,
      'lastLogin': lastLogin?.millisecondsSinceEpoch,
      'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      profileImage: map['profileImage'],
      kycDocumentType: map['kycDocumentType'],
      kycId: map['kycId'],
      kycDocumentImage: map['kycDocumentImage'],
      bankAccountName: map['bankAccountName'],
      bankIFSCCode: map['bankIFSCCode'],
      bankAccountNumber: map['bankAccountNumber'],
      bankBranchCode: map['bankBranchCode'],
      isProfileApproved: map['isProfileApproved'],
      isProfileSuspended: map['isProfileSuspended'],
      isKycDone: map['isKycDone'],
      userWalletBalance: map['userWalletBalance']?.toDouble(),
      aiWalletBalance: map['aiWalletBalance']?.toDouble(),
      lastLogin: map['lastLogin'] != null
          ? Timestamp.fromMillisecondsSinceEpoch(map['lastLogin'])
          : null,
      createdAt: map['createdAt'] != null
          ? Timestamp.fromMillisecondsSinceEpoch(map['createdAt'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) =>
      UserProfile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserProfile(id: $id, name: $name, email: $email, profileImage: $profileImage, kycDocumentType: $kycDocumentType, kycId: $kycId, kycDocumentImage: $kycDocumentImage, bankAccountName: $bankAccountName, bankIFSCCode: $bankIFSCCode, bankAccountNumber: $bankAccountNumber, bankBranchCode: $bankBranchCode, isProfileApproved: $isProfileApproved, isProfileSuspended: $isProfileSuspended, isKycDone: $isKycDone, userWalletBalance: $userWalletBalance, aiWalletBalance: $aiWalletBalance, lastLogin: $lastLogin, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfile &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.profileImage == profileImage &&
        other.kycDocumentType == kycDocumentType &&
        other.kycId == kycId &&
        other.kycDocumentImage == kycDocumentImage &&
        other.bankAccountName == bankAccountName &&
        other.bankIFSCCode == bankIFSCCode &&
        other.bankAccountNumber == bankAccountNumber &&
        other.bankBranchCode == bankBranchCode &&
        other.isProfileApproved == isProfileApproved &&
        other.isProfileSuspended == isProfileSuspended &&
        other.isKycDone == isKycDone &&
        other.userWalletBalance == userWalletBalance &&
        other.aiWalletBalance == aiWalletBalance &&
        other.lastLogin == lastLogin &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        profileImage.hashCode ^
        kycDocumentType.hashCode ^
        kycId.hashCode ^
        kycDocumentImage.hashCode ^
        bankAccountName.hashCode ^
        bankIFSCCode.hashCode ^
        bankAccountNumber.hashCode ^
        bankBranchCode.hashCode ^
        isProfileApproved.hashCode ^
        isProfileSuspended.hashCode ^
        isKycDone.hashCode ^
        userWalletBalance.hashCode ^
        aiWalletBalance.hashCode ^
        lastLogin.hashCode ^
        createdAt.hashCode;
  }
}
