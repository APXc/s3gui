import 'package:minio/minio.dart';
import 'package:s3gui/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:s3gui/repository/secureStore.dart';

class Client {
  static final Client _client = Client._internal();
  Client._internal();
  bool isInited = false;
  late Minio c;

  factory Client() {
    return _client;
  }

  Future<void> init(SharedPreferences sharedPreferences) async{
    // final endpoint = sharedPreferences.getString(s3EndpointURLTag)!;
    // final accessKey = sharedPreferences.getString(s3AccessKeyTag)!;
    // final secretKey = sharedPreferences.getString(s3SecretKeyTag)!;
    // final regionTag = sharedPreferences.getString(s3RegionTag)!;
  if (isInited) return;

    final secureStorage = SecureStorage();
    
  // Leggi i valori da secure storage
  final endpoint = await secureStorage.getString(s3EndpointURLTag) ?? 
                    sharedPreferences.getString(s3EndpointURLTag) ?? '';
  final accessKey = await secureStorage.getString(s3AccessKeyTag) ?? 
                    sharedPreferences.getString(s3AccessKeyTag) ?? '';
  final secretKey = await secureStorage.getString(s3SecretKeyTag) ?? 
                    sharedPreferences.getString(s3SecretKeyTag) ?? '';
  final region = await secureStorage.getString(s3RegionTag) ?? 
                  sharedPreferences.getString(s3RegionTag) ?? '';
  // final secure = await secureStorage.getString(s3SecureTag) == 'true' ||
  //                 sharedPreferences.getBool(s3SecureTag) ?? true;
                  
  // Se i valori esistono in SharedPreferences ma non in SecureStorage,
  // migrali a SecureStorage e cancellali da SharedPreferences
  if (sharedPreferences.containsKey(s3AccessKeyTag)) {
    await secureStorage.saveString(s3AccessKeyTag, accessKey);
    sharedPreferences.remove(s3AccessKeyTag);
  }
  
  if (sharedPreferences.containsKey(s3SecretKeyTag)) {
    await secureStorage.saveString(s3SecretKeyTag, secretKey);
    sharedPreferences.remove(s3SecretKeyTag);
  }
    
    c = Minio(
      endPoint: endpoint,
      accessKey: accessKey,
      secretKey: secretKey,
      useSSL: true,
      region: region
    );
    isInited = true;
  }
}
