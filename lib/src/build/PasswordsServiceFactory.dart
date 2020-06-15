import 'package:pip_services3_components/pip_services3_components.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';

import '../persistence/PasswordsMemoryPersistence.dart';
import '../persistence/PasswordsFilePersistence.dart';
import '../persistence/PasswordsMongoDbPersistence.dart';
import '../logic/PasswordsController.dart';
import '../services/version1/PasswordsHttpServiceV1.dart';

class PasswordsServiceFactory extends Factory {
  static final MemoryPersistenceDescriptor =
      Descriptor('pip-services-passwords', 'persistence', 'memory', '*', '1.0');
  static final FilePersistenceDescriptor =
      Descriptor('pip-services-passwords', 'persistence', 'file', '*', '1.0');
  static final MongoDbPersistenceDescriptor = Descriptor(
      'pip-services-passwords', 'persistence', 'mongodb', '*', '1.0');
  static final ControllerDescriptor =
      Descriptor('pip-services-passwords', 'controller', 'default', '*', '1.0');
  static final HttpServiceDescriptor =
      Descriptor('pip-services-passwords', 'service', 'http', '*', '1.0');

  PasswordsServiceFactory() : super() {
    registerAsType(PasswordsServiceFactory.MemoryPersistenceDescriptor,
        PasswordsMemoryPersistence);
    registerAsType(PasswordsServiceFactory.FilePersistenceDescriptor,
        PasswordsFilePersistence);
    registerAsType(PasswordsServiceFactory.MongoDbPersistenceDescriptor,
        PasswordsMongoDbPersistence);
    registerAsType(
        PasswordsServiceFactory.ControllerDescriptor, PasswordsController);
    registerAsType(
        PasswordsServiceFactory.HttpServiceDescriptor, PasswordsHttpServiceV1);
  }
}
