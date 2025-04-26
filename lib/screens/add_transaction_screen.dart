import 'package:flutter/material.dart';

class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Transaction')),
      body: const Center(child: Text('Add your transaction form here')),
    );
  }
}
