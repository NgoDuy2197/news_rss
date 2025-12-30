class AppConfig {
  AppConfig._internal();

  static final AppConfig instance = AppConfig._internal();

  final String appTitle = 'News RSS';

  /// Base URL of the backend (Node.js) server.
  final String apiBaseUrl = 'https://example-node-service.com/api';

  /// Default timeout for HTTP requests.
  final Duration requestTimeout = const Duration(seconds: 12);

  /// Toggle this to false once the Node.js backend is ready.
  final bool useMockApi = true;
}
