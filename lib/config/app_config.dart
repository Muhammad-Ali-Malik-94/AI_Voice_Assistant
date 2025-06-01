class AppConfig {
  static const String cloudRunUrl = String.fromEnvironment(
    'CLOUD_RUN_URL',
    defaultValue: 'http://localhost:8080',
  );

  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  static bool get isProduction => const bool.fromEnvironment('dart.vm.product');

// Add other configuration variables as needed
}