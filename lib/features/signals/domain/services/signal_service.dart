import 'dart:io';

import 'package:flutter_task/core/exceptions/app_exceptions.dart';
import 'package:flutter_task/features/signals/data/models/comment_model.dart';
import 'package:flutter_task/features/signals/data/models/log_signal_model.dart';
import 'package:flutter_task/features/signals/data/models/signal_model.dart';
import 'package:flutter_task/features/signals/data/repositories/signals_repository.dart';

class SignalsService {
  final SignalsRepository _repository;

  SignalsService({required SignalsRepository repository})
      : _repository = repository;

  // ─── Fetch All ────────────────────────────────────────────────────
  Future<void> fetchAllSignalsData() async {
    try {
      await _repository.getSignalData(1, 10);
    } on AppException {
      if (!hasCache()) {
        rethrow;
      }
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  // ─── Fetch Initial Comments ───────────────────────────────────────
  Future<void> fetchInitialComments(String signalId) async {
    try {
      await _repository.getComments(signalId, 1, 10);
    } on AppException {
      if (!hasCache()) {
        rethrow;
      }
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  // ─── Fetch More Signals (Pagination) ─────────────────────────────
  Future<List<SignalsModel>> fetchMoreSignals({
    required int page,
    required int limit,
  }) async {
    try {
      return await _repository.fetchMoreSignalData(page: page, limit: limit);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  // ─── Fetch More Comments (Pagination) ────────────────────────────
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

  // ─── Add Comment ──────────────────────────────────────────────────
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

  // ─── Signal Details ───────────────────────────────────────────────
  Future<SignalsModel> getSignalDetails(String signalId) async {
    try {
      return await _repository.getSignalDetails(signalId);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  // ─── Copy Signal ──────────────────────────────────────────────────
  Future<void> copyTradingSignal({required String signalId}) async {
    try {
      await _repository.copyTradingSignal(signalId: signalId);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  // ─── Log Signal ───────────────────────────────────────────────────
  Future<void> logTradingSignal(LogTradingSignalModel data) async {
    try {
      await _repository.logTradingSignal(data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  // ─── Upload Image ─────────────────────────────────────────────────
  Future<String> uploadImage(File file) async {
    try {
      return await _repository.uploadImage(file);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  // ─── Cache ────────────────────────────────────────────────────────
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

// ─── Screen Data Model ────────────────────────────────────────────────
class SignalsScreenData {
  final List<SignalsModel> signals;
  final List<CommentModel> comments;

  SignalsScreenData({required this.signals, required this.comments});
}