import 'package:flutter/material.dart';
import 'package:last_bite/screens/order_list_screen.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _itemNameController = TextEditingController();
  final _orderNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _addressController = TextEditingController();
  final _flatNoController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _noteController = TextEditingController();
  String _selectedCategory = 'Bakery Item';
  DateTime _selectedDeliveryTime = DateTime.now().add(const Duration(hours: 1));
  bool _isPaid = false;
  bool _isDelivered = false;

  final List<String> _categories = [
    'Bakery Item',
    'Chocklet',
    'Cake',
  ];

  @override
  void dispose() {
    _itemNameController.dispose();
    _orderNameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _addressController.dispose();
    _flatNoController.dispose();
    _mobileNumberController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDeliveryDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDeliveryTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDeliveryTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          _selectedDeliveryTime.hour,
          _selectedDeliveryTime.minute,
        );
      });
    }
  }

  Future<void> _selectDeliveryTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDeliveryTime),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedDeliveryTime = DateTime(
          _selectedDeliveryTime.year,
          _selectedDeliveryTime.month,
          _selectedDeliveryTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Last Bite - Create Order'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.orange.shade50,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order Details',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _itemNameController,
                            decoration: const InputDecoration(
                              labelText: 'Food Item',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a food item';
                              }
                              return null;
                            },
                          ),
                         
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _orderNameController,
                            decoration: const InputDecoration(
                              labelText: 'Order Name',
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _priceController,
                            decoration: const InputDecoration(
                              labelText: 'Price',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a price';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _quantityController,
                            decoration: const InputDecoration(
                              labelText: 'Quantity',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a quantity';
                              }
                              if (int.tryParse(value) == null ||
                                  int.parse(value) <= 0) {
                                return 'Please enter a valid positive number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _addressController,
                            decoration: const InputDecoration(
                              labelText: 'Delivery Address',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a delivery address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _flatNoController,
                            decoration: const InputDecoration(
                              labelText: 'Flat Number',
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _mobileNumberController,
                            decoration: const InputDecoration(
                              labelText: 'Mobile Number',
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a mobile number';
                              }
                              return null;
                            },
                          ),
                             const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _selectedCategory,
                            decoration:
                                const InputDecoration(labelText: 'Category'),
                            items: _categories.map((String category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedCategory = newValue!;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a category';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.orange.shade200),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              children: [
                                ListTile(
                                  title: const Text('Delivery Date'),
                                  subtitle: Text(
                                    '${_selectedDeliveryTime.day}/${_selectedDeliveryTime.month}/${_selectedDeliveryTime.year}',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                  leading: Icon(Icons.calendar_today,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  trailing: Icon(Icons.edit,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                  onTap: _selectDeliveryDate,
                                ),
                                const Divider(height: 1),
                                ListTile(
                                  title: const Text('Delivery Time'),
                                  subtitle: Text(
                                    '${_selectedDeliveryTime.hour}:${_selectedDeliveryTime.minute.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                  leading: Icon(Icons.access_time,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  trailing: Icon(Icons.edit,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                  onTap: _selectDeliveryTime,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _noteController,
                            decoration: const InputDecoration(
                              labelText: 'Note (Special Requirements)',
                            ),
                            maxLines: 2,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              children: [
                                SwitchListTile(
                                  title: const Text('Paid'),
                                  subtitle: Text(_isPaid
                                      ? 'Payment received'
                                      : 'Payment pending'),
                                  secondary: Icon(
                                    _isPaid ? Icons.payment : Icons.money_off,
                                    color: _isPaid ? Colors.green : Colors.grey,
                                  ),
                                  value: _isPaid,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _isPaid = value;
                                    });
                                  },
                                ),
                                const Divider(height: 1),
                                SwitchListTile(
                                  title: const Text('Delivered'),
                                  subtitle: Text(_isDelivered
                                      ? 'Order delivered'
                                      : 'Delivery pending'),
                                  secondary: Icon(
                                    _isDelivered
                                        ? Icons.check_circle
                                        : Icons.delivery_dining,
                                    color: _isDelivered
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                  value: _isDelivered,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _isDelivered = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          await Provider.of<OrderProvider>(context, listen: false)
                              .addOrder(
                            _itemNameController.text,
                            _orderNameController.text,
                            double.parse(_priceController.text),
                            int.parse(_quantityController.text),
                            _selectedCategory,
                            _addressController.text,
                            _flatNoController.text,
                            _mobileNumberController.text,
                            _selectedDeliveryTime,
                            _noteController.text,
                            _isPaid,
                            _isDelivered,
                          );
                        _itemNameController.clear();
                        _orderNameController.clear();
                        _priceController.clear();
                        _quantityController.clear();
                        _addressController.clear();
                        _flatNoController.clear();
                        _mobileNumberController.clear();
                        _noteController.clear();
                        setState(() {
                          _isPaid = false;
                          _isDelivered = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Order added to Last Bite!'),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                        // Navigate to OrderListScreen()
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const OrderListScreen()));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: ${e.toString()}'),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Add to Order'),
                   // set button color to orange
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
