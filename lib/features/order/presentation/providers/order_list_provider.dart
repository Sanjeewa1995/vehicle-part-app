import 'package:flutter/foundation.dart';
import '../../data/models/order_model.dart';
import '../../domain/usecases/get_orders_usecase.dart';

enum OrderListStatus { initial, loading, loaded, error }

class OrderListProvider extends ChangeNotifier {
  final GetOrdersUseCase getOrdersUseCase;

  OrderListProvider({required this.getOrdersUseCase});

  OrderListStatus _status = OrderListStatus.initial;
  List<OrderModel> _orders = [];
  String? _errorMessage;
  int _currentPage = 1;
  final int _pageSize = 20;
  bool _hasMore = true;

  OrderListStatus get status => _status;
  List<OrderModel> get orders => _orders;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == OrderListStatus.loading;
  bool get hasMore => _hasMore;

  Future<void> loadOrders({bool refresh = false}) async {
    try {
      if (refresh) {
        _currentPage = 1;
        _hasMore = true;
      }

      _status = OrderListStatus.loading;
      _errorMessage = null;
      notifyListeners();

      final result = await getOrdersUseCase(
        page: _currentPage,
        pageSize: _pageSize,
      );

      if (refresh) {
        _orders = result.data;
      } else {
        _orders.addAll(result.data);
      }

      // Check if there are more pages
      if (result.meta != null) {
        _hasMore = result.meta!.currentPage < result.meta!.totalPages;
        if (_hasMore) {
          _currentPage++;
        }
      } else {
        _hasMore = result.data.length >= _pageSize;
        if (_hasMore) {
          _currentPage++;
        }
      }

      _status = OrderListStatus.loaded;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _status = OrderListStatus.error;
      String errorMsg = e.toString();

      // Remove common prefixes
      errorMsg = errorMsg
          .replaceAll('Exception: ', '')
          .replaceAll('ServerException: ', '')
          .replaceAll('AuthenticationException: ', '')
          .replaceAll('NetworkException: ', '')
          .trim();

      _errorMessage = errorMsg.isEmpty ? 'Failed to load orders' : errorMsg;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await loadOrders(refresh: true);
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

