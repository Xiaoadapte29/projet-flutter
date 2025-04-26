import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/category_service.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final CategoryService _catService = CategoryService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final cat = Category(
        id: '',
        name: _nameCtrl.text,
        description: _descCtrl.text,
        createdAt: DateTime.now(),
      );

      _catService.addCategory(cat).then((_) {
        _nameCtrl.clear();
        _descCtrl.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Category added!")),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Categories")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (val) => val!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(onPressed: _submit, child: const Text("Add")),
            ]),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder<List<Category>>(
              stream: _catService.getCategories(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final cats = snapshot.data!;
                return ListView.builder(
                  itemCount: cats.length,
                  itemBuilder: (_, i) {
                    final cat = cats[i];
                    return ListTile(
                      title: Text(cat.name),
                      subtitle: Text(cat.description),
                      trailing: Text(cat.createdAt.toString().split(' ')[0]),
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
