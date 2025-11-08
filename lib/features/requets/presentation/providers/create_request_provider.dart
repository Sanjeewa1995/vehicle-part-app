import 'package:flutter/foundation.dart';
import '../../domain/entities/vehicle_part_request.dart';
import '../../domain/usecases/create_request_usecase.dart';
import '../../data/models/create_request_data.dart';

enum CreateRequestStatus {
  initial,
  loading,
  success,
  error,
}

class CreateRequestProvider extends ChangeNotifier {
  final CreateRequestUseCase createRequestUseCase;

  CreateRequestProvider({required this.createRequestUseCase});

  CreateRequestStatus _status = CreateRequestStatus.initial;
  VehiclePartRequest? _createdRequest;
  String? _errorMessage;
  bool _hasVideo = false;

  CreateRequestStatus get status => _status;
  VehiclePartRequest? get createdRequest => _createdRequest;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == CreateRequestStatus.loading;
  bool get isSuccess => _status == CreateRequestStatus.success;
  bool get hasError => _status == CreateRequestStatus.error;
  bool get hasVideo => _hasVideo;

  Future<void> createRequest(CreateRequestData data) async {
    _status = CreateRequestStatus.loading;
    _errorMessage = null;
    _hasVideo = data.partVideoPath != null;
    notifyListeners();

    try {
      _createdRequest = await createRequestUseCase(data);
      _status = CreateRequestStatus.success;
      _errorMessage = null;
    } catch (e) {
      _status = CreateRequestStatus.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '').trim();
      _createdRequest = null;
    } finally {
      notifyListeners();
    }
  }

  void reset() {
    _status = CreateRequestStatus.initial;
    _createdRequest = null;
    _errorMessage = null;
    _hasVideo = false;
    notifyListeners();
  }
}

