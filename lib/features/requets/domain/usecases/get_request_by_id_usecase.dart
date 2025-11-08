import '../entities/vehicle_part_request.dart';
import '../repositories/request_repository.dart';

class GetRequestByIdUseCase {
  final RequestRepository repository;

  GetRequestByIdUseCase(this.repository);

  Future<VehiclePartRequest> call(int id) async {
    return await repository.getRequestById(id);
  }
}

