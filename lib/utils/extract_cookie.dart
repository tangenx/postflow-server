String? extractCookie(String? cookieHeader, String name) {
  if (cookieHeader == null) return null;
  final match = RegExp('$name=([^;]+)').firstMatch(cookieHeader);
  return match?.group(1);
}
