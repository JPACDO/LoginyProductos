import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(jsonDecode(str));
String productModelToJson(ProductModel data) => jsonEncode(data.toJson());

class ProductModel {
  ProductModel({
    this.id,
    this.titulo = '',
    this.valor = 0.0,
    this.disponible = true,
    this.fotoUrl,
  });
  late String? id;
  late String titulo;
  late double valor;
  late bool disponible;
  late String? fotoUrl;

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titulo = json['titulo'];
    valor = json['valor'].toDouble();
    disponible = json['disponible'];
    fotoUrl = json['fotoUrl'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    // data['id'] = id;
    data['titulo'] = titulo;
    data['valor'] = valor.toDouble();
    data['disponible'] = disponible;
    data['fotoUrl'] = fotoUrl;
    return data;
  }
}
