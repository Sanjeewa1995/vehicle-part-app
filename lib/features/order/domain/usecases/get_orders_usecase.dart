import '../../domain/repositories/order_repository.dart';
import '../../data/models/order_list_response.dart';

class GetOrdersUseCase {
  final OrderRepository repository;

  GetOrdersUseCase(this.repository);

  Future<OrderListResponse> call({int page = 1, int pageSize = 20}) async {
    return await repository.getOrders(page: page, pageSize: pageSize);
  }
}

