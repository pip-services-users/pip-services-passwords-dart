import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_components/pip_services3_components.dart';
import 'package:pip_clients_activities/pip_clients_activities.dart';

import '../../src/data/version1/UserPasswordInfoV1.dart';
import '../../src/data/version1/UserPasswordV1.dart';
import '../../src/persistence/IPasswordsPersistence.dart';
import './IPasswordsController.dart';
import './ActivitiesConnector.dart';
import './MessageConnector.dart';
import './PasswordsCommandSet.dart';

class PasswordsController
    implements
        IPasswordsController,
        IConfigurable,
        IReferenceable,
        ICommandable {
  static final ConfigParams _defaultConfig = ConfigParams.fromTuples([
    'dependencies.persistence', 'pip-services-passwords:persistence:*:*:1.0',
    'dependencies.activities', 'pip-services-activities:client:*:*:1.0',
    'dependencies.msgdistribution',
    'pip-services-msgdistribution:client:*:*:1.0',

    'message_templates.account_locked.subject', 'Account was locked',
    'message_templates.account_locked.text',
    '{{name}} account was locked for 30 minutes after several failed signin attempts.',
    'message_templates.password_changed.subject', 'Password was changed',
    'message_templates.password_changed.text', '{{name}} password was changed.',
    'message_templates.recover_password.subject', 'Reset password',
    'message_templates.recover_password.text',
    '{{name}} password reset code is {{code}}',

    'options.lock_timeout', 1800000, // 30 mins
    'options.attempt_timeout', 60000, // 1 min
    'options.attempt_count', 4, // 4 times
    'options.rec_expire_timeout', 24 * 3600000, // 24 hours
    'options.lock_enabled', false, // set to TRUE to enable locking logic
    'options.magic_code', null // Universal code
  ]);

  DependencyResolver dependencyResolver =
      DependencyResolver(PasswordsController._defaultConfig);
  //MessageResolverV1 _messageResolver = MessageResolverV1();
  final CompositeLogger _logger = CompositeLogger();
  IPasswordsPersistence _persistence;
  IActivitiesClientV1 _activitiesClient;
  ActivitiesConnector _activitiesConnector;
  //IMessageDistributionClientV1 _messageDistributionClient;
  MessageConnector _messageConnector;
  PasswordsCommandSet commandSet;

  num _lockTimeout = 1800000; // 30 mins
  num _attemptTimeout = 60000; // 1 min
  num _attemptCount = 4; // 4 times
  num _recExpireTimeout = 24 * 3600000; // 24 hours
  bool _lockEnabled = false;
  String _magicCode;

  /// Configures component by passing configuration parameters.
  ///
  /// - [config]    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    config = config.setDefaults(PasswordsController._defaultConfig);
    dependencyResolver.configure(config);
    //_messageResolver.configure(config);

    _lockTimeout =
        config.getAsIntegerWithDefault('options.lock_timeout', _lockTimeout);
    _attemptTimeout = config.getAsIntegerWithDefault(
        'options.attempt_timeout', _attemptTimeout);
    _attemptCount =
        config.getAsIntegerWithDefault('options.attempt_count', _attemptCount);
    _recExpireTimeout = config.getAsIntegerWithDefault(
        'options.rec_expire_timeout', _recExpireTimeout);
    _lockEnabled =
        config.getAsBooleanWithDefault('options.lock_enabled', _lockEnabled);
    _magicCode =
        config.getAsStringWithDefault('options.magic_code', _magicCode);
  }

  /// Set references to component.
  ///
  /// - [references]    references parameters to be set.
  @override
  void setReferences(IReferences references) {
    _logger.setReferences(references);
    dependencyResolver.setReferences(references);
    _persistence =
        dependencyResolver.getOneRequired<IPasswordsPersistence>('persistence');
    _activitiesClient =
        dependencyResolver.getOneOptional<IActivitiesClientV1>('activities');
    //_messageDistributionClient = _dependencyResolver.getOneOptional<IMessageDistributionClientV1>('msgdistribution');

    _activitiesConnector = ActivitiesConnector(_logger, _activitiesClient);
    //_messageConnector = MessageConnector(_logger, _messageResolver, _messageDistributionClient);
  }

  /// Gets a command set.
  ///
  /// Return Command set
  @override
  CommandSet getCommandSet() {
    commandSet ??= PasswordsCommandSet(this);
    return commandSet;
  }

  String _generateVerificationCode() {
    return IdGenerator.nextShort();
  }

  String _hashPassword(String password) {
    if (password == null) return null;

    var pass = utf8.encode(password);
    var digest = sha256.convert(pass);

    return digest.toString();
  }

  bool _verifyPassword(String correlationId, String password) {
    if (password == null) {
      var err = BadRequestException(
          correlationId, 'NO_PASSWORD', 'Missing user password');
      _logger.trace(correlationId, 'Password is null %s', [err]);
      return false;
    }

    if (password.length < 6 || password.length > 20) {
      var err = BadRequestException(correlationId, 'BAD_PASSWORD',
          'User password should be 5 to 20 symbols long');
      _logger.trace(correlationId, 'Password is not valid %s', [err]);
      return false;
    }
    return true;
  }

  Future<UserPasswordV1> _readUserPassword(
      String correlationId, String userId) async {
    var item = await _persistence.getOneById(correlationId, userId);
    var err;
    if (item == null) {
      err = NotFoundException(correlationId, 'USER_NOT_FOUND',
              'User ' + userId + ' was not found')
          .withDetails('user_id', userId);
    }

    _logger.trace(correlationId, 'Could not read user password %s', [err]);
    return item;
  }

  /// Validate a password.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [password]            a password to be validated.
  /// Return         Future that receives null for success.
  @override
  Future validatePassword(String correlationId, String password) async {
    if (_verifyPassword(correlationId, password)) {
      return;
    }

    return null;
  }

  /// Gets a password infomation.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [userId]            an id of password to be retrieved.
  /// Return         Future that receives a password info.
  /// Throws error.
  @override
  Future<UserPasswordInfoV1> getPasswordInfo(
      String correlationId, String userId) async {
    var data = await _persistence.getOneById(correlationId, userId);
    if (data != null) {
      var info = UserPasswordInfoV1(
          id: data.id,
          change_time: data.change_time,
          locked: data.locked,
          lock_time: data.lock_time);
      return info;
    } else {
      return null;
    }
  }

  /// Sets a password.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [userId]            an id of password to be set.
  /// - [password]            a password to be set.
  /// Return         Future that receives null for success.
  @override
  Future setPassword(
      String correlationId, String userId, String password) async {
    var passwordHash = _hashPassword(password);

    var userPassword = UserPasswordV1(id: userId, password: passwordHash);
    await _persistence.create(correlationId, userPassword);
  }

  /// Sets a temporary password.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [userId]            an id of password to be set.
  /// Return         Future that receives string temp password.
  @override
  Future<String> setTempPassword(String correlationId, String userId) async {
    // Todo: Improve password generation
    var _random = Random();
    var password =
        'pass' + (1000 * _random.nextDouble() * 9000).floor().toString();
    var passwordHash = _hashPassword(password);

    var userPassword = UserPasswordV1(id: userId, password: passwordHash);
    userPassword.change_time = DateTime.now().toUtc();

    await _persistence.create(correlationId, userPassword);
    return password;
  }

  /// Deletes a password.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [userId]            an id of password to be deleted.
  /// Return         Future that receives null for success.
  @override
  Future deletePassword(String correlationId, String userId) async {
    await _persistence.deleteById(correlationId, userId);
  }

  /// Authenticates a password.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [userId]            an id of password.
  /// - [password]            a password to be authenticated.
  /// Return         Future that receives bool value of the authentication result.
  @override
  Future<bool> authenticate(
      String correlationId, String userId, String password) async {
    var hashedPassword = _hashPassword(password);
    var currentTime = DateTime.now();
    UserPasswordV1 userPassword;
    var err;

    // Retrieve user password
    userPassword = await _readUserPassword(correlationId, userId);
    if (userPassword == null) {
      err = BadRequestException(correlationId, 'NO_USER_PASSWORD',
              'User password  ' + userId + ' null')
          .withDetails('user_id', userId);
      _logger.trace(correlationId, 'No user password %s', [err]);
      return false;
    }

    // Check password and process failed attempts
    var passwordMatch = userPassword.password == hashedPassword;
    var lastFailureTimeout = userPassword.fail_time != null
        ? currentTime.millisecondsSinceEpoch -
            userPassword.fail_time.millisecondsSinceEpoch
        : 0;

    //verify user account is still locked from last authorization failure or just tell user that it's user is locked
    if (!_lockEnabled && passwordMatch) {
      userPassword.locked = false;
    } else {
      if (passwordMatch &&
          userPassword.locked &&
          lastFailureTimeout > _lockTimeout) {
        userPassword.locked = false; //unlock user
      } else if (userPassword.locked) {
        err = BadRequestException(correlationId, 'ACCOUNT_LOCKED',
                'Account for user ' + userId + ' is locked')
            .withDetails('user_id', userId);
        _logger.trace(correlationId, 'Account locked %s', [err]);
      }

      if (!passwordMatch) {
        if (lastFailureTimeout < _attemptTimeout) {
          userPassword.fail_count =
              userPassword.fail_count != null ? userPassword.fail_count + 1 : 1;
        }

        userPassword.fail_time = currentTime;

        if (userPassword.fail_count >= _attemptCount) {
          userPassword.locked = true;
          // _messageConnector.sendAccountLockedEmail(correlationId, userId);
          err = BadRequestException(
                  correlationId,
                  'ACCOUNT_LOCKED',
                  'Number of attempts exceeded. Account for user ' +
                      userId +
                      ' was locked')
              .withDetails('user_id', userId);
          _logger.trace(correlationId, 'Account locked %s', [err]);
        } else {
          err = BadRequestException(
                  correlationId, 'WRONG_PASSWORD', 'Invalid password')
              .withDetails('user_id', userId);
          _logger.trace(correlationId, 'Wrong password %s', [err]);
        }

        var pass = await _persistence.update(correlationId, userPassword);
        if (pass == null) {
          _logger.error(correlationId, Exception('Could not update password'),
              'Failed to save user password');
        }
      }
    }

    // Perform authentication and save user
    // Update user last signin date
    userPassword.fail_count = 0;
    userPassword.fail_time = null;

    await _persistence.update(correlationId, userPassword);
    // Asynchronous post-processing
    _activitiesConnector.logSigninActivity(correlationId, userId);
    if (err != null) {
      return false;
    } else {
      return userPassword != null;
    }
  }

  /// Changes a password.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [userId]            an id of password.
  /// - [oldPassword]            an old password.
  /// - [newPassword]            a new password.
  /// Return         Future that receives null for success.
  @override
  Future changePassword(String correlationId, String userId, String oldPassword,
      String newPassword) async {
    UserPasswordV1 userPassword;
    var err;

    if (!_verifyPassword(correlationId, newPassword)) {
      return;
    }

    oldPassword = _hashPassword(oldPassword);
    newPassword = _hashPassword(newPassword);

    userPassword = await _readUserPassword(correlationId, userId);
    if (userPassword == null) {
      err = BadRequestException(correlationId, 'NO_USER_PASSWORD',
              'User password  ' + userId + ' null')
          .withDetails('user_id', userId);
      _logger.trace(correlationId, 'No user password %s', [err]);
      return;
    }
    // Verify and reset password
    // Password must be different then the previous one
    if (userPassword.password != oldPassword) {
      err = BadRequestException(
              correlationId, 'WRONG_PASSWORD', 'Invalid password')
          .withDetails('user_id', userId);
      _logger.trace(correlationId, 'Wrong password %s', [err]);
    }

    if (oldPassword == newPassword) {
      err = BadRequestException(correlationId, 'PASSWORD_NOT_CHANGED',
              'Old and new passwords are identical')
          .withDetails('user_id', userId);
      _logger.trace(correlationId, 'Wrong password %s', [err]);
    }

    // Reset password
    userPassword.password = newPassword;
    userPassword.rec_code = null;
    userPassword.rec_expire_time = null;
    userPassword.locked = false;
    // Todo: Add change password policy
    userPassword.change_time = null;

    // Save the new password
    await _persistence.update(correlationId, userPassword);
    // Asynchronous post-processing
    _activitiesConnector.logPasswordChangedActivity(correlationId, userId);
    // _messageConnector.sendPasswordChangedEmail(correlationId, userId);
  }

  /// Validates a code.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [userId]            an id of password.
  /// - [code]            a code to be validated.
  /// Return         Future that receives bool value of the validation result.
  @override
  Future<bool> validateCode(
      String correlationId, String userId, String code) async {
    var data = await _readUserPassword(correlationId, userId);
    if (data != null) {
      var valid = code == _magicCode ||
          (data.rec_code == code &&
              data.rec_expire_time.millisecondsSinceEpoch >
                  DateTime.now().millisecondsSinceEpoch);
      return valid;
    } else {
      return false;
    }
  }

  /// Resets a password.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [userId]            an id of password.
  /// - [code]            a code.
  /// - [password]            a password.
  /// Return         Future that receives null for success.
  @override
  Future resetPassword(
      String correlationId, String userId, String code, String password) async {
    UserPasswordV1 userPassword;
    var err;

    if (!_verifyPassword(correlationId, password)) {
      return;
    }

    var passwordHash = _hashPassword(password);

    userPassword = await _readUserPassword(correlationId, userId);
    if (userPassword == null) {
      err = BadRequestException(correlationId, 'NO_USER_PASSWORD',
              'User password  ' + userId + ' null')
          .withDetails('user_id', userId);
      _logger.trace(correlationId, 'No user password %s', [err]);
      return;
    }
    // Validate reset code and reset the password
    if (userPassword.rec_code != code && code != _magicCode) {
      err = BadRequestException(correlationId, 'WRONG_CODE',
              'Invalid password recovery code ' + code)
          .withDetails('user_id', userId);
      _logger.trace(correlationId, 'Wrong code %s', [err]);
    }

    // Check if code already expired
    if (!(userPassword.rec_expire_time.millisecondsSinceEpoch >
            DateTime.now().millisecondsSinceEpoch) &&
        code != _magicCode) {
      err = BadRequestException(correlationId, 'CODE_EXPIRED',
              'Password recovery code ' + code + ' expired')
          .withDetails('user_id', userId);
      _logger.trace(correlationId, 'Wrong code %s', [err]);
    }

    // Reset password
    userPassword.password = passwordHash;
    userPassword.rec_code = null;
    userPassword.rec_expire_time = null;
    userPassword.locked = false;
    // Todo: Add change password policy
    userPassword.change_time = null;

    // Save the new password
    await _persistence.update(correlationId, userPassword);
    // Asynchronous post-processing
    _activitiesConnector.logPasswordChangedActivity(correlationId, userId);
    // _messageConnector.sendPasswordChangedEmail(correlationId, userId);
  }

  /// Recovers a password.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [userId]            an id of password.
  /// Return         Future that receives null for success.
  @override
  Future recoverPassword(String correlationId, String userId) async {
    UserPasswordV1 userPassword;

    userPassword = await _readUserPassword(correlationId, userId);
    if (userPassword == null) {
      var err = BadRequestException(correlationId, 'NO_USER_PASSWORD',
              'User password  ' + userId + ' null')
          .withDetails('user_id', userId);
      _logger.trace(correlationId, 'No user password %s', [err]);
      return;
    }
    // Update and save recovery code
    var currentTicks = DateTime.now().millisecondsSinceEpoch;
    var expireTicks = currentTicks + _recExpireTimeout;
    var expireTime = DateTime.fromMillisecondsSinceEpoch(expireTicks);

    userPassword.rec_code = _generateVerificationCode();
    userPassword.rec_expire_time = expireTime;

    // Save the new password
    await _persistence.update(correlationId, userPassword);
    // Asynchronous post-processing
    _activitiesConnector.logPasswordRecoveredActivity(correlationId, userId);
    // _messageConnector.sendRecoverPasswordEmail(
    //     correlationId, userId, userPassword.rec_code);
  }
}
