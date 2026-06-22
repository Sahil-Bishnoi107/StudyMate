import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureTokens {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';

  Future<void> saveTokens(String accessToken, String refreshToken) async{
    print("trying to save the tokens in secure storage");
     await _storage.write(key: accessTokenKey, value: accessToken);
     await _storage.write(key: refreshTokenKey, value: refreshToken);
     print("saved the tokens in secure storage");
  }

  Future<String?> getAccessToken() async{
    return await _storage.read(key: accessTokenKey);
  }
  Future<String?> getRefreshToken() async{
    return await _storage.read(key: refreshTokenKey);
  }

  Future<void> clearTokens() async{
    await _storage.delete(key: accessTokenKey);
    await _storage.delete(key: refreshTokenKey);
  }
}