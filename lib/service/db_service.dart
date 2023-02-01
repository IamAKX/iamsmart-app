import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:iamsmart/model/transaction_model.dart';
import 'package:iamsmart/model/user_profile.dart';
import 'package:permission_handler/permission_handler.dart';

class DBService {
  static DBService instance = DBService();
  late FirebaseFirestore _db;
  String userCollection = 'users';
  String txnCollection = 'transactions';

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
        .where('userId', isEqualTo: userId)
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
}
