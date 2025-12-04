class Env {
  // singleton instance of the Env class
  static final Env _env = Env._internal();

  // private constructor
  Env._internal() {
    print('APP_NAME: $appName');
    print('FLAVOR: $flavor');
    print('API_URL: $apiUrl');
  }

  // factory constructor
  factory Env() => _env;

  final bundleId = const String.fromEnvironment(
    'BUNDLE_ID',
    defaultValue: '',
  );

  final deepLinkHost = const String.fromEnvironment(
    'DEEP_LINK_HOST',
    defaultValue: '',
  );

  final googleClientId = const String.fromEnvironment(
    'GOOGLE_CLIENT_ID',
    defaultValue: '',
  );

  final sentryDSN = const String.fromEnvironment(
    'SENTRY_DSN',
    defaultValue: '',
  );

  final providerFirebase = const String.fromEnvironment(
    'PROVIDER_FIREBASE',
    defaultValue: 'PROVIDER_FIREBASE',
  );

  final providerApn = const String.fromEnvironment(
    'PROVIDER_APN',
    defaultValue: 'PROVIDER_FIREBASE',
  );

  final appName = const String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'Flutter Kit',
  );

  final flavor = Flavor.values.byName(const String.fromEnvironment(
    'FLAVOR',
    defaultValue: 'production',
  ));

  final _apiUrl = const String.fromEnvironment(
    'API_URL',
    defaultValue: '',
  );
  String get apiUrl => _apiUrl;

  final _socketUrl = const String.fromEnvironment(
    'SOCKET_URL',
    defaultValue: '',
  );
  String get socketUrl => _socketUrl;

  final _isMaintaining = false;
  bool get isMaintaining => _isMaintaining;

  final _maintainingData = <String, dynamic>{};
  Map<String, dynamic> get maintainingData => _maintainingData;

  Future getRemoteConfig() async {
    // final remoteConfig = FirebaseRemoteConfig.instance;
    // await remoteConfig.setDefaults(<String, dynamic>{
    //   'API_URL': _apiUrl,
    //   'DISCOVER_URL': _discoverUrl,
    //   'IS_MAINTAINING': false,
    // });
    // await remoteConfig.setConfigSettings(RemoteConfigSettings(
    //   fetchTimeout: const Duration(minutes: 1),
    //   minimumFetchInterval: flavor == Flavor.staging
    //       ? const Duration(minutes: 1)
    //       : const Duration(hours: 1),
    // ));
    // await remoteConfig.fetchAndActivate();

    // _apiUrl = remoteConfig.getString('API_URL');
    // _discoverUrl = remoteConfig.getString('DISCOVER_URL');
    // _isMaintaining = remoteConfig.getBool('IS_MAINTAINING');
    // _maintainingData = jsonDecode(remoteConfig.getString('MAINTAINING_DATA'));

    // print('Remote config: ${remoteConfig.getAll().map(
    //       (key, value) => MapEntry(key, value.asString()),
    //     )}');
  }
}

enum Flavor { staging, production }
