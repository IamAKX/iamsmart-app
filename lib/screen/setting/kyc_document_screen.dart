import 'dart:io';

import 'package:dropdown_search2/dropdown_search2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iamsmart/util/constants.dart';
import 'package:iamsmart/widget/button_active.dart';
import 'package:image_picker/image_picker.dart';

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
  bool isImageSelected = false;
  late File? imageFile;

  @override
  Widget build(BuildContext context) {
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
            keyboardType: TextInputType.number,
            obscure: false,
            icon: FontAwesomeIcons.userShield),
        const Padding(
          padding: EdgeInsets.only(
            left: defaultPadding,
            right: defaultPadding,
            top: defaultPadding,
          ),
          child: Text(
            'Please attched the KYC Document image',
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.all(defaultPadding),
            height: 200,
            width: 200,
            child: !isImageSelected
                ? InkWell(
                    child: Image.asset(
                      'assets/image/add-image.png',
                    ),
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        imageFile = File(image.path);

                        setState(() {
                          isImageSelected = true;
                        });
                      }
                    },
                  )
                : SizedBox(
                    height: 200,
                    width: 200,
                    child: Stack(
                      children: [
                        Image.file(
                          imageFile!,
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          right: 1,
                          top: 1,
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  imageFile = null;
                                  isImageSelected = false;
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
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        ActiveButton(
          onPressed: () {},
          label: 'Update',
        )
      ],
    );
  }
}
