import 'package:test/test.dart';
import 'package:pip_services_passwords/pip_services_passwords.dart';

final USER_PWD = UserPasswordV1(id: '1', password: 'password123');

class PasswordsPersistenceFixture {
  IPasswordsPersistence _persistence;

  PasswordsPersistenceFixture(IPasswordsPersistence persistence) {
    expect(persistence, isNotNull);
    _persistence = persistence;
  }

  void testCrudOperations() async {
    UserPasswordV1 password1;

    // Create item
    var userPassword = await _persistence.create(null, USER_PWD);

    expect(userPassword, isNotNull);
    expect(USER_PWD.id, userPassword.id);
    expect(userPassword.password, isNotNull);
    expect(userPassword.locked, isFalse);

    password1 = userPassword;

    // Update the password
    password1.password = 'newpwd123';
    password1.rec_code = '123';
    password1.rec_expire_time = DateTime.now().toUtc();

    userPassword = await _persistence.update(null, password1);
    expect(userPassword, isNotNull);
    expect(password1.id, userPassword.id);
    expect(userPassword.password, password1.password);
    expect(userPassword.locked, isFalse);

    // Get user password by id
    userPassword = await _persistence.getOneById(null, USER_PWD.id);
    expect(userPassword, isNotNull);
    expect(USER_PWD.id, userPassword.id);
    expect(userPassword.password, 'newpwd123');
    expect(userPassword.locked, isFalse);

    // Delete the password
    userPassword = await _persistence.deleteById(null, password1.id);
    expect(userPassword, isNotNull);
    expect(password1.id, userPassword.id);

    // Try to get deleted password
    userPassword = await _persistence.getOneById(null, password1.id);
    expect(userPassword, isNull);
  }
}
