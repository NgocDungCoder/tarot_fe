/// Product model for shop items
class Product {
  final String id;
  final String name;
  final String nameVi;
  final String description;
  final double price;
  final String imagePath;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.nameVi,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.category,
  });

  /// Create product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      nameVi: json['nameVi']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imagePath: json['imagePath']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
    );
  }

  /// Convert product to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameVi': nameVi,
      'description': description,
      'price': price,
      'imagePath': imagePath,
      'category': category,
    };
  }
}

