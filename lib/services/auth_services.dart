import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/auth/auth_repository.dart';
import 'package:bookkart_flutter/models/auth/login_model.dart';
import 'package:bookkart_flutter/screens/auth/view/opt_dialog_component.dart';
import 'package:bookkart_flutter/screens/auth/view/sign_up_screen.dart';
import 'package:bookkart_flutter/screens/cart/cart_functions.dart';
import 'package:bookkart_flutter/screens/dashboard/view/dashboard_screen.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/push_notification_service.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;

class AuthService {
  final GoogleSignIn googleSignIn = GoogleSignIn();

//region Google Login
  Future<LoginResponse?> signInWithGoogle() async {
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult = await _auth.signInWithCredential(credential);
      final User user = authResult.user!;

      assert(!user.isAnonymous);

      final User currentUser = _auth.currentUser!;
      assert(user.uid == currentUser.uid);

      await googleSignIn.signOut();
      String firstName = '';
      String lastName = '';
      if (currentUser.displayName.validate().split(' ').length >= 1) firstName = currentUser.displayName.splitBefore(' ');
      if (currentUser.displayName.validate().split(' ').length >= 2) lastName = currentUser.displayName.splitAfter(' ');

      /// Create a temporary request to send
      Map<String, dynamic> req = {
        "email": currentUser.email,
        "firstName": firstName,
        "lastName": lastName,
        "photoURL": currentUser.photoURL,
        "accessToken": googleSignInAuthentication.accessToken,
        "loginType": 'google',
      };

      log("Google Login Json " + req.toString());

      return socialLoginApi(req).then((value) {
        appStore.setUserProfile(currentUser.photoURL!);

        return value;
      }).catchError((e) {
        toast(e.toString());
      });
    } else {
      appStore.setLoading(false);
      return null;
    }
  }

//endregion

  Future loginWithOTP(BuildContext context, {String phoneNumber = "", String? countryCode}) async {
    log("PHONE NUMBER VERIFIED $countryCode$phoneNumber");
    return await _auth.verifyPhoneNumber(
      phoneNumber: "+$countryCode$phoneNumber",
      verificationCompleted: (PhoneAuthCredential credential) {
        toast("Verified");
      },
      verificationFailed: (FirebaseAuthException e) {
        appStore.setLoading(false);

        if (e.code == INVALID_PHONE_NUMBER) {
          toast(locale.theEnteredCodeIsInvalidPleaseTryAgain, print: true);
        } else {
          toast(e.toString(), print: true);
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        toast(locale.lblOTPCodeIsSentToYourMobileNumber);

        appStore.setLoading(false);

        /// Opens a dialog when the code is sent to the user successfully.
        await OtpDialogComponent(
          onTap: (otpCode) async {
            if (otpCode != null) {
              AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otpCode);

              await _auth.signInWithCredential(credential).then((credentials) async {
                appStore.setLoginType(OTP_USER);

                Map<String, dynamic> req = {
                  'username': phoneNumber,
                  'password': phoneNumber,
                };

                log(req);

                await getLoginUserRestApi(req).then((value) async {
                  DashboardScreen().launch(context, isNewTask: true);
                }).catchError((e) {
                  if (e.toString() == INVALID_CREDENTIAL) {
                    finish(context);
                    SignUpScreen(countryCode: countryCode, isOTPLogin: true, phoneNumber: phoneNumber).launch(context);
                  } else {
                    toast(e.toString(), print: true);
                  }
                });

                appStore.setLoading(false);
              }).catchError((e) {
                if (e.code.toString() == INVALID_VERIFICATION_CODE) {
                  toast(locale.lblTheEnteredCodeIsInvalidPleaseTryAgain, print: true);
                } else {
                  toast(e.message.toString(), print: true);
                }
                appStore.setLoading(false);
              });
            }
          },
        ).launch(context);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        //
      },
    );
  }
}

Future<void> setUserInfo(LoginResponse response, {String password = "", String username = "", required bool isRemember}) async {
  await appStore.setUserName(response.userNicename.validate());
  await appStore.setToken(response.token.validate());
  await appStore.setFirstName(response.firstName.validate());
  await appStore.setLastName(response.lastName.validate());
  await appStore.setUserId(response.userId.validate());
  await appStore.setUserEmail(response.userEmail.validate());
  await appStore.setAvatar(response.avatar.validate());
  await appStore.setDisplayName(response.userDisplayName.validate());
  await appStore.setPassword(password);
  await appStore.setLoggedIn(true);
  await appStore.setUserProfile(response.profileImage.validate());
  await appStore.setAvatar(response.avatar.validate());

  if (isRemember.validate()) {
    setValue(REMEMBER_PASSWORD, isRemember.validate());

    setValue(EMAIL, username);
  }

  if (appStore.isLoggedIn && appStore.cartList.isEmpty) getCartDetails();
  PushNotificationService().registerFCMAndTopics();

}
