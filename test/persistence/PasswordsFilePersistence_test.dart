import 'package:test/test.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';

import 'package:pip_services_passwords/pip_services_passwords.dart';
import './PasswordsPersistenceFixture.dart';

void main() {
  group('PasswordsFilePersistence', () {
    PasswordsFilePersistence persistence;
    PasswordsPersistenceFixture fixture;

    setUp(() async {
      persistence = PasswordsFilePersistence('data/passwords.test.json');
      persistence.configure(ConfigParams());

      fixture = PasswordsPersistenceFixture(persistence);

      await persistence.open(null);
      await persistence.clear(null);
    });

    tearDown(() async {
      await persistence.close(null);
    });

    test('CRUD Operations', () async {
      await fixture.testCrudOperations();
    });
  });
}
