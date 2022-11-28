import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/producto_model.dart';
// import 'package:formvalidation/src/providers/productos_providers.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>();
  // final scaffolKey = GlobalKey<ScaffoldState>();
  // final productoProvider = ProductosProvider();
  late ProductosBloc productosBloc;
  ProductModel producto = ProductModel();
  bool _guardando = false;
  XFile? foto;

  @override
  Widget build(BuildContext context) {
    productosBloc = Provider.productosBloc(context);

    final Object? prodData = ModalRoute.of(context)?.settings.arguments;

    if (prodData != null) producto = prodData as ProductModel;

    return Scaffold(
      // key: scaffolKey,
      appBar: AppBar(
        title: const Text('Producto'),
        actions: [
          IconButton(
              onPressed: _seleccionarFoto,
              icon: const Icon(Icons.photo_size_select_actual)),
          IconButton(
            onPressed: _tomarFoto,
            icon: const Icon(Icons.camera_alt),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _creardisponible(),
                _crearBoton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(labelText: 'Producto'),
      onSaved: ((newValue) => producto.titulo = newValue!),
      validator: ((value) {
        return (value!.length < 3) ? 'Ingrrese el nombre del prodcto' : null;
      }),
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(labelText: 'Precio'),
      onSaved: ((newValue) => producto.valor = double.parse(newValue!)),
      validator: ((value) {
        if (utils.isNumeric(value!)) {
          return null;
        } else {
          return 'Solo números';
        }
      }),
    );
  }

  Widget _crearBoton() {
    return ElevatedButton(
      onPressed: _guardando ? null : _submit,
      style: ElevatedButton.styleFrom(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.save),
          Text('Guardar'),
        ],
      ),
    );
  }

  Widget _creardisponible() {
    return SwitchListTile(
      value: producto.disponible,
      onChanged: ((value) => setState(() {
            producto.disponible = value;
          })),
      title: const Text('Disponible'),
    );
  }

  void _submit() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState?.save();
    setState(() {
      _guardando = true;
    });

    if (foto != null) {
      producto.fotoUrl = await productosBloc
          .subriFoto(File(foto!.path)); //productoProvider.subirImagen(foto!);
    }
    if (producto.id == null) {
      productosBloc.agregarProducto(
          producto); //productoProvider.crearProducto(producto);
    } else {
      productosBloc.editarProducto(
          producto); //productoProvider.editarProducto(producto);
    }
    // setState(() {      _guardando = false;    });
    mostrarSnackbar('Registro guardado');
    // if (kIsWeb) {
    //   print('is web');
    if (!mounted) return;
    Navigator.pushNamed(context, 'home');
    // } else {
    //   Navigator.pop(context);
    // }
  }

  void mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: const Duration(milliseconds: 1500),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  Widget _mostrarFoto() {
    if (producto.fotoUrl != null) {
      return FadeInImage(
        placeholder: const AssetImage('assets/jar-loading.gif'),
        image: NetworkImage(producto.fotoUrl!),
        height: 300.0,
        fit: BoxFit.contain,
      );
    } else {
      return _imagen();
      // return Image(
      //   image: AssetImage(foto?.path ?? 'assets/no-image.png'),
      //   height: 300.0,
      //   fit: BoxFit.cover,
      // );
    }
  }

  _imagen() {
    if (kIsWeb) {
      return Image.network(
        foto?.path ?? 'assets/no-image.png',
        height: 300.0,
        fit: BoxFit.cover,
      );
    } else {
      if (foto != null) {
        return Image.file(
          File(foto!.path),
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/no-image.png');
    }
  }

  _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origen) async {
    final ImagePicker picker = ImagePicker();
    foto = await picker.pickImage(source: origen);

    if (foto != null) {
      producto.fotoUrl = null;
    }
    setState(() {});
  }
}
