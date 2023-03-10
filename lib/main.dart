import 'dart:io';
import 'package:flutter/material.dart' hide MenuItemButton;
import 'package:tray_manager/tray_manager.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';

import "package:github/github.dart";

import 'github_summary.dart';

final _authorizationEndpoint =
    Uri.parse('https://github.com/login/oauth/authorize');
final _tokenEndpoint = Uri.parse('https://github.com/login/oauth/access_token');

const githubClientId = '9c8389a88c2ca804d2ae';
const githubClientSecret = '7e1a7d7cd97bfebb819e90600c0e72c29a2e5b21';

const githubScopes = ['repo', 'read:org'];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppTray.instance.initDataAppTray();
  await windowManager.ensureInitialized();
  const WindowOptions windowOptions = WindowOptions(
    center: false,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );

  windowManager.waitUntilReadyToShow(
    windowOptions,
    () async {
      await windowManager.show();
      await windowManager.focus();
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TrayListener {
  @override
  void initState() {
    trayManager.addListener(this);
    super.initState();
  }

  @override
  void onTrayIconMouseDown() async {
    windowManager.show();
  }

  @override
  void onTrayIconMouseUp() async {
    windowManager.show();
  }

  @override
  void onTrayIconRightMouseDown() async {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayIconRightMouseUp() async {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    AppTray.instance.onTrayMenuItemClick(menuItem);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Github Clone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Github Login',
        builder: (context, httpClient) {
          return FutureBuilder(
              future: viewerDetail(httpClient.credentials.accessToken),
              builder: (context, snapshot) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('Github Login'),
                    elevation: 2,
                  ),
                  body: GitHubSummary(
                    gitHub: GitHub(
                      auth: Authentication.withToken(
                        httpClient.credentials.accessToken,
                      ),
                    ),
                  ),
                );
              });
        },
        githubClientId: githubClientId,
        githubClientSecret: githubClientSecret,
        githubScopes: githubScopes,
      ),
    );
  }
}

Future<CurrentUser> viewerDetail(String accessToken) {
  final gitHub = GitHub(auth: Authentication.withToken(accessToken));
  return gitHub.users.getCurrentUser();
}

typedef AuthenticatedBuilder = Widget Function(
    BuildContext context, oauth2.Client client);

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.builder,
    required this.githubClientId,
    required this.githubClientSecret,
    required this.githubScopes,
  });
  final String title;
  final AuthenticatedBuilder builder;
  final String githubClientId;
  final String githubClientSecret;
  final List<String> githubScopes;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  HttpServer? _redirectServer;
  oauth2.Client? _client;

  @override
  Widget build(BuildContext context) {
    final client = _client;
    if (_client != null) {
      return widget.builder(context, client!);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _redirectServer?.close();
            _redirectServer = await HttpServer.bind("localhost", 0);
            var authenticatedHttpClient = await _getOAuth2Client(
                Uri.parse('http://localhost:${_redirectServer!.port}/auth'));
            setState(() {
              _client = authenticatedHttpClient;
            });
          },
          child: const Text("Login to Github"),
        ),
      ),
    );
  }

  Future<oauth2.Client> _getOAuth2Client(Uri redirectUrl) async {
    if (widget.githubClientId.isEmpty || widget.githubClientSecret.isEmpty) {
      throw Exception("Error");
    }

    var grant = oauth2.AuthorizationCodeGrant(
      widget.githubClientId,
      _authorizationEndpoint,
      _tokenEndpoint,
      secret: widget.githubClientSecret,
      httpClient: _JsonAcceptingHttpClient(),
    );

    var authorizationUrl =
        grant.getAuthorizationUrl(redirectUrl, scopes: widget.githubScopes);

    await _redirect(authorizationUrl);

    var responseQueryParameters = await _listen();
    var client =
        await grant.handleAuthorizationResponse(responseQueryParameters);

    return client;
  }

  Future<void> _redirect(Uri authorizationUrl) async {
    if (await canLaunchUrl(authorizationUrl)) {
      await launchUrl(authorizationUrl);
      await windowManager.focus();
    } else {
      throw Exception('Could not launch $authorizationUrl');
    }
  }

  Future<Map<String, String>> _listen() async {
    var request = await _redirectServer!.first;
    var params = request.uri.queryParameters;
    request.response.statusCode = 200;
    request.response.writeln("Authenticated! You can close this tab");
    await request.response.close();
    await _redirectServer!.close();
    _redirectServer = null;
    return params;
  }
}

class _JsonAcceptingHttpClient extends http.BaseClient {
  final _httpClient = http.Client();
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Accept'] = 'application/json';
    return _httpClient.send(request);
  }
}

class AppTray {
  List<MenuItem> items = [
    MenuItem(
      key: 'show_window',
      label: 'Show Window',
      disabled: false,
    ),
    MenuItem(
      disabled: false,
      checked: true,
      key: 'exit_app',
      label: 'Exit App',
    ),
  ];

  final String iconPath = "assets/icons/zakat.png";

  static final instance = AppTray._internal();

  Future initDataAppTray() async {
    await trayManager.setIcon(iconPath);

    await trayManager.setContextMenu(Menu(items: items));
    await trayManager.popUpContextMenu();
  }

  void onTrayMenuItemClick(MenuItem menuItem) {
    if (menuItem.key == 'show_window') {
      windowManager.show();
    } else if (menuItem.key == 'exit_app') {
      exit(0);
    }
  }

  factory AppTray() {
    return instance;
  }

  AppTray._internal();
}
