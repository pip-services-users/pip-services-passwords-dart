import 'package:test/test.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';

import 'package:pip_services_passwords/pip_services_passwords.dart';
import './PasswordsPersistenceFixture.dart';

void main() {
  group('PasswordsMemoryPersistence', () {
    PasswordsMemoryPersistence persistence;
    PasswordsPersistenceFixture fixture;

    setUp(() async {
      persistence = PasswordsMemoryPersistence();
      persistence.configure(ConfigParams());

      fixture = PasswordsPersistenceFixture(persistence);

      await persistence.open(null);
    });

    tearDown(() async {
      await persistence.close(null);
    });

    test('CRUD Operations', () async {
      await fixture.testCrudOperations();
    });
  });
}
