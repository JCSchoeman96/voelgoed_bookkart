import 'dart:convert';
import 'dart:io';

import 'package:bookkart_flutter/utils/constants.dart';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String> getTime() async {
  DateTime currentTime = DateTime.now().toUtc();
  final f = DateFormat('yyyy-MM-dd hh:mm');
  log(f.format(currentTime).toString());
  return f.format(currentTime).toString();
}

Future<String> getKey(time) async {
  String finalString = time + SALT;
  log("Final String: " + finalString);
  String md5String = md5.convert(utf8.encode(finalString)).toString();
  log("MD5 String: " + md5String);
  return md5String;
}

String reviewConvertDate(String dateString) {
  try {
    if (!dateString.endsWith('Z')) {
      dateString += 'Z'; 
    }
    DateTime inputDate = DateTime.parse(dateString).toLocal(); 
    DateTime now = DateTime.now();
    Duration difference = now.difference(inputDate);

if (difference.inDays == 0) {
  if (difference.inHours > 0) {
    return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago'; 
  } else {
    return "just now";
  }
} else if (difference.inDays == 1) {
  return "yesterday";
} else if (difference.inDays <= 2) {
  return '${difference.inDays} days ago';
} else {
  return DateFormat('dd MMM, yyyy').format(inputDate);
}
  } catch (e) {
    log('Error parsing date: $e'); 
    return 'invalid date'; 
  }
}

Future<bool> checkPermission() async {
  if (isAndroid || isIOS) {
    if (await isAndroid12Above()) {
      return true;
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();

      bool isGranted = false;
      statuses.forEach((key, value) {
        isGranted = value.isGranted;
      });

      return isGranted;
    }
  } else {
    return false;
  }
}

Future<String> get localPath async {
  Directory? directory;

  if (Platform.isAndroid) {
    directory = await getExternalStorageDirectory();
  } else {
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      throw "Unsupported platform";
    }
  }

  return directory!.path;
}

Future<String> getBookFileName(String? bookId, String url, {isSample = false}) async {
  List<String> name = url.split("/");

  String fileNameNew = url;

  if (name.length > 0) fileNameNew = name[name.length - 1];

  fileNameNew = fileNameNew.replaceAll("%", "");
  String fileName = isSample ? bookId! + "_sample_" + fileNameNew : bookId! + "_purchased_" + fileNameNew;
  log("File Name: " + fileName);

  return fileName;
}

Future<String> getBookFilePath(String? bookId, String url, {isSampleFile = false}) async {
  String path = await localPath;
  String filePath = path + "/" + await getBookFileName(bookId, url, isSample: isSampleFile);
  filePath = filePath.replaceAll("null/", "");
  log("--- FULL FILE PATH: " + filePath);

  return filePath;
}
