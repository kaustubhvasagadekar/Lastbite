import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import '../models/order.dart';

class FirebaseService {
  final firestore.CollectionReference _ordersCollection = 
      firestore.FirebaseFirestore.instance.collection('orders');
  final firestore.CollectionReference _itemsCollection = 
      firestore.FirebaseFirestore.instance.collection('items');

  // Add a new order to Firestore
  Future<String> addOrder(Order order) async {
    try {
      final docRef = await _ordersCollection.add({
        'itemName': order.itemName,
        'orderName': order.orderName,
        'price': order.price,
        'quantity': order.quantity,
        'category': order.category,
        'date': firestore.Timestamp.fromDate(order.date),
        'address': order.address,
        'flatNo': order.flatNo,
        'mobileNumber': order.mobileNumber,
        'deliveryTime': firestore.Timestamp.fromDate(order.deliveryTime),
        'note': order.note,
        'isPaid': order.isPaid,
        'isDelivered': order.isDelivered,
      });
      return docRef.id;
    } catch (e) {
      print('Error adding order: $e');
      throw e;
    }
  }

  // Get stream of orders for real-time updates
  Stream<List<Order>> getOrders() {
    return _ordersCollection
        .orderBy('date', descending: true)
        .snapshots()
        .map((firestore.QuerySnapshot snapshot) {
      return snapshot.docs.map((firestore.QueryDocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        // Convert Firestore Timestamp to DateTime
        final date = (data['date'] as firestore.Timestamp).toDate();
        final deliveryTime = data['deliveryTime'] != null 
            ? (data['deliveryTime'] as firestore.Timestamp).toDate()
            : DateTime.now();
            
        return Order.fromJson({
          ...data,
          'id': doc.id,
          'date': date.toIso8601String(),
          'deliveryTime': deliveryTime.toIso8601String(),
        });
      }).toList();
    });
  }

  // Get all items with their amounts
  Future<Map<String, double>> getAllItemAmounts() async {
    try {
      final querySnapshot = await _itemsCollection.get();
      final Map<String, double> itemAmounts = {};
      
      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final name = data['name'] as String;
        final amount = (data['amount'] as num).toDouble();
        itemAmounts[name] = amount;
      }
      
      return itemAmounts;
    } catch (e) {
      print('Error getting item amounts: $e');
      return {};
    }
  }
  
  // Add or update an item
  Future<void> addOrUpdateItem(String name, double amount, bool isActive, [String? id]) async {
    try {
      final data = {
        'name': name,
        'amount': amount,
        'isActive': isActive,
      };
      
      if (id != null && id.isNotEmpty) {
        await _itemsCollection.doc(id).update(data);
      } else {
        await _itemsCollection.add(data);
      }
    } catch (e) {
      print('Error adding/updating item: $e');
      throw e;
    }
  }
  
  // Get all items
  Stream<List<Map<String, dynamic>>> getItems() {
    return _itemsCollection
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return {
              'name': data['name'] ?? '',
              'amount': data['amount'] ?? 0.0,
              'isActive': data['isActive'] ?? true,
              'id': doc.id,
            };
          }).toList();
        });
  }

  // Update an existing order
  Future<void> updateOrder(Order order, String itemName) async {
    try {
      await _ordersCollection.doc(order.id).update({
        'itemName': order.itemName,
        'orderName': order.orderName,
        'price': order.price,
        'quantity': order.quantity,
        'category': order.category,
        'date': firestore.Timestamp.fromDate(order.date),
        'address': order.address,
        'flatNo': order.flatNo,
        'mobileNumber': order.mobileNumber,
        'deliveryTime': firestore.Timestamp.fromDate(order.deliveryTime),
        'note': order.note,
        'isPaid': order.isPaid,
        'isDelivered': order.isDelivered,
      });
    } catch (e) {
      print('Error updating order: $e');
      throw e;
    }
  }

  // Delete an order
  Future<void> deleteOrder(String orderId) async {
    try {
      await _ordersCollection.doc(orderId).delete();
    } catch (e) {
      print('Error deleting order: $e');
      throw e;
    }
  }
}