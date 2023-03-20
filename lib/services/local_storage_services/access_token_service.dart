import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AccessTokenService {
  static const String accessTokenKey = "accessToken";
  static const String refreshTokenKey = "refreshToken";

  Future<void> storeToken(String key, String value) async {
    AndroidOptions getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions());
    await storage.write(key: key, value: value);
  }

  Future<String?> getToken(String key) async {
    AndroidOptions getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions());
    return await storage.read(key: key);
  }
}
