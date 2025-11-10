import '../../domain/entities/store_product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/remote/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<StoreProduct>> getProducts({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await remoteDataSource.getProducts(
        page: page,
        pageSize: pageSize,
      );

      if (response.success && response.data.success) {
        return response.data.data;
      } else {
        throw Exception(response.data.message);
      }
    } catch (e) {
      // Extract clean error message
      String errorMessage;

      if (e is Exception) {
        errorMessage = e.toString()
            .replaceAll('Exception: ', '')
            .replaceAll('ServerException: ', '')
            .replaceAll('AuthenticationException: ', '')
            .replaceAll('NetworkException: ', '')
            .trim();
      } else {
        errorMessage = e.toString();
      }

      throw Exception(errorMessage.isEmpty ? 'Failed to load products' : errorMessage);
    }
  }
}

