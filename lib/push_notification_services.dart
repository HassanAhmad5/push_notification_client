import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initialize(BuildContext context) async {
    // Request notification permissions
    await requestNotificationPermission();

    // Initialize local notifications
    _initializeLocalNotifications();

    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        // Check for duplicates and handle foreground notifications
        _handleForegroundNotification(context, message);
      }
    });

    // Handle notification interactions in the background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleNotificationInteraction(context, message);
    });

    // Handle notifications when the app is terminated
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationInteraction(context, initialMessage);
    }
  }

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) print('User granted notification permission.');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) print('User granted provisional notification permission.');
    } else {
      if (kDebugMode) print('User denied notification permission.');
    }
  }

  void _initializeLocalNotifications() {
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInitializationSettings =
    DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        if (kDebugMode) print('Notification clicked: ${response.payload}');
      },
    );
  }

  void _handleForegroundNotification(
      BuildContext context, RemoteMessage message) {
    if (message.notification != null) {
      _showNotification(message);
    }
  }

  static Future<void> displayNotification(RemoteMessage message) async {
    // Prevent duplicate notifications
    if (message.notification?.title == null && message.notification?.body == null) {
      return;
    }

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // Unique ID
      'High Importance Notifications', // Channel name
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
      playSound: true,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
      notificationDetails,
    );
  }

  Future<void> _showNotification(RemoteMessage message) async {
    displayNotification(message);
  }

  void _handleNotificationInteraction(
      BuildContext context, RemoteMessage message) {
    if (kDebugMode) print('Notification interaction: ${message.data}');
    if (message.data['type'] == 'chat') {
      // Handle navigation
      // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(chatId: message.data['chatId'])));
    }
  }
}
