// 🍕 MODELO DE PIZZA ACTUALIZADO
class Pizza {
  final String nombre;
  final String ingredientes;
  final double precioFamiliar;
  final double precioPersonal;
  final double precioExtraGrande; // 🔥 NUEVO CAMPO
  final String imagen;

  Pizza({
    required this.nombre,
    required this.ingredientes,
    required this.precioFamiliar,
    required this.precioPersonal,
    required this.precioExtraGrande, // 🔥 NUEVO CAMPO REQUERIDO
    required this.imagen,
  });
}

// 🍗 MODELO DE MOSTRITO (BROASTER + ACOMPAÑAMIENTOS)
class Mostrito {
  final String nombre;
  final String descripcion;
  final double precio;
  final String imagen;

  Mostrito({
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.imagen,
  });
}

// 🍕 MODELO DE PIZZA ESPECIAL (2 Y 4 SABORES)
class PizzaEspecial {
  final String nombre;
  final String descripcion;
  final double precio;
  final String imagen;
  final String tipo; // "2 Sabores" o "4 Sabores"

  PizzaEspecial({
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.imagen,
    required this.tipo,
  });
}

// 🎁 MODELO DE COMBO
class Combo {
  final String nombre;
  final String descripcion;
  final double precio;
  final String imagen;

  Combo({
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.imagen,
  });
}

// 🔧 MODELO DE ADICIONAL
class Adicional {
  final String nombre;
  final double precio;
  final String icono;

  Adicional({
    required this.nombre,
    required this.precio,
    required this.icono,
  });

  // Método para crear copia del adicional (útil para comparaciones)
  Adicional copyWith({
    String? nombre,
    double? precio,
    String? icono,
  }) {
    return Adicional(
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
      icono: icono ?? this.icono,
    );
  }

  // Sobrescribir operadores para comparaciones
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Adicional && other.nombre == nombre;
  }

  @override
  int get hashCode => nombre.hashCode;
}

// 🛒 MODELO DE ITEM DEL PEDIDO ACTUALIZADO
class ItemPedido {
  final String nombre;
  final double precio;
  final int cantidad;
  final String tamano;
  final String imagen;
  final List<Adicional> adicionales;
  final bool tienePrimeraGaseosa; // 🔥 NUEVO CAMPO

  ItemPedido({
    required this.nombre,
    required this.precio,
    required this.cantidad,
    required this.tamano,
    required this.imagen,
    this.adicionales = const [],
    this.tienePrimeraGaseosa = false, // 🔥 NUEVO CAMPO
  });

  // 🔥 MÉTODO ACTUALIZADO PARA OBTENER PRECIO TOTAL CON LÓGICA ESPECIAL
  double get precioTotal {
    double precioAdicionales = 0.0;
    bool yaAplicoPrimeraGaseosa = false;
    
    for (Adicional adicional in adicionales) {
      // 🔥 LÓGICA ESPECIAL PARA PRIMERA GASEOSA EN PIZZAS PERSONALES
      if (tamano == 'Personal' && 
          adicional.nombre == 'Pepsi 350ml (primera)' && 
          !yaAplicoPrimeraGaseosa) {
        precioAdicionales += 1.0; // Solo +1 sol
        yaAplicoPrimeraGaseosa = true;
      } else {
        precioAdicionales += adicional.precio;
      }
    }
    
    return precio + precioAdicionales;
  }

  // 🔥 MÉTODO PARA VERIFICAR SI PUEDE AGREGAR PRIMERA GASEOSA
  bool get puedeAgregarPrimeraGaseosa {
    if (tamano != 'Personal') return false;
    return !adicionales.any((a) => a.nombre == 'Pepsi 350ml (primera)');
  }

  // 🔥 MÉTODO PARA CONTAR GASEOSAS NORMALES
  int get cantidadGasesosasNormales {
    return adicionales.where((a) => 
      a.nombre == 'Pepsi 350ml' || a.nombre == 'Pepsi 750ml'
    ).length;
  }

  // Descripción completa del item
  String get descripcionCompleta {
    if (adicionales.isEmpty) return nombre;
    String adicionalesTexto = adicionales.map((a) => a.nombre).join(', ');
    return '$nombre + $adicionalesTexto';
  }

