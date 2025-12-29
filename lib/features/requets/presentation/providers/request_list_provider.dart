import 'package:flutter/foundation.dart';
import '../../domain/entities/vehicle_part_request.dart';
import '../../domain/usecases/get_requests_usecase.dart';
import '../../../../core/utils/error_message_helper.dart';

enum RequestListStatus { initial, loading, loaded, error }

class RequestListProvider extends ChangeNotifier {
  final GetRequestsUseCase getRequestsUseCase;

  RequestListProvider({required this.getRequestsUseCase});

  RequestListStatus _status = RequestListStatus.initial;
  List<VehiclePartRequest> _requests = [];
  String? _errorMessage;
  int _currentPage = 1;
  final int _pageSize = 10;
  bool _hasMore = true;

  RequestListStatus get status => _status;
  List<VehiclePartRequest> get requests => _requests;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == RequestListStatus.loading;
  bool get hasMore => _hasMore;

  Future<void> loadRequests({bool refresh = false}) async {
    try {
      if (refresh) {
        _currentPage = 1;
        _hasMore = true;
      }

      _status = RequestListStatus.loading;
      _errorMessage = null;
      notifyListeners();

      final result = await getRequestsUseCase(
        page: _currentPage,
        pageSize: _pageSize,
      );

      if (refresh) {
        _requests = result;
      } else {
        _requests.addAll(result);
      }

      // Check if there are more pages
      _hasMore = result.length >= _pageSize;
      if (_hasMore) {
        _currentPage++;
      }

      _status = RequestListStatus.loaded;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _status = RequestListStatus.error;
      final errorMsg = ErrorMessageHelper.getUserFriendlyMessage(e);
      _errorMessage = errorMsg.isEmpty ? 'Failed to load requests' : errorMsg;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await loadRequests(refresh: true);
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

