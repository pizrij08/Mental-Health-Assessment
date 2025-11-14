class AppConfig {
  const AppConfig({required this.environment, required this.apiBaseUrl});

  final String environment;
  final String apiBaseUrl;

  static AppConfig fromEnvironment() {
    const env = String.fromEnvironment('APP_ENV', defaultValue: 'development');
    switch (env) {
      case 'production':
        return const AppConfig(
          environment: 'production',
          apiBaseUrl: 'https://api.mindwellclinic.com',
        );
      case 'staging':
        return const AppConfig(
          environment: 'staging',
          apiBaseUrl: 'https://staging-api.mindwellclinic.com',
        );
      default:
        return const AppConfig(
          environment: 'development',
          apiBaseUrl: 'https://dev-api.mindwellclinic.local',
        );
    }
  }
}
