import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthService {
  static final _auth = LocalAuthentication();

  static Future<bool> canAuthenticate() async =>
      await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

  static Future<bool> authenticate() async {
    try {
      if (!await canAuthenticate()) return false;
      return _auth.authenticate(
        localizedReason: 'Use biometric authentication to login',
        options: const AuthenticationOptions(
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
