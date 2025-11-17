import '../../domain/repositories/request_repository.dart';
import '../../data/models/request_stats_response.dart';

class GetRequestStatsUseCase {
  final RequestRepository repository;

  GetRequestStatsUseCase(this.repository);

  Future<RequestStatsResponse> call() async {
    return await repository.getStats();
  }
}

