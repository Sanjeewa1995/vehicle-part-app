import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<User> call(String phone, String password) async {
    if (phone.isEmpty) {
      throw Exception('Phone number is required');
    }
    if (password.isEmpty) {
      throw Exception('Password is required');
    }
    return await repository.login(phone, password);
  }
}

