import 'dart:io';

import 'package:formvalidation/src/providers/productos_providers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

import 'package:formvalidation/src/models/producto_model.dart';

class ProductosBloc {
  final _productosController = BehaviorSubject<List<ProductModel>>();
  final _cargandoController = BehaviorSubject<bool>();

  final _productosPrvider = ProductosProvider();

  Stream<List<ProductModel>> get productosStream => _productosController.stream;
  Stream<bool> get cargando => _cargandoController.stream;

  void cargaProductos() async {
    final productos = await _productosPrvider.cargarProductos();
    _productosController.sink.add(productos);
  }

  void agregarProducto(ProductModel producto) async {
    _cargandoController.sink.add(true);
    await _productosPrvider.crearProducto(producto);
    _cargandoController.sink.add(false);
  }

  Future<String> subriFoto(File foto) async {
    _cargandoController.sink.add(true);
    final fotoUrl = await _productosPrvider.subirImagen(XFile(foto.path));
    _cargandoController.sink.add(false);

    return fotoUrl!;
  }

  void editarProducto(ProductModel producto) async {
    _cargandoController.sink.add(true);
    await _productosPrvider.editarProducto(producto);
    _cargandoController.sink.add(false);
  }

  void borrarProducto(String id) async {
    await _productosPrvider.borrarProducto(id);
  }

  dispose() {
    _productosController.close();
    _cargandoController.close();
  }
}
