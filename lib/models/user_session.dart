import 'package:hive/hive.dart';

part 'user_session.g.dart';

@HiveType(typeId: 1)
class UserSession {
  @HiveField(0)
  final bool isLoggedIn;

  @HiveField(1)
  final String username;

  UserSession({
    required this.isLoggedIn,
    required this.username,
  });
}