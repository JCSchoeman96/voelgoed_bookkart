import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:bookkart_flutter/configs.dart';
import 'package:crypto/crypto.dart' as crypto;


String getOAuthURL({required String requestMethod, required String endpoint, bool addConsumerKeys = true}) {
  bool isHttps = BASE_URL.startsWith("https");
  String token = "";
  String tokenSecret = "";
  String url = BASE_URL + endpoint;

  bool containsQueryParams = url.contains("?");

  String finalParameter = getFinalParameter(containsQueryParams);

  if (isHttps == true) {
    if (addConsumerKeys)
      return url + finalParameter;
    else
      return url;
  } else {
    Random rand = Random();
    int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    List<int> codeUnits = List.generate(10, (index) => rand.nextInt(26) + 97);

    String httpMethod = requestMethod;
    String nonce = String.fromCharCodes(codeUnits);
    String parameters =
        "oauth_consumer_key=" + CONSUMER_KEY + "&oauth_nonce=" + nonce + "&oauth_signature_method=HMAC-SHA1&oauth_timestamp=" + timestamp.toString() + "&oauth_token=" + token + "&oauth_version=1.0&";

    (containsQueryParams == true) ? parameters = parameters + url.split("?")[1] : parameters = parameterStringForRequestUrl(parameters);

    Map<dynamic, dynamic> treeMap = treeMapForKeyAndValue(parameters);
    String parameterString = "";

    for (String key in treeMap.keys) {
      parameterString = parameterString + Uri.encodeQueryComponent(key) + "=" + treeMap[key] + "&";
    }

    parameterString = parameterStringForRequestUrl(parameterString);

    String baseString = baseStringForSig(httpMethod, containsQueryParams, url, parameterString);
    String signingKey = CONSUMER_SECRET + "&" + tokenSecret;
    String requestUrl = createRequestUrl(containsQueryParams, "", url, parameterString, finalSignatureReq(signingKey, baseString));

    print("BASE-STRING : " + baseString + '\n');
    print("SIGNING-KEY : " + signingKey + '\n');
    print("REQUEST-URL : " + requestUrl + '\n');

    return requestUrl;
  }
}

Map<dynamic, dynamic> treeMapForKeyAndValue(String parameters) {
  Map<dynamic, dynamic> params = QueryString.parse(parameters);
  Map<dynamic, dynamic> treeMap = SplayTreeMap<dynamic, dynamic>();
  treeMap.addAll(params);
  return treeMap;
}

String getFinalParameter(bool containsQueryParams) {
  String appendValue = containsQueryParams ? '&' : '?';
  String consumerKey = appendValue + "consumer_key=$CONSUMER_KEY";
  String consumerSecret = "&consumer_secret=$CONSUMER_SECRET";
  String finalParameter = consumerKey + consumerSecret;

  return finalParameter;
}

String finalSignatureReq(String signingKey, String baseString) {
  crypto.Hmac hmacSha1 = crypto.Hmac(crypto.sha1, utf8.encode(signingKey)); // HMAC-SHA1
  crypto.Digest signature = hmacSha1.convert(utf8.encode(baseString));
  String finalSignature = base64Encode(signature.bytes);

  return finalSignature;
}

String baseStringForSig(String method, bool containsQueryParams, String url, String parameterString) {
  return method + "&" + Uri.encodeQueryComponent(containsQueryParams == true ? url.split("?")[0] : url) + "&" + Uri.encodeQueryComponent(parameterString);
}

String parameterStringForRequestUrl(String parameterString) {
  return parameterString.substring(0, parameterString.length - 1);
}

String createRequestUrl(bool containsQueryParams, String requestUrl, String url, String parameterString, String finalSignature) {
  return (containsQueryParams == true)
      ? url.split("?")[0] + "?" + parameterString + "&oauth_signature=" + Uri.encodeQueryComponent(finalSignature)
      : url + "?" + parameterString + "&oauth_signature=" + Uri.encodeQueryComponent(finalSignature);
}

class QueryString {
  static Map parse(String query) {
    var search = new RegExp('([^&=]+)=?([^&]*)');
    var result = new Map();

    // Get rid off the beginning ? in query strings.
    if (query.startsWith('?')) query = query.substring(1);

    // A custom decoder.
    decode(String s) => Uri.decodeComponent(s.replaceAll('+', ' '));

    // Go through all the matches and build the result map.
    for (Match match in search.allMatches(query)) {
      result[decode(match.group(1)!)] = decode(match.group(2)!);
    }

    return result;
  }
}
