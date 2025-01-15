import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      if (message.data.isNotEmpty) {
        PushNotificationService.displayNotification(message);
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


  static Future<void> displayNotification(RemoteMessage message) async {
    final String title = message.data['title'] ?? 'No Title';
    final String body = message.data['body'] ?? 'No Body';

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
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
      importance: Importance.max,
      priority: Priority.max,
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
      title,
      body,
      notificationDetails,
    );
  }


  void _handleNotificationInteraction(
      BuildContext context, RemoteMessage message) {
    if (kDebugMode) print('Notification interaction: ${message.data}');
    if (message.data['type'] == 'chat') {
      // Handle navigation
      // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(chatId: message.data['chatId'])));
    }
  }

  void isTokenRefresh(){
    _messaging.onTokenRefresh.listen((event) async {
      final FirebaseAuth auth = FirebaseAuth.instance;
      await updateFcmTokenOnLogin(auth.currentUser!.uid, event);
    });
  }


  Future<void> updateFcmTokenOnLogin(String uid, String newFcmToken) async {
    try {
      // Reference to the user's document
      DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(uid);

      // Update the fcmToken field
      await userDoc.update({
        'fcmToken': newFcmToken,
      });

      print('FCM Token updated successfully for user: $uid');
    } catch (e) {
      print('Error updating FCM Token for user $uid: $e');
    }
  }

}