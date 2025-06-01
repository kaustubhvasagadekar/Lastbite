class Order {
  final String id;
  final String itemName;
  final String orderName;
  final double price;
  final int quantity;
  final String category;
  final DateTime date;
  final String address;
  final String flatNo;
  final String mobileNumber;
  final DateTime deliveryTime;
  final String note;
  final bool isPaid;
  final bool isDelivered;

  Order({
    required this.id,
    required this.itemName,
    this.orderName = '',
    required this.price,
    required this.quantity,
    required this.category,
    required this.date,
    required this.address,
    this.flatNo = '',
    required this.mobileNumber,
    required this.deliveryTime,
    this.note = '',
    this.isPaid = false,
    this.isDelivered = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'itemName': itemName,
        'orderName': orderName,
        'price': price,
        'quantity': quantity,
        'category': category,
        'date': date.toIso8601String(),
        'address': address,
        'flatNo': flatNo,
        'mobileNumber': mobileNumber,
        'deliveryTime': deliveryTime.toIso8601String(),
        'note': note,
        'isPaid': isPaid,
        'isDelivered': isDelivered,
      };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'],
        itemName: json['itemName'],
        orderName: json['orderName'] ?? '',
        price: json['price'],
        quantity: json['quantity'],
        category: json['category'],
        date: DateTime.parse(json['date']),
        address: json['address'] ?? '',
        flatNo: json['flatNo'] ?? '',
        mobileNumber: json['mobileNumber'] ?? '',
        deliveryTime: json['deliveryTime'] != null 
            ? DateTime.parse(json['deliveryTime']) 
            : DateTime.now(),
        note: json['note'] ?? '',
        isPaid: json['isPaid'] ?? false,
        isDelivered: json['isDelivered'] ?? false,
      );
}