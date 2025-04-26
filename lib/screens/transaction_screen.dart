import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../services/transaction_service.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final TransactionService _txService = TransactionService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final TextEditingController _categoryCtrl = TextEditingController();

  String _selectedType = 'income';

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final tx = TransactionModel(
        id: '',
        amount: double.parse(_amountCtrl.text),
        type: _selectedType,
        description: _descCtrl.text,
        categoryId: _categoryCtrl.text,
        createdAt: DateTime.now(),
      );

      _txService.addTransaction(tx).then((_) {
        _amountCtrl.clear();
        _descCtrl.clear();
        _categoryCtrl.clear();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Transaction added!")));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transactions")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Form(
            key: _formKey,
            child: Column(children: [
              DropdownButtonFormField(
                value: _selectedType,
                items: const [
                  DropdownMenuItem(value: 'income', child: Text('Income')),
                  DropdownMenuItem(value: 'expense', child: Text('Expense')),
                ],
                onChanged: (value) => setState(() => _selectedType = value!),
              ),
              TextFormField(
                controller: _amountCtrl,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: _categoryCtrl,
                decoration: const InputDecoration(labelText: 'Category ID'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(onPressed: _submit, child: const Text("Add")),
            ]),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder<List<TransactionModel>>(
              stream: _txService.getTransactions(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final txs = snapshot.data!;
                return ListView.builder(
                  itemCount: txs.length,
                  itemBuilder: (_, i) {
                    final tx = txs[i];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            tx.type == 'income' ? Colors.green : Colors.red,
                        child: Icon(
                          tx.type == 'income' ? Icons.arrow_downward : Icons.arrow_upward,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(tx.description),
                      subtitle: Text(DateFormat.yMd().format(tx.createdAt)),
                      trailing: Text(
                        "${tx.type == 'income' ? '+' : '-'}\$${tx.amount.toStringAsFixed(2)}",
                        style: TextStyle(
                          color: tx.type == 'income' ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
