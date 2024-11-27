import 'package:country_picker/country_picker.dart';

const APP_NAME = 'BookKart';
const DEFAULT_LANGUAGE = 'en';


const DOMAIN_URL = "";

const BASE_URL = '$DOMAIN_URL/wp-json/';

// LIVE
const CONSUMER_SECRET = '';
const CONSUMER_KEY = '';


const IOS_LINK_FOR_USER = '';

const TERMS_CONDITION_URL = '';
const PRIVACY_POLICY_URL = '';
const PER_PAGE_ITEM = 30;
const bool ENABLE_ADS = false;

const FLUTTER_WAVE_KEY = '';
const FLUTTER_WAVE_PUBLIC_KEY = '';
const FLUTTER_ENCRYPTION_KEY = '';

//Razorpay
const RAZOR_KEY = '';

///ad Strings id
const BANNER_AD_ID_ANDROID = '';
const BANNER_AD_ID_IOS = '';
const INTERSTITIAL_AD_ID_ANDROID = '';
const INTERSTITIAL_AD_ID_IOS = '';

const DEFAULT_COUNTRY_CODE = '+91';

Country defaultCountry() {
  return Country(
    phoneCode: '91',
    countryCode: 'IN',
    e164Sc: 91,
    geographic: true,
    level: 1,
    name: 'India',
    example: '9123456789',
    displayName: 'India (IN) [+91]',
    displayNameNoCountryCode: 'India (IN)',
    e164Key: '91-IN-0',
    fullExampleWithPlusSign: '+919123456789',
  );
}
