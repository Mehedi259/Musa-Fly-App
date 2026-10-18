import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import 'api_exceptions.dart';

class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  Future<dynamic> get(String endpoint, {Map<String, String>? queryParams}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint').replace(
      queryParameters: queryParams,
    );

    try {
      developer.log('GET Request: $uri', name: 'ApiClient');
      final response = await _client
          .get(uri, headers: _headers)
          .timeout(ApiConstants.connectTimeout);
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException();
    } on TimeoutException {
      throw TimeoutException('Request timeout to server');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Unexpected network error: $e');
    }
  }

  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');

    try {
      developer.log('POST Request: $uri', name: 'ApiClient');
      if (body != null) {
        developer.log('Payload: ${jsonEncode(body)}', name: 'ApiClient');
      }
      final response = await _client
          .post(
            uri,
            headers: _headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConstants.connectTimeout);
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException();
    } on TimeoutException {
      throw TimeoutException('Request timeout to server');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Unexpected network error: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    developer.log(
      'Response Status [${response.statusCode}] for ${response.request?.url}',
      name: 'ApiClient',
    );

    switch (response.statusCode) {
      case 200:
      case 201:
        if (response.body.isEmpty) return null;
        try {
          return jsonDecode(utf8.decode(response.bodyBytes));
        } catch (e) {
          return response.body;
        }
      case 204:
        return null;
      case 400:
        String message = 'Bad request';
        try {
          final errorJson = jsonDecode(utf8.decode(response.bodyBytes));
          message = errorJson.toString();
        } catch (_) {}
        throw ApiException(message, 400);
      case 404:
        throw NotFoundException('Resource not found', 404);
      case 500:
      default:
        throw ServerException(
          'Server returned error: ${response.statusCode}',
          response.statusCode,
        );
    }
  }

  void close() {
    _client.close();
  }
}
