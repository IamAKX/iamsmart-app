import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:iamsmart/main.dart';
import 'package:iamsmart/model/set_model.dart';
import 'package:iamsmart/model/transaction_model.dart';
import 'package:iamsmart/model/user_profile.dart';
import 'package:iamsmart/util/preference_key.dart';
import 'package:permission_handler/permission_handler.dart';

import '../model/transaction_activity_model.dart';
import '../util/constants.dart';

class DBService {
  static DBService instance = DBService();
  late FirebaseFirestore _db;
  String userCollection = 'users';
  String txnCollection = 'transactions';
  String setCollection = 'sets';

  DBService() {
    _db = FirebaseFirestore.instance;
  }

  Future<void> createUser(UserProfile user) async {
    await _db.collection(userCollection).doc(user.id).set(user.toMap());
  }

  Future<void> updateLastLoginTime(String userId) async {
    Map<String, dynamic> map = {
      'lastLogin': Timestamp.now().millisecondsSinceEpoch,
    };
    if (await Permission.location.request().isGranted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      map['latitude'] = position.latitude;
      map['longitude'] = position.longitude;
    }
    await _db.collection(userCollection).doc(userId).update(map);
  }

  Future<UserProfile> getUserById(String userId) async {
    UserProfile user = UserProfile();
    await _db.collection(userCollection).doc(userId).get().then((snapshot) {
      Map<String, dynamic> userMap = snapshot.data() ?? {};
      user = UserProfile.fromMap(userMap);
    });

    return user;
  }

  Future<void> updateProfile(String userId, Map<String, dynamic> profileData,
      BuildContext context) async {
    await _db
        .collection(userCollection)
        .doc(userId)
        .update(profileData)
        .then((value) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: 'Success',
        autoDismiss: false,
        desc: 'Your profile data is updated',
        btnOkOnPress: () {
          context.pop();
        },
        onDismissCallback: (type) {},
        btnOkText: 'Okay',
      ).show();
    });
  }

  Future<void> addTransaction(TransactionModel txn) async {
    var ref = _db.collection(txnCollection).doc();
    txn.id = ref.id;
    await ref.set(txn.toMap());
  }

  Future<List<TransactionModel>> getAllTransactions(String userId) async {
    List<TransactionModel> txnList = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
        .collection(txnCollection)
        .where('user.id', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    txnList = querySnapshot.docs
        .map((txn) => TransactionModel.fromMap(txn.data()))
        .toList();
    return txnList;
  }

  Future<TransactionModel> getTransactionById(String txnId) async {
    TransactionModel txn = TransactionModel();
    await _db.collection(txnCollection).doc(txnId).get().then((snapshot) {
      txn = TransactionModel.fromMap(snapshot.data() ?? {});
    });
    return txn;
  }

  Future<List<SetModel>> getAllSet(String userId) async {
    List<SetModel> setList = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
        .collection(setCollection)
        .where('userProfile.id', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    setList =
        querySnapshot.docs.map((set) => SetModel.fromMap(set.data())).toList();
    return setList;
  }

  Future<SetModel> getSetById(String setId) async {
    SetModel set = SetModel();
    await _db.collection(setCollection).doc(setId).get().then((s) {
      set = SetModel.fromMap(s.data() ?? {});
    });
    return set;
  }

  Future<bool> withdrawSet(SetModel set, double amount) async {
    UserProfile userProfile =
        UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);
    userProfile = await getUserById(userProfile.id!);
    TransactionModel txn = TransactionModel(
      amount: amount,
      assignedTo: Party.admin.name,
      creditParty: Party.userWallet.name,
      debitParty: Party.aiWallet.name,
      status: PaymentStatus.pending.name,
      transactionActivity: [
        TransactionActivityModel(
          comment: 'Redeem from ${set.userProfile!.name!} #${set.setNumber}',
          createdAt: DateTime.now(),
        )
      ],
      transactionMode: set.id,
      user: userProfile,
      transactionScreenshot: '',
      createdAt: DateTime.now(),
    );

    await addTransaction(txn);

    return false;
  }

  Future<List<TransactionModel>> getCurrentDateTransactions(
      String userId) async {
    List<TransactionModel> txnList = [];
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
        .collection(txnCollection)
        .where('user.id', isEqualTo: userId)
        .where('createdAt',
            isGreaterThanOrEqualTo: today.millisecondsSinceEpoch)
        .orderBy('createdAt', descending: true)
        .get();

    txnList = querySnapshot.docs
        .map((txn) => TransactionModel.fromMap(txn.data()))
        .toList();
    return txnList;
  }
}
