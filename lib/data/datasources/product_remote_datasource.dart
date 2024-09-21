import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:kasboxapp/core/constants/variables.dart';
import 'package:kasboxapp/data/datasources/auth_local_datasource.dart';
import 'package:kasboxapp/data/models/response/product_response_model.dart';

class ProductRemoteDatasource {
  Future<Either<String, ProductResponseModel>> getProducts() async {
    try {
      final authData = await AuthLocalDatasource().getAuthData();
      final response = await http.get(
        Uri.parse('${Variables.baseUrl}/api/products'),
        headers: {
          'Authorization': 'Bearer ${authData.token}',
        },
      );
      if (response.statusCode == 200) {
        return right(ProductResponseModel.fromJson(jsonDecode(response.body)));
      } else {
        return left(response.body);
      }
    } catch (e) {
      return left('Terjadi kesalahan saat memuat data produk.');
    }
  }
}
