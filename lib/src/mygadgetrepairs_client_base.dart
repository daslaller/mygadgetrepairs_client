import 'dart:convert';
import 'dart:io';

import 'models/models.dart';
import 'request_method.dart';


class MgrApiException implements Exception {
  final int statusCode;
  final Uri? uri;
  final dynamic body;
  final String? message;

  const MgrApiException({
    required this.statusCode,
    this.uri,
    this.body,
    this.message,
  });

  @override
  String toString() {
    final buffer = StringBuffer('MgrApiException(')
      ..write('statusCode: $statusCode');
    if (uri != null) buffer.write(', uri: $uri');
    if (message != null) buffer.write(', message: $message');
    if (body != null && message == null) buffer.write(', body: $body');
    buffer.write(')');
    return buffer.toString();
  }
}

class MgrClient {
  MgrClient({
    required this.apiKey,
    this.contentType = 'application/json',
    this.accept = 'application/json',
    HttpClient? httpClient,
  }) : httpClient = httpClient ?? HttpClient() {
    _refreshDefaultHeaders();
  }

  String apiKey;
  final String accept;
  final String contentType;
  final HttpClient httpClient;

  late Map<String, String> header;

  set setApiKey(String value) {
    apiKey = value;
    _refreshDefaultHeaders();
  }

  void setHeader(Map<String, String> header) =>
      this.header = {...this.header, ...header};

  void _refreshDefaultHeaders() {
    header = <String, String>{
      HttpHeaders.authorizationHeader: apiKey,
      HttpHeaders.acceptHeader: accept,
      HttpHeaders.contentTypeHeader: contentType,
    };
  }

  Future<T?> request<T>({
    required Resources resource,
    required MgrRequestMethod method,
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Object? body,
    MgrParser<T>? parser,
  }) async {
    final uri = resource.fullUrl(
      pathParameters: pathParameters,
      queryParameters: queryParameters,
    );


    final HttpClientRequest request = switch (method) {
      MgrRequestMethod.get when resource.descriptor.get => await httpClient.getUrl(uri),
      MgrRequestMethod.post when resource.descriptor.post => await httpClient.postUrl(uri),
      MgrRequestMethod.put when resource.descriptor.put => await httpClient.putUrl(uri),
      MgrRequestMethod.patch when resource.descriptor.patch => await httpClient.patchUrl(uri),
      MgrRequestMethod.delete when resource.descriptor.delete => await httpClient.deleteUrl(uri),
      _ => throw ArgumentError(
          'HTTP ${method.name.toUpperCase()} is not supported for ${resource.name}',
        ),
    };

    final requestHeaders = {...header, if (headers != null) ...headers};
    requestHeaders.forEach(request.headers.set);

    if (body != null && method != MgrRequestMethod.get) {
      await _writeBody(request, body);
    }

    final dynamic rawParser = parser ?? resource.parser;
    final response = await request.close();
    final parsed = await _handleResponse(response, uri: uri);

    if (parsed == null) {
      return null;
    }

    if (rawParser != null) {
      return rawParser(parsed) as T;
    }

    return parsed as T?;
  }

  static Future<void> _writeBody(HttpClientRequest request, Object body) async {
    switch (body) {
      case String bodyString:
        request.write(bodyString);
      case List<int> bodyBytes:
        request.add(bodyBytes);
      case Map<String, dynamic> bodyMap:
        request.write(jsonEncode(bodyMap));
      case Iterable bodyIterable:
        request.write(jsonEncode(bodyIterable));
      default:
        throw ArgumentError(
          'Unsupported body type: ${body.runtimeType}. Provide String, bytes, Map, or Iterable.',
        );
    }
    await request.flush();
  }

  static Future<dynamic> _handleResponse(
    HttpClientResponse response, {
    Uri? uri,
  }) async {
    final responseBody =
        await response.transform(const Utf8Decoder()).join();

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (responseBody.isEmpty) {
        return null;
      }
      try {
        return jsonDecode(responseBody);
      } on FormatException {
        return responseBody;
      }
    }

    dynamic errorBody;
    if (responseBody.isNotEmpty) {
      try {
        errorBody = jsonDecode(responseBody);
      } on FormatException {
        errorBody = responseBody;
      }
    }

    String? errorMessage;
    if (errorBody is Map<String, dynamic>) {
      final dynamic messageValue = errorBody['error'] ?? errorBody['message'];
      if (messageValue != null) {
        errorMessage = messageValue.toString();
      }
    }

    throw MgrApiException(
      statusCode: response.statusCode,
      uri: uri,
      body: errorBody,
      message: errorMessage,
    );
  }
}
