import 'package:flutter/foundation.dart';
import '../../domain/entities/store_product.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../../../core/utils/error_message_helper.dart';

enum ProductListStatus { initial, loading, loaded, error }

class ProductListProvider extends ChangeNotifier {
  final GetProductsUseCase getProductsUseCase;

  ProductListProvider({required this.getProductsUseCase});

  ProductListStatus _status = ProductListStatus.initial;
  List<StoreProduct> _products = [];
  String? _errorMessage;
  int _currentPage = 1;
  final int _pageSize = 10;
  bool _hasMore = true;

  ProductListStatus get status => _status;
  List<StoreProduct> get products => _products;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == ProductListStatus.loading;
  bool get hasMore => _hasMore;

  Future<void> loadProducts({bool refresh = false}) async {
    try {
      if (refresh) {
        _currentPage = 1;
        _hasMore = true;
      }

      _status = ProductListStatus.loading;
      _errorMessage = null;
      notifyListeners();

      final result = await getProductsUseCase(
        page: _currentPage,
        pageSize: _pageSize,
      );

      if (refresh) {
        _products = result;
      } else {
        _products.addAll(result);
      }

      // Check if there are more pages
      _hasMore = result.length >= _pageSize;
      if (_hasMore) {
        _currentPage++;
      }

      _status = ProductListStatus.loaded;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _status = ProductListStatus.error;
      final errorMsg = ErrorMessageHelper.getUserFriendlyMessage(e);
      _errorMessage = errorMsg.isEmpty ? 'Failed to load products' : errorMsg;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await loadProducts(refresh: true);
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}


