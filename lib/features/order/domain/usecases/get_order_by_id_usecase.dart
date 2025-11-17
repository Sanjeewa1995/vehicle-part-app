import '../../domain/repositories/order_repository.dart';
import '../../data/models/order_detail_response.dart';

class GetOrderByIdUseCase {
  final OrderRepository repository;

  GetOrderByIdUseCase(this.repository);

  Future<OrderDetailResponse> call(int id) async {
    return await repository.getOrderById(id);
  }
}

