import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/firebase_service.dart';

class OrderProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  OrderProvider() {
    // Listen to real-time updates from Firestore
    _firebaseService.getOrders().listen((orders) {
      _orders = orders.cast<Order>();
      notifyListeners();
    });
  }

  Future<void> addOrder(
    String itemName,
    String orderName,
    double price,
    int quantity,
    String category,
    String address,
    String flatNo,
    String mobileNumber,
    DateTime deliveryTime,
    String note,
    bool isPaid,
    bool isDelivered,
  ) async {
    final order = Order(
      id: DateTime.now().toString(),
      itemName: itemName,
      orderName: orderName,
      price: price,
      quantity: quantity,
      category: category,
      date: DateTime.now(),
      address: address,
      flatNo: flatNo,
      mobileNumber: mobileNumber,
      deliveryTime: deliveryTime,
      note: note,
      isPaid: isPaid,
      isDelivered: isDelivered,
    );

    await _firebaseService.addOrder(order);
    // No need to manually update _orders as the stream will handle it
  }

  Future<void> deleteOrder(String id) async {
    await _firebaseService.deleteOrder(id);
    // No need to manually update _orders as the stream will handle it
  }

  Future<void> updateOrder(Order order) async {
    await _firebaseService.updateOrder(order, order.id);
    // No need to manually update _orders as the stream will handle it
  }
}
