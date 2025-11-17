import 'package:flutter/foundation.dart';
import '../../data/models/order_detail_response.dart';
import '../../domain/usecases/get_order_by_id_usecase.dart';

enum OrderDetailStatus { initial, loading, loaded, error }

class OrderDetailProvider extends ChangeNotifier {
  final GetOrderByIdUseCase getOrderByIdUseCase;

  OrderDetailProvider({required this.getOrderByIdUseCase});

  OrderDetailStatus _status = OrderDetailStatus.initial;
  OrderDetailData? _order;
  String? _errorMessage;

  OrderDetailStatus get status => _status;
  OrderDetailData? get order => _order;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == OrderDetailStatus.loading;
  bool get hasError => _status == OrderDetailStatus.error;

  Future<void> loadOrder(int id) async {
    try {
      _status = OrderDetailStatus.loading;
      _errorMessage = null;
      notifyListeners();

      final response = await getOrderByIdUseCase(id);
      
      if (response.success) {
        _order = response.data;
        _status = OrderDetailStatus.loaded;
        _errorMessage = null;
      } else {
        _status = OrderDetailStatus.error;
        _errorMessage = response.message;
      }
      notifyListeners();
    } catch (e) {
      _status = OrderDetailStatus.error;
      String errorMsg = e.toString();

      // Remove common prefixes
      errorMsg = errorMsg
          .replaceAll('Exception: ', '')
          .replaceAll('ServerException: ', '')
          .replaceAll('AuthenticationException: ', '')
          .replaceAll('NetworkException: ', '')
          .trim();

      _errorMessage = errorMsg.isEmpty ? 'Failed to load order details' : errorMsg;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void reset() {
    _status = OrderDetailStatus.initial;
    _order = null;
    _errorMessage = null;
    notifyListeners();
  }
}

