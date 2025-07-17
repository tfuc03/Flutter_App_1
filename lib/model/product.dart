class Product {
  final int id;
  final String name;
  final double price;
  final String image;
  final String description;
  final int categoryId;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.categoryId,
  });

factory Product.fromJson(Map<String, dynamic> json) {
  return Product(
    id: json['id'],
    name: json['name'],
    price: json['price'].toDouble(),
    image: json['img'],
    description: json['des'],
    categoryId: json['catId'],
  );
}
}