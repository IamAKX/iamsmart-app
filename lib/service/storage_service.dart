import 'dart:io';
import 'package:path/path.dart';
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

  static Future<Map<String, String>> uploadKycDocuments(File fileFront,
      File fileBack, String documentType, String extension) async {
    Map<String, String> linkMap = {
      'kycDocumentImageFront': '',
      'kycDocumentImageBack': ''
    };
    UserProfile profile =
        UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);

    // Uploading front side image
    String path =
        'kycDocument/${profile.email}/${documentType}_front.$extension';
    Reference ref = FirebaseStorage.instance.ref().child(path);
    UploadTask? uploadTask = ref.putFile(fileFront);
    var snapshot = await uploadTask.whenComplete(() {});
    var downloadLink = await snapshot.ref.getDownloadURL();
    linkMap['kycDocumentImageFront'] = downloadLink;

    // Uploading back side image
    path = 'kycDocument/${profile.email}/${documentType}_back.$extension';
    ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(fileBack);
    snapshot = await uploadTask.whenComplete(() {});
    downloadLink = await snapshot.ref.getDownloadURL();
    linkMap['kycDocumentImageBack'] = downloadLink;

    return linkMap;
  }

  static Future<String> uploadTransactionProof(File file) async {
    UserProfile profile =
        UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);
    String path = 'transactionProof/${profile.email}/${basename(file.path)}';
    final ref = FirebaseStorage.instance.ref().child(path);
    UploadTask? uploadTask = ref.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    final downloadLink = await snapshot.ref.getDownloadURL();
    return downloadLink;
  }
}
