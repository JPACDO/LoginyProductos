import 'dart:convert';
// import 'dart:io';

import 'package:formvalidation/src/preferenias_usuario/preferencas_usuario.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:formvalidation/src/models/producto_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime_type/mime_type.dart';

class ProductosProvider {
  final String _url =
      'https://flutter-varios-37737-default-rtdb.firebaseio.com';

  final _prefs = Preferenciasusuario();

  Future<bool> crearProducto(ProductModel producto) async {
    final url = Uri.parse('$_url/productos.json?auth=${_prefs.token}');
    final resp = await http.post(url, body: productModelToJson(producto));
    final decodeData = jsonDecode(resp.body);
    // print(decodeData);
    return true;
  }

  Future<bool> editarProducto(ProductModel producto) async {
    final url =
        Uri.parse('$_url/productos/${producto.id}.json?auth=${_prefs.token}');
    final resp = await http.put(url, body: productModelToJson(producto));
    final decodeData = jsonDecode(resp.body);
    // print(decodeData);
    return true;
  }

  Future<List<ProductModel>> cargarProductos() async {
    final url = Uri.parse('$_url/productos.json?auth=${_prefs.token}');
    final resp = await http.get(url);

    final Map<String, dynamic> decodeData = jsonDecode(resp.body);
    final List<ProductModel> productos = [];

    if (decodeData.isEmpty) return [];
    if (decodeData['error'] != null) return [];

    decodeData.forEach((id, prod) {
      // print(prod);
      final prodTemp = ProductModel.fromJson(prod);
      // print(prodTemp);
      prodTemp.id = id;
      // print(prodTemp.id);
      productos.add(prodTemp);
    });

    // print(productos);
    return productos;
  }

  Future<int> borrarProducto(String id) async {
    final url = Uri.parse('$_url/productos/$id.json?auth=${_prefs.token}');
    final resp = await http.delete(url);

    // print(resp.body);

    return 1;
  }

  Future<String?> subirImagen(XFile imagen) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/--/image/upload---');
    final mimeType = mime(imagen.path)?.split('/');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', imagen.path,
        contentType: MediaType(mimeType![0], mimeType[1]));

    imageUploadRequest.files.add(file);

    final streamREsponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamREsponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      // print('mal salio');
      // print(resp.body);
      return null;
    }

    final respData = jsonDecode(resp.body);
    // print(respData);
    return respData['secure_url'];
  }
}
