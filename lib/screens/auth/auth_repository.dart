import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/models/auth/customer_response_model.dart';
import 'package:bookkart_flutter/models/auth/register_response_model.dart';
import 'package:bookkart_flutter/models/base_response_model.dart';
import 'package:bookkart_flutter/network/network_utils.dart';
import 'package:bookkart_flutter/models/auth/login_model.dart';
import 'package:bookkart_flutter/screens/auth/view/sign_in_screen.dart';
import 'package:bookkart_flutter/screens/cart/cart_functions.dart';
import 'package:bookkart_flutter/screens/dashboard/view/dashboard_screen.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:bookkart_flutter/utils/push_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../services/auth_services.dart';

Future<RegisterResponse> getRegisterUserRestApi(Map<String, dynamic> request) async {
  log('REGISTER-API');
  return RegisterResponse.fromJson(await responseHandler(await buildHttpResponse(
    "iqonic-api/api/v1/woocommerce/customer/registration",
    request: request,
    isTokenRequired: false,
    method: HttpMethodType.POST,
  )));
}

Future<LoginResponse> getLoginUserRestApi(Map<String, dynamic> request) async {
  log('LOGIN-API');
  LoginResponse loginResponse = LoginResponse.fromJson(await responseHandler(await buildHttpResponse(
    "jwt-auth/v1/token",
    request: request,
    isTokenRequired: false,
    method: HttpMethodType.POST,
  )));
  await setUserInfo(loginResponse, isRemember: false, password: '', username: '');
  return loginResponse;
}

Future<LoginResponse> socialLoginApi(Map request) async {
  log('SOCIAL-LOGIN-API');
  return LoginResponse.fromJson(await responseHandler(await buildHttpResponse(
    'iqonic-api/api/v1/customer/social_login',
    request: request,
    method: HttpMethodType.POST,
    isTokenRequired: false,
  )));
}

Future<BaseResponseModel> changePassword(Map<String, dynamic> request) async {
  log('CHANGE-PASSWORD-API');
  return BaseResponseModel.fromJson(await responseHandler(await buildHttpResponse('iqonic-api/api/v1/woocommerce/change-password', request: request, method: HttpMethodType.POST)));
}

Future<Customer> getCustomer(int? id) async {
  log('GET-CUSTOMER-API');
  return Customer.fromJson(await responseHandler(await buildHttpResponse('wc/v3/customers/$id', isTokenRequired: false)));
}

Future<BaseResponseModel> saveProfileImage(Map<String, dynamic> request) async {
  log('SAVE-PROFILE-IMAGE-API');
  return BaseResponseModel.fromJson(await responseHandler(await buildHttpResponse(
    'iqonic-api/api/v1/customer/save-profile-image',
    request: request,
    method: HttpMethodType.POST,
  )));
}

Future<Customer> updateCustomer(Map<String, dynamic> request) async {
  log('UPDATE-CUSTOMER-API');

  appStore.setLoading(true);
  return responseHandler(await buildHttpResponse('wc/v3/customers/${appStore.userId}', request: request, method: HttpMethodType.POST)).then((value) {
    appStore.setLoading(false);

    Customer customer = Customer.fromJson(value);
    appStore.setUserProfile(customer.avatarUrl.validate());
    appStore.setFirstName(customer.firstName.validate());
    appStore.setLastName(customer.lastName.validate());

    customer.metaData.forEachIndexed(
      (customerData, index) {
        if (customerData.key == IQONIC_PROFILE_IMAGE) {
          if (customerData.value.validate().isEmpty) {
            appStore.setUserProfile(customer.avatarUrl.validate());
          } else {
            appStore.setUserProfile(customerData.value.validate());
          }
        }
      },
    );

    toast(locale.lblProfileSaved);
    return customer;
  }).catchError((e) {
    appStore.setLoading(false);
    throw e;
  });
}

Future<BaseResponseModel> forgetPassword({required Map<String, dynamic> request}) async {
  log("FORGOT-PASSWORD-API");
  appStore.setLoading(true);
  Response res = await buildHttpResponse('iqonic-api/api/v1/customer/forget-password', request: request, method: HttpMethodType.POST).then((value) {
    appStore.setLoading(false);
    return value;
  }).catchError((e) {
    appStore.setLoading(false);
    throw e;
  });

  return responseHandler(res).then((value) {
    appStore.setLoading(false);
    BaseResponseModel baseResponse = BaseResponseModel.fromJson(value);
    toast(baseResponse.message.validate());
    return baseResponse;
  }).catchError((e) {
    appStore.setLoading(false);
    toast('forget password request failed');
    throw e;
  });
}

Future deleteAccount() async {
  log('DELETE-ACCOUNT-API');
  return responseHandler(await buildHttpResponse('iqonic-api/api/v1/customer/delete-account'));
}

Future logout(BuildContext context) async {
  showConfirmDialogCustom(
    context,
    title: locale.lblAreYourLogout,
    primaryColor: context.primaryColor,
    onAccept: (e) async {
      await PushNotificationService().unsubscribeFirebaseTopic();
      clearData(context);
    },
  );
}

Future clearData(BuildContext context) async {
  removeCart();

  await appStore.setUserName('');
  await appStore.setToken('');
  await appStore.setFirstName('');
  await appStore.setLastName('');
  await appStore.setDisplayName('');
  await appStore.setUserId(0);
  await appStore.setUserEmail('');
  await appStore.setAvatar('');
  await appStore.setLoggedIn(false);
  await appStore.setUserProfile('');
  await appStore.setSocialLogin(false);
  appStore.setLoading(false);

  DashboardScreen().launch(context, isNewTask: true);
}

void openSignInScreen() async {
  await appStore.setUserName('');
  await appStore.setToken('');
  await appStore.setFirstName('');
  await appStore.setLastName('');
  await appStore.setDisplayName('');
  await appStore.setUserId(0);
  await appStore.setUserEmail('');
  await appStore.setAvatar('');
  await appStore.setLoggedIn(false);
  await appStore.setUserProfile('');
  SignInScreen().launch(getContext, isNewTask: true);
}
