import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:iamsmart/main.dart';
import 'package:iamsmart/model/user_profile.dart';
import 'package:iamsmart/util/preference_key.dart';

class StorageService {
  static Future<String> uploadProfileImage(File file, String fileName) async {
    UserProfile profile =
        UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);
    String path = 'profileImage/${profile.email}/$fileName';
    final ref = FirebaseStorage.instance.ref().child(path);
    UploadTask? uploadTask = ref.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    final downloadLink = await snapshot.ref.getDownloadURL();
    return downloadLink;
  }
}
