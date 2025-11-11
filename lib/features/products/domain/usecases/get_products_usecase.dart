import '../entities/store_product.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<List<StoreProduct>> call({
    int page = 1,
    int pageSize = 10,
  }) async {
    return await repository.getProducts(
      page: page,
      pageSize: pageSize,
    );
  }
}


