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

// 🔧 MODELO DE ADICIONAL ACTUALIZADO CON CANTIDAD Y PIZZA ESPECÍFICA
class Adicional {
  final String nombre;
  final double precio;
  final String icono;  // 🔥 MANTENER ICONO PARA EL CARRITO
  final String imagen; // 🔥 AGREGAR IMAGEN PARA LA VISTA DE ADICIONALES
  final int cantidad;  // 🔥 NUEVO: CANTIDAD DEL ADICIONAL
  final String? pizzaEspecifica; // 🔥 NUEVO: PIZZA ESPECÍFICA PARA COMBOS MÚLTIPLES

  Adicional({
    required this.nombre,
    required this.precio,
    required this.icono,  // 🔥 REQUERIDO
    required this.imagen, // 🔥 REQUERIDO
    this.cantidad = 1,    // 🔥 NUEVO: DEFAULT 1
    this.pizzaEspecifica, // 🔥 NUEVO: OPCIONAL
  });

  // 🔥 MÉTODO ACTUALIZADO PARA CREAR COPIA CON MODIFICACIONES
  Adicional copyWith({
    String? nombre,
    double? precio,
    String? icono,  // 🔥 MANTENER ICONO
    String? imagen, // 🔥 MANTENER IMAGEN
    int? cantidad,  // 🔥 NUEVO CAMPO
    String? pizzaEspecifica, // 🔥 NUEVO CAMPO
  }) {
    return Adicional(
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
      icono: icono ?? this.icono,   // 🔥 MANTENER ICONO
      imagen: imagen ?? this.imagen, // 🔥 MANTENER IMAGEN
      cantidad: cantidad ?? this.cantidad, // 🔥 NUEVO CAMPO
      pizzaEspecifica: pizzaEspecifica ?? this.pizzaEspecifica, // 🔥 NUEVO CAMPO
    );
  }

  // 🔥 PRECIO TOTAL DEL ADICIONAL (PRECIO * CANTIDAD)
  double get precioTotal => precio * cantidad;

  // 🔥 NOMBRE COMPLETO CON INFORMACIÓN ADICIONAL
  String get nombreCompleto {
    String nombreFinal = nombre;
    if (pizzaEspecifica != null && pizzaEspecifica!.isNotEmpty) {
      nombreFinal += ' (${pizzaEspecifica})';
    }
    if (cantidad > 1) {
      nombreFinal += ' x$cantidad';
    }
    return nombreFinal;
  }

  // 🔥 VERIFICAR SI ES EL MISMO ADICIONAL (PARA COMPARACIONES)
  bool esMismoAdicional(Adicional otro) {
    return nombre == otro.nombre && pizzaEspecifica == otro.pizzaEspecifica;
  }

  // Sobrescribir operadores para comparaciones
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Adicional && 
           other.nombre == nombre && 
           other.pizzaEspecifica == pizzaEspecifica;
  }

  @override
  int get hashCode => Object.hash(nombre, pizzaEspecifica);

  // 🔥 NUEVO: CONVERTIR A MAP PARA ALMACENAMIENTO
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'precio': precio,
      'icono': icono,
      'imagen': imagen,
      'cantidad': cantidad,
      'pizzaEspecifica': pizzaEspecifica,
    };
  }

  // 🔥 NUEVO: CREAR DESDE MAP
  static Adicional fromMap(Map<String, dynamic> map) {
    return Adicional(
      nombre: map['nombre'] ?? '',
      precio: (map['precio'] ?? 0.0).toDouble(),
      icono: map['icono'] ?? '🔧',
      imagen: map['imagen'] ?? 'assets/images/adicionales/default.png',
      cantidad: map['cantidad'] ?? 1,
      pizzaEspecifica: map['pizzaEspecifica'],
    );
  }
}

// 🛒 MODELO DE ITEM DEL PEDIDO ACTUALIZADO
class ItemPedido {
  final String nombre;
  final double precio;
  final int cantidad;
  final String tamano;
  final String imagen;
  final List<Adicional> adicionales;
  final bool tienePrimeraGaseosa; // 🔥 CAMPO EXISTENTE

  ItemPedido({
    required this.nombre,
    required this.precio,
    required this.cantidad,
    required this.tamano,
    required this.imagen,
    this.adicionales = const [],
    this.tienePrimeraGaseosa = false, // 🔥 CAMPO EXISTENTE
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
        precioAdicionales += 1.0 * adicional.cantidad; // Solo +1 sol por cada una
        yaAplicoPrimeraGaseosa = true;
      } else {
        // 🔥 USAR PRECIO TOTAL DEL ADICIONAL (PRECIO * CANTIDAD)
        precioAdicionales += adicional.precioTotal;
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
    ).fold(0, (sum, a) => sum + a.cantidad);
  }

  // 🔥 MÉTODO PARA OBTENER CANTIDAD TOTAL DE ADICIONALES
  int get cantidadTotalAdicionales {
    return adicionales.fold(0, (sum, a) => sum + a.cantidad);
  }

