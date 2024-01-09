class Product {
  final String id;
  final String image;
  final String name;
  final String price;
  final String stock;
  final String desc;

  Product(
      {required this.id,
      required this.image,
      required this.name,
      required this.price,
      required this.stock,
      required this.desc});
}
class Placemark {
  final String thoroughfare;
  final String subThoroughfare;
  final String locality;
  final String administrativeArea;
  final String postalCode;

  Placemark({
    required this.thoroughfare,
    required this.subThoroughfare,
    required this.locality,
    required this.administrativeArea,
    required this.postalCode,
  });
}

