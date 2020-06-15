import 'package:pip_services3_rpc/pip_services3_rpc.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';

class PasswordsHttpServiceV1 extends CommandableHttpService {
  PasswordsHttpServiceV1() : super('v1/passwords') {
    dependencyResolver.put('controller',
        Descriptor('pip-services-passwords', 'controller', '*', '*', '1.0'));
  }
}
