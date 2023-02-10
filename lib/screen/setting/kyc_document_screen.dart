import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iamsmart/main.dart';
import 'package:iamsmart/model/user_profile.dart';
import 'package:iamsmart/service/db_service.dart';
import 'package:iamsmart/service/storage_service.dart';
import 'package:iamsmart/util/preference_key.dart';
import 'package:iamsmart/widget/button_active.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../service/snakbar_service.dart';
import '../../util/theme.dart';
import '../../widget/custom_textfield.dart';
import '../../widget/heading.dart';

class KycDocumentScreen extends StatefulWidget {
  const KycDocumentScreen({super.key});
  static const String kycDocumentRoute = '/mainContainer/settings/kycDocument';
  @override
  State<KycDocumentScreen> createState() => _KycDocumentScreenState();
}

class _KycDocumentScreenState extends State<KycDocumentScreen> {
  final TextEditingController _kycAadhaarNumber = TextEditingController();
  bool isAadhaarImageSelectedFront = false;
  late File? imageAadhaarFileFront;
  bool isAadhaarImageSelectedBack = false;
  late File? imageAadhaarFileBack;

  // PAN
  final TextEditingController _kycPanNumber = TextEditingController();
  bool isPanImageSelectedFront = false;
  late File? imagePanFileFront;
  bool isPanImageSelectedBack = false;
  late File? imagePanFileBack;

