import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/data/datasources/remote/auth_remote_datasource.dart';
import '../../features/auth/data/datasources/local/auth_local_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
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

    // Providers
    getIt.registerFactory<AuthProvider>(
      () => AuthProvider(
        loginUseCase: getIt<LoginUseCase>(),
        authRepository: getIt<AuthRepository>(),
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