  // 🔥 DESCRIPCIÓN COMPLETA DEL ITEM MEJORADA
  String get descripcionCompleta {
    if (adicionales.isEmpty) return nombre;
    
    String adicionalesTexto = adicionales.map((a) {
      if (a.cantidad > 1) {
        return '${a.nombre} x${a.cantidad}';
      }
      return a.nombre;
    }).join(', ');
    
    return '$nombre + $adicionalesTexto';
  }

  // 🔥 OBTENER RESUMEN DE ADICIONALES POR TIPO
  Map<String, int> get resumenAdicionales {
    Map<String, int> resumen = {};
    for (Adicional adicional in adicionales) {
      String key = adicional.pizzaEspecifica != null 
          ? '${adicional.nombre} (${adicional.pizzaEspecifica})'
          : adicional.nombre;
      resumen[key] = (resumen[key] ?? 0) + adicional.cantidad;
    }
    return resumen;
  }

  // 🔥 VERIFICAR SI TIENE ADICIONAL ESPECÍFICO
  bool tieneAdicional(String nombreAdicional, {String? pizzaEspecifica}) {
    return adicionales.any((a) => 
        a.nombre == nombreAdicional && a.pizzaEspecifica == pizzaEspecifica);
  }

  // 🔥 OBTENER CANTIDAD DE ADICIONAL ESPECÍFICO
  int getCantidadAdicional(String nombreAdicional, {String? pizzaEspecifica}) {
    final adicional = adicionales.firstWhere(
      (a) => a.nombre == nombreAdicional && a.pizzaEspecifica == pizzaEspecifica,
      orElse: () => Adicional(nombre: '', precio: 0.0, icono: '', imagen: '', cantidad: 0),
    );
    return adicional.cantidad;
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
           other.adicionales.every((a) => adicionales.any((b) => b.esMismoAdicional(a)));
  }

  @override
  int get hashCode => Object.hash(nombre, tamano, adicionales);

  // 🔥 NUEVO: CONVERTIR A MAP PARA ALMACENAMIENTO
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'precio': precio,
      'cantidad': cantidad,
      'tamano': tamano,
      'imagen': imagen,
      'tienePrimeraGaseosa': tienePrimeraGaseosa,
      'adicionales': adicionales.map((a) => a.toMap()).toList(),
    };
  }

  // 🔥 NUEVO: CREAR DESDE MAP
  static ItemPedido fromMap(Map<String, dynamic> map) {
    return ItemPedido(
      nombre: map['nombre'] ?? '',
      precio: (map['precio'] ?? 0.0).toDouble(),
      cantidad: map['cantidad'] ?? 1,
      tamano: map['tamano'] ?? '',
      imagen: map['imagen'] ?? '',
      tienePrimeraGaseosa: map['tienePrimeraGaseosa'] ?? false,
      adicionales: (map['adicionales'] as List<dynamic>?)
          ?.map((a) => Adicional.fromMap(a))
          .toList() ?? [],
    );
  }
}

// 📱 MODELO DE PEDIDO COMPLETO ACTUALIZADO
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

  // 🔥 OBTENER CANTIDAD TOTAL DE ITEMS
  int get cantidadTotalItems {
    return items.fold(0, (sum, item) => sum + item.cantidad);
  }

  // 🔥 OBTENER RESUMEN DEL PEDIDO
  String get resumenPedido {
    if (items.isEmpty) return 'Pedido vacío';
    
    Map<String, int> resumen = {};
    for (ItemPedido item in items) {
      String key = '${item.nombre} (${item.tamano})';
      resumen[key] = (resumen[key] ?? 0) + item.cantidad;
    }
    
    return resumen.entries
        .map((e) => '${e.value}x ${e.key}')
        .join(', ');
  }

  // 🔥 VERIFICAR SI TIENE ITEMS DE CIERTO TIPO
  bool tieneItemTipo(String tipo) {
    return items.any((item) => item.tamano.toLowerCase().contains(tipo.toLowerCase()));
  }

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

  // 🔥 MÉTODO ACTUALIZADO - Convertir a Map para almacenamiento
  Map<String, dynamic> toMap() {
    return {
      'numeroPedido': numeroPedido,
      'items': items.map((item) => item.toMap()).toList(),
      'total': total,
      'metodoPago': metodoPago,
      'datosCliente': datosCliente,
      'fechaPedido': fechaPedido.millisecondsSinceEpoch,
      'estado': estado,
    };
  }

  // 🔥 MÉTODO ACTUALIZADO - Crear desde Map
  static Pedido fromMap(Map<String, dynamic> map) {
    return Pedido(
      numeroPedido: map['numeroPedido'] ?? '',
      items: (map['items'] as List<dynamic>?)
          ?.map((item) => ItemPedido.fromMap(item))
          .toList() ?? [],
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