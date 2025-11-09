import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/data/datasources/remote/auth_remote_datasource.dart';
import '../../features/auth/data/datasources/local/auth_local_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/requets/data/datasources/remote/request_remote_datasource.dart';
import '../../features/requets/data/repositories/request_repository_impl.dart';
import '../../features/requets/domain/repositories/request_repository.dart';
import '../../features/requets/domain/usecases/get_requests_usecase.dart';
import '../../features/requets/domain/usecases/get_request_by_id_usecase.dart';
import '../../features/requets/domain/usecases/create_request_usecase.dart';
import '../../features/requets/domain/usecases/delete_request_usecase.dart';
import '../../features/requets/presentation/providers/request_list_provider.dart';
import '../../features/requets/presentation/providers/request_detail_provider.dart';
import '../../features/requets/presentation/providers/create_request_provider.dart';
import '../network/api_client.dart';
import '../services/token_service.dart';

final getIt = GetIt.instance;

class ServiceLocator {
  static Future<void> setup() async {
    // External dependencies
    final sharedPreferences = await SharedPreferences.getInstance();
    getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

    // Services
    getIt.registerLazySingleton(() => TokenService());

    // API Client
    getIt.registerLazySingleton<ApiClient>(
      () => ApiClient(
        getAccessToken: TokenService.getAccessToken,
      ),
    );

    // Data Sources
    getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        apiClient: getIt<ApiClient>(),
      ),
    );

    getIt.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(
        sharedPreferences: getIt<SharedPreferences>(),
      ),
    );

    // Repositories
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: getIt<AuthRemoteDataSource>(),
        localDataSource: getIt<AuthLocalDataSource>(),
      ),
    );

    // Use Cases
    getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
    getIt.registerLazySingleton(
      () => RegisterUseCase(authRepository: getIt<AuthRepository>()),
    );

    // Request Data Sources
    getIt.registerLazySingleton<RequestRemoteDataSource>(
      () => RequestRemoteDataSourceImpl(
        apiClient: getIt<ApiClient>(),
      ),
    );

    // Request Repositories
    getIt.registerLazySingleton<RequestRepository>(
      () => RequestRepositoryImpl(
        remoteDataSource: getIt<RequestRemoteDataSource>(),
      ),
    );

    // Request Use Cases
    getIt.registerLazySingleton(
      () => GetRequestsUseCase(getIt<RequestRepository>()),
    );

    getIt.registerLazySingleton(
      () => GetRequestByIdUseCase(getIt<RequestRepository>()),
    );

    getIt.registerLazySingleton(
      () => CreateRequestUseCase(getIt<RequestRepository>()),
    );

    getIt.registerLazySingleton(
      () => DeleteRequestUseCase(getIt<RequestRepository>()),
    );

    // Providers
    getIt.registerFactory<AuthProvider>(
      () => AuthProvider(
        loginUseCase: getIt<LoginUseCase>(),
        registerUseCase: getIt<RegisterUseCase>(),
        authRepository: getIt<AuthRepository>(),
      ),
    );

    getIt.registerFactory<RequestListProvider>(
      () => RequestListProvider(
        getRequestsUseCase: getIt<GetRequestsUseCase>(),
      ),
    );

    getIt.registerFactory<RequestDetailProvider>(
      () => RequestDetailProvider(
        getRequestByIdUseCase: getIt<GetRequestByIdUseCase>(),
        deleteRequestUseCase: getIt<DeleteRequestUseCase>(),
      ),
    );

    getIt.registerFactory<CreateRequestProvider>(
      () => CreateRequestProvider(
        createRequestUseCase: getIt<CreateRequestUseCase>(),
      ),
    );
  }

  static AuthProvider getAuthProvider() {
    return getIt<AuthProvider>();
  }

  static T get<T extends Object>() {
    return getIt<T>();
  }
}

