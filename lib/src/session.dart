class Session {
  final String token;
  final String expiresAt;
  final String refreshToken;
  final String refreshExpiresAt;

  Session({
    required this.token,
    required this.expiresAt,
    required this.refreshToken,
    required this.refreshExpiresAt,
  });
}
