import 'dart:io';

import 'package:flutter_task/core/exceptions/app_exceptions.dart';
import 'package:flutter_task/features/signals/data/models/comment_model.dart';
import 'package:flutter_task/features/signals/data/models/log_signal_model.dart';
import 'package:flutter_task/features/signals/data/models/platform_model.dart';
import 'package:flutter_task/features/signals/data/models/signal_model.dart';
import 'package:flutter_task/features/signals/data/repositories/signals_repository.dart';

class SignalsService {
  final SignalsRepository _repository;

  SignalsService({required SignalsRepository repository})
      : _repository = repository;

  Future<void> fetchAllSignalsData({
    String? assetType,
    String? symbol,
    String? search,
    String sortBy = 'newest',
  }) async {
    try {
      await _repository.getSignalData(
        page: 1,
        limit: 10,
        assetType: assetType,
        symbol: symbol,
        search: search,
        sortBy: sortBy,
      );
    } on AppException {
      if (!hasCache()) rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<void> fetchInitialComments(String signalId) async {
    try {
      await _repository.getComments(signalId, 1, 10);
    } on AppException {
      if (!hasCache()) rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<SignalsModel>> fetchMoreSignals({
    required int page,
    required int limit,
    String? assetType,
    String? symbol,
    String? search,
    String sortBy = 'newest',
  }) async {
    try {
      return await _repository.fetchMoreSignalData(
        page: page,
        limit: limit,
        assetType: assetType,
        symbol: symbol,
        search: search,
        sortBy: sortBy,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<CommentModel>> fetchMoreComments({
    required int page,
    required int limit,
    required String signalId,
  }) async {
    try {
      return await _repository.fetchMoreComments(
        signalId: signalId,
        page: page,
        limit: limit,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<void> addComment({
    required String signalId,
    required String comment,
  }) async {
    try {
      await _repository.addComment(signalId: signalId, comment: comment);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<SignalsModel> getSignalDetails(String signalId) async {
    try {
      return await _repository.getSignalDetails(signalId);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<void> copyTradingSignal({required String signalId}) async {
    try {
      await _repository.copyTradingSignal(signalId: signalId);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<void> logTradingSignal(LogTradingSignalModel data) async {
    try {
      await _repository.logTradingSignal(data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<String> uploadImage(File file) async {
    try {
      return await _repository.uploadImage(file);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<PlatformModel>> getPlatforms() async {
    try {
      return await _repository.getPlatforms();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  bool hasCache() {
    return _repository.getCachedSignalData() != null ||
        _repository.getCachedComments() != null;
  }

  SignalsScreenData getCachedData() {
    return SignalsScreenData(
      comments: _repository.getCachedComments() ?? [],
      signals: _repository.getCachedSignalData() ?? [],
    );
  }
}

class SignalsScreenData {
  final List<SignalsModel> signals;
  final List<CommentModel> comments;

  SignalsScreenData({required this.signals, required this.comments});
}
