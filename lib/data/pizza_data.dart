import '../models/models.dart';

class PizzaData {
  static final List<Pizza> pizzas = [
    Pizza(
      nombre: 'Americana',
      ingredientes: 'queso mozzarella, jamón, salchichón',
      precioFamiliar: 26.0,
      precioPersonal: 11.0,
      imagen: 'assets/images/americana.jpg', // 🔥 NUEVA IMAGEN
    ),
    Pizza(
      nombre: 'Hawaiana',
      ingredientes: 'queso mozzarella, jamón, piña',
      precioFamiliar: 28.0,
      precioPersonal: 12.0,
      imagen: 'assets/images/hawaiana.jpg', // 🔥 NUEVA IMAGEN
    ),
    Pizza(
      nombre: 'Pepperoni',
      ingredientes: 'queso mozzarella, pepperoni',
      precioFamiliar: 30.0,
      precioPersonal: 14.0,
      imagen: 'assets/images/pepperoni.jpg', // 🔥 NUEVA IMAGEN
    ),
    Pizza(
      nombre: 'Extremo',
      ingredientes: 'queso mozzarella, salami, jamón, tocino, pepperoni, chorizo español',
      precioFamiliar: 32.0,
      precioPersonal: 14.0,
      imagen: 'assets/images/extremo.jpg', // 🔥 NUEVA IMAGEN
    ),
    Pizza(
      nombre: 'Tocino',
      ingredientes: 'queso mozzarella, tocino, jamón',
      precioFamiliar: 29.0,
      precioPersonal: 13.0,
      imagen: 'assets/images/tocino.jpg', // 🔥 NUEVA IMAGEN
    ),
    Pizza(
      nombre: 'Africana',
      ingredientes: 'queso mozzarella, salami, salchichón, jamón, pepperoni, chorizo español',
      precioFamiliar: 30.0,
      precioPersonal: 14.0,
      imagen: 'assets/images/africana.jpg', // 🔥 NUEVA IMAGEN
    ),
  ];

  static final List<Combo> combos = [
    Combo(
      nombre: 'Combo Estrella',
      descripcion: 'Pizza Familiar 2 sabores + 6 Bracitos + Porción papas + Pepsi Jumbo',
      precio: 42.0,
      imagen: 'assets/images/combo_estrella.jpg', // 🔥 NUEVA IMAGEN
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