import '../models/models.dart';

class PizzaData {
  static final List<Pizza> pizzas = [
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

  static final List<Combo> combos = [
    Combo(
      nombre: 'Combo Estrella',
      descripcion: 'Pizza Familiar 2 sabores + 6 Bracitos + Porción papas + Pepsi Jumbo',
      precio: 42.0,
    ),
  ];
}