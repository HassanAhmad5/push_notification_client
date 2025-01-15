import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notification_client/server_key.dart';
import 'package:http/http.dart' as http;

class DepositScreen extends StatelessWidget {
  const DepositScreen({Key? key}) : super(key: key);

  Future<void> addDeposit() async {
    try {
      // Get the current user's ID
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("No user is logged in");
      }

      final userId = user.uid;

      // Reference to the user's document in Firestore
      final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);

      // Subcollection reference for 'Deposit'
      final depositRef = userDoc.collection('Deposit');

      // Data to add
      final data = {
        'amount': 5000, // Example amount
        'timestamp': FieldValue.serverTimestamp(),
        'number': '1234567890', // Example number
        'status': 'pending',
      };

      // Add the data to the subcollection
      await depositRef.add(data).then((_) async {
          await fetchFcmToken().then((adminFcm) {
            _sendNotification(adminFcm!, "New Deposit From User");
          });
      });

      debugPrint("Deposit added successfully!");
    } catch (error) {
      debugPrint("Error adding deposit: $error");
    }
  }

  Future<String?> fetchFcmToken() async {
    try {
      // Reference to the Admin collection
      CollectionReference adminCollection = FirebaseFirestore.instance.collection('Admin');

      // Fetch all documents in the Admin collection
      QuerySnapshot querySnapshot = await adminCollection.get();

      if (querySnapshot.docs.isNotEmpty) {
        // Access the first document in the collection
        DocumentSnapshot adminDoc = querySnapshot.docs.first;

        // Extract the fcmToken field
        String? fcmToken = adminDoc.get('fcmToken'); // Use 'get' to fetch the field
        print('FCM Token: $fcmToken');
        return fcmToken;
      } else {
        print('No documents found in the Admin collection.');
        return null;
      }
    } catch (e) {
      print('Error fetching FCM token: $e');
      return null;
    }
  }

  Future<void> _sendNotification(String fcmToken, String notificationMessage) async {
    final get = get_server_key();
    await get.server_token().then((value) async {
      String serverKey =
          value; // Replace with your Firebase Server Key
      print("Server: $serverKey");


      final Uri url = Uri.parse('https://fcm.googleapis.com/v1/projects/push-notification-7073c/messages:send');

      final message = {
        "message": {
          "token": fcmToken,
          "data": {
            "title": "New Deposit",
            "body": "New Deposit from User"
          }
        }
      };

      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $serverKey',
          },
          body: jsonEncode(message),
        );

        if (response.statusCode == 200) {
          debugPrint('Notification sent successfully.');
        } else {
          debugPrint('Error sending notification: ${response.body}');
        }
      } catch (e) {
        debugPrint('Exception sending notification: $e');
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deposit Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await addDeposit();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Deposit added successfully!')),
            );
          },
          child: const Text('Deposit'),
        ),
      ),
    );
  }
}
