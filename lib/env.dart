class Env {
  // singleton instance of the Env class
  static final Env _env = Env._internal();

  // private constructor
  Env._internal() {
    print('APP_NAME: $appName');
    print('FLAVOR: $flavor');
    print('API_URL: $apiUrl');
    print('DISCOVER_URL: $discoverUrl');
    print('SOCKET_URL: $socketUrl');

    // if (kIsWeb) {
    //   final isBranchIoTestMode =
    //       const bool.fromEnvironment('BRANCH_IO_TEST_MODE');
    //   js.context["BRANCH_IO_KEY"] = isBranchIoTestMode
    //       ? const String.fromEnvironment("BRANCH_IO_TEST_KEY")
    //       : const String.fromEnvironment("BRANCH_IO_KEY");
    //   // etc..
    //   //Custom DOM event to signal to js the execution of the dart code
    //   html.document.dispatchEvent(html.CustomEvent("dart_loaded"));
    // }
  }

  // factory constructor
  factory Env() => _env;

  final mapboxAPI = 'pk.eyJ1IjoidGFuZGF0azAwNSIsImEiOiJjbWMwY2JhM3EwMHJhMmpzN3Jvb2s5aHplIn0.oSJq8mHU_Y6gApzy658I2g';

  final deepLinkHost = const String.fromEnvironment(
    'DEEP_LINK_HOST',
    defaultValue: '',
  );

  final googleClientId = const String.fromEnvironment(
    'GOOGLE_CLIENT_ID',
    defaultValue: '',
  );

  final providerFirebase = const String.fromEnvironment(
    'PROVIDER_FIREBASE',
    defaultValue: 'PROVIDER_FIREBASE',
  );

  final providerApn = const String.fromEnvironment(
    'PROVIDER_APN',
    defaultValue: 'PROVIDER_APN',
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

  final _discoverUrl = const String.fromEnvironment(
    'DISCOVER_URL',
    defaultValue: '',
  );
  String get discoverUrl => _discoverUrl;

  final _sentryDSN = const String.fromEnvironment(
    'SENTRY_DSN',
    defaultValue: '',
  );
  String get sentryDSN => _sentryDSN;

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
