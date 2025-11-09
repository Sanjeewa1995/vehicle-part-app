import '../entities/vehicle_part_request.dart';
import '../../data/models/create_request_data.dart';

abstract class RequestRepository {
  Future<List<VehiclePartRequest>> getRequests({
    int page = 1,
    int pageSize = 10,
  });

  Future<VehiclePartRequest> getRequestById(int id);

  Future<VehiclePartRequest> createRequest(CreateRequestData data);

  Future<void> deleteRequest(int id);
}

