import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(PizzeriaApp());
}

class PizzeriaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizzería App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Modelo de Pizza
class Pizza {
  final String nombre;
  final String ingredientes;
  final double precioFamiliar;
  final double precioPersonal;

  Pizza({
    required this.nombre,
    required this.ingredientes,
    required this.precioFamiliar,
    required this.precioPersonal,
  });
}

// Modelo de Combo
class Combo {
  final String nombre;
  final String descripcion;
  final double precio;

  Combo({
    required this.nombre,
    required this.descripcion,
    required this.precio,
  });
}

// Modelo de Pedido
class ItemPedido {
  final String nombre;
  final double precio;
  final int cantidad;
  final String tamano;

  ItemPedido({
    required this.nombre,
    required this.precio,
    required this.cantidad,
    required this.tamano,
  });
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ItemPedido> carrito = [];
  
  final List<Pizza> pizzas = [
    Pizza(
      nombre: 'Americana',
      ingredientes: 'queso mozzarella, jamón, salchichón',
      precioFamiliar: 26.0,
      precioPersonal: 11.0,
    ),
    Pizza(
      nombre: 'Hawaiana',
      ingredientes: 'queso mozzarella, jamón, piña',
      precioFamiliar: 28.0,
      precioPersonal: 12.0,
    ),
    Pizza(
      nombre: 'Pepperoni',
      ingredientes: 'queso mozzarella, pepperoni',
      precioFamiliar: 30.0,
      precioPersonal: 14.0,
    ),
    Pizza(
      nombre: 'Extremo',
      ingredientes: 'queso mozzarella, salami, jamón, tocino, pepperoni, chorizo español',
      precioFamiliar: 32.0,
      precioPersonal: 14.0,
    ),
    Pizza(
      nombre: 'Tocino',
      ingredientes: 'queso mozzarella, tocino, jamón',
      precioFamiliar: 29.0,
      precioPersonal: 13.0,
    ),
    Pizza(
      nombre: 'Africana',
      ingredientes: 'queso mozzarella, salami, salchichón, jamón, pepperoni, chorizo español',
      precioFamiliar: 30.0,
      precioPersonal: 14.0,
    ),
  ];

  final List<Combo> combos = [
    Combo(
      nombre: 'Combo Estrella',
      descripcion: 'Pizza Familiar 2 sabores + 6 Bracitos + Porción papas + Pepsi Jumbo',
      precio: 42.0,
    ),
  ];

  double get totalCarrito {
    return carrito.fold(0.0, (sum, item) => sum + (item.precio * item.cantidad));
  }

