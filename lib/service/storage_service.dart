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

  static Future<Map<String, String>> uploadKycDocuments(
    File aadhaarFront,
    File aadhaarBack,
    File panfileFront,
    File? panfileBack,
    File? dlfileFront,
    File? dlfileBack,
  ) async {
    Map<String, String> linkMap = {
      'aadhaarFront': '',
      'aadhaarBack': '',
      'panfileFront': '',
      'panfileBack': '',
      'dlfileFront': '',
      'dlfileBack': '',
    };
    UserProfile profile =
        UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);

    // Uploading front side image
    String path = 'kycDocument/${profile.email}/adhaar_front';
    Reference ref = FirebaseStorage.instance.ref().child(path);
    UploadTask? uploadTask = ref.putFile(aadhaarFront);
    var snapshot = await uploadTask.whenComplete(() {});
    var downloadLink = await snapshot.ref.getDownloadURL();
    linkMap['aadhaarFront'] = downloadLink;

    // Uploading back side image
    path = 'kycDocument/${profile.email}/adhaar_back';
    ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(aadhaarBack);
    snapshot = await uploadTask.whenComplete(() {});
    downloadLink = await snapshot.ref.getDownloadURL();
    linkMap['aadhaarBack'] = downloadLink;

    // PAN
    path = 'kycDocument/${profile.email}/pan_fron';
    ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(panfileFront);
    snapshot = await uploadTask.whenComplete(() {});
    downloadLink = await snapshot.ref.getDownloadURL();
    linkMap['panfileFront'] = downloadLink;

    if (panfileBack != null) {
      path = 'kycDocument/${profile.email}/pan_back';
      ref = FirebaseStorage.instance.ref().child(path);
      uploadTask = ref.putFile(panfileBack);
      snapshot = await uploadTask.whenComplete(() {});
      downloadLink = await snapshot.ref.getDownloadURL();
      linkMap['panfileBack'] = downloadLink;
    }

    if (dlfileFront != null && dlfileBack != null) {
      path = 'kycDocument/${profile.email}/dl_front';
      ref = FirebaseStorage.instance.ref().child(path);
      uploadTask = ref.putFile(dlfileFront);
      snapshot = await uploadTask.whenComplete(() {});
      downloadLink = await snapshot.ref.getDownloadURL();
      linkMap['dlfileFront'] = downloadLink;

      path = 'kycDocument/${profile.email}/dl_back';
      ref = FirebaseStorage.instance.ref().child(path);
      uploadTask = ref.putFile(dlfileBack);
      snapshot = await uploadTask.whenComplete(() {});
      downloadLink = await snapshot.ref.getDownloadURL();
      linkMap['dlfileBack'] = downloadLink;
    }
    //DL

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
