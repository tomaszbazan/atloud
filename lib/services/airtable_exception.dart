class AirtableException implements Exception {
  final int statusCode;
  final String? reasonPhrase;

  AirtableException(this.statusCode, this.reasonPhrase);

  @override
  String toString() => 'AirtableException: $statusCode ${reasonPhrase ?? ''}';
}