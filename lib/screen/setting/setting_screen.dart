import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iamsmart/main.dart';
import 'package:iamsmart/model/user_profile.dart';
import 'package:iamsmart/screen/login/login_screen.dart';
import 'package:iamsmart/screen/setting/change_password.dart';
import 'package:iamsmart/screen/setting/kyc_document_screen.dart';
import 'package:iamsmart/screen/setting/profile_details_screen.dart';
import 'package:iamsmart/service/db_service.dart';
import 'package:iamsmart/service/local_auth_service.dart';
import 'package:iamsmart/service/storage_service.dart';
import 'package:iamsmart/util/preference_key.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../service/auth_provider.dart';
import '../../service/snakbar_service.dart';
import '../../util/colors.dart';
import '../../util/theme.dart';
import '../../widget/heading.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({
    Key? key,
    required this.switchTab,
  }) : super(key: key);
  final Function(int index, int txnIndex) switchTab;

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isBiometricEnabled =
      prefs.getBool(PreferenceKey.isBiometricEnabled) ?? false;
  late MyAuthProvider _auth;
  late UserProfile userProfile;
  bool isImageUploading = false;

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _auth = Provider.of<MyAuthProvider>(context);
    if (prefs.containsKey(PreferenceKey.user)) {
      userProfile = UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);
    }
    return WillPopScope(
      onWillPop: () async {
        widget.switchTab(0, 0);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Heading(title: 'Profile'),
        ),
        body: getBody(),
      ),
    );
  }

  getBody() {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(settingsPageUserIconSize),
                child: CachedNetworkImage(
                  imageUrl: userProfile.profileImage ?? '',
                  width: settingsPageUserIconSize,
                  height: settingsPageUserIconSize,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/image/user.png',
                    width: settingsPageUserIconSize,
                    height: settingsPageUserIconSize,
                  ),
                ),
              ),
              const SizedBox(
                width: defaultPadding,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userProfile.name ?? '',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  InkWell(
                    onTap: isImageUploading
                        ? null
                        : () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (image != null) {
                              File imageFile = File(image.path);
                              setState(() {
                                isImageUploading = true;
                              });
                              StorageService.uploadProfileImage(imageFile,
                                      'profile_image.${image.name.split('.')[1]}')
                                  .then((imageUrl) async {
                                await DBService.instance
                                    .updateProfile(userProfile.id!,
                                        {'profileImage': imageUrl}, context)
                                    .then((value) async {
                                  await DBService.instance
                                      .getUserById(userProfile.id!)
                                      .then((updatedProfile) {
                                    prefs.setString(PreferenceKey.user,
                                        updatedProfile.toJson());
                                    setState(() {
                                      isImageUploading = false;
                                    });
                                  });
                                });
                              });
                            }
                          },
                    child: Text(
                      isImageUploading
                          ? 'Uploading image, please wait...'
                          : 'Edit picture',
                      style: Theme.of(context).textTheme.subtitle2?.copyWith(
                            color: isImageUploading
                                ? Colors.orange
                                : primaryColorDark,
                          ),
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding / 3,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding / 2,
                        vertical: defaultPadding / 4),
                    decoration: BoxDecoration(
                        color: userProfile.isKycDone ?? false
                            ? Colors.green.withOpacity(0.2)
                            : Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      userProfile.isKycDone ?? false
                          ? 'KYC Verified'
                          : 'KYC not verified',
                      style: Theme.of(context).textTheme.caption?.copyWith(
                            color: userProfile.isKycDone ?? false
                                ? Colors.green
                                : Colors.red,
                          ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        const Divider(
          height: 1,
          color: hintColor,
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        ListTile(
          title: const Text(
            'Profile Details',
          ),
          leading: const Icon(
            FontAwesomeIcons.userGear,
            size: 20,
          ),
          trailing: const Icon(
            FontAwesomeIcons.chevronRight,
            size: 15,
          ),
          onTap: () {
            context.push(ProfileDetailScreen.profileDetailRoute);
          },
        ),
        ListTile(
          title: const Text(
            'KYC Documents',
          ),
          leading: const Icon(
            FontAwesomeIcons.userCheck,
            size: 20,
          ),
          trailing: const Icon(
            FontAwesomeIcons.chevronRight,
            size: 15,
          ),
          onTap: () {
            context.push(KycDocumentScreen.kycDocumentRoute);
          },
        ),
        ListTile(
          title: const Text(
            'Change password',
          ),
          leading: const Icon(
            FontAwesomeIcons.lock,
            size: 20,
          ),
          trailing: const Icon(
            FontAwesomeIcons.chevronRight,
            size: 15,
          ),
          onTap: () {
            context.push(ChangePasswordScreen.changePasswordRoute);
          },
        ),
        SwitchListTile(
          value: isBiometricEnabled,
          onChanged: (value) async {
            if (await LocalAuthService.authenticate()) {
              setState(() {
                isBiometricEnabled = !isBiometricEnabled;
                prefs.setBool(
                    PreferenceKey.isBiometricEnabled, isBiometricEnabled);
              });
            }
          },
          title: const Text(
            'Enable biometric',
          ),
          secondary: const Icon(
            FontAwesomeIcons.fingerprint,
            size: 20,
          ),
        ),
        ListTile(
          title: const Text(
            'Logout',
          ),
          textColor: Colors.red,
          leading: const Icon(
            FontAwesomeIcons.rightFromBracket,
            color: Colors.red,
            size: 20,
          ),
          trailing: const Icon(
            FontAwesomeIcons.chevronRight,
            color: Colors.red,
            size: 15,
          ),
          onTap: () {
            _auth.logoutUser().then((value) {
              context.go(LoginScreen.loginRoute);
              prefs.clear();
            });
          },
        ),
      ],
    );
  }
}
