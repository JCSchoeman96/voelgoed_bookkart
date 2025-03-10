import 'package:country_picker/country_picker.dart';

const APP_NAME = 'Voelgoed Media';
const DEFAULT_LANGUAGE = 'af';


const DOMAIN_URL = "";

const BASE_URL = 'https://voelgoedwinkel.co.za/wp-json/';

// LIVE
const CONSUMER_SECRET = 'cs_7fed19ef9ae02be3d24a3ced8e1c4485cb2b5427';
const CONSUMER_KEY = 'ck_0d62dc8088c5fa89d1051eeda1d917dfd390f4e8';


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

const DEFAULT_COUNTRY_CODE = '+27';

Country defaultCountry() {
  return Country(
    phoneCode: '27',
    countryCode: 'ZA',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'South Africa',
    example: '712345678',
    displayName: 'South Africa (ZA) [+27]',
    displayNameNoCountryCode: 'South Africa (ZA)',
    e164Key: 'ZA-27-0',
    fullExampleWithPlusSign: '+27712345678',
  );
}
