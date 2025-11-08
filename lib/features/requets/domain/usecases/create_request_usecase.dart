import '../entities/vehicle_part_request.dart';
import '../repositories/request_repository.dart';
import '../../data/models/create_request_data.dart';

class CreateRequestUseCase {
  final RequestRepository repository;

  CreateRequestUseCase(this.repository);

  Future<VehiclePartRequest> call(CreateRequestData data) async {
    return await repository.createRequest(data);
  }
}

