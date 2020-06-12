import 'dart:async';
import '../../src/data/version1/UserPasswordInfoV1.dart';

abstract class IPasswordsController {
  Future<UserPasswordInfoV1> getPasswordInfo(
      String correlationId, String userId);

  Future validatePassword(String correlationId, String password);

  Future setPassword(String correlationId, String userId, String password);

  Future<String> setTempPassword(String correlationId, String userId);

  Future deletePassword(String correlationId, String userId);

  Future<bool> authenticate(
      String correlationId, String userId, String password);

  Future changePassword(String correlationId, String userId, String oldPassword,
      String newPassword);

  Future<bool> validateCode(String correlationId, String userId, String code);

  Future resetPassword(
      String correlationId, String userId, String code, String password);

  Future recoverPassword(String correlationId, String userId);
}
