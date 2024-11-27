import 'package:firebase_remote_config/firebase_remote_config.dart';

Future<FirebaseRemoteConfig> setStoreReviewConfig() async {
  final FirebaseRemoteConfig firebaseRemoteConfig = FirebaseRemoteConfig.instance;

  firebaseRemoteConfig.setConfigSettings(RemoteConfigSettings(fetchTimeout: Duration.zero, minimumFetchInterval: Duration.zero));
  await firebaseRemoteConfig.fetchAndActivate();

  return firebaseRemoteConfig;
}
