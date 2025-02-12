import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_accessibility_service/flutter_accessibility_service.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalPlugin = FlutterLocalNotificationsPlugin();
const AndroidNotificationChannel notificationChannel = AndroidNotificationChannel(
  'my-channel-id',
  'my-channel' 
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initService();
  await initAccessabilityService();

  runApp(const MyApp());
}

Future<void> initAccessabilityService() async {
  final bool res = await FlutterAccessibilityService.isAccessibilityPermissionEnabled();

  if (!res) {
    await FlutterAccessibilityService.requestAccessibilityPermission();
  }
}

Future<void> initService() async {
  final service = FlutterBackgroundService();
  await flutterLocalPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(notificationChannel);

  await service.configure(
    iosConfiguration: IosConfiguration(), 
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      notificationChannelId: 'my-channel-id',
      autoStart: true,
      initialNotificationTitle: "Initial Notificiation",
      initialNotificationContent: "Initial Notificiation Content",
      foregroundServiceNotificationId: 90
    )
  );

  service.startService();
}

@pragma("vm:entry-point")
Future<void> onStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  service.on("setAsForeground").listen((event) {
    print("foreground ============>");
  });

  service.on("setAsBackground").listen((event) {
    print("background ============>");
  });

  service.on("stopService").listen((event) {
    service.stopSelf();
  });

  /* Timer.periodic(Duration(seconds: 10), (timer) {
    flutterLocalPlugin.show(
      DateTime.now().microsecond,
      'Nova notificação',
      'Topzera',
      const NotificationDetails(android: AndroidNotificationDetails('my-channel-id', 'my-channel', ongoing: true, icon: 'app_icon'))
    );

    print('Loging');
  });*/
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  DateTime eventDateTime = DateTime.now();
  bool foundSearchField = false;
  bool setText = false;
  bool clickFirstSearch = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(),
      ),
    );
  }
}
