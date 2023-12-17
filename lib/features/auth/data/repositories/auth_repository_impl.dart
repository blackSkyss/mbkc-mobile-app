import '../../../../models/token_model.dart';
import '../../../../models/response/success_model.dart';
import '../../../../utils/commons/functions/functions_common_export.dart';
import '../../../../utils/constants/api_constant.dart';
import '../../../../utils/resources/remote_base_repository.dart';
import '../../domain/models/request/change_first_time_request.dart';
import '../../domain/models/request/change_password_request.dart';
import '../../domain/models/request/email_verify_request.dart';
import '../../domain/models/request/otp_verify_request.dart';
import '../../domain/models/request/register_token_request.dart';
import '../../domain/models/request/sign_in_request.dart';
import '../../domain/models/response/account_reponse.dart';
import '../../domain/repositories/auth_repository.dart';
import '../remote/auth_source.dart';

class AuthRepositoryImpl extends RemoteBaseRepository
    implements AuthRepository {
  final bool addDelay;
  final AuthSource _authSource;
  AuthRepositoryImpl(this._authSource, {this.addDelay = true});

  @override
  Future<AccountReponse> signIn({required SignInRequest request}) {
    return getDataOf(
      request: () => _authSource.signIn(request, APIConstants.contentType),
    );
  }

  @override
  Future<TokenModel> generateToken({required TokenModel request}) {
    return getDataOf(
      request: () =>
          _authSource.generateToken(request, APIConstants.contentType),
    );
  }

  @override
  Future<SuccessModel> changePassword({
    required ChangePasswordRequest request,
  }) {
    return getDataOf(
      request: () =>
          _authSource.changePassword(request, APIConstants.contentType),
    );
  }

  @override
  Future<SuccessModel> verifyEmail({required EmailVerifyRequest request}) {
    return getDataOf(
      request: () => _authSource.verifyEmail(request, APIConstants.contentType),
    );
  }

  @override
  Future<SuccessModel> verifyOTPCode({required OTPVerifyRequest request}) {
    return getDataOf(
      request: () =>
          _authSource.verifyOTPCode(request, APIConstants.contentType),
    );
  }

  @override
  Future<SuccessModel> changeFirstTime({
    required ChangeFirstTimeRequest request,
    required int id,
    required String accessToken,
  }) {
    return getDataOf(
      request: () => _authSource.changeFirstTime(
        request,
        APIConstants.contentType,
        accessToken,
        id,
      ),
    );
  }

  @override
  Future<void> signOut() async {
    await SharedPreferencesUtils.clearInstance('user_token');
  }

  @override
  Future<SuccessModel> registerToken({
    required RegisterTokenRequest request,
    required String accessToken,
  }) {
    return getDataOf(
      request: () => _authSource.registerToken(
        request,
        APIConstants.contentType,
        accessToken,
      ),
    );
  }

  @override
  Future<SuccessModel> deleteToken({
    required int id,
  }) {
    return getDataOf(
      request: () => _authSource.deleteToken(
        id,
        APIConstants.contentType,
      ),
    );
  }
}
