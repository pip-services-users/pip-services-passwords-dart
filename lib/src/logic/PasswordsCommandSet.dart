import 'package:pip_services3_commons/pip_services3_commons.dart';
import './IPasswordsController.dart';

class PasswordsCommandSet extends CommandSet {
  IPasswordsController _logic;

  PasswordsCommandSet(IPasswordsController logic) : super() {
    _logic = logic;

    // Register commands to the database
    addCommand(_makeGetPasswordInfoCommand());
    addCommand(_makeSetPasswordCommand());
    addCommand(_makeSetTempPasswordCommand());
    addCommand(_makeDeletePasswordCommand());
    addCommand(_makeAuthenticateCommand());
    addCommand(_makeChangePasswordCommand());
    addCommand(_makeValidateCodeCommand());
    addCommand(_makeResetPasswordCommand());
    addCommand(_makeRecoverPasswordCommand());
  }

  // ICommand _makeGetAccountByIdCommand() {
  //   return Command('get_account_by_id',
  //       ObjectSchema(true).withRequiredProperty('account_id', TypeCode.String),
  //       (String correlationId, Parameters args) {
  //     var accountId = args.getAsString('account_id');
  //     return _controller.getAccountById(correlationId, accountId);
  //   });
  // }

  ICommand _makeGetPasswordInfoCommand() {
    return Command('get_password_info',
        ObjectSchema(true).withRequiredProperty('user_id', TypeCode.String),
        (String correlationId, Parameters args) {
      var userId = args.getAsNullableString('user_id');
      return _logic.getPasswordInfo(correlationId, userId);
    });
  }

  ICommand _makeSetPasswordCommand() {
    return Command(
        'set_password',
        ObjectSchema(true)
            .withRequiredProperty('user_id', TypeCode.String)
            .withRequiredProperty('password', TypeCode.String),
        (String correlationId, Parameters args) {
      var userId = args.getAsNullableString('user_id');
      var password = args.getAsNullableString('password');
      return _logic.setPassword(correlationId, userId, password);
    });
  }

  ICommand _makeSetTempPasswordCommand() {
    return Command('set_temp_password',
        ObjectSchema(true).withRequiredProperty('user_id', TypeCode.String),
        (String correlationId, Parameters args) {
      var userId = args.getAsNullableString('user_id');
      return _logic.setTempPassword(correlationId, userId);
    });
  }

  ICommand _makeDeletePasswordCommand() {
    return Command('delete_password',
        ObjectSchema(true).withRequiredProperty('user_id', TypeCode.String),
        (String correlationId, Parameters args) {
      var userId = args.getAsNullableString('user_id');
      return _logic.deletePassword(correlationId, userId);
    });
  }

  ICommand _makeAuthenticateCommand() {
    return Command(
        'authenticate',
        ObjectSchema(true)
            .withRequiredProperty('user_id', TypeCode.String)
            .withRequiredProperty('password', TypeCode.String),
        (String correlationId, Parameters args) {
      var userId = args.getAsNullableString('user_id');
      var password = args.getAsNullableString('password');
      return _logic.authenticate(correlationId, userId, password);
    });
  }

  ICommand _makeChangePasswordCommand() {
    return Command(
        'change_password',
        ObjectSchema(true)
            .withRequiredProperty('user_id', TypeCode.String)
            .withRequiredProperty('old_password', TypeCode.String)
            .withRequiredProperty('new_password', TypeCode.String),
        (String correlationId, Parameters args) {
      var userId = args.getAsNullableString('user_id');
      var oldPassword = args.getAsNullableString('old_password');
      var newPassword = args.getAsNullableString('new_password');
      return _logic.changePassword(
          correlationId, userId, oldPassword, newPassword);
    });
  }

  ICommand _makeValidateCodeCommand() {
    return Command(
        'validate_code',
        ObjectSchema(true)
            .withRequiredProperty('user_id', TypeCode.String)
            .withRequiredProperty('code', TypeCode.String),
        (String correlationId, Parameters args) {
      var userId = args.getAsNullableString('user_id');
      var code = args.getAsNullableString('code');
      return _logic.validateCode(correlationId, userId, code);
    });
  }

  ICommand _makeResetPasswordCommand() {
    return Command(
        'reset_password',
        ObjectSchema(true)
            .withRequiredProperty('user_id', TypeCode.String)
            .withRequiredProperty('code', TypeCode.String)
            .withRequiredProperty('password', TypeCode.String),
        (String correlationId, Parameters args) {
      var userId = args.getAsNullableString('user_id');
      var code = args.getAsNullableString('code');
      var password = args.getAsNullableString('password');
      return _logic.resetPassword(correlationId, userId, code, password);
    });
  }

  ICommand _makeRecoverPasswordCommand() {
    return Command('recover_password',
        ObjectSchema(true).withRequiredProperty('user_id', TypeCode.String),
        (String correlationId, Parameters args) {
      var userId = args.getAsNullableString('user_id');
      return _logic.recoverPassword(correlationId, userId);
    });
  }
}
