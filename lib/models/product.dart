class Product {
  final int? id;
  final String code;
  final String name;
  final String category;
  final String description;
  final String brand;
  final String model;
  final String status;
  final int quantity;

  Product({
    this.id,
    required this.code,
    required this.name,
    required this.category,
    required this.description,
    required this.brand,
    required this.model,
    required this.status,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'category': category,
      'description': description,
      'brand': brand,
      'model': model,
      'status': status,
      'quantity': quantity,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      code: map['code'],
      name: map['name'],
      category: map['category'],
      description: map['description'],
      brand: map['brand'],
      model: map['model'],
      status: map['status'],
      quantity: map['quantity'],
    );
  }
}
