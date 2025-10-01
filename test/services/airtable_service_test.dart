import 'package:atloud/services/airtable_service.dart';
import 'package:atloud/services/airtable_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('AirtableService', () {
    test('sendFeedback sends correct request with valid data', () async {
      final mockClient = MockClient((request) async {
        expect(request.method, 'POST');
        expect(
          request.url.toString(),
          'https://api.airtable.com/v0/appwMTGnfU1fqBmuU/Opinie',
        );
        expect(request.headers['Authorization'], startsWith('Bearer '));
        expect(request.headers['Content-Type'], contains('application/json'));

        final body = request.body;
        expect(body, contains('records'));
        expect(body, contains('test@example.com'));
        expect(body, contains('Yes'));
        expect(body, contains('Feature request'));
        expect(body, contains('Android 13'));

        return http.Response('{"records": []}', 200);
      });

      await AirtableService.sendFeedback(
        email: 'test@example.com',
        appWorksCorrectly: 'Yes',
        futureFunctionalities: 'Feature request',
        deviceInfo: 'Android 13',
        client: mockClient,
      );
    });

    test('sendFeedback handles 201 status code', () async {
      final mockClient = MockClient((request) async {
        return http.Response('{"records": []}', 201);
      });

      await expectLater(
        AirtableService.sendFeedback(
          email: 'test@example.com',
          appWorksCorrectly: 'Yes',
          futureFunctionalities: 'Feature request',
          deviceInfo: 'Android 13',
          client: mockClient,
        ),
        completes,
      );
    });

    test('sendFeedback throws AirtableException on 400 error', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Bad Request', 400);
      });

      expect(
        () => AirtableService.sendFeedback(
          email: 'test@example.com',
          appWorksCorrectly: 'Yes',
          futureFunctionalities: 'Feature request',
          deviceInfo: 'Android 13',
          client: mockClient,
        ),
        throwsA(isA<AirtableException>()),
      );
    });

    test('sendFeedback throws AirtableException on 401 error', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Unauthorized', 401);
      });

      expect(
        () => AirtableService.sendFeedback(
          email: 'test@example.com',
          appWorksCorrectly: 'Yes',
          futureFunctionalities: 'Feature request',
          deviceInfo: 'Android 13',
          client: mockClient,
        ),
        throwsA(isA<AirtableException>()),
      );
    });

    test('sendFeedback throws AirtableException on 500 error', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Internal Server Error', 500);
      });

      expect(
        () => AirtableService.sendFeedback(
          email: 'test@example.com',
          appWorksCorrectly: 'Yes',
          futureFunctionalities: 'Feature request',
          deviceInfo: 'Android 13',
          client: mockClient,
        ),
        throwsA(isA<AirtableException>()),
      );
    });

    test('AirtableException contains status code and reason', () {
      final exception = AirtableException(404, 'Not Found');
      expect(exception.statusCode, 404);
      expect(exception.reasonPhrase, 'Not Found');
    });
  });
}