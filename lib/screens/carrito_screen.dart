import 'package:flutter/material.dart';
import '../models/models.dart';
import 'pago_screen.dart';

class CarritoScreen extends StatefulWidget {
  final List<ItemPedido> carrito;
  final Function(List<ItemPedido>) onActualizar;

  CarritoScreen({required this.carrito, required this.onActualizar});

  @override
  _CarritoScreenState createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  List<ItemPedido> carritoLocal = [];

  @override
  void initState() {
    super.initState();
    carritoLocal = List.from(widget.carrito);
  }

  double get total {
    return carritoLocal.fold(0.0, (sum, item) => sum + (item.precio * item.cantidad));
  }

  void _procederAlPago(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PagoScreen(
          carrito: carritoLocal,
          total: total,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Carrito', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: carritoLocal.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                  Text('Tu carrito está vacío', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: carritoLocal.length,
                    itemBuilder: (context, index) {
                      final item = carritoLocal[index];
                      return Card(
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(item.nombre),
                          subtitle: Text('${item.tamano} - S/ ${item.precio.toStringAsFixed(0)}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove_circle, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    if (item.cantidad > 1) {
                                      carritoLocal[index] = ItemPedido(
                                        nombre: item.nombre,
                                        precio: item.precio,
                                        cantidad: item.cantidad - 1,
                                        tamano: item.tamano,
                                      );
                                    } else {
                                      carritoLocal.removeAt(index);
                                    }
                                    widget.onActualizar(carritoLocal);
                                  });
                                },
                              ),
                              Text('${item.cantidad}', style: TextStyle(fontSize: 16)),
                              IconButton(
                                icon: Icon(Icons.add_circle, color: Colors.green),
                                onPressed: () {
                                  setState(() {
                                    carritoLocal[index] = ItemPedido(
                                      nombre: item.nombre,
                                      precio: item.precio,
                                      cantidad: item.cantidad + 1,
                                      tamano: item.tamano,
                                    );
                                    widget.onActualizar(carritoLocal);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text('S/ ${total.toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
                        ],
                      ),
                      SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: carritoLocal.isEmpty ? null : () => _procederAlPago(context),
                          child: Text('PROCEDER AL PAGO', style: TextStyle(fontSize: 16)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
