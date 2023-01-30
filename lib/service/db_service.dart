import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> updateProfile(
      String userId, Map<String, dynamic> profileData) async {
    await _db.collection(userCollection).doc(userId).update(profileData);
  }
}
