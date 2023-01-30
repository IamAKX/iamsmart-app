import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iamsmart/model/user_profile.dart';

class DBService {
  static DBService instance = DBService();
  late FirebaseFirestore _db;
  String userCollection = 'users';

  DBService() {
    _db = FirebaseFirestore.instance;
  }

  Future<void> createUser(UserProfile user) async {
    await _db.collection(userCollection).doc(user.id).set(user.toMap());
  }

  Future<void> updateLastLoginTime(String userId) async {
    await _db
        .collection(userCollection)
        .doc(userId)
        .update({'lastLogin': Timestamp.now().millisecondsSinceEpoch});
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
}
