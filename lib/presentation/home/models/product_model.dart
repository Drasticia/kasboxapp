
import 'package:kasboxapp/core/extensions/int_ext.dart';

import 'product_category.dart';

class ProductModel {
  final String img;
  final String name;
  final ProductCategory category;
  final int price;
  final int stock;

  ProductModel({
    required this.img,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
  });

  String get priceFormat => price.currencyFormatRp;
}
