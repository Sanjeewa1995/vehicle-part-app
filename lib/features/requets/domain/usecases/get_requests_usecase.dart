import '../entities/vehicle_part_request.dart';
import '../repositories/request_repository.dart';

class GetRequestsUseCase {
  final RequestRepository repository;

  GetRequestsUseCase(this.repository);

  Future<List<VehiclePartRequest>> call({
    int page = 1,
    int pageSize = 10,
  }) async {
    return await repository.getRequests(
      page: page,
      pageSize: pageSize,
    );
  }
}

