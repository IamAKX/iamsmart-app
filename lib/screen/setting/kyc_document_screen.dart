import 'dart:io';

import 'package:dropdown_search2/dropdown_search2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iamsmart/main.dart';
import 'package:iamsmart/model/user_profile.dart';
import 'package:iamsmart/service/db_service.dart';
import 'package:iamsmart/service/storage_service.dart';
import 'package:iamsmart/util/constants.dart';
import 'package:iamsmart/util/preference_key.dart';
import 'package:iamsmart/widget/button_active.dart';
import 'package:image_picker/image_picker.dart';

import '../../service/snakbar_service.dart';
import '../../util/colors.dart';
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
  String _kycDocumentType = '';
  final TextEditingController _kycNumber = TextEditingController();
  bool isImageSelectedFront = false;
  late File? imageFileFront;
  bool isImageSelectedBack = false;
  late File? imageFileBack;
  bool isSaving = false;
  String extension = '';

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
          padding: const EdgeInsets.all(defaultPadding),
          child: DropdownSearch<String>(
            mode: Mode.MENU,
            dropDownButton: const Icon(
              FontAwesomeIcons.chevronDown,
              size: 15,
              color: textColorLight,
            ),
            showSelectedItems: true,
            selectedItem: _kycDocumentType,
            label: 'KYC Document',
            items: kycDocumentList,
            onChanged: (value) {
              _kycDocumentType = value!;
            },
          ),
        ),
        CustomTextField(
            hint: 'ID Number',
            controller: _kycNumber,
            keyboardType: TextInputType.name,
            obscure: false,
            icon: FontAwesomeIcons.userShield),
        const Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(
              left: defaultPadding,
              right: defaultPadding,
              top: defaultPadding,
              bottom: defaultPadding,
            ),
            child: Text(
              'Please attched the KYC Document image',
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
              child: !isImageSelectedFront
                  ? InkWell(
                      child: Image.asset(
                        'assets/image/add-image.png',
                      ),
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          imageFileFront = File(image.path);

                          setState(() {
                            isImageSelectedFront = true;
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
                            imageFileFront!,
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
                                    imageFileFront = null;
                                    isImageSelectedFront = false;
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
              child: !isImageSelectedBack
                  ? InkWell(
                      child: Image.asset(
                        'assets/image/add-image.png',
                      ),
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          imageFileBack = File(image.path);
                          extension = image.name.split('.')[1];
                          setState(() {
                            isImageSelectedBack = true;
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
                            imageFileBack!,
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
                                    imageFileBack = null;
                                    isImageSelectedBack = false;
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
        Row(
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
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        ActiveButton(
          onPressed: () async {
            if (_kycDocumentType.isEmpty ||
                _kycNumber.text.isEmpty ||
                imageFileBack == null ||
                imageFileFront == null) {
              SnackBarService.instance
                  .showSnackBarError('All fields are mandatory');
              return;
            }
            setState(() {
              isSaving = true;
            });
            await StorageService.uploadKycDocuments(imageFileFront!,
                    imageFileBack!, _kycDocumentType, extension)
                .then((map) async {
              UserProfile userProfile =
                  UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);
              userProfile.kycDocumentType = _kycDocumentType;
              userProfile.kycId = _kycNumber.text;
              userProfile.kycDocumentImageBack = map['kycDocumentImageBack'];
              userProfile.kycDocumentImageFront = map['kycDocumentImageFront'];
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
}
