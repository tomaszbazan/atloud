import 'dart:convert';
import 'package:http/http.dart' as http;

class AirtableService {
  static const String _apiKey = String.fromEnvironment('AIRTABLE_API_KEY');
  static const String _baseId = 'appwMTGnfU1fqBmuU';
  static const String _tableName = 'Opinie';

  static const String _emailField = 'fldi6Paxkqbqy3MN3';
  static const String _appWorksCorrectlyField = 'fldJWuKXe0UKqIpig';
  static const String _futureFunctionalitiesField = 'fldfCBH1gWCQUCJzq';
  static const String _deviceInfoField = 'fldqbzQnibueS43Cb';

  static Future<bool> sendFeedback({
    required String email,
    required String appWorksCorrectly,
    required String futureFunctionalities,
    required String deviceInfo,
  }) async {
    final url = Uri.parse('https://api.airtable.com/v0/$_baseId/$_tableName');

    final headers = {
      'Authorization': 'Bearer $_apiKey',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'records': [
        {
          'fields': {
            _emailField: email,
            _appWorksCorrectlyField: appWorksCorrectly,
            _futureFunctionalitiesField: futureFunctionalities,
            _deviceInfoField: deviceInfo,
          },
        }
      ],
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('Airtable API Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error sending data to Airtable: $e');
      return false;
    }
  }
}
