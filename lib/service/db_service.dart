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
}
