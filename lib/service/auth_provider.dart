import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iamsmart/service/snakbar_service.dart';
import 'package:string_validator/string_validator.dart';

import '../util/messages.dart';

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
    if (email.isEmpty) {
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

      // await DBService.instance
      //     .addUserToDb(user!.uid, name, email, otherData);
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
}
