import '../entities/store_product.dart';

abstract class ProductRepository {
  Future<List<StoreProduct>> getProducts({
    int page = 1,
    int pageSize = 10,
  });
}


