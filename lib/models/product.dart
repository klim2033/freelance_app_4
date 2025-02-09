class Product {
  final String id;
  final String name;
  final String category;
  final DateTime expirationDate;
  final int quantity;
  final String unit; // e.g., "г", "шт", "мл"

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.expirationDate,
    required this.quantity,
    required this.unit,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'expirationDate': expirationDate.toIso8601String(),
      'quantity': quantity,
      'unit': unit,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      expirationDate: DateTime.parse(map['expirationDate']),
      quantity: map['quantity'],
      unit: map['unit'],
    );
  }

  Product copyWith({
    String? id,
    String? name,
    String? category,
    DateTime? expirationDate,
    int? quantity,
    String? unit,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      expirationDate: expirationDate ?? this.expirationDate,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
    );
  }
}
