import '../repositories/request_repository.dart';

class DeleteRequestUseCase {
  final RequestRepository repository;

  DeleteRequestUseCase(this.repository);

  Future<void> call(int id) async {
    return await repository.deleteRequest(id);
  }
}

