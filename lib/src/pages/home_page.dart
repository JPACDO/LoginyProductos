import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
// import 'package:formvalidation/src/bloc/provider.dart';
// import 'package:formvalidation/src/providers/productos_providers.dart';

import '../models/producto_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  // final productosProvider = ProductosProvider();

  @override
  Widget build(BuildContext context) {
    // final bloc = Provider.of(context);
    final productosBloc = Provider.productosBloc(context);
    productosBloc.cargaProductos();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: _crearListado(productosBloc),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearListado(ProductosBloc productosBloc) {
    return StreamBuilder(
      stream: productosBloc.productosStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
        if (snapshot.hasData) {
          final productos = snapshot.data;
          return ListView.builder(
            itemCount: productos!.length,
            itemBuilder: ((context, index) =>
                _crearItem(context, productosBloc, productos[index])),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _crearItem(BuildContext context, ProductosBloc productosBloc,
      ProductModel producto) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(color: Colors.red),
      onDismissed: ((direction) {
        // productosProvider.borrarProducto(producto.id!);
        productosBloc.borrarProducto(producto.id!);
      }),
      child: Card(
        child: GestureDetector(
          onTap: () =>
              Navigator.pushNamed(context, 'producto', arguments: producto),
          child: Column(
            children: <Widget>[
              (producto.fotoUrl == null)
                  ? const Image(image: AssetImage('assets/no-image.png'))
                  : FadeInImage(
                      placeholder: const AssetImage('assets/jar-loading.gif'),
                      image: NetworkImage(producto.fotoUrl!),
                      height: 300.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
              ListTile(
                title: Text('${producto.titulo} - ${producto.valor}'),
                subtitle: Text('${producto.id}'),
                // onTap: () =>
                //     Navigator.pushNamed(context, 'producto', arguments: producto),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, 'producto'),
      backgroundColor: Colors.deepPurple,
      child: const Icon(Icons.add),
    );
  }
}
