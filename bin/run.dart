import 'package:pip_services_passwords/pip_services_passwords.dart';

void main(List<String> argument) {
  try {
    var proc = PasswordsProcess();
    proc.configPath = './config/config.yml';
    proc.run(argument);
  } catch (ex) {
    print(ex);
  }
}
