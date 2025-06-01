import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/firebase_service.dart';
import '../models/order.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'en_IN', symbol: '₹');
  DateTime? _selectedDeliveryDate;
  
  // Controller for the date display
  late TextEditingController _dateController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Last Bite - Order History'),
      ),
      body: StreamBuilder<List<Order>>(
        stream: _firebaseService.getOrders(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text('Something went wrong: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data ?? [];

          if (orders.isEmpty) {
            return const Center(child: Text('No orders yet at Last Bite!'));
          }

          // Separate orders into not delivered and delivered
          final notDeliveredOrders =
              orders.where((order) => !order.isDelivered).toList();
          final deliveredOrders =
              orders.where((order) => order.isDelivered).toList();

          return ListView(
            children: [
              // Not Delivered Orders Section
              if (notDeliveredOrders.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Not Delivered Orders',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ...notDeliveredOrders.map((order) => Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(order.itemName,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        subtitle: Text('Order Name: ${order.orderName}\n'
                            'Address: ${order.address}\n'
                            'Flat No: ${order.flatNo}\n'
                            'Quantity: ${order.quantity}\n'
                            'Price: ${currencyFormat.format(order.price)}\n'
                            'Mobile: ${order.mobileNumber}\n'
                            'Category: ${order.category}\n'
                            '${order.note.isNotEmpty ? 'Note: ${order.note}\n' : ''}'
                            'Payment: ${order.isPaid ? "Paid" : "Not Paid"}\n'
                            'Status: ${order.isDelivered ? "Delivered" : "Not Delivered"}\n'
                            'Delivery Date: ${DateFormat('dd/MM/yyyy').format(order.deliveryTime)}\n'
                            'Delivery Time: ${DateFormat.jm().format(order.deliveryTime)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _selectedDeliveryDate = null;
                                _showEditDialog(context, order);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                // Show confirmation dialog
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Delete Order'),
                                    content: const Text(
                                        'Are you sure you want to delete this order?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(ctx).pop(),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _firebaseService
                                              .deleteOrder(order.id);
                                          Navigator.of(ctx).pop();
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
              
              // Delivered Orders Section
              if (deliveredOrders.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Delivered Orders',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ...deliveredOrders.map((order) => Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(order.itemName,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        subtitle: Text('Order Name: ${order.orderName}\n'
                            'Address: ${order.address}\n'
                            'Flat No: ${order.flatNo}\n'
                            'Quantity: ${order.quantity}\n'
                            'Price: ${currencyFormat.format(order.price)}\n'
                            'Mobile: ${order.mobileNumber}\n'
                            'Category: ${order.category}\n'
                            '${order.note.isNotEmpty ? 'Note: ${order.note}\n' : ''}'
                            'Payment: ${order.isPaid ? "Paid" : "Not Paid"}\n'
                            'Status: ${order.isDelivered ? "Delivered" : "Not Delivered"}\n'
                            'Delivery Date: ${DateFormat('dd/MM/yyyy').format(order.deliveryTime)}\n'
                            'Delivery Time: ${DateFormat.jm().format(order.deliveryTime)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _selectedDeliveryDate = null;
                                _showEditDialog(context, order);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                // Show confirmation dialog
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Delete Order'),
                                    content: const Text(
                                        'Are you sure you want to delete this order?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(ctx).pop(),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _firebaseService
                                              .deleteOrder(order.id);
                                          Navigator.of(ctx).pop();
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            ],
          );
        },
      ),
    );
  }
  
  // Extracted method to show edit dialog
  void _showEditDialog(BuildContext context, Order order) {
    final TextEditingController itemNameController =
        TextEditingController(text: order.itemName);
    final TextEditingController orderNameController = 
        TextEditingController(text: order.orderName);
    final TextEditingController priceController =
        TextEditingController(text: order.price.toString());
    final TextEditingController quantityController =
        TextEditingController(text: order.quantity.toString());
    final TextEditingController categoryController =
        TextEditingController(text: order.category);
    final TextEditingController addressController =
        TextEditingController(text: order.address);
    final TextEditingController flatNoController =
        TextEditingController(text: order.flatNo);
    final TextEditingController mobileNumberController =
        TextEditingController(text: order.mobileNumber);
    final TextEditingController noteController =
        TextEditingController(text: order.note);
    final TextEditingController deliveryTimeController =
        TextEditingController(
            text: DateFormat.jm(Localizations.localeOf(context).toString())
                .format(order.deliveryTime));
    
    // Initialize date controller with current delivery date
    _dateController = TextEditingController(
      text: "${order.deliveryTime.day}/${order.deliveryTime.month}/${order.deliveryTime.year}"
    );
    
    bool isPaid = order.isPaid;
    bool isDelivered = order.isDelivered;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Edit Order'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                      controller: itemNameController,
                      decoration: const InputDecoration(labelText: 'Item Name')),
                  TextField(
                      controller: orderNameController,
                      decoration: const InputDecoration(labelText: 'Order Name')),
                  TextField(
                      controller: priceController,
                      decoration: const InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.numberWithOptions(decimal: true)),
                  TextField(
                      controller: quantityController,
                      decoration: const InputDecoration(labelText: 'Quantity'),
                      keyboardType: TextInputType.number),
                  TextField(
                      controller: categoryController,
                      decoration: const InputDecoration(labelText: 'Category')),
                  TextField(
                      controller: addressController,
                      decoration: const InputDecoration(labelText: 'Address')),
                  TextField(
                      controller: flatNoController,
                      decoration: const InputDecoration(labelText: 'Flat No')),
                  TextField(
                      controller: mobileNumberController,
                      decoration: const InputDecoration(labelText: 'Mobile Number'),
                      keyboardType: TextInputType.phone),
                  TextField(
                      controller: noteController,
                      decoration: const InputDecoration(labelText: 'Note')),
                  
                  // Paid/Delivered toggles
                  Row(
                    children: [
                      const Text('Paid: '),
                      Switch(
                        value: isPaid,
                        onChanged: (value) {
                          setState(() {
                            isPaid = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Delivered: '),
                      Switch(
                        value: isDelivered,
                        onChanged: (value) {
                          setState(() {
                            isDelivered = value;
                          });
                        },
                      ),
                    ],
                  ),
                  
                  // Date picker with live update
                  TextField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                      labelText: 'Delivery Date',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () async {
                      // Set initialDate to today or the order date if it's in the future
                      DateTime now = DateTime.now();
                      DateTime initialDate = _selectedDeliveryDate ?? 
                          (order.deliveryTime.isAfter(now) ? order.deliveryTime : now);
                          
                      final DateTime? pickedDate = await showDatePicker(
                        context: ctx,
                        initialDate: initialDate,
                        firstDate: now, // Only allow future dates
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );

                      if (pickedDate != null) {
                        // Create the updated delivery date
                        final newDeliveryDate = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          order.deliveryTime.hour,
                          order.deliveryTime.minute,
                        );

                        // Store the date and update the UI
                        _selectedDeliveryDate = newDeliveryDate;
                        setState(() {
                          _dateController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                        });
                      }
                    },
                  ),
                  
                  // Time picker
                  TextField(
                    controller: deliveryTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Delivery Time',
                      suffixIcon: Icon(Icons.access_time),
                    ),
                    readOnly: true,
                    onTap: () async {
                      TimeOfDay initialTime = TimeOfDay.now();
                      final String localeString = Localizations.localeOf(ctx).toString();
                      if (deliveryTimeController.text.isNotEmpty) {
                        try {
                          // Try parsing locale-specific time (e.g., "2:30 PM" or "14:30")
                          DateTime parsedDateTime = DateFormat.jm(localeString)
                              .parseLoose(deliveryTimeController.text);
                          initialTime = TimeOfDay.fromDateTime(parsedDateTime);
                        } catch (_) {
                          try {
                            // Fallback to HH:mm if jm fails
                            DateTime parsedDateTime = DateFormat.Hm(localeString)
                                .parseLoose(deliveryTimeController.text);
                            initialTime = TimeOfDay.fromDateTime(parsedDateTime);
                          } catch (e) {
                            // If parsing fails, default to now
                            print('Error parsing delivery time: ${deliveryTimeController.text}, $e');
                            initialTime = TimeOfDay.now();
                          }
                        }
                      }
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: ctx,
                        initialTime: initialTime,
                      );
                      if (pickedTime != null) {
                        setState(() {
                          deliveryTimeController.text = pickedTime.format(ctx);
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // Create the updated order
                  final double newPrice = double.tryParse(priceController.text) ?? order.price;
                  final int newQuantity = int.tryParse(quantityController.text) ?? order.quantity;
                  final String newOrderName = orderNameController.text;
                  final String newFlatNo = flatNoController.text;
                  final String newNote = noteController.text;

                  // Use the selected date if available, otherwise use the original delivery time
                  DateTime selectedDate = _selectedDeliveryDate ?? order.deliveryTime;

                  // Parse the deliveryTimeController.text back to DateTime
                  DateTime newDeliveryTime = selectedDate;
                  if (deliveryTimeController.text.isNotEmpty) {
                    try {
                      final String localeStr = Localizations.localeOf(ctx).toString();
                      TimeOfDay parsedTimeOfDay;
                      // Attempt to parse with locale-specific AM/PM format first
                      try {
                        DateTime parsedGenericTime = DateFormat.jm(localeStr)
                            .parseLoose(deliveryTimeController.text);
                        parsedTimeOfDay = TimeOfDay.fromDateTime(parsedGenericTime);
                      } catch (_) {
                        // Fallback to HH:mm format if AM/PM parsing fails
                        DateTime parsedGenericTime = DateFormat.Hm(localeStr)
                            .parseLoose(deliveryTimeController.text);
                        parsedTimeOfDay = TimeOfDay.fromDateTime(parsedGenericTime);
                      }

                      // Combine the parsed time with the date part of the current delivery time
                      newDeliveryTime = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        parsedTimeOfDay.hour,
                        parsedTimeOfDay.minute,
                      );
                    } catch (e) {
                      print('Error parsing delivery time string for saving: "${deliveryTimeController.text}". Error: $e. Using original delivery time.');
                      newDeliveryTime = selectedDate;
                    }
                  }

                  final updatedOrder = Order(
                    id: order.id,
                    itemName: itemNameController.text,
                    orderName: newOrderName,
                    price: newPrice,
                    quantity: newQuantity,
                    category: categoryController.text,
                    address: addressController.text,
                    flatNo: newFlatNo,
                    mobileNumber: mobileNumberController.text,
                    date: order.date,
                    deliveryTime: newDeliveryTime,
                    note: newNote,
                    isPaid: isPaid,
                    isDelivered: isDelivered,
                  );

                  // Pass both the updated order and its ID to the updateOrder method
                  _firebaseService.updateOrder(updatedOrder, updatedOrder.itemName);

                  // Reset the selected delivery date
                  _selectedDeliveryDate = null;

                  Navigator.of(ctx).pop();
                },
                child: const Text('Update'),
              ),
            ],
          );
        }
      ),
    );
  }
}