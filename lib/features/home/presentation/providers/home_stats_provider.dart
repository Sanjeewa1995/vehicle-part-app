import 'package:flutter/foundation.dart';
import '../../../requets/data/models/request_stats_response.dart';
import '../../../requets/domain/usecases/get_request_stats_usecase.dart';

enum HomeStatsStatus { initial, loading, loaded, error }

class HomeStatsProvider extends ChangeNotifier {
  final GetRequestStatsUseCase getRequestStatsUseCase;

  HomeStatsProvider({required this.getRequestStatsUseCase});

  HomeStatsStatus _status = HomeStatsStatus.initial;
  RequestStatsData? _stats;
  String? _errorMessage;

  HomeStatsStatus get status => _status;
  RequestStatsData? get stats => _stats;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == HomeStatsStatus.loading;
  bool get hasError => _status == HomeStatsStatus.error;

  Future<void> loadStats() async {
    try {
      _status = HomeStatsStatus.loading;
      _errorMessage = null;
      notifyListeners();

      final response = await getRequestStatsUseCase();
      
      if (response.success) {
        _stats = response.data;
        _status = HomeStatsStatus.loaded;
        _errorMessage = null;
      } else {
        _status = HomeStatsStatus.error;
        _errorMessage = response.message;
      }
      notifyListeners();
    } catch (e) {
      _status = HomeStatsStatus.error;
      String errorMsg = e.toString();

      // Remove common prefixes
      errorMsg = errorMsg
          .replaceAll('Exception: ', '')
          .replaceAll('ServerException: ', '')
          .replaceAll('AuthenticationException: ', '')
          .replaceAll('NetworkException: ', '')
          .trim();

      _errorMessage = errorMsg.isEmpty ? 'Failed to load stats' : errorMsg;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void reset() {
    _status = HomeStatsStatus.initial;
    _stats = null;
    _errorMessage = null;
    notifyListeners();
  }
}

