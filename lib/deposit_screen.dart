import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      await depositRef.add(data);

      debugPrint("Deposit added successfully!");
    } catch (error) {
      debugPrint("Error adding deposit: $error");
    }
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
