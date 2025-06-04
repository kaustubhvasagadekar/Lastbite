import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
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

  // Helper to build TextFormFields in the dialog
  Widget _buildTextFormField(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int? maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          filled: true,
          fillColor: readOnly ? Colors.grey[200] : Colors.white,
          suffixIcon: suffixIcon,
        ),
        keyboardType: keyboardType,
        validator: validator,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Last Bite - Order History'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Order>>(
        stream: _firebaseService.getOrders(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text('Error loading orders: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final allOrders = snapshot.data ?? [];

          if (allOrders.isEmpty) {
            return const Center(child: Text('No orders yet at Last Bite!'));
          }

          // Separate orders into not delivered and delivered
          final notDeliveredOrders =
              allOrders.where((order) => !order.isDelivered).toList();
          final deliveredOrders =
              allOrders.where((order) => order.isDelivered).toList();

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            children: [
              _buildOrderSection(context, 'Pending Delivery', notDeliveredOrders),
              if (notDeliveredOrders.isNotEmpty && deliveredOrders.isNotEmpty)
                const Divider(height: 24, thickness: 1, indent: 16, endIndent: 16),
              _buildOrderSection(context, 'Delivered Orders', deliveredOrders),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOrderSection(BuildContext context, String title, List<Order> orders) {
    if (orders.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary),
          ),
        ),
        ...orders.map((order) => _buildOrderListItem(context, order)),
      ],
    );
  }

  Widget _buildOrderListItem(BuildContext context, Order order) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color secondaryColor = Theme.of(context).colorScheme.secondary;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    order.itemName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: primaryColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: secondaryColor, size: 22),
                      onPressed: () => _showEditOrderDialog(context, order),
                      tooltip: 'Edit Order',
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red[600], size: 22),
                      onPressed: () => _showDeleteConfirmationDialog(context, order.id, order.itemName),
                      tooltip: 'Delete Order',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Customer: ${order.orderName}', style: const TextStyle(fontSize: 14)),
            if (order.flatNo.isNotEmpty)
              Text('Flat: ${order.flatNo}', style: const TextStyle(fontSize: 14)),
            Text('Address: ${order.address}', style: const TextStyle(fontSize: 14)),
               Text('Contact:', style: const TextStyle(fontSize: 14)),
            InkWell(
              onTap: () => _launchPhoneDialer(context, order.mobileNumber),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0), // Add some padding for better tap target
                child: Text(
                  order.mobileNumber,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text('Qty: ${order.quantity}', style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 12),
                Text(
                    'Total: ${currencyFormat.format(order.price )}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
            if (order.category.isNotEmpty)
              Text('Category: ${order.category}', style: const TextStyle(fontSize: 14)),
            if (order.note.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text('Note: ${order.note}',
                    style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[700])),
              ),
            const SizedBox(height: 10),
            Row(
              children: [
                Chip(
                  avatar: Icon(
                      order.isPaid ? Icons.check_circle : Icons.cancel_outlined,
                      color: order.isPaid ? Colors.green.shade700 : Colors.red.shade700,
                      size: 18),
                  label: Text(order.isPaid ? 'Paid' : 'Unpaid',
                      style: TextStyle(fontSize: 12, color: order.isPaid ? Colors.green.shade700 : Colors.red.shade700, fontWeight: FontWeight.w500)),
                  backgroundColor: order.isPaid ? Colors.green.shade100 : Colors.red.shade100,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                ),
                const SizedBox(width: 8),
                Chip(
                  avatar: Icon(
                      order.isDelivered ? Icons.local_shipping : Icons.pending_actions,
                      color: order.isDelivered ? Colors.blue.shade700 : Colors.orange.shade700,
                      size: 18),
                  label: Text(order.isDelivered ? 'Delivered' : 'Pending',
                      style: TextStyle(fontSize: 12, color: order.isDelivered ? Colors.blue.shade700 : Colors.orange.shade700, fontWeight: FontWeight.w500)),
                  backgroundColor: order.isDelivered ? Colors.blue.shade100 : Colors.orange.shade100,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
                'Delivery: ${DateFormat('EEE, MMM d, yyyy hh:mm a').format(order.deliveryTime)}',
                style: TextStyle(fontSize: 13, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Future<void> _launchPhoneDialer(BuildContext context, String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber.replaceAll(RegExp(r'\s+|-'), ''), // Sanitize phone number
  );
  try {
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch dialer for $phoneNumber. Please ensure you have a calling app.')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error launching dialer: $e')),
    );
  }
}

  void _showDeleteConfirmationDialog(BuildContext context, String orderId, String itemName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Order'),
        content: Text('Are you sure you want to delete the order for "$itemName"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              _firebaseService.deleteOrder(orderId);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Order "$itemName" deleted.'),
                    backgroundColor: Colors.red),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEditOrderDialog(BuildContext outerContext, Order originalOrder) {
    final formKey = GlobalKey<FormState>();

    final itemNameController = TextEditingController(text: originalOrder.itemName);
    final orderNameController = TextEditingController(text: originalOrder.orderName);
    final priceController = TextEditingController(text: originalOrder.price.toString());
    final quantityController = TextEditingController(text: originalOrder.quantity.toString());
    final categoryController = TextEditingController(text: originalOrder.category);
    final addressController = TextEditingController(text: originalOrder.address);
    final flatNoController = TextEditingController(text: originalOrder.flatNo);
    final mobileNumberController = TextEditingController(text: originalOrder.mobileNumber);
    final noteController = TextEditingController(text: originalOrder.note);

    bool currentIsPaid = originalOrder.isPaid;
    bool currentIsDelivered = originalOrder.isDelivered;
    DateTime currentDeliveryDateTime = originalOrder.deliveryTime;

    final deliveryDateDisplayController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(currentDeliveryDateTime),
    );
    final deliveryTimeDisplayController = TextEditingController(
      text: DateFormat.jm(Localizations.localeOf(outerContext).toString()).format(currentDeliveryDateTime),
    );

    showDialog(
      context: outerContext,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Edit Order: ${originalOrder.itemName}'),
          contentPadding: const EdgeInsets.all(20),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
              return SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildTextFormField(itemNameController, 'Item Name',
                          validator: (val) => val == null || val.isEmpty ? 'Item name is required' : null),
                      _buildTextFormField(orderNameController, 'Customer Name',
                          validator: (val) => val == null || val.isEmpty ? 'Customer name is required' : null),
                      _buildTextFormField(priceController, 'Price (per unit)',
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: (val) {
                            if (val == null || val.isEmpty) return 'Price is required';
                            if (double.tryParse(val) == null) return 'Invalid price format';
                            if (double.parse(val) <= 0) return 'Price must be positive';
                            return null;
                          }),
                      _buildTextFormField(quantityController, 'Quantity',
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val == null || val.isEmpty) return 'Quantity is required';
                            if (int.tryParse(val) == null) return 'Invalid quantity format';
                            if (int.parse(val) <= 0) return 'Quantity must be positive';
                            return null;
                          }),
                      _buildTextFormField(categoryController, 'Category'),
                      _buildTextFormField(addressController, 'Delivery Address',
                          validator: (val) => val == null || val.isEmpty ? 'Address is required' : null),
                      _buildTextFormField(flatNoController, 'Flat/House No.'),
                      _buildTextFormField(mobileNumberController, 'Mobile Number',
                          keyboardType: TextInputType.phone,
                          validator: (val) => val == null || val.isEmpty ? 'Mobile number is required' : null),
                      _buildTextFormField(noteController, 'Note (Special Requirements)', maxLines: 2),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Paid'),
                        value: currentIsPaid,
                        onChanged: (value) => setDialogState(() => currentIsPaid = value),
                        secondary: Icon(currentIsPaid ? Icons.check_circle : Icons.money_off_csred_outlined,
                            color: currentIsPaid ? Colors.green : Colors.grey),
                        contentPadding: EdgeInsets.zero,
                      ),
                      SwitchListTile(
                        title: const Text('Delivered'),
                        value: currentIsDelivered,
                        onChanged: (value) => setDialogState(() => currentIsDelivered = value),
                        secondary: Icon(currentIsDelivered ? Icons.local_shipping : Icons.pending_actions,
                            color: currentIsDelivered ? Colors.green : Colors.grey),
                        contentPadding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        deliveryDateDisplayController, 'Delivery Date',
                        readOnly: true,
                        suffixIcon: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: dialogContext,
                            initialDate: currentDeliveryDateTime,
                            firstDate: DateTime.now().subtract(const Duration(days: 30)), // Allow some past dates for correction
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (pickedDate != null) {
                            setDialogState(() {
                              currentDeliveryDateTime = DateTime(
                                pickedDate.year, pickedDate.month, pickedDate.day,
                                currentDeliveryDateTime.hour, currentDeliveryDateTime.minute,
                              );
                              deliveryDateDisplayController.text = DateFormat('dd/MM/yyyy').format(currentDeliveryDateTime);
                            });
                          }
                        },
                      ),
                      _buildTextFormField(
                        deliveryTimeDisplayController, 'Delivery Time',
                        readOnly: true,
                        suffixIcon: const Icon(Icons.access_time),
                        onTap: () async {
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: dialogContext,
                            initialTime: TimeOfDay.fromDateTime(currentDeliveryDateTime),
                          );
                          if (pickedTime != null) {
                            setDialogState(() {
                              currentDeliveryDateTime = DateTime(
                                currentDeliveryDateTime.year, currentDeliveryDateTime.month, currentDeliveryDateTime.day,
                                pickedTime.hour, pickedTime.minute,
                              );
                              deliveryTimeDisplayController.text = pickedTime.format(dialogContext);
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Theme.of(outerContext).colorScheme.primary),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final updatedOrder = Order(
                    id: originalOrder.id,
                    itemName: itemNameController.text,
                    orderName: orderNameController.text,
                    price: double.parse(priceController.text),
                    quantity: int.parse(quantityController.text),
                    category: categoryController.text,
                    address: addressController.text,
                    flatNo: flatNoController.text,
                    mobileNumber: mobileNumberController.text,
                    date: originalOrder.date, // Order creation date
                    deliveryTime: currentDeliveryDateTime,
                    note: noteController.text,
                    isPaid: currentIsPaid,
                    isDelivered: currentIsDelivered,
                  );

                  // Pass both the updated Order object and the original order's ID
                  _firebaseService.updateOrder(updatedOrder, originalOrder.id).then((_) {
                     ScaffoldMessenger.of(outerContext).showSnackBar(
                      SnackBar(
                          content: Text('Order "${updatedOrder.itemName}" updated successfully!'),
                          backgroundColor: Colors.green),
                    );
                  }).catchError((error) {
                     ScaffoldMessenger.of(outerContext).showSnackBar(
                      SnackBar(
                          content: Text('Failed to update order: $error'),
                          backgroundColor: Colors.red),
                    );
                  });
                  Navigator.of(dialogContext).pop();
                }
              },
              child: const Text('Update', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
