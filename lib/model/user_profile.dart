import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserProfile {
  String? id;
  String? name;
  String? email;
  String? profileImage;
  // String? kycDocumentType;
  String? aadhaarId;
  String? aadhaarDocumentImageFront;
  String? aadhaarDocumentImageBack;
  String? panId;
  String? panDocumentImageFront;
  String? panDocumentImageBack;
  String? dlId;
  String? dlDocumentImageFront;
  String? dlDocumentImageBack;
  String? bankAccountName;
  String? bankIFSCCode;
  String? bankAccountNumber;
  String? bankBranchCode;
  bool? isProfileApproved;
  bool? isProfileSuspended;
  bool? isKycDone;
  double? userWalletBalance;
  double? aiWalletBalance;
  DateTime? lastLogin;
  DateTime? createdAt;
  double? latitude;
  double? longitude;
  int? setCount;
  double? rewardBalance;
  List<String>? referalList;
  String? inviteCode;
  String? phone;
  String? residencialAddress1;
  String? residencialAddress2;
  String? residencialAddress3;
  String? residencialAddress4;
  String? communicationAddress1;
  String? communicationAddress2;
  String? communicationAddress3;
  String? communicationAddress4;
  String? referredByUserId;
  String? fcmToken;
  UserProfile({
    this.id,
    this.name,
    this.email,
    this.profileImage,
    this.aadhaarId,
    this.aadhaarDocumentImageFront,
    this.aadhaarDocumentImageBack,
    this.panId,
    this.panDocumentImageFront,
    this.panDocumentImageBack,
    this.dlId,
    this.dlDocumentImageFront,
    this.dlDocumentImageBack,
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
    this.latitude,
    this.longitude,
    this.setCount,
    this.rewardBalance,
    this.referalList,
    this.inviteCode,
    this.phone,
    this.residencialAddress1,
    this.residencialAddress2,
    this.residencialAddress3,
    this.residencialAddress4,
    this.communicationAddress1,
    this.communicationAddress2,
    this.communicationAddress3,
    this.communicationAddress4,
    this.referredByUserId,
    this.fcmToken,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImage,
    String? aadhaarId,
    String? aadhaarDocumentImageFront,
    String? aadhaarDocumentImageBack,
    String? panId,
    String? panDocumentImageFront,
    String? panDocumentImageBack,
    String? dlId,
    String? dlDocumentImageFront,
    String? dlDocumentImageBack,
    String? bankAccountName,
    String? bankIFSCCode,
    String? bankAccountNumber,
    String? bankBranchCode,
    bool? isProfileApproved,
    bool? isProfileSuspended,
    bool? isKycDone,
    double? userWalletBalance,
    double? aiWalletBalance,
    DateTime? lastLogin,
    DateTime? createdAt,
    double? latitude,
    double? longitude,
    int? setCount,
    double? rewardBalance,
    List<String>? referalList,
    String? inviteCode,
    String? phone,
    String? residencialAddress1,
    String? residencialAddress2,
    String? residencialAddress3,
    String? residencialAddress4,
    String? communicationAddress1,
    String? communicationAddress2,
    String? communicationAddress3,
    String? communicationAddress4,
    String? referredByUserId,
    String? fcmToken,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      aadhaarId: aadhaarId ?? this.aadhaarId,
      aadhaarDocumentImageFront:
          aadhaarDocumentImageFront ?? this.aadhaarDocumentImageFront,
      aadhaarDocumentImageBack:
          aadhaarDocumentImageBack ?? this.aadhaarDocumentImageBack,
      panId: panId ?? this.panId,
      panDocumentImageFront:
          panDocumentImageFront ?? this.panDocumentImageFront,
      panDocumentImageBack: panDocumentImageBack ?? this.panDocumentImageBack,
      dlId: dlId ?? this.dlId,
      dlDocumentImageFront: dlDocumentImageFront ?? this.dlDocumentImageFront,
      dlDocumentImageBack: dlDocumentImageBack ?? this.dlDocumentImageBack,
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
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      setCount: setCount ?? this.setCount,
      rewardBalance: rewardBalance ?? this.rewardBalance,
      referalList: referalList ?? this.referalList,
      inviteCode: inviteCode ?? this.inviteCode,
      phone: phone ?? this.phone,
      residencialAddress1: residencialAddress1 ?? this.residencialAddress1,
      residencialAddress2: residencialAddress2 ?? this.residencialAddress2,
      residencialAddress3: residencialAddress3 ?? this.residencialAddress3,
      residencialAddress4: residencialAddress4 ?? this.residencialAddress4,
      communicationAddress1:
          communicationAddress1 ?? this.communicationAddress1,
      communicationAddress2:
          communicationAddress2 ?? this.communicationAddress2,
      communicationAddress3:
          communicationAddress3 ?? this.communicationAddress3,
      communicationAddress4:
          communicationAddress4 ?? this.communicationAddress4,
      referredByUserId: referredByUserId ?? this.referredByUserId,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'aadhaarId': aadhaarId,
      'aadhaarDocumentImageFront': aadhaarDocumentImageFront,
      'aadhaarDocumentImageBack': aadhaarDocumentImageBack,
      'panId': panId,
      'panDocumentImageFront': panDocumentImageFront,
      'panDocumentImageBack': panDocumentImageBack,
      'dlId': dlId,
      'dlDocumentImageFront': dlDocumentImageFront,
      'dlDocumentImageBack': dlDocumentImageBack,
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
      'latitude': latitude,
      'longitude': longitude,
      'setCount': setCount,
      'rewardBalance': rewardBalance,
      'referalList': referalList,
      'inviteCode': inviteCode,
      'phone': phone,
      'residencialAddress1': residencialAddress1,
      'residencialAddress2': residencialAddress2,
      'residencialAddress3': residencialAddress3,
      'residencialAddress4': residencialAddress4,
      'communicationAddress1': communicationAddress1,
      'communicationAddress2': communicationAddress2,
      'communicationAddress3': communicationAddress3,
      'communicationAddress4': communicationAddress4,
      'referredByUserId': referredByUserId,
      'fcmToken': fcmToken,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      profileImage: map['profileImage'],
      aadhaarId: map['aadhaarId'],
      aadhaarDocumentImageFront: map['aadhaarDocumentImageFront'],
      aadhaarDocumentImageBack: map['aadhaarDocumentImageBack'],
      panId: map['panId'],
      panDocumentImageFront: map['panDocumentImageFront'],
      panDocumentImageBack: map['panDocumentImageBack'],
      dlId: map['dlId'],
      dlDocumentImageFront: map['dlDocumentImageFront'],
      dlDocumentImageBack: map['dlDocumentImageBack'],
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
          ? DateTime.fromMillisecondsSinceEpoch(map['lastLogin'])
          : null,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : null,
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      setCount: map['setCount']?.toInt(),
      rewardBalance: map['rewardBalance']?.toDouble(),
      referalList: List<String>.from(map['referalList']),
      inviteCode: map['inviteCode'],
      phone: map['phone'],
      residencialAddress1: map['residencialAddress1'],
      residencialAddress2: map['residencialAddress2'],
      residencialAddress3: map['residencialAddress3'],
      residencialAddress4: map['residencialAddress4'],
      communicationAddress1: map['communicationAddress1'],
      communicationAddress2: map['communicationAddress2'],
      communicationAddress3: map['communicationAddress3'],
      communicationAddress4: map['communicationAddress4'],
      referredByUserId: map['referredByUserId'],
      fcmToken: map['fcmToken'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) =>
      UserProfile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserProfile(id: $id, name: $name, email: $email, profileImage: $profileImage, aadhaarId: $aadhaarId, aadhaarDocumentImageFront: $aadhaarDocumentImageFront, aadhaarDocumentImageBack: $aadhaarDocumentImageBack, panId: $panId, panDocumentImageFront: $panDocumentImageFront, panDocumentImageBack: $panDocumentImageBack, dlId: $dlId, dlDocumentImageFront: $dlDocumentImageFront, dlDocumentImageBack: $dlDocumentImageBack, bankAccountName: $bankAccountName, bankIFSCCode: $bankIFSCCode, bankAccountNumber: $bankAccountNumber, bankBranchCode: $bankBranchCode, isProfileApproved: $isProfileApproved, isProfileSuspended: $isProfileSuspended, isKycDone: $isKycDone, userWalletBalance: $userWalletBalance, aiWalletBalance: $aiWalletBalance, lastLogin: $lastLogin, createdAt: $createdAt, latitude: $latitude, longitude: $longitude, setCount: $setCount, rewardBalance: $rewardBalance, referalList: $referalList, inviteCode: $inviteCode, phone: $phone, residencialAddress1: $residencialAddress1, residencialAddress2: $residencialAddress2, residencialAddress3: $residencialAddress3, residencialAddress4: $residencialAddress4, communicationAddress1: $communicationAddress1, communicationAddress2: $communicationAddress2, communicationAddress3: $communicationAddress3, communicationAddress4: $communicationAddress4, referredByUserId: $referredByUserId, fcmToken: $fcmToken)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfile &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.profileImage == profileImage &&
        other.aadhaarId == aadhaarId &&
        other.aadhaarDocumentImageFront == aadhaarDocumentImageFront &&
        other.aadhaarDocumentImageBack == aadhaarDocumentImageBack &&
        other.panId == panId &&
        other.panDocumentImageFront == panDocumentImageFront &&
        other.panDocumentImageBack == panDocumentImageBack &&
        other.dlId == dlId &&
        other.dlDocumentImageFront == dlDocumentImageFront &&
        other.dlDocumentImageBack == dlDocumentImageBack &&
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
        other.createdAt == createdAt &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.setCount == setCount &&
        other.rewardBalance == rewardBalance &&
        listEquals(other.referalList, referalList) &&
        other.inviteCode == inviteCode &&
        other.phone == phone &&
        other.residencialAddress1 == residencialAddress1 &&
        other.residencialAddress2 == residencialAddress2 &&
        other.residencialAddress3 == residencialAddress3 &&
        other.residencialAddress4 == residencialAddress4 &&
        other.communicationAddress1 == communicationAddress1 &&
        other.communicationAddress2 == communicationAddress2 &&
        other.communicationAddress3 == communicationAddress3 &&
        other.communicationAddress4 == communicationAddress4 &&
        other.referredByUserId == referredByUserId &&
        other.fcmToken == fcmToken;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        profileImage.hashCode ^
        aadhaarId.hashCode ^
        aadhaarDocumentImageFront.hashCode ^
        aadhaarDocumentImageBack.hashCode ^
        panId.hashCode ^
        panDocumentImageFront.hashCode ^
        panDocumentImageBack.hashCode ^
        dlId.hashCode ^
        dlDocumentImageFront.hashCode ^
        dlDocumentImageBack.hashCode ^
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
        createdAt.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        setCount.hashCode ^
        rewardBalance.hashCode ^
        referalList.hashCode ^
        inviteCode.hashCode ^
        phone.hashCode ^
        residencialAddress1.hashCode ^
        residencialAddress2.hashCode ^
        residencialAddress3.hashCode ^
        residencialAddress4.hashCode ^
        communicationAddress1.hashCode ^
        communicationAddress2.hashCode ^
        communicationAddress3.hashCode ^
        communicationAddress4.hashCode ^
        referredByUserId.hashCode ^
        fcmToken.hashCode;
  }
}
