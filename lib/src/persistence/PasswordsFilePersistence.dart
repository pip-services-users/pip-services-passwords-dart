import 'package:pip_services3_data/pip_services3_data.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../data/version1/UserPasswordV1.dart';
import './PasswordsMemoryPersistence.dart';

class PasswordsFilePersistence extends PasswordsMemoryPersistence {
  JsonFilePersister<UserPasswordV1> persister;

  PasswordsFilePersistence([String path]) : super() {
    persister = JsonFilePersister<UserPasswordV1>(path);
    loader = persister;
    saver = persister;
  }
  @override
  void configure(ConfigParams config) {
    super.configure(config);
    persister.configure(config);
  }
}
