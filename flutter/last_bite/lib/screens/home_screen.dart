import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/order.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseService firebaseService = FirebaseService();

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Last Bite Dashboard'),
      //   elevation: 0,
      // ),
      body: StreamBuilder<List<Order>>(
        stream: firebaseService.getOrders(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data ?? [];
          final pendingOrders =
              orders.where((order) => !order.isDelivered).toList();
          final deliveredOrders =
              orders.where((order) => order.isDelivered).toList();
          final paidOrders = orders.where((order) => order.isPaid).toList();
          final unpaidOrders = orders.where((order) => !order.isPaid).toList();

          // Calculate total revenue
          double totalRevenue = 0;
          for (var order in paidOrders) {
            totalRevenue += order.price;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 60.0, bottom: 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome section
                const Text(
                  'Welcome to Last Bite',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Dashboard Overview',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),

                // Stats cards
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildStatCard(
                      context,
                      'Pending Orders',
                      pendingOrders.length.toString(),
                      Colors.orange,
                      Icons.pending_actions,
                    ),
                    _buildStatCard(
                      context,
                      'Delivered Orders',
                      deliveredOrders.length.toString(),
                      Colors.green,
                      Icons.check_circle_outline,
                    ),
                    _buildStatCard(
                      context,
                      'Total Revenue',
                      '₹${totalRevenue.toStringAsFixed(2)}',
                      Colors.blue,
                      Icons.currency_rupee,
                    ),
                    _buildStatCard(
                      context,
                      'Unpaid Orders',
                      unpaidOrders.length.toString(),
                      Colors.red,
                      Icons.money_off,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Recent orders section
                const Text(
                  'Recent Orders',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Recent orders list
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orders.isEmpty
                      ? 1
                      : orders.length > 5
                          ? 7
                          : orders.length,
                         
                  itemBuilder: (context, index) {
                   
                    if (orders.isEmpty) {
                      return const Card(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 0.0, bottom: 16.0),
                          child: Text('No orders yet'),
                        ),
                      );
                    }

                    final order = orders[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(order.itemName),
                        subtitle: Text('${order.orderName} ${order.flatNo} • ₹${order.price}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              order.isPaid
                                  ? Icons.check_circle
                                  : Icons.money_off,
                              color: order.isPaid ? Colors.green : Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              order.isDelivered
                                  ? Icons.check_circle
                                  : Icons.pending,
                              color: order.isDelivered
                                  ? Colors.green
                                  : Colors.orange,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value,
      Color color, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 12),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
