import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/firebase_service.dart';
import '../models/order.dart';

class DebugIncomeReportScreen extends StatefulWidget {
  const DebugIncomeReportScreen({super.key});

  @override
  State<DebugIncomeReportScreen> createState() => _DebugIncomeReportScreenState();
}

class _DebugIncomeReportScreenState extends State<DebugIncomeReportScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final NumberFormat currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Income Report'),
      ),
      body: StreamBuilder<List<Order>>(
        stream: _firebaseService.getOrders(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data ?? [];
          
          // Show all orders with their dates for debugging
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return ListTile(
                title: Text('${order.itemName} (${DateFormat('yyyy-MM-dd').format(order.deliveryTime)})'),
                subtitle: Text('ID: ${order.id}, Order Name: ${order.orderName}, Price: ${order.price}, Qty: ${order.quantity}'),
                trailing: Text(currencyFormat.format(order.price * order.quantity)),
              );
            },
          );
        },
      ),
    );
  }
}