import 'dart:async';
import '../../src/data/version1/UserPasswordInfoV1.dart';

abstract class IPasswordsController {
  /// Gets a password infomation.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [userId]            an id of password to be retrieved.
  /// Return         Future that receives a password info.
  /// Throws error.
  Future<UserPasswordInfoV1> getPasswordInfo(
      String correlationId, String userId);

  /// Validate a password.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [password]            a password to be validated.
  /// Return         Future that receives null for success.
  Future validatePassword(String correlationId, String password);

  /// Sets a password.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [userId]            an id of password to be set.
  /// - [password]            a password to be set.
  /// Return         Future that receives null for success.
  Future setPassword(String correlationId, String userId, String password);

  /// Sets a temporary password.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [userId]            an id of password to be set.
  /// Return         Future that receives string temp password.
  Future<String> setTempPassword(String correlationId, String userId);

  /// Deletes a password.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [userId]            an id of password to be deleted.
  /// Return         Future that receives null for success.
  Future deletePassword(String correlationId, String userId);

  /// Authenticates a password.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [userId]            an id of password.
  /// - [password]            a password to be authenticated.
  /// Return         Future that receives bool value of the authentication result.
  Future<bool> authenticate(
      String correlationId, String userId, String password);

  /// Changes a password.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [userId]            an id of password.
  /// - [oldPassword]            an old password.
  /// - [newPassword]            a new password.
  /// Return         Future that receives null for success.
  Future changePassword(String correlationId, String userId, String oldPassword,
      String newPassword);

  /// Validates a code.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [userId]            an id of password.
  /// - [code]            a code to be validated.
  /// Return         Future that receives bool value of the validation result.
  Future<bool> validateCode(String correlationId, String userId, String code);

  /// Resets a password.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [userId]            an id of password.
  /// - [code]            a code.
  /// - [password]            a password.
  /// Return         Future that receives null for success.
  Future resetPassword(
      String correlationId, String userId, String code, String password);

  /// Recovers a password.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [userId]            an id of password.
  /// Return         Future that receives null for success.
  Future recoverPassword(String correlationId, String userId);
}
