import 'package:cammate/config/api_endpoints.dart';
import 'package:cammate/core/failure/failure.dart';
import 'package:cammate/core/networking/http_service.dart';
import 'package:cammate/features/auth/data/model/auth_model.dart';
import 'package:cammate/features/auth/domain/entity/auth_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRemoteDataSourceProvider =
    Provider.autoDispose<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSource(
    dio: ref.read(httpServiceProvider),
  ),
);

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource({required this.dio});

  Future<Either<Failure, bool>> register(AuthEntity register) async {
    try {
      AuthAPIModel authAPIModel = AuthAPIModel.fromEntity(register);
      var response = await dio.post(ApiEndpoints.register,
          data: authAPIModel.toJson(includePassword: true));
      if (response.statusCode == 200) {
        if (response.data['success']) {
          return const Right(true);
        } else {
          return Left(Failure(error: response.data["message"]));
        }
      } else {
        return Left(
          Failure(
            error: response.data["message"],
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(Failure(error: e.response?.data['message']));
    }
  }

  Future<Either<Failure, List<String>>> login(
    String email,
    String password,
  ) async {
    try {
      Response response = await dio.post(
        ApiEndpoints.login,
        data: {
          "email": email,
          "password": password,
        },
      );
      if (response.statusCode == 200) {
        if (response.data['success']) {
          print(response.data);
          String token = response.data["token"];
          // String name =
          //     '${response.data["userData"]["firstName"]} ${response.data["userData"]["lastName"]}';
          // String id = response.data["userData"]["_id"];
          // String phone = response.data["userData"]["phone"];
          return Right([token,"1","2","3" ]);
        } else {
          return Left(Failure(error: response.data["message"]));
        }
      } else {
        return Left(
          Failure(
            error: response.data["message"],
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

}