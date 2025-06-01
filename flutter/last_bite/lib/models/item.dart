class Item {
  final String id;
  final String name;
  final double amount;
  final bool isActive;

  Item({
    this.id = '',
    required this.name,
    required this.amount,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'amount': amount,
    'isActive': isActive,
  };

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    isActive: json['isActive'] ?? true,
  );
}