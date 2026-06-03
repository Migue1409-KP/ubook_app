import 'package:floor/floor.dart';
import 'package:ubook_app/model/auth/auth_provider.dart';

class AuthProviderConverter extends TypeConverter<AuthProvider, String> {
  @override
  AuthProvider decode(String databaseValue) {
    return AuthProvider.fromJson(databaseValue);
  }

  @override
  String encode(AuthProvider value) {
    return value.toJson();
  }
}
