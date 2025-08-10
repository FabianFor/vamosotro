import '../models/models.dart';

class PizzaData {
  static final List<Pizza> pizzas = [
    Pizza(
      nombre: 'Americana',
      ingredientes: 'queso mozzarella, jamón, salchichón',
      precioFamiliar: 26.0,
      precioPersonal: 11.0,
      imagen: 'assets/images/pizzas/americana.png', // 🔥 NUEVA RUTA
    ),
    Pizza(
      nombre: 'Hawaiana',
      ingredientes: 'queso mozzarella, jamón, piña',
      precioFamiliar: 28.0,
      precioPersonal: 12.0,
      imagen: 'assets/images/pizzas/hawaiana.png', // 🔥 NUEVA RUTA
    ),
    Pizza(
      nombre: 'Pepperoni',
      ingredientes: 'queso mozzarella, pepperoni',
      precioFamiliar: 30.0,
      precioPersonal: 14.0,
      imagen: 'assets/images/pizzas/pepperoni.png', // 🔥 NUEVA RUTA
    ),
    Pizza(
      nombre: 'Extremo',
      ingredientes: 'queso mozzarella, salami, jamón, tocino, pepperoni, chorizo español',
      precioFamiliar: 32.0,
      precioPersonal: 14.0,
      imagen: 'assets/images/pizzas/extremo.png', // 🔥 NUEVA RUTA
    ),
    Pizza(
      nombre: 'Tocino',
      ingredientes: 'queso mozzarella, tocino, jamón',
      precioFamiliar: 29.0,
      precioPersonal: 13.0,
      imagen: 'assets/images/pizzas/tocino.png', // 🔥 NUEVA RUTA
    ),
    Pizza(
      nombre: 'Africana',
      ingredientes: 'queso mozzarella, salami, salchichón, jamón, pepperoni, chorizo español',
      precioFamiliar: 30.0,
      precioPersonal: 14.0,
      imagen: 'assets/images/pizzas/africana.png', // 🔥 NUEVA RUTA
    ),
  ];

  static final List<Combo> combos = [
    Combo(
      nombre: 'Combo Estrella',
      descripcion: 'Pizza Familiar 2 sabores + 6 Bracitos + Porción papas + Pepsi Jumbo',
      precio: 42.0,
      imagen: 'assets/images/combos/combo_estrella.png', // 🔥 NUEVA RUTA
    ),
  ];

  // 🔥 NUEVA LISTA DE ADICIONALES DISPONIBLES
  static final List<Adicional> adicionalesDisponibles = [
    Adicional(
      nombre: 'Queso Extra',
      precio: 3.0,
      icono: '🧀',
    ),
    // 🔥 PREPARADO PARA FUTUROS ADICIONALES
    // Adicional(
    //   nombre: 'Doble Carne',
    //   precio: 5.0,
    //   icono: '🥩',
    // ),
    // Adicional(
    //   nombre: 'Champiñones',
    //   precio: 4.0,
    //   icono: '🍄',
    // ),
    // Adicional(
    //   nombre: 'Aceitunas',
    //   precio: 3.0,
    //   icono: '🫒',
    // ),
    // Adicional(
    //   nombre: 'Pepperoni Extra',
    //   precio: 4.0,
    //   icono: '🌶️',
    // ),
  ];
}