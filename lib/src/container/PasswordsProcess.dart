import 'package:pip_services3_container/pip_services3_container.dart';
import 'package:pip_services3_rpc/pip_services3_rpc.dart';

import '../build/PasswordsServiceFactory.dart';

class PasswordsProcess extends ProcessContainer {
  PasswordsProcess() : super('passwords', 'User passwords microservice') {
    factories.add(PasswordsServiceFactory());
    factories.add(DefaultRpcFactory());
  }
}
