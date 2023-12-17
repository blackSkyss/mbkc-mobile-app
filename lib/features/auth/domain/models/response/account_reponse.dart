import 'dart:convert';
import '../../../../../models/token_model.dart';

class AccountReponse {
  final int accountId;
  final String email;
  final String roleName;
  final bool isConfirmed;
  final TokenModel tokens;

  AccountReponse({
    required this.accountId,
    required this.email,
    required this.roleName,
    required this.tokens,
    required this.isConfirmed,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'accountId': accountId});
    result.addAll({'email': email});
    result.addAll({'roleName': roleName});
    result.addAll({'isConfirmed': isConfirmed});
    result.addAll({'tokens': tokens.toMap()});

    return result;
  }

  factory AccountReponse.fromMap(Map<String, dynamic> map) {
    return AccountReponse(
      accountId: map['accountId']?.toInt() ?? 0,
      email: map['email'] ?? '',
      roleName: map['roleName'] ?? '',
      isConfirmed: map['isConfirmed'] ?? false,
      tokens: TokenModel.fromMap(map['tokens']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AccountReponse.fromJson(String source) =>
      AccountReponse.fromMap(json.decode(source));
}
