import 'package:flutter/foundation.dart';
import '../../domain/entities/vehicle_part_request.dart';
import '../../domain/usecases/get_request_by_id_usecase.dart';

enum RequestDetailStatus { initial, loading, loaded, error }

class RequestDetailProvider extends ChangeNotifier {
  final GetRequestByIdUseCase getRequestByIdUseCase;

  RequestDetailProvider({required this.getRequestByIdUseCase});

  RequestDetailStatus _status = RequestDetailStatus.initial;
  VehiclePartRequest? _request;
  String? _errorMessage;

  RequestDetailStatus get status => _status;
  VehiclePartRequest? get request => _request;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == RequestDetailStatus.loading;

  Future<void> loadRequest(int id) async {
    try {
      _status = RequestDetailStatus.loading;
      _errorMessage = null;
      notifyListeners();

      _request = await getRequestByIdUseCase(id);

      _status = RequestDetailStatus.loaded;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _status = RequestDetailStatus.error;
      String errorMsg = e.toString();

      // Remove common prefixes
      errorMsg = errorMsg
          .replaceAll('Exception: ', '')
          .replaceAll('ServerException: ', '')
          .replaceAll('AuthenticationException: ', '')
          .replaceAll('NetworkException: ', '')
          .trim();

      _errorMessage = errorMsg.isEmpty ? 'Failed to load request' : errorMsg;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

