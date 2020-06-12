import 'package:pip_services3_data/pip_services3_data.dart';
import '../data/version1/UserPasswordV1.dart';
import './IPasswordsPersistence.dart';

class PasswordsMemoryPersistence
    extends IdentifiableMemoryPersistence<UserPasswordV1, String>
    implements IPasswordsPersistence {
  PasswordsMemoryPersistence() : super();
}
