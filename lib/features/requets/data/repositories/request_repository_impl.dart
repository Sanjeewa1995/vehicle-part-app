import '../../domain/entities/vehicle_part_request.dart';
import '../../domain/repositories/request_repository.dart';
import '../datasources/remote/request_remote_datasource.dart';
import '../models/create_request_data.dart';
import '../models/request_stats_response.dart';
import '../../../../core/utils/error_message_helper.dart';

class RequestRepositoryImpl implements RequestRepository {
  final RequestRemoteDataSource remoteDataSource;

  RequestRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<VehiclePartRequest>> getRequests({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await remoteDataSource.getRequests(
        page: page,
        pageSize: pageSize,
      );

      if (response.success) {
        return response.data;
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      // Convert to user-friendly message
      final errorMessage = ErrorMessageHelper.getUserFriendlyMessage(e);
      throw Exception(errorMessage.isEmpty ? 'Failed to load requests' : errorMessage);
    }
  }

  @override
  Future<VehiclePartRequest> getRequestById(int id) async {
    try {
      final response = await remoteDataSource.getRequestById(id);

      if (response.success) {
        return response.data;
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      // Convert to user-friendly message
      final errorMessage = ErrorMessageHelper.getUserFriendlyMessage(e);
      throw Exception(errorMessage.isEmpty ? 'Failed to load request' : errorMessage);
    }
  }

  @override
  Future<VehiclePartRequest> createRequest(CreateRequestData data) async {
    try {
      final response = await remoteDataSource.createRequest(data);

      if (response.success) {
        return response.data;
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      // Convert to user-friendly message
      final errorMessage = ErrorMessageHelper.getUserFriendlyMessage(e);
      throw Exception(errorMessage.isEmpty ? 'Failed to create request' : errorMessage);
    }
  }

  @override
  Future<void> deleteRequest(int id) async {
    try {
      await remoteDataSource.deleteRequest(id);
    } catch (e) {
      // Convert to user-friendly message
      final errorMessage = ErrorMessageHelper.getUserFriendlyMessage(e);
      throw Exception(errorMessage.isEmpty ? 'Failed to delete request' : errorMessage);
    }
  }

  @override
  Future<RequestStatsResponse> getStats() async {
    try {
      return await remoteDataSource.getStats();
    } catch (e) {
      // Convert to user-friendly message
      final errorMessage = ErrorMessageHelper.getUserFriendlyMessage(e);
      throw Exception(errorMessage.isEmpty ? 'Failed to load stats' : errorMessage);
    }
  }
}