  void agregarAlCarrito(String nombre, double precio, String tamano) {
    setState(() {
      // Buscar si ya existe el item
      int index = carrito.indexWhere((item) => 
        item.nombre == nombre && item.tamano == tamano);
      
      if (index != -1) {
        // Si existe, incrementar cantidad
        carrito[index] = ItemPedido(
          nombre: carrito[index].nombre,
          precio: carrito[index].precio,
          cantidad: carrito[index].cantidad + 1,
          tamano: carrito[index].tamano,
        );
      } else {
        // Si no existe, agregar nuevo
        carrito.add(ItemPedido(
          nombre: nombre,
          precio: precio,
          cantidad: 1,
          tamano: tamano,
        ));
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$nombre ($tamano) agregado al carrito'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.local_pizza, color: Colors.red),
            ),
            SizedBox(width: 10),
            Text('PIZZA FABICHELO', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.red,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () => _mostrarCarrito(context),
              ),
              if (carrito.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      '${carrito.fold(0, (sum, item) => sum + item.cantidad)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header con logo
            Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red, Colors.orange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Text(
                  'LISTA DE SABORES',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            // Información de tamaños
            Container(
              color: Colors.green,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Icon(Icons.local_pizza, color: Colors.white, size: 30),
                      Text('Familiar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text('8 tajadas', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  Container(width: 2, height: 40, color: Colors.white),
                  Column(
                    children: [
                      Icon(Icons.local_pizza, color: Colors.white, size: 20),
                      Text('Personal', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text('4 tajadas', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),

            // Lista de pizzas
            Container(
              color: Colors.amber[100],
              child: Column(
                children: pizzas.map((pizza) => _buildPizzaCard(pizza)).toList(),
              ),
            ),

            // Combo Estrella
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange, Colors.red],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      'Combo Estrella',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('• Pizza Familiar 2 sabores', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text('• 6 Bracitos'),
                                  Text('• Porción papas'),
                                  Text('• Pepsi Jumbo'),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(15),
                              child: Text(
                                '42',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => agregarAlCarrito('Combo Estrella', 42.0, 'Combo'),
                          child: Text('Agregar Combo'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Información de contacto
            Container(
              color: Colors.red,
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.delivery_dining, color: Colors.white),
                      SizedBox(width: 10),
                      Text('DELIVERY', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.green),
                      SizedBox(width: 10),
                      Text('933 214 908', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.blue),
                      SizedBox(width: 10),
                      Text('01 6723 711', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'UBICACIÓN: Paradero la posta subiendo una cuadra',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('Yape', style: TextStyle(color: Colors.white)),
                      ),
                      SizedBox(width: 20),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('Plin', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPizzaCard(Pizza pizza) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pizza.nombre,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          Text(
            pizza.ingredientes,
            style: TextStyle(fontSize: 12, color: Colors.black87),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Botón Familiar
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: 5),
                  child: ElevatedButton(
                    onPressed: () => agregarAlCarrito(pizza.nombre, pizza.precioFamiliar, 'Familiar'),
                    child: Column(
                      children: [
                        Text('Familiar'),
                        Text('S/ ${pizza.precioFamiliar.toStringAsFixed(0)}', 
                             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
              // Botón Personal
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 5),
                  child: ElevatedButton(
                    onPressed: () => agregarAlCarrito(pizza.nombre, pizza.precioPersonal, 'Personal'),
                    child: Column(
                      children: [
                        Text('Personal'),
                        Text('S/ ${pizza.precioPersonal.toStringAsFixed(0)}', 
                             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _mostrarCarrito(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: CarritoScreen(
            carrito: carrito,
            onActualizar: (nuevoCarrito) {
              setState(() {
                carrito = nuevoCarrito;
              });
            },
          ),
        );
      },
    );
  }
}

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
                          Text('S/ ${total.toStringAsFixed(2)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
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
}

class PagoScreen extends StatefulWidget {
  final List<ItemPedido> carrito;
  final double total;

  PagoScreen({required this.carrito, required this.total});

  @override
  _PagoScreenState createState() => _PagoScreenState();
}

class _PagoScreenState extends State<PagoScreen> {
  String metodoPago = '';
  String tipoEntrega = '';
  TextEditingController nombreController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController direccionController = TextEditingController();
  Position? ubicacionActual;
  bool cargandoUbicacion = false;

  @override
  void dispose() {
    nombreController.dispose();
    telefonoController.dispose();
    direccionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finalizar Pedido', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumen del pedido
            Card(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Resumen del Pedido', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    ...widget.carrito.map((item) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text('${item.cantidad}x ${item.nombre} (${item.tamano})')),
                          Text('S/ ${(item.precio * item.cantidad).toStringAsFixed(2)}'),
                        ],
                      ),
                    )).toList(),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('S/ ${widget.total.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Datos del cliente
            Text('Datos del Cliente', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TextField(
              controller: nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre completo',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: telefonoController,
              decoration: InputDecoration(
                labelText: 'Teléfono',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),

            SizedBox(height: 20),

            // Tipo de entrega
            Text('Tipo de Entrega', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            RadioListTile(
              title: Text('Delivery'),
              value: 'delivery',
              groupValue: tipoEntrega,
              onChanged: (value) {
                setState(() {
                  tipoEntrega = value!;
                });
              },
            ),
            RadioListTile(
              title: Text('Recojo en tienda'),
              value: 'recojo',
              groupValue: tipoEntrega,
              onChanged: (value) {
                setState(() {
                  tipoEntrega = value!;
                });
              },
            ),

            if (tipoEntrega == 'delivery') ...[
              SizedBox(height: 10),
              TextField(
                controller: direccionController,
                decoration: InputDecoration(
                  labelText: 'Dirección de entrega',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: cargandoUbicacion ? null : _obtenerUbicacion,
                      icon: cargandoUbicacion 
                          ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                          : Icon(Icons.location_on),
                      label: Text(cargandoUbicacion ? 'Obteniendo...' : 'Usar mi ubicación'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              if (ubicacionActual != null)
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    'Ubicación: ${ubicacionActual!.latitude.toStringAsFixed(6)}, ${ubicacionActual!.longitude.toStringAsFixed(6)}',
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
                ),
            ],

            SizedBox(height: 20),

            // Método de pago
            Text('Método de Pago', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            RadioListTile(
              title: Text('Efectivo'),
              value: 'efectivo',
              groupValue: metodoPago,
              onChanged: (value) {
                setState(() {
                  metodoPago = value!;
                });
              },
            ),
            RadioListTile(
              title: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text('Yape', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                  SizedBox(width: 10),
                  Text('Yape'),
                ],
              ),
              value: 'yape',
              groupValue: metodoPago,
              onChanged: (value) {
                setState(() {
                  metodoPago = value!;
                });
              },
            ),
            RadioListTile(
              title: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text('Plin', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                  SizedBox(width: 10),
                  Text('Plin'),
                ],
              ),
              value: 'plin',
              groupValue: metodoPago,
              onChanged: (value) {
                setState(() {
                  metodoPago = value!;
                });
              },
            ),

            SizedBox(height: 30),

            // Botón confirmar pedido
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _puedeConfirmarPedido() ? _confirmarPedido : null,
                child: Text('CONFIRMAR PEDIDO', style: TextStyle(fontSize: 16)),
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
    );
  }

  bool _puedeConfirmarPedido() {
    return nombreController.text.isNotEmpty &&
           telefonoController.text.isNotEmpty &&
           tipoEntrega.isNotEmpty &&
           metodoPago.isNotEmpty &&
           (tipoEntrega == 'recojo' || direccionController.text.isNotEmpty);
  }

  Future<void> _obtenerUbicacion() async {
    setState(() {
      cargandoUbicacion = true;
    });

    try {
      // Verificar si el servicio de ubicación está habilitado
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _mostrarError('El servicio de ubicación está deshabilitado');
        return;
      }

      // Solicitar permisos
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        _mostrarError('Permisos de ubicación denegados permanentemente');
        return;
      }

      if (permission == LocationPermission.denied) {
        _mostrarError('Permisos de ubicación denegados');
        return;
      }

      // Obtener ubicación
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        ubicacionActual = position;
        direccionController.text = 'Lat: ${position.latitude.toStringAsFixed(6)}, Lng: ${position.longitude.toStringAsFixed(6)}';
      });

    } catch (e) {
      _mostrarError('Error al obtener ubicación: $e');
    } finally {
      setState(() {
        cargandoUbicacion = false;
      });
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _confirmarPedido() {
    // Generar número de pedido único
    String numeroPedido = DateTime.now().millisecondsSinceEpoch.toString();
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmacionScreen(
          numeroPedido: numeroPedido,
          carrito: widget.carrito,
          total: widget.total,
          metodoPago: metodoPago,
          tipoEntrega: tipoEntrega,
          nombre: nombreController.text,
          telefono: telefonoController.text,
          direccion: direccionController.text,
          ubicacion: ubicacionActual,
        ),
      ),
    );
  }
}

class ConfirmacionScreen extends StatefulWidget {
  final String numeroPedido;
  final List<ItemPedido> carrito;
  final double total;
  final String metodoPago;
  final String tipoEntrega;
  final String nombre;
  final String telefono;
  final String direccion;
  final Position? ubicacion;

  ConfirmacionScreen({
    required this.numeroPedido,
    required this.carrito,
    required this.total,
    required this.metodoPago,
    required this.tipoEntrega,
    required this.nombre,
    required this.telefono,
    required this.direccion,
    this.ubicacion,
  });

  @override
  _ConfirmacionScreenState createState() => _ConfirmacionScreenState();
}

class _ConfirmacionScreenState extends State<ConfirmacionScreen> {
  String estadoPedido = 'confirmado';
  String estadoPago = 'pendiente';

  @override
  void initState() {
    super.initState();
    _enviarPedidoWhatsApp();
    
    // Simular proceso de pago y pedido
    _simularProcesoPedido();
  }

  void _simularProcesoPedido() {
    // Simular confirmación de pago después de 3 segundos
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          estadoPago = widget.metodoPago == 'efectivo' ? 'pendiente_entrega' : 'confirmado';
        });
      }
    });

    // Simular estados del pedido
    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          estadoPedido = 'preparando';
        });
      }
    });

    Future.delayed(Duration(seconds: 15), () {
      if (mounted) {
        setState(() {
          estadoPedido = 'listo';
        });
      }
    });

    if (widget.tipoEntrega == 'delivery') {
      Future.delayed(Duration(seconds: 20), () {
        if (mounted) {
          setState(() {
            estadoPedido = 'en_camino';
          });
        }
      });
    }
  }

  void _enviarPedidoWhatsApp() {
    String mensaje = '''
🍕 *NUEVO PEDIDO* 🍕

*Pedido #:* ${widget.numeroPedido}
*Cliente:* ${widget.nombre}
*Teléfono:* ${widget.telefono}

*PRODUCTOS:*
${widget.carrito.map((item) => '• ${item.cantidad}x ${item.nombre} (${item.tamano}) - S/ ${(item.precio * item.cantidad).toStringAsFixed(2)}').join('\n')}

*Total:* S/ ${widget.total.toStringAsFixed(2)}

*Entrega:* ${widget.tipoEntrega == 'delivery' ? 'Delivery' : 'Recojo en tienda'}
${widget.tipoEntrega == 'delivery' ? '*Dirección:* ${widget.direccion}' : ''}
${widget.ubicacion != null ? '*Coordenadas:* ${widget.ubicacion!.latitude}, ${widget.ubicacion!.longitude}' : ''}

*Método de pago:* ${_obtenerNombreMetodoPago()}

Confirmar recepción del pedido 👍
    ''';

    // Enviar a WhatsApp del negocio
    _enviarWhatsApp('933214908', mensaje);
  }

  void _enviarWhatsApp(String numero, String mensaje) async {
    final url = Uri.parse('https://wa.me/51$numero?text=${Uri.encodeComponent(mensaje)}');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        _mostrarError('No se pudo abrir WhatsApp');
      }
    } catch (e) {
      _mostrarError('Error al abrir WhatsApp: $e');
    }
  }

  String _obtenerNombreMetodoPago() {
    switch (widget.metodoPago) {
      case 'efectivo':
        return 'Efectivo';
      case 'yape':
        return 'Yape - 944609326';
      case 'plin':
        return 'Plin - 924802760';
      default:
        return widget.metodoPago;
    }
  }

  String _obtenerEstadoTexto() {
    switch (estadoPedido) {
      case 'confirmado':
        return 'Pedido Confirmado';
      case 'preparando':
        return 'Preparando tu pedido';
      case 'listo':
        return widget.tipoEntrega == 'delivery' ? 'Pedido listo para envío' : 'Pedido listo para recojo';
      case 'en_camino':
        return 'En camino';
      case 'entregado':
        return 'Entregado';
      default:
        return 'Estado desconocido';
    }
  }

  Color _obtenerColorEstado() {
    switch (estadoPedido) {
      case 'confirmado':
        return Colors.blue;
      case 'preparando':
        return Colors.orange;
      case 'listo':
        return Colors.green;
      case 'en_camino':
        return Colors.purple;
      case 'entregado':
        return Colors.green[800]!;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedido Confirmado', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Estado del pedido
            Card(
              color: _obtenerColorEstado(),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white, size: 64),
                    SizedBox(height: 10),
                    Text(
                      _obtenerEstadoTexto(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Pedido #${widget.numeroPedido}',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Información de pago
            if (widget.metodoPago != 'efectivo')
              Card(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.payment, color: Colors.blue),
                          SizedBox(width: 10),
                          Text('Información de Pago', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                      SizedBox(height: 15),
                      if (widget.metodoPago == 'yape')
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.purple[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.purple),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.purple,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text('Yape', style: TextStyle(color: Colors.white)),
                                      ),
                                      SizedBox(width: 10),
                                      Text('Realizar pago a:', style: TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Número:', style: TextStyle(fontWeight: FontWeight.bold)),
                                      SelectableText('944609326', style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Monto:', style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text('S/ ${widget.total.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton.icon(
                              onPressed: () => _abrirYape(),
                              icon: Icon(Icons.open_in_new),
                              label: Text('Abrir Yape'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      if (widget.metodoPago == 'plin')
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.teal[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.teal),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.teal,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text('Plin', style: TextStyle(color: Colors.white)),
                                      ),
                                      SizedBox(width: 10),
                                      Text('Realizar pago a:', style: TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Número:', style: TextStyle(fontWeight: FontWeight.bold)),
                                      SelectableText('924802760', style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Monto:', style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text('S/ ${widget.total.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton.icon(
                              onPressed: () => _abrirPlin(),
                              icon: Icon(Icons.open_in_new),
                              label: Text('Abrir Plin'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),

            SizedBox(height: 20),

            // Detalles del pedido
            Card(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Detalles del Pedido', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 10),
                    ...widget.carrito.map((item) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text('${item.cantidad}x ${item.nombre} (${item.tamano})')),
                          Text('S/ ${(item.precio * item.cantidad).toStringAsFixed(2)}'),
                        ],
                      ),
                    )).toList(),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('S/ ${widget.total.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Información de entrega
            Card(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Información de Entrega', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.person, color: Colors.blue),
                        SizedBox(width: 10),
                        Text('${widget.nombre}'),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.phone, color: Colors.green),
                        SizedBox(width: 10),
                        Text('${widget.telefono}'),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(widget.tipoEntrega == 'delivery' ? Icons.delivery_dining : Icons.store, color: Colors.orange),
                        SizedBox(width: 10),
                        Text(widget.tipoEntrega == 'delivery' ? 'Delivery' : 'Recojo en tienda'),
                      ],
                    ),
                    if (widget.tipoEntrega == 'delivery') ...[
                      SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on, color: Colors.red),
                          SizedBox(width: 10),
                          Expanded(child: Text('${widget.direccion}')),
                        ],
                      ),
                      if (widget.ubicacion != null) ...[
                        SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () => _abrirEnMaps(),
                          icon: Icon(Icons.map),
                          label: Text('Ver en Google Maps'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Tiempo estimado
            Card(
              color: Colors.orange[100],
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.orange),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tiempo estimado:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(widget.tipoEntrega == 'delivery' ? '25-35 minutos' : '15-20 minutos'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),

            // Botones de acción
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _llamarPizzeria(),
                    icon: Icon(Icons.phone),
                    label: Text('Llamar a la pizzería'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _enviarWhatsAppSeguimiento(),
                    icon: Icon(Icons.chat),
                    label: Text('Contactar por WhatsApp'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                      (route) => false,
                    ),
                    child: Text('Volver al menú'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _abrirYape() async {
    // Intentar abrir la app de Yape con URL scheme
    final Uri yapeUrl = Uri.parse('yape://');
    try {
      if (await canLaunchUrl(yapeUrl)) {
        await launchUrl(yapeUrl, mode: LaunchMode.externalApplication);
      } else {
        // Si no se puede abrir, mostrar instrucciones
        _mostrarInstruccionesPago('Yape', '944609326');
      }
    } catch (e) {
      _mostrarInstruccionesPago('Yape', '944609326');
    }
  }

  void _abrirPlin() async {
    // Intentar abrir la app de Plin con URL scheme
    final Uri plinUrl = Uri.parse('plin://');
    try {
      if (await canLaunchUrl(plinUrl)) {
        await launchUrl(plinUrl, mode: LaunchMode.externalApplication);
      } else {
        // Si no se puede abrir, mostrar instrucciones
        _mostrarInstruccionesPago('Plin', '924802760');
      }
    } catch (e) {
      _mostrarInstruccionesPago('Plin', '924802760');
    }
  }

  void _mostrarInstruccionesPago(String metodo, String numero) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pago con $metodo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Para realizar el pago:'),
            SizedBox(height: 10),
            Text('1. Abre tu app de $metodo'),
            Text('2. Busca el número: $numero'),
            Text('3. Envía: S/ ${widget.total.toStringAsFixed(2)}'),
            Text('4. Concepto: Pedido #${widget.numeroPedido}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Entendido'),
          ),
        ],
      ),
    );
  }

  void _abrirEnMaps() async {
    if (widget.ubicacion != null) {
      final Uri mapsUrl = Uri.parse('https://www.google.com/maps?q=${widget.ubicacion!.latitude},${widget.ubicacion!.longitude}');
      try {
        if (await canLaunchUrl(mapsUrl)) {
          await launchUrl(mapsUrl, mode: LaunchMode.externalApplication);
        } else {
          _mostrarError('No se pudo abrir Google Maps');
        }
      } catch (e) {
        _mostrarError('Error al abrir Google Maps: $e');
      }
    }
  }

  void _llamarPizzeria() async {
    final Uri telUrl = Uri.parse('tel:933214908');
    try {
      if (await canLaunchUrl(telUrl)) {
        await launchUrl(telUrl);
      } else {
        _mostrarError('No se pudo realizar la llamada');
      }
    } catch (e) {
      _mostrarError('Error al realizar la llamada: $e');
    }
  }

  void _enviarWhatsAppSeguimiento() {
    String mensaje = '''
Hola! Soy ${widget.nombre}

Quiero consultar sobre mi pedido #${widget.numeroPedido}

Gracias 😊
    ''';
    _enviarWhatsApp('933214908', mensaje);
  }

  void _mostrarError(String mensaje) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensaje),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}