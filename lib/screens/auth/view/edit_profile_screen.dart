import 'dart:convert';
import 'dart:io';

import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/components/cached_image_widget.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/auth/auth_repository.dart';
import 'package:bookkart_flutter/utils/colors.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

enum ImageFromSource { Camera, Gallery }

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController nameCont = TextEditingController();
  TextEditingController lastNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();

  File? imageFile;
  XFile? pickedFile;

  @override
  void initState() {
    if (mounted) {
      super.initState();
      init();
    }
  }

  @override
  void dispose() {
    appStore.setLoading(false);
    super.dispose();
  }

  Future<void> init() async {
    nameCont.text = appStore.userFirstName.validate();
    lastNameCont.text = appStore.userLastName.validate();
    emailCont.text = appStore.userEmail.validate();
  }

  void _getImageFrom(ImageFromSource imageSource) async {
    switch (imageSource) {
      case ImageFromSource.Camera:
        pickedFile = await ImagePicker().pickImage(source: ImageSource.camera, maxWidth: 1800, maxHeight: 1800);

        break;
      case ImageFromSource.Gallery:
        pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1800, maxHeight: 1800);
        break;
    }

    if (pickedFile != null) {
      imageFile = File(pickedFile!.path);
      setState(() {});
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      backgroundColor: context.cardColor,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SettingItemWidget(
              title: locale.gallery,
              leading: Icon(Icons.image, color: primaryColor),
              onTap: () {
                _getImageFrom(ImageFromSource.Gallery);
                finish(context);
              },
            ),
            Divider(),
            SettingItemWidget(
              title: locale.camera,
              leading: Icon(Icons.camera, color: primaryColor),
              onTap: () {
                _getImageFrom(ImageFromSource.Camera);
                finish(context);
              },
            ),
          ],
        ).paddingAll(16.0);
      },
    );
  }

  Future<void> updateProfileOnConfirm() async {
    Map<String, dynamic> req = {'first_name': nameCont.text, 'last_name': lastNameCont.text};
    appStore.setLoading(true);

    if (imageFile != null) {
      await saveProfileImage({'base64_img': base64Encode(imageFile!.readAsBytesSync())}).then((value) async {
        await updateCustomer(req);
        appStore.setLoading(false);
        finish(context);
      }).catchError((e) {
        appStore.setLoading(false);
        throw e;
      });
    } else {
      await updateCustomer(req);
      finish(context);
    }
  }

  void saveUser() async {
    hideKeyboard(context);

    await showConfirmDialogCustom(
      context,
      primaryColor: context.primaryColor,
      title: locale.lblAreSureAboutUpdatingYourProfile,
      onAccept: (e) async {
        await updateProfileOnConfirm();
      },
    );
  }

  Widget buildProfileWidget() {
    return Stack(
      children: [
        Container(
          child: _buildProfileImage(),
          decoration: boxDecorationDefault(
            border: Border.all(color: context.scaffoldBackgroundColor, width: 4),
            shape: BoxShape.circle,
          ),
        ),
        Positioned(
          bottom: 4,
          right: 0,
          child: GestureDetector(
            onTap: () async {
              _showBottomSheet(context);
            },
            child: Container(
              padding: EdgeInsets.all(6),
              child: Icon(Icons.camera_alt, color: Colors.white, size: 12),
              decoration: boxDecorationWithRoundedCorners(
                boxShape: BoxShape.circle,
                backgroundColor: primaryColor,
                border: Border.all(color: Colors.white),
              ),
            ),
          ),
        ).visible(!(appStore.loginType == GOOGLE_USER) && !(appStore.loginType == OTP_USER))
      ],
    ).center();
  }

  Widget _buildProfileImage() {
    if (imageFile != null) {
      return Image.file(imageFile!, width: 85, height: 85, fit: BoxFit.cover).cornerRadiusWithClipRRect(40);
    } else {
      return Observer(builder: (_) => CachedImageWidget(url: appStore.userProfileImage, height: 85, width: 85, fit: BoxFit.cover, circle: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(locale.lblEditProfile),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Stack(
          children: [
            Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.always,
              child: AnimatedScrollView(
                children: [
                  buildProfileWidget(),
                  32.height,
                  AppTextField(
                    decoration: inputDecoration(context, locale.hintEnterFirstName),
                    isPassword: false,
                    controller: nameCont,
                    textFieldType: TextFieldType.USERNAME,
                  ),
                  16.height,
                  AppTextField(
                    decoration: inputDecoration(context, locale.hintEnterLastName),
                    isPassword: false,
                    controller: lastNameCont,
                    textFieldType: TextFieldType.USERNAME,
                  ),
                  16.height,
                  AppTextField(
                    decoration: inputDecoration(context, locale.hintEnterEmail),
                    isPassword: false,
                    controller: emailCont,
                    textFieldType: TextFieldType.EMAIL,
                    enabled: false,
                  ),
                  16.height,
                  AppButton(
                    width: context.width(),
                    shapeBorder: RoundedRectangleBorder(borderRadius: radius()),
                    color: context.primaryColor,
                    text: locale.lblSave,
                    textStyle: boldTextStyle(color: Colors.white),
                    onTap: () {
                      hideKeyboard(context);
                      (formKey.currentState!.validate()) ? saveUser() : appStore.setLoading(false);
                      setState(() {});
                    },
                  )
                ],
              ),
            ),
            AppLoader(isObserver: true),
          ],
        ),
      ),
    );
  }
}
