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

// Modelo de datos del cliente
class DatosCliente {
  final String nombre;
  final String telefono;

  DatosCliente({
    required this.nombre,
    required this.telefono,
  });

  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    'telefono': telefono,
  };

  factory DatosCliente.fromJson(Map<String, dynamic> json) => DatosCliente(
    nombre: json['nombre'] ?? '',
    telefono: json['telefono'] ?? '',
  );
}