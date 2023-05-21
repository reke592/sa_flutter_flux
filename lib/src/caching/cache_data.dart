/// offline database record for cached action results
class CacheData {
  final DateTime expiresAt;
  final String jsonString;
  CacheData({
    required this.expiresAt,
    required this.jsonString,
  });

  factory CacheData.fromDb(Map<String, dynamic> row) {
    return CacheData(
      expiresAt: DateTime.fromMillisecondsSinceEpoch(row['expires_at']),
      jsonString: row['json'],
    );
  }
}
