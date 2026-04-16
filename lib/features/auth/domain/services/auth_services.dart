import 'package:flutter_task/core/exceptions/app_exceptions.dart';
import 'package:flutter_task/core/services/connectivity_service.dart';
import 'package:flutter_task/features/auth/data/models/login_response_model.dart';
import 'package:flutter_task/features/auth/data/models/user_response_model.dart';
import 'package:flutter_task/features/auth/data/repositories/auth_repository.dart';

class AuthService {
  final AuthRepository _repository;
  final ConnectivityService _connectivityService;

  AuthService({
    required AuthRepository repository,
    required ConnectivityService connectivityService,
  }) : _repository = repository,
       _connectivityService = connectivityService;

  Future<void> _checkConnectivity() async {
    final isConnected = await _connectivityService.checkConnectivity();
    if (!isConnected) throw NoInternetException();
  }

  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    await _checkConnectivity();
    return await _repository.login(email: email, password: password);
  }

  Future<void> logout() async {
    await _repository.logout();
  }

  bool isLoggedIn() => _repository.isLoggedIn();

  String? getAccessToken() => _repository.getAccessToken();

  UserResponseModel? getCachedUser() => _repository.getCachedUser();
}
