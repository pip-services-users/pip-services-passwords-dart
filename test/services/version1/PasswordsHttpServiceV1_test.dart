import 'dart:convert';
import 'package:pip_services_passwords/pip_services_passwords.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:pip_services3_commons/pip_services3_commons.dart';

final USER_PWD = UserPasswordV1(id: '1', password: 'password123');

var httpConfig = ConfigParams.fromTuples([
  'connection.protocol',
  'http',
  'connection.host',
  'localhost',
  'connection.port',
  3000
]);

void main() {
  group('PasswordsHttpServiceV1', () {
    PasswordsMemoryPersistence persistence;
    PasswordsController controller;
    PasswordsHttpServiceV1 service;
    http.Client rest;
    String url;

    setUp(() async {
      url = 'http://localhost:3000';
      rest = http.Client();

      persistence = PasswordsMemoryPersistence();
      persistence.configure(ConfigParams());

      controller = PasswordsController();
      controller.configure(ConfigParams());

      service = PasswordsHttpServiceV1();
      service.configure(httpConfig);

      var references = References.fromTuples([
        Descriptor('pip-services-passwords', 'persistence', 'memory', 'default',
            '1.0'),
        persistence,
        Descriptor('pip-services-passwords', 'controller', 'default', 'default',
            '1.0'),
        controller,
        Descriptor(
            'pip-services-passwords', 'service', 'http', 'default', '1.0'),
        service
      ]);

      controller.setReferences(references);
      service.setReferences(references);

      await persistence.open(null);
      await service.open(null);
    });

    tearDown(() async {
      await service.close(null);
      await persistence.close(null);
    });

    test('Basic Operations', () async {
      // Create password
      var resp = await rest.post(url + '/v1/passwords/set_password',
          headers: {'Content-Type': 'application/json'},
          body: json
              .encode({'user_id': USER_PWD.id, 'password': USER_PWD.password}));
      expect(resp, isNotNull);
      expect(resp.statusCode ~/ 100, 2);

      // Authenticate user
      resp = await rest.post(url + '/v1/passwords/authenticate',
          headers: {'Content-Type': 'application/json'},
          body: json
              .encode({'user_id': USER_PWD.id, 'password': USER_PWD.password}));
      var authenticated = json.decode(resp.body);
      expect(authenticated, isNotNull);
      expect(authenticated, isTrue);

      // Change password
      resp = await rest.post(url + '/v1/passwords/change_password',
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'user_id': USER_PWD.id,
            'old_password': USER_PWD.password,
            'new_password': 'newpwd123'
          }));
      expect(resp, isNotNull);
      expect(resp.statusCode ~/ 100, 2);

      // Authenticate user
      resp = await rest.post(url + '/v1/passwords/authenticate',
          headers: {'Content-Type': 'application/json'},
          body: json
              .encode({'user_id': USER_PWD.id, 'password': USER_PWD.password}));
      authenticated = json.decode(resp.body);
      expect(authenticated, isNotNull);
      expect(authenticated, isFalse);

      // Delete password
      resp = await rest.post(url + '/v1/passwords/delete_password',
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'user_id': USER_PWD.id}));
      expect(resp, isNotNull);
      expect(resp.statusCode ~/ 100, 2);

      // Authenticate user again
      resp = await rest.post(url + '/v1/passwords/authenticate',
          headers: {'Content-Type': 'application/json'},
          body: json
              .encode({'user_id': USER_PWD.id, 'password': USER_PWD.password}));
      expect(authenticated, isNotNull);
      expect(authenticated, isFalse);
    });
  });
}
