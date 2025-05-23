import 'dart:convert';

import 'package:result_dart/result_dart.dart';
import '../../../core/logger/logger_mixin.dart';
import '../../../domain/dto/credentials_login_dto.dart';
import '../../../domain/dto/recover_password_dto.dart';
import '../../../domain/dto/recover_password_otp_dto.dart';
import '../../../domain/dto/recover_password_send_email_dto.dart';
import '../../../domain/dto/register_dto.dart';
import '../../../domain/dto/register_otp_dto.dart';
import 'client_http/i_rest_client.dart';
import 'client_http/rest_client_request.dart';
import 'client_http/rest_client_response.dart';

class AuthApi with LoggerMixin {
  final IRestClient client;

  AuthApi(this.client);

  AsyncResult<RestClientResponse> login(CredentialsLoginDto credentials) async {
    final logger = log.forMethod()..logInfo(data: credentials);
    String basicAuth =
        'Basic ' +
        base64.encode(
          utf8.encode('${credentials.email}:${credentials.password}'),
        );

    return await client
        .get(
          RestClientRequest(
            path: '/auth/login',
            headers: {'Authorization': basicAuth},
          ),
        )
        .onSuccess(logger.fromSuccess)
        .onFailure(logger.fromException);
  }

  AsyncResult<RestClientResponse> getLoggedUser() async {
    final logger = log.forMethod();

    return await client
        .get(RestClientRequest(path: '/user'))
        .onSuccess(logger.fromSuccess)
        .onFailure(logger.fromException);
  }

  AsyncResult<RestClientResponse> register(RegisterDto credentials) async {
    final logger = log.forMethod()..logInfo(data: credentials);

    return await client
        .post(RestClientRequest(path: '/user', data: credentials.toJson()))
        .onSuccess(logger.fromSuccess)
        .onFailure(logger.fromException);
  }

  AsyncResult<RestClientResponse> getRefreshToken(String refreshToken) async {
    final logger = log.forMethod()..logInfo(data: refreshToken);

    return await client
        .get(
          RestClientRequest(
            path: '/auth/refresh',
            headers: {'Authorization': 'Bearer $refreshToken'},
          ),
        )
        .onSuccess(logger.fromSuccess)
        .onFailure(logger.fromException);
  }

  AsyncResult<RestClientResponse> confirmOtpRegisterCode(
    RegisterOtpDto dto,
  ) async {
    final logger = log.forMethod()..logInfo(data: dto);

    return await client
        .post(RestClientRequest(path: '/user/verify', data: dto.toJson()))
        .onSuccess(logger.fromSuccess)
        .onFailure(logger.fromException);
  }

  AsyncResult<RestClientResponse> requestToRecoverPassword(
    RecoverPasswordSendEmailDto dto,
  ) async {
    final logger = log.forMethod()..logInfo(data: dto);

    return await client
        .get(RestClientRequest(path: '/user/recovery/${dto.email}'))
        .onSuccess(logger.fromSuccess)
        .onFailure(logger.fromException);
  }

  AsyncResult<RestClientResponse> confirmOtpPassword(
    RecoverPasswordOtpDto dto,
  ) async {
    final logger = log.forMethod()..logInfo(data: dto);

    return await client
        .post(RestClientRequest(path: '/user/recovery', data: dto.toJson()))
        .onSuccess(logger.fromSuccess)
        .onFailure(logger.fromException);
  }

  AsyncResult<RestClientResponse> newPassword(RecoverPasswordDto dto) async {
    final logger = log.forMethod()..logInfo(data: dto);

    return await client
        .put(RestClientRequest(path: '/user', data: dto.toJson()))
        .onSuccess(logger.fromSuccess)
        .onFailure(logger.fromException);
  }
}
