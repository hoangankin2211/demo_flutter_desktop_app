import 'dart:io';

import 'package:flutter/material.dart' hide MenuItemButton;
import 'package:tray_manager/tray_manager.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:window_manager/window_manager.dart';

final _authorizationEndpoint =
    Uri.parse('https://github.com/login/oauth/authorize');
final _tokenEndpoint = Uri.parse('https://github.com/login/oauth/access_token');

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
      home: const MyHomePage(title: 'Github Login'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  HttpServer? _redirectServer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {},
          child: const Text("Login to Github"),
        ),
      ),
    );
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
