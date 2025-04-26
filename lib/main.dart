import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/dashboard_screen.dart';
import 'firebase_options.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screens/add_transaction_screen.dart';


class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getTransactions() async {
    var snapshot = await _firestore.collection('transactions').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const FinanceApp());
}

class FinanceApp extends StatelessWidget {
  const FinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Manager V1',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const DashboardScreen(),
    );
  }
}
