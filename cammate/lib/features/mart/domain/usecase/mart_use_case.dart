import 'package:cammate/core/failure/failure.dart';
import 'package:cammate/core/shared_pref/user_shared_prefs.dart';
import 'package:cammate/features/mart/data/model/mart_model.dart';
import 'package:cammate/features/mart/domain/repository/mart_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final martUseCaseProvider = Provider.autoDispose<MartUseCase>(
  (ref) => MartUseCase(
    repository: ref.read(martRepositoryProvider),
    userSharedPrefs: ref.read(userSharedPrefsProvider),
  ),
);

class MartUseCase {
  final IMartRepository repository;
  final UserSharedPrefs userSharedPrefs;

  MartUseCase({required this.repository, required this.userSharedPrefs});

  /// Create a new mart
  Future<Either<Failure, MartAPIModel>> createMart(MartAPIModel mart) async {
    final tokenEither = await userSharedPrefs.getUserToken();
    final token = tokenEither.fold((_) => null, (t) => t);

    if (token == null || token.isEmpty) {
      return Left(Failure(error: 'User is not authenticated', statusCode: 401));
    }

    return await repository.createMart(mart);
  }

  /// Get all marts with optional pagination
  Future<Either<Failure, List<MartAPIModel>>> getAllMarts({int skip = 0, int limit = 100}) async {
    return await repository.getAllMarts(skip: skip, limit: limit);
  }

  /// Get a mart by ID
  Future<Either<Failure, MartAPIModel>> getMartById(int martId) async {
    return await repository.getMartById(martId);
  }

  /// Update a mart by ID
  Future<Either<Failure, MartAPIModel>> updateMart(int martId, MartAPIModel mart) async {
    return await repository.updateMart(martId, mart);
  }

  /// Delete a mart by ID
  Future<Either<Failure, String>> deleteMart(int martId) async {
    return await repository.deleteMart(martId);
  }
}
