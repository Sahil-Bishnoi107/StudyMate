import 'package:study_mate/Authentication/Domain/Entities/ApiResponse.dart';

abstract class AuthData{
Future<ApiResponse> loginWithEmail(String email,String password);
Future<ApiResponse> autoLogin(String refreshToken);
}