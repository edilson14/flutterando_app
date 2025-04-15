import 'package:result_command/result_command.dart';
import '../../../data/repositories/auth_repository.dart';

class LoginViewmodel {
  final AuthRepository _authRepository;

  LoginViewmodel(this._authRepository);

  late final loginCommand = Command1(_authRepository.login);
}
