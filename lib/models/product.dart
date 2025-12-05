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
}

