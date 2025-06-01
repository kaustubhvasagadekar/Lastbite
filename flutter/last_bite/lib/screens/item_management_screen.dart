import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/firebase_service.dart';
// import '../models/item.dart';

class ItemManagementScreen extends StatefulWidget {
  const ItemManagementScreen({super.key});

  @override
  State<ItemManagementScreen> createState() => _ItemManagementScreenState();
}

class _ItemManagementScreenState extends State<ItemManagementScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isActive = true;
  String? _editingItemId;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _nameController.clear();
    _amountController.clear();
    _isActive = true;
    _editingItemId = null;
  }

  void _editItem(Map<String, dynamic> item) {
    setState(() {
      _editingItemId = item['id'];
      _nameController.text = item['name'];
      _amountController.text = item['amount'].toString();
      _isActive = item['isActive'] ?? true;
    });
  }

  Future<void> _saveItem() async {
    if (_formKey.currentState!.validate()) {
      try {
        final name = _nameController.text.trim();
        final amount = double.parse(_amountController.text);
        
        await _firebaseService.addOrUpdateItem(name, amount, _isActive, _editingItemId);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_editingItemId == null ? 'Item added!' : 'Item updated!')),
          );
          _resetForm();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Management'),
      ),

      body: Column(
        children: [
          // Add/Edit Item Form
          Padding(
            padding: const EdgeInsets.only( left: 16.0, right: 16.0 , top: 30.0 , bottom: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Item Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter item name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: 'Item Amount',
                      border: OutlineInputBorder(),
                      prefixText: '₹ ',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter amount';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Active:'),
                      Switch(
                        value: _isActive,
                        onChanged: (value) {
                          setState(() {
                            _isActive = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _saveItem,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(_editingItemId == null ? 'Add Item' : 'Update Item'),
                  ),
                  if (_editingItemId != null)
                    TextButton(
                      onPressed: _resetForm,
                      child: const Text('Cancel Editing'),
                    ),
                ],
              ),
            ),
          ),
          
          // Item List
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _firebaseService.getItems(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final items = snapshot.data ?? [];
                
                if (items.isEmpty) {
                  return const Center(child: Text('No items added yet'));
                }
                
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      title: Text(item['name'] ?? ''),
                      subtitle: Text('₹ ${item['amount'] ?? 0}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            item['isActive'] == true ? Icons.check_circle : Icons.cancel,
                            color: item['isActive'] == true ? Colors.green : Colors.red,
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editItem(item),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}