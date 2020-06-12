import 'package:pip_services3_mongodb/pip_services3_mongodb.dart';

import '../data/version1/UserPasswordV1.dart';
import './IPasswordsPersistence.dart';

class PasswordsMongoDbPersistence
    extends IdentifiableMongoDbPersistence<UserPasswordV1, String>
    implements IPasswordsPersistence {
  PasswordsMongoDbPersistence() : super('passwords');
}
