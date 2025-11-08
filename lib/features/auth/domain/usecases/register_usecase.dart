import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository authRepository;

  RegisterUseCase({required this.authRepository});

  Future<User> call({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    return await authRepository.register(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      password: password,
      confirmPassword: confirmPassword,
    );
  }
}