  // DL
  final TextEditingController _kycDLNumber = TextEditingController();
  bool isDLImageSelectedFront = false;
  late File? imageDLFileFront;
  bool isDLImageSelectedBack = false;
  late File? imageDLFileBack;

  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    return Scaffold(
      appBar: AppBar(
        title: const Heading(title: 'KYC Details'),
      ),
      body: getBody(),
    );
  }

  getBody() {
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Text('Aadhaar Number'),
        ),
        CustomTextField(
            hint: 'Aadhaar Number',
            controller: _kycAadhaarNumber,
            keyboardType: TextInputType.name,
            obscure: false,
            icon: FontAwesomeIcons.userShield),
        const Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(
              left: defaultPadding,
              right: defaultPadding,
              // top: defaultPadding,
              bottom: defaultPadding / 2,
            ),
            child: Text(
              'Please attched the Aadhaar Document image',
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 100,
              width: 150,
              child: !isAadhaarImageSelectedFront
                  ? InkWell(
                      child: Image.asset(
                        'assets/image/add-image.png',
                      ),
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          imageAadhaarFileFront = File(image.path);

                          setState(() {
                            isAadhaarImageSelectedFront = true;
                          });
                        }
                      },
                    )
                  : SizedBox(
                      height: 100,
                      width: 150,
                      child: Stack(
                        children: [
                          Image.file(
                            imageAadhaarFileFront!,
                            height: 100,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            right: 1,
                            top: 1,
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    imageAadhaarFileFront = null;
                                    isAadhaarImageSelectedFront = false;
                                  });
                                },
                                icon: const Icon(
                                  FontAwesomeIcons.trash,
                                  color: Colors.red,
                                )),
                          )
                        ],
                      ),
                    ),
            ),
            SizedBox(
              height: 100,
              width: 150,
              child: !isAadhaarImageSelectedBack
                  ? InkWell(
                      child: Image.asset(
                        'assets/image/add-image.png',
                      ),
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          imageAadhaarFileBack = File(image.path);
                          setState(() {
                            isAadhaarImageSelectedBack = true;
                          });
                        }
                      },
                    )
                  : SizedBox(
                      height: 100,
                      width: 150,
                      child: Stack(
                        children: [
                          Image.file(
                            imageAadhaarFileBack!,
                            height: 100,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            right: 1,
                            top: 1,
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    imageAadhaarFileBack = null;
                                    isAadhaarImageSelectedBack = false;
                                  });
                                },
                                icon: const Icon(
                                  FontAwesomeIcons.trash,
                                  color: Colors.red,
                                )),
                          )
                        ],
                      ),
                    ),
            ),
          ],
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        imageLableRow(),
        const SizedBox(
          height: defaultPadding,
        ),
        // PAN
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Text('PAN Number'),
        ),
        CustomTextField(
            hint: 'PAN Number',
            controller: _kycPanNumber,
            keyboardType: TextInputType.name,
            obscure: false,
            icon: FontAwesomeIcons.userShield),
        const Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(
              left: defaultPadding,
              right: defaultPadding,
              // top: defaultPadding,
              bottom: defaultPadding / 2,
            ),
            child: Text(
              'Please attched the PAN Document image',
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 100,
              width: 150,
              child: !isPanImageSelectedFront
                  ? InkWell(
                      child: Image.asset(
                        'assets/image/add-image.png',
                      ),
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          imagePanFileFront = File(image.path);

                          setState(() {
                            isPanImageSelectedFront = true;
                          });
                        }
                      },
                    )
                  : SizedBox(
                      height: 100,
                      width: 150,
                      child: Stack(
                        children: [
                          Image.file(
                            imagePanFileFront!,
                            height: 100,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            right: 1,
                            top: 1,
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    imagePanFileFront = null;
                                    isPanImageSelectedFront = false;
                                  });
                                },
                                icon: const Icon(
                                  FontAwesomeIcons.trash,
                                  color: Colors.red,
                                )),
                          )
                        ],
                      ),
                    ),
            ),
            SizedBox(
              height: 100,
              width: 150,
              child: !isPanImageSelectedBack
                  ? InkWell(
                      child: Image.asset(
                        'assets/image/add-image.png',
                      ),
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          imagePanFileBack = File(image.path);
                          setState(() {
                            isPanImageSelectedBack = true;
                          });
                        }
                      },
                    )
                  : SizedBox(
                      height: 100,
                      width: 150,
                      child: Stack(
                        children: [
                          Image.file(
                            imagePanFileBack!,
                            height: 100,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            right: 1,
                            top: 1,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  imagePanFileBack = null;
                                  isPanImageSelectedBack = false;
                                });
                              },
                              icon: const Icon(
                                FontAwesomeIcons.trash,
                                color: Colors.red,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
            ),
          ],
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        imageLableRow(),
        const SizedBox(
          height: defaultPadding,
        ),
        // DL
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Text('Driving Lisence Number'),
        ),
        CustomTextField(
            hint: 'Driving Lisence Number',
            controller: _kycDLNumber,
            keyboardType: TextInputType.name,
            obscure: false,
            icon: FontAwesomeIcons.userShield),
        const Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(
              left: defaultPadding,
              right: defaultPadding,
              // top: defaultPadding,
              bottom: defaultPadding / 2,
            ),
            child: Text(
              'Please attched the DL Document image',
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 100,
              width: 150,
              child: !isDLImageSelectedFront
                  ? InkWell(
                      child: Image.asset(
                        'assets/image/add-image.png',
                      ),
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          imageDLFileFront = File(image.path);

                          setState(() {
                            isDLImageSelectedFront = true;
                          });
                        }
                      },
                    )
                  : SizedBox(
                      height: 100,
                      width: 150,
                      child: Stack(
                        children: [
                          Image.file(
                            imageDLFileFront!,
                            height: 100,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            right: 1,
                            top: 1,
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    imageDLFileFront = null;
                                    isDLImageSelectedFront = false;
                                  });
                                },
                                icon: const Icon(
                                  FontAwesomeIcons.trash,
                                  color: Colors.red,
                                )),
                          )
                        ],
                      ),
                    ),
            ),
            SizedBox(
              height: 100,
              width: 150,
              child: !isDLImageSelectedBack
                  ? InkWell(
                      child: Image.asset(
                        'assets/image/add-image.png',
                      ),
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          imageDLFileBack = File(image.path);
                          setState(() {
                            isDLImageSelectedBack = true;
                          });
                        }
                      },
                    )
                  : SizedBox(
                      height: 100,
                      width: 150,
                      child: Stack(
                        children: [
                          Image.file(
                            imageDLFileBack!,
                            height: 100,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            right: 1,
                            top: 1,
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    imageDLFileBack = null;
                                    isDLImageSelectedBack = false;
                                  });
                                },
                                icon: const Icon(
                                  FontAwesomeIcons.trash,
                                  color: Colors.red,
                                )),
                          )
                        ],
                      ),
                    ),
            ),
          ],
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        imageLableRow(),
        const SizedBox(
          height: defaultPadding,
        ),
        ActiveButton(
          onPressed: () async {
            if (_kycAadhaarNumber.text.isEmpty ||
                imageAadhaarFileBack == null ||
                imageAadhaarFileFront == null ||
                _kycPanNumber.text.isEmpty ||
                imagePanFileBack == null ||
                imagePanFileFront == null) {
              SnackBarService.instance
                  .showSnackBarError('Aadhaar and PAN fields are mandatory');
              return;
            }
            setState(() {
              isSaving = true;
            });
            await StorageService.uploadKycDocuments(
                    imageAadhaarFileFront!,
                    imageAadhaarFileBack!,
                    imagePanFileFront!,
                    imagePanFileBack!,
                    imageDLFileFront,
                    imageDLFileBack)
                .then((map) async {
              UserProfile userProfile =
                  UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);

              if (await Permission.location.request().isGranted) {
                Position position = await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high);
                userProfile.latitude = position.latitude;
                userProfile.longitude = position.longitude;
              }
              userProfile.aadhaarId = _kycAadhaarNumber.text;
              userProfile.panId = _kycPanNumber.text;
              userProfile.dlId = _kycDLNumber.text;
              userProfile.aadhaarDocumentImageBack = map['aadhaarBack'];
              userProfile.aadhaarDocumentImageFront = map['aadhaarFront'];
              userProfile.panDocumentImageBack = map['panfileBack'];
              userProfile.panDocumentImageFront = map['panfileFront'];
              userProfile.dlDocumentImageBack = map['dlfileBack'];
              userProfile.dlDocumentImageFront = map['dlfileFront'];
              userProfile.isKycDone = false;
              // ignore: use_build_context_synchronously
              await DBService.instance
                  .updateProfile(userProfile.id!, userProfile.toMap(), context);
            });
            setState(() {
              isSaving = false;
            });
          },
          label: 'Update',
          isDisabled: isSaving,
        )
      ],
    );
  }

  Row imageLableRow() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        Text(
          'Front Side',
        ),
        Text(
          'Back Side',
        ),
      ],
    );
  }
}
