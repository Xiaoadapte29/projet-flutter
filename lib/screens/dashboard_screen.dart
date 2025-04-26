import 'package:flutter/material.dart';
import '../services/transaction_service.dart';
import 'transaction_screen.dart';
import 'category_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TransactionService _txService = TransactionService();
  double totalIncome = 0;
  double totalExpense = 0;

  double get balance => totalIncome - totalExpense;

  @override
  void initState() {
    super.initState();
    _loadTotals();
  }

  Future<void> _loadTotals() async {
    final income = await _txService.getTotal('income');
    final expense = await _txService.getTotal('expense');
    setState(() {
      totalIncome = income;
      totalExpense = expense;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.account_balance_wallet, color: Colors.blue),
                title: const Text("Balance"),
                trailing: Text(
                  "\$${balance.toStringAsFixed(2)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.arrow_downward, color: Colors.green),
                title: const Text("Total Income"),
                trailing: Text("\$${totalIncome.toStringAsFixed(2)}"),
              ),
            ),
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.arrow_upward, color: Colors.red),
                title: const Text("Total Expense"),
                trailing: Text("\$${totalExpense.toStringAsFixed(2)}"),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.list),
              label: const Text("View Transactions"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TransactionScreen()),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.category),
              label: const Text("Manage Categories"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CategoryScreen()),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadTotals,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
