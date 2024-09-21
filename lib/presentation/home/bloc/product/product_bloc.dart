import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kasboxapp/data/datasources/product_local_datasource.dart';
import 'package:kasboxapp/data/datasources/product_remote_datasource.dart';
import 'package:kasboxapp/data/models/response/product_response_model.dart';

part 'product_bloc.freezed.dart';
part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRemoteDatasource _productRemoteDatasource;
  List<Product> products = [];

  ProductBloc(this._productRemoteDatasource) : super(const ProductState.initial()) {
    on<_Fetch>((event, emit) async {
      emit(const ProductState.loading());
      try {
        final result = await _productRemoteDatasource.getProducts();
        result.fold(
          (l) => emit(ProductState.error(l)),
          (r) {
            products = r.data;
            emit(ProductState.success(r.data));
          },
        );
      } catch (e) {
        emit(ProductState.error('Terjadi kesalahan saat memuat produk.'));
      }
    });

     on<_FetchLocal>((event, emit) async {
      emit(const ProductState.loading());
      try {
        final localPproducts = await ProductLocalDatasource.instance.getAllProduct();
        products = localPproducts;
        emit(ProductState.success(products));
      } catch (e) {
        emit(ProductState.error('Terjadi kesalahan saat memuat produk.'));
      }
    });

    on<_FetchByCategory>((event, emit) async {
      emit(const ProductState.loading());
      try {
        final newProducts = event.category == 'all'
            ? products
            : products.where((element) => element.category.toString().split('.').last.toLowerCase() == event.category).toList();
        emit(ProductState.success(newProducts));
      } catch (e) {
        emit(ProductState.error('Terjadi kesalahan saat memfilter produk.'));
      }
    });
  }
}
