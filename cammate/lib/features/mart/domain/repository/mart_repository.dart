import 'package:cammate/core/failure/failure.dart';
import 'package:cammate/features/mart/data/model/mart_model.dart';
import 'package:cammate/features/mart/data/repository/mart_remote_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final martRepositoryProvider = Provider.autoDispose<IMartRepository>(
  (ref) => ref.read(martRemoteRepoProvider),
);

abstract class IMartRepository {
  // Register mart
  Future<Either<Failure, MartAPIModel>> createMart(MartAPIModel mart);

  // Get all marts
  Future<Either<Failure, List<MartAPIModel>>> getAllMarts({int skip = 0, int limit = 100});

  // Get mart by ID
  Future<Either<Failure, MartAPIModel>> getMartById(int martId);

  // Update mart
  Future<Either<Failure, MartAPIModel>> updateMart(int martId, MartAPIModel mart);

  // Delete mart
  Future<Either<Failure, String>> deleteMart(int martId);
}
