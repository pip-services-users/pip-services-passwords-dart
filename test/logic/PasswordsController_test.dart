import 'package:pip_clients_msgdistribution/pip_clients_msgdistribution.dart';
import 'package:pip_services3_components/pip_services3_components.dart';
import 'package:pip_services_passwords/pip_services_passwords.dart';
import 'package:test/test.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';

final USER_PWD = UserPasswordV1(id: '1', password: 'password123');

void main() {
  group('PasswordsController', () {
    PasswordsMemoryPersistence persistence;
    PasswordsController controller;

    setUp(() async {
      persistence = PasswordsMemoryPersistence();
      persistence.configure(ConfigParams());

      controller = PasswordsController();
      controller.configure(ConfigParams());

      var logger = ConsoleLogger();

      var references = References.fromTuples([
        Descriptor('pip-services', 'logger', 'console', 'default', '1.0'),
        logger,
        Descriptor('pip-services-passwords', 'persistence', 'memory', 'default',
            '1.0'),
        persistence,
        Descriptor('pip-services-passwords', 'controller', 'default', 'default',
            '1.0'),
        controller,
        Descriptor(
            'pip-services-msgdistribution', 'client', 'null', 'default', '1.0'),
        MessageDistributionNullClientV1()
      ]);

      controller.setReferences(references);

      await persistence.open(null);
    });

    tearDown(() async {
      await persistence.close(null);
    });

    test('Recover Password', () async {
      UserPasswordV1 userPassword1;

      // Create a new user
      await controller.setPassword(null, USER_PWD.id, USER_PWD.password);

      // Verify
      var password = await persistence.getOneById(null, USER_PWD.id);
      expect(password, isNotNull);
      expect(password.id, USER_PWD.id);
      expect(password.rec_code, isNull);

      // Recover password
      await controller.recoverPassword(null, USER_PWD.id);

      // Verify
      password = await persistence.getOneById(null, USER_PWD.id);
      expect(password, isNotNull);
      expect(password.id, USER_PWD.id);
      expect(password.rec_code, isNotNull);
      expect(password.rec_expire_time, isNotNull);

      userPassword1 = password;

      // Validate code
      var valid = await controller.validateCode(
          null, userPassword1.id, userPassword1.rec_code);
      expect(valid, isTrue);
    });

    test('Change Password', () async {
      // Sign up
      await controller.setPassword(null, USER_PWD.id, USER_PWD.password);

      // Change password
      await controller.changePassword(
          null, USER_PWD.id, USER_PWD.password, 'xxx123');

      // Sign in with new password
      var authenticated =
          await controller.authenticate(null, USER_PWD.id, 'xxx123');
      expect(authenticated, isTrue);
    });

    test('Fail to Signin with Wrong Password', () async {
      // Sign up
      await controller.setPassword(null, USER_PWD.id, USER_PWD.password);

      // Sign in with wrong password
      var authenticated =
          await controller.authenticate(null, USER_PWD.id, 'xxx');
      expect(authenticated, isFalse);
    });

    test('Set Temp Password', () async {
      // Create a new user
      var password = await controller.setTempPassword(null, USER_PWD.id);
      expect(password, isNotNull);

      // Verify
      var info = await controller.getPasswordInfo(null, USER_PWD.id);
      expect(info, isNotNull);
      expect(info.id, USER_PWD.id);
      expect(info.change_time, isNotNull);
    });
  });
}
