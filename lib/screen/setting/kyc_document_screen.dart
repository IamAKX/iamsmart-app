import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  UserProfile? userProfile;

  final TextEditingController _kycAadhaarNumber = TextEditingController();
  bool isAadhaarImageSelectedFront = false;
  File? imageAadhaarFileFront;
  bool isAadhaarImageSelectedBack = false;
  File? imageAadhaarFileBack;

  // PAN
  final TextEditingController _kycPanNumber = TextEditingController();
  bool isPanImageSelectedFront = false;
  File? imagePanFileFront;
  bool isPanImageSelectedBack = false;
  File? imagePanFileBack;

  // DL
  final TextEditingController _kycDLNumber = TextEditingController();
  bool isDLImageSelectedFront = false;
  File? imageDLFileFront;
  bool isDLImageSelectedBack = false;
  File? imageDLFileBack;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  loadProfile() async {
    userProfile = await DBService.instance.getUserById(
        UserProfile.fromJson(prefs.getString(PreferenceKey.user)!).id!);
    prefs.setString(PreferenceKey.user, userProfile!.toJson());
    if (userProfile?.isKycDone ?? false) {
      _kycAadhaarNumber.text = userProfile?.aadhaarId ?? '';
      _kycPanNumber.text = userProfile?.panId ?? '';
      _kycDLNumber.text = userProfile?.dlId ?? '';
    }
    setState(() {});
  }

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
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding,
            vertical: defaultPadding / 2,
          ),
          child: Text(
            'Please choose png or jpeg type image only',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Text('Aadhaar Number'),
        ),
        CustomTextField(
          hint: 'Aadhaar Number',
          controller: _kycAadhaarNumber,
          keyboardType: TextInputType.name,
          obscure: false,
          icon: FontAwesomeIcons.userShield,
          enabled: !(userProfile?.isKycDone ?? false),
        ),
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
              child: userProfile?.isKycDone ?? false
                  ? getLoadedImage(userProfile?.aadhaarDocumentImageFront)
                  : !isAadhaarImageSelectedFront
                      ? InkWell(
                          child: Image.asset(
                            'assets/image/add-image.png',
                          ),
                          onTap: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(
                                source: ImageSource.gallery);
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
              child: userProfile?.isKycDone ?? false
                  ? getLoadedImage(userProfile?.aadhaarDocumentImageBack)
                  : !isAadhaarImageSelectedBack
                      ? InkWell(
                          child: Image.asset(
                            'assets/image/add-image.png',
                          ),
                          onTap: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(
                                source: ImageSource.gallery);
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
          icon: FontAwesomeIcons.userShield,
          enabled: !(userProfile?.isKycDone ?? false),
        ),
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
              child: userProfile?.isKycDone ?? false
                  ? getLoadedImage(userProfile?.panDocumentImageFront)
                  : !isPanImageSelectedFront
                      ? InkWell(
                          child: Image.asset(
                            'assets/image/add-image.png',
                          ),
                          onTap: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(
                                source: ImageSource.gallery);
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
            // SizedBox(
            //   height: 100,
            //   width: 150,
            //   child: userProfile?.isKycDone ?? false
            //       ? getLoadedImage(userProfile?.panDocumentImageBack)
            //       : !isPanImageSelectedBack
            //           ? InkWell(
            //               child: Image.asset(
            //                 'assets/image/add-image.png',
            //               ),
            //               onTap: () async {
            //                 final ImagePicker picker = ImagePicker();
            //                 final XFile? image = await picker.pickImage(
            //                     source: ImageSource.gallery);
            //                 if (image != null) {
            //                   imagePanFileBack = File(image.path);
            //                   setState(() {
            //                     isPanImageSelectedBack = true;
            //                   });
            //                 }
            //               },
            //             )
            //           : SizedBox(
            //               height: 100,
            //               width: 150,
            //               child: Stack(
            //                 children: [
            //                   Image.file(
            //                     imagePanFileBack!,
            //                     height: 100,
            //                     width: 150,
            //                     fit: BoxFit.cover,
            //                   ),
            //                   Positioned(
            //                     right: 1,
            //                     top: 1,
            //                     child: IconButton(
            //                       onPressed: () {
            //                         setState(() {
            //                           imagePanFileBack = null;
            //                           isPanImageSelectedBack = false;
            //                         });
            //                       },
            //                       icon: const Icon(
            //                         FontAwesomeIcons.trash,
            //                         color: Colors.red,
            //                       ),
            //                     ),
            //                   )
            //                 ],
            //               ),
            //             ),
            // ),
          ],
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Text(
              'Front Side',
            ),
          ],
        ),

        // DL
        // const Padding(
        //   padding: EdgeInsets.symmetric(horizontal: defaultPadding),
        //   child: Text('Driving Lisence Number'),
        // ),
        // CustomTextField(
        //   hint: 'Driving Lisence Number',
        //   controller: _kycDLNumber,
        //   keyboardType: TextInputType.name,
        //   obscure: false,
        //   icon: FontAwesomeIcons.userShield,
        //   enabled: !(userProfile?.isKycDone ?? false),
        // ),
        // const Align(
        //   alignment: Alignment.center,
        //   child: Padding(
        //     padding: EdgeInsets.only(
        //       left: defaultPadding,
        //       right: defaultPadding,
        //       // top: defaultPadding,
        //       bottom: defaultPadding / 2,
        //     ),
        //     child: Text(
        //       'Please attched the DL Document image',
        //     ),
        //   ),
        // ),
        // Row(
        //   mainAxisSize: MainAxisSize.max,
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: [
        //     SizedBox(
        //       height: 100,
        //       width: 150,
        //       child: userProfile?.isKycDone ?? false
        //           ? getLoadedImage(userProfile?.dlDocumentImageFront)
        //           : !isDLImageSelectedFront
        //               ? InkWell(
        //                   child: Image.asset(
        //                     'assets/image/add-image.png',
        //                   ),
        //                   onTap: () async {
        //                     final ImagePicker picker = ImagePicker();
        //                     final XFile? image = await picker.pickImage(
        //                         source: ImageSource.gallery);
        //                     if (image != null) {
        //                       imageDLFileFront = File(image.path);

        //                       setState(() {
        //                         isDLImageSelectedFront = true;
        //                       });
        //                     }
        //                   },
        //                 )
        //               : SizedBox(
        //                   height: 100,
        //                   width: 150,
        //                   child: Stack(
        //                     children: [
        //                       Image.file(
        //                         imageDLFileFront!,
        //                         height: 100,
        //                         width: 150,
        //                         fit: BoxFit.cover,
        //                       ),
        //                       Positioned(
        //                         right: 1,
        //                         top: 1,
        //                         child: IconButton(
        //                             onPressed: () {
        //                               setState(() {
        //                                 imageDLFileFront = null;
        //                                 isDLImageSelectedFront = false;
        //                               });
        //                             },
        //                             icon: const Icon(
        //                               FontAwesomeIcons.trash,
        //                               color: Colors.red,
        //                             )),
        //                       )
        //                     ],
        //                   ),
        //                 ),
        //     ),
        //     SizedBox(
        //       height: 100,
        //       width: 150,
        //       child: userProfile?.isKycDone ?? false
        //           ? getLoadedImage(userProfile?.dlDocumentImageBack)
        //           : !isDLImageSelectedBack
        //               ? InkWell(
        //                   child: Image.asset(
        //                     'assets/image/add-image.png',
        //                   ),
        //                   onTap: () async {
        //                     final ImagePicker picker = ImagePicker();
        //                     final XFile? image = await picker.pickImage(
        //                         source: ImageSource.gallery);
        //                     if (image != null) {
        //                       imageDLFileBack = File(image.path);
        //                       setState(() {
        //                         isDLImageSelectedBack = true;
        //                       });
        //                     }
        //                   },
        //                 )
        //               : SizedBox(
        //                   height: 100,
        //                   width: 150,
        //                   child: Stack(
        //                     children: [
        //                       Image.file(
        //                         imageDLFileBack!,
        //                         height: 100,
        //                         width: 150,
        //                         fit: BoxFit.cover,
        //                       ),
        //                       Positioned(
        //                         right: 1,
        //                         top: 1,
        //                         child: IconButton(
        //                             onPressed: () {
        //                               setState(() {
        //                                 imageDLFileBack = null;
        //                                 isDLImageSelectedBack = false;
        //                               });
        //                             },
        //                             icon: const Icon(
        //                               FontAwesomeIcons.trash,
        //                               color: Colors.red,
        //                             )),
        //                       )
        //                     ],
        //                   ),
        //                 ),
        //     ),
        //   ],
        // ),
        // const SizedBox(
        //   height: defaultPadding / 2,
        // ),
        // imageLableRow(),

        Visibility(
          visible: !(userProfile?.isKycDone ?? false),
          child: ActiveButton(
            onPressed: () async {
              if (_kycAadhaarNumber.text.isEmpty ||
                  imageAadhaarFileBack == null ||
                  imageAadhaarFileFront == null ||
                  _kycPanNumber.text.isEmpty ||
                  imagePanFileFront == null) {
                SnackBarService.instance
                    .showSnackBarError('Aadhaar and PAN fields are mandatory');
                return;
              }
              setState(() {
                isSaving = true;
              });
              AwesomeDialog(
                context: context,
                dialogType: DialogType.info,
                animType: AnimType.bottomSlide,
                title: 'Please wait...',
                autoDismiss: false,
                customHeader: const Center(child: CircularProgressIndicator()),
                desc:
                    'Uploading document, please do not press back button or close the app',
                onDismissCallback: (type) {},
              ).show();
              await StorageService.uploadKycDocuments(
                      imageAadhaarFileFront!,
                      imageAadhaarFileBack!,
                      imagePanFileFront!,
                      imagePanFileBack,
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
                await DBService.instance.updateProfile(
                    userProfile.id!, userProfile.toMap(), context);
              });
              setState(() {
                isSaving = false;
                loadProfile();
              });
            },
            label: isSaving ? 'Uploading...' : 'Update',
            isDisabled: isSaving,
          ),
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

  getLoadedImage(String? imgLink) {
    return SizedBox(
      height: 100,
      width: 150,
      child: CachedNetworkImage(
        imageUrl: imgLink ?? '',
        height: 100,
        width: 150,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Image.asset(
          'assets/image/add-image.png',
          height: 100,
          width: 150,
        ),
      ),
    );
  }
}
