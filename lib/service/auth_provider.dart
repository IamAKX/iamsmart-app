import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iamsmart/main.dart';
import 'package:iamsmart/model/user_profile.dart';
import 'package:iamsmart/service/snakbar_service.dart';
import 'package:iamsmart/util/preference_key.dart';
import 'package:iamsmart/util/utilities.dart';
import 'package:string_validator/string_validator.dart';

import '../util/constants.dart';
import '../util/messages.dart';
import 'db_service.dart';

enum AuthStatus {
  notAuthenticated,
  authenticating,
  authenticated,
  error,
  forgotPwdMailSent
}

class AuthProvider extends ChangeNotifier {
  User? user;
  AuthStatus? status = AuthStatus.notAuthenticated;
  late FirebaseAuth _auth;

  static AuthProvider instance = AuthProvider();

  AuthProvider() {
    _auth = FirebaseAuth.instance;
    _checkCurrentUserIsAuthenticated();
  }

  void _checkCurrentUserIsAuthenticated() async {
    user = _auth.currentUser;
    if (user != null) {
      if (user!.emailVerified) {
      } else {
        logoutUser();
      }
    }
  }

  Future<void> logoutUser() async {
    try {
      await _auth.signOut();
      user = null;

      status = AuthStatus.notAuthenticated;
    } catch (e) {
      SnackBarService.instance.showSnackBarError("Error Logging Out");
    }
    notifyListeners();
  }

  Future<void> loginUserWithEmailAndPassword(
      String email, String password) async {
    if (!isEmail(email)) {
      SnackBarService.instance.showSnackBarError('Enter valid email');
      return;
    }
    if (!isAlphanumeric(password)) {
      SnackBarService.instance
          .showSnackBarError('Enter alpha numeric password');
      return;
    }
    status = AuthStatus.authenticating;
    notifyListeners();
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = result.user;

      if (!user!.emailVerified) {
        SnackBarService.instance.showSnackBarError(onEmailNotVerified);
        status = AuthStatus.error;
        logoutUser();
      } else {
        status = AuthStatus.authenticated;
        await DBService.instance.updateLastLoginTime(user?.uid ?? '');
        await DBService.instance.getUserById(user?.uid ?? '').then((value) {
          UserProfile userProfile = value;
          prefs.setString(PreferenceKey.user, userProfile.toJson());
        });
      }
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      SnackBarService.instance.showSnackBarError(e.message!);
      status = AuthStatus.error;
      user = null;
      notifyListeners();
    }
  }

  Future<bool> registerUserWithEmailAndPassword(
      String name, String email, String password) async {
    if (name.isEmpty) {
      SnackBarService.instance.showSnackBarError('Enter Full name');
      return false;
    }
    if (!isEmail(email)) {
      SnackBarService.instance.showSnackBarError('Enter valid email');
      return false;
    }
    if (!isAlphanumeric(password)) {
      SnackBarService.instance
          .showSnackBarError('Enter alpha numeric password');
      return false;
    }
    status = AuthStatus.authenticating;
    notifyListeners();
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = result.user;
      status = AuthStatus.authenticated;
      user!.updateDisplayName(name);
      user!.sendEmailVerification();
      SnackBarService.instance.showSnackBarSuccess(onSuccessfullSignupMsg);
      UserProfile userProfile = UserProfile(
        id: user?.uid,
        name: name,
        email: user?.email,
        profileImage: defaultProfileImage,
        aadhaarDocumentImageBack: '',
        aadhaarDocumentImageFront: '',
        aadhaarId: '',
        panDocumentImageBack: '',
        panDocumentImageFront: '',
        panId: '',
        dlDocumentImageBack: '',
        dlDocumentImageFront: '',
        dlId: '',
        bankAccountName: '',
        bankIFSCCode: '',
        bankAccountNumber: '',
        bankBranchCode: '',
        isProfileApproved: false,
        isProfileSuspended: false,
        isKycDone: false,
        userWalletBalance: 0.0,
        aiWalletBalance: 0.0,
        lastLogin: DateTime.now(),
        createdAt: DateTime.now(),
        inviteCode: Utilities.generateInviteCode(),
        latitude: 0,
        longitude: 0,
        referalList: [],
        setCount: 0,
        rewardBalance: 0.0,
      );
      await DBService.instance.createUser(userProfile).then(
          (value) => prefs.setString(PreferenceKey.user, userProfile.toJson()));

      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      SnackBarService.instance.showSnackBarError(e.message!);
      status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    if (!isEmail(email)) {
      SnackBarService.instance.showSnackBarError('Enter valid email');
      return false;
    }
    status = AuthStatus.authenticating;
    notifyListeners();
    try {
      await _auth.sendPasswordResetEmail(email: email);
      status = AuthStatus.forgotPwdMailSent;
      notifyListeners();
      SnackBarService.instance
          .showSnackBarSuccess("Please check your mail for reset link");
      return true;
    } on FirebaseAuthException catch (e) {
      SnackBarService.instance.showSnackBarError(e.message!);
      status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updatePassword(String newPassword) async {
    if (!isAlphanumeric(newPassword)) {
      SnackBarService.instance
          .showSnackBarError('Enter alpha numeric password');
      return false;
    }
    status = AuthStatus.authenticating;
    notifyListeners();
    try {
      bool res = false;
      await user?.updatePassword(newPassword).then((value) {
        res = true;
      }).catchError((onError) {
        res = false;
      });
      return res;
    } on FirebaseAuthException catch (e) {
      SnackBarService.instance.showSnackBarError(e.message!);
      status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }
}
