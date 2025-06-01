import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/firebase_service.dart';
import '../models/order.dart';

class IncomeReportScreen extends StatefulWidget {
  const IncomeReportScreen({super.key});

  @override
  State<IncomeReportScreen> createState() => _IncomeReportScreenState();
}

class _IncomeReportScreenState extends State<IncomeReportScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'en_IN', symbol: '₹');

  // Selected date range
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Income Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: () => _selectDateRange(context),
          ),
        ],
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

          // Filter orders by date range and paid status
          final filteredOrders = orders.where((order) {
            final orderDate = order.deliveryTime;
            print(orderDate);
            return orderDate.isAfter(_startDate.subtract(const Duration(days: 1))) &&
                orderDate.isBefore(_endDate.add(const Duration(days: 31)));
          }).toList();

          // Group orders by date
          final Map<String, List<Order>> ordersByDate = {};
          double totalIncome = 0;

          for (var order in filteredOrders) {
            final dateStr = DateFormat('yyyy-MM-dd').format(order.deliveryTime);
            ordersByDate.putIfAbsent(dateStr, () => []).add(order);
            totalIncome += order.price;;
          }

          // Sort dates in descending order
          final sortedDates = ordersByDate.keys.toList()
            ..sort((a, b) => b.compareTo(a));

          if (filteredOrders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No income data for the selected period'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _selectDateRange(context),
                    child: const Text('Change Date Range'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Income from ${DateFormat('MMM d, yyyy').format(_startDate)} to ${DateFormat('MMM d, yyyy').format(_endDate)}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: sortedDates.length,
                  itemBuilder: (context, index) {
                    final date = sortedDates[index];
                    final dateOrders = ordersByDate[date]!;

                    // Calculate total for this date
                    double dateTotal = 0;
                    for (var order in dateOrders) {
                      dateTotal += order.price;
                    }

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ExpansionTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('MMM d, yyyy')
                                  .format(DateTime.parse(date)),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              currencyFormat.format(dateTotal),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: dateOrders.length,
                            itemBuilder: (context, orderIndex) {
                              final order = dateOrders[orderIndex];
                              return ListTile(
                                title: Text(order.flatNo),
                                subtitle:
                                    Text(currencyFormat.format(order.price)),
                                trailing:
                                    Text(currencyFormat.format(order.price)),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Income:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      currencyFormat.format(totalIncome),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }
}
