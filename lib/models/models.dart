// Modelo de Pizza
class Pizza {
  final String nombre;
  final String ingredientes;
  final double precioFamiliar;
  final double precioPersonal;
  final String imagen; // 🔥 NUEVO CAMPO PARA IMAGEN

  Pizza({
    required this.nombre,
    required this.ingredientes,
    required this.precioFamiliar,
    required this.precioPersonal,
    required this.imagen, // 🔥 REQUERIDO
  });
}

// 🔥 NUEVO MODELO PARA ADICIONALES
class Adicional {
  final String nombre;
  final double precio;
  final String icono;

  Adicional({
    required this.nombre,
    required this.precio,
    required this.icono,
  });
}

// Modelo de Combo
class Combo {
  final String nombre;
  final String descripcion;
  final double precio;
  final String imagen; // 🔥 NUEVO CAMPO PARA IMAGEN

  Combo({
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.imagen, // 🔥 REQUERIDO
  });
}

// Modelo de Pedido ACTUALIZADO
class ItemPedido {
  final String nombre;
  final double precio;
  final int cantidad;
  final String tamano;
  final List<Adicional> adicionales; // 🔥 NUEVO CAMPO PARA ADICIONALES
  final String imagen; // 🔥 NUEVO CAMPO PARA IMAGEN

  ItemPedido({
    required this.nombre,
    required this.precio,
    required this.cantidad,
    required this.tamano,
    this.adicionales = const [], // 🔥 VALOR POR DEFECTO
    required this.imagen, // 🔥 REQUERIDO
  });

  // 🔥 MÉTODO PARA CALCULAR PRECIO CON ADICIONALES
  double get precioTotal {
    double precioAdicionales = adicionales.fold(0.0, (sum, adicional) => sum + adicional.precio);
    return precio + precioAdicionales;
  }

  // 🔥 MÉTODO PARA OBTENER DESCRIPCIÓN CON ADICIONALES
  String get descripcionCompleta {
    if (adicionales.isEmpty) return nombre;
    String adicionalesTexto = adicionales.map((a) => a.nombre).join(', ');
    return '$nombre + $adicionalesTexto';
  }

  // 🔥 MÉTODO PARA COPIAR CON NUEVOS ADICIONALES
  ItemPedido copyWith({
    String? nombre,
    double? precio,
    int? cantidad,
    String? tamano,
    List<Adicional>? adicionales,
    String? imagen,
  }) {
    return ItemPedido(
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
      cantidad: cantidad ?? this.cantidad,
      tamano: tamano ?? this.tamano,
      adicionales: adicionales ?? this.adicionales,
      imagen: imagen ?? this.imagen,
    );
  }
}

// Modelo de datos del cliente (sin cambios)
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