  // 🔥 MÉTODO ACTUALIZADO PARA CREAR COPIA CON MODIFICACIONES
  ItemPedido copyWith({
    String? nombre,
    double? precio,
    int? cantidad,
    String? tamano,
    String? imagen,
    List<Adicional>? adicionales,
    bool? tienePrimeraGaseosa,
  }) {
    return ItemPedido(
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
      cantidad: cantidad ?? this.cantidad,
      tamano: tamano ?? this.tamano,
      imagen: imagen ?? this.imagen,
      adicionales: adicionales ?? List.from(this.adicionales),
      tienePrimeraGaseosa: tienePrimeraGaseosa ?? this.tienePrimeraGaseosa,
    );
  }

  // Sobrescribir operadores para comparaciones
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ItemPedido && 
           other.nombre == nombre && 
           other.tamano == tamano &&
           other.adicionales.length == adicionales.length &&
           other.adicionales.every((a) => adicionales.contains(a));
  }

  @override
  int get hashCode => Object.hash(nombre, tamano, adicionales);
}

// 📱 MODELO DE PEDIDO COMPLETO
class Pedido {
  final String numeroPedido;
  final List<ItemPedido> items;
  final double total;
  final String metodoPago;
  final Map<String, dynamic> datosCliente;
  final DateTime fechaPedido;
  final String estado;

  Pedido({
    required this.numeroPedido,
    required this.items,
    required this.total,
    required this.metodoPago,
    required this.datosCliente,
    required this.fechaPedido,
    this.estado = 'Pendiente',
  });

  // Crear copia del pedido con modificaciones
  Pedido copyWith({
    String? numeroPedido,
    List<ItemPedido>? items,
    double? total,
    String? metodoPago,
    Map<String, dynamic>? datosCliente,
    DateTime? fechaPedido,
    String? estado,
  }) {
    return Pedido(
      numeroPedido: numeroPedido ?? this.numeroPedido,
      items: items ?? this.items,
      total: total ?? this.total,
      metodoPago: metodoPago ?? this.metodoPago,
      datosCliente: datosCliente ?? this.datosCliente,
      fechaPedido: fechaPedido ?? this.fechaPedido,
      estado: estado ?? this.estado,
    );
  }

  // Convertir a Map para almacenamiento
  Map<String, dynamic> toMap() {
    return {
      'numeroPedido': numeroPedido,
      'items': items.map((item) => {
        'nombre': item.nombre,
        'precio': item.precio,
        'cantidad': item.cantidad,
        'tamano': item.tamano,
        'imagen': item.imagen,
        'tienePrimeraGaseosa': item.tienePrimeraGaseosa, // 🔥 NUEVO CAMPO
        'adicionales': item.adicionales.map((a) => {
          'nombre': a.nombre,
          'precio': a.precio,
          'icono': a.icono,
        }).toList(),
      }).toList(),
      'total': total,
      'metodoPago': metodoPago,
      'datosCliente': datosCliente,
      'fechaPedido': fechaPedido.millisecondsSinceEpoch,
      'estado': estado,
    };
  }

  // Crear desde Map
  static Pedido fromMap(Map<String, dynamic> map) {
    return Pedido(
      numeroPedido: map['numeroPedido'] ?? '',
      items: (map['items'] as List<dynamic>?)?.map((item) => ItemPedido(
        nombre: item['nombre'] ?? '',
        precio: (item['precio'] ?? 0.0).toDouble(),
        cantidad: item['cantidad'] ?? 1,
        tamano: item['tamano'] ?? '',
        imagen: item['imagen'] ?? '',
        tienePrimeraGaseosa: item['tienePrimeraGaseosa'] ?? false, // 🔥 NUEVO CAMPO
        adicionales: (item['adicionales'] as List<dynamic>?)?.map((a) => Adicional(
          nombre: a['nombre'] ?? '',
          precio: (a['precio'] ?? 0.0).toDouble(),
          icono: a['icono'] ?? '',
        )).toList() ?? [],
      )).toList() ?? [],
      total: (map['total'] ?? 0.0).toDouble(),
      metodoPago: map['metodoPago'] ?? '',
      datosCliente: Map<String, dynamic>.from(map['datosCliente'] ?? {}),
      fechaPedido: DateTime.fromMillisecondsSinceEpoch(map['fechaPedido'] ?? 0),
      estado: map['estado'] ?? 'Pendiente',
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