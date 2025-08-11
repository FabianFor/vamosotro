import '../models/models.dart';

class PizzaData {
  // 🍕 PIZZAS EXISTENTES (Solo las 6 de la carta)
  static final List<Pizza> pizzas = [
    Pizza(
      nombre: 'Americana',
      ingredientes: 'Queso mozzarella, jamón, salchichón',
      precioFamiliar: 26.0,
      precioPersonal: 11.0,
      imagen: 'assets/images/pizzas/americana.png',
    ),
    Pizza(
      nombre: 'Hawaiana',
      ingredientes: 'Queso mozzarella, jamón, piña',
      precioFamiliar: 28.0,
      precioPersonal: 12.0,
      imagen: 'assets/images/pizzas/hawaiana.png',
    ),
    Pizza(
      nombre: 'Pepperoni',
      ingredientes: 'Queso mozzarella, pepperoni',
      precioFamiliar: 30.0,
      precioPersonal: 14.0,
      imagen: 'assets/images/pizzas/pepperoni.png',
    ),
    Pizza(
      nombre: 'Extremo',
      ingredientes: 'Queso mozzarella, salami, jamón, tocino, pepperoni, chorizo español',
      precioFamiliar: 32.0,
      precioPersonal: 14.0,
      imagen: 'assets/images/pizzas/extremo.png',
    ),
    Pizza(
      nombre: 'Tocino',
      ingredientes: 'Queso mozzarella, tocino, jamón',
      precioFamiliar: 29.0,
      precioPersonal: 13.0,
      imagen: 'assets/images/pizzas/tocino.png',
    ),
    Pizza(
      nombre: 'Africana',
      ingredientes: 'Queso mozzarella, salami, salchichón, jamón, pepperoni, chorizo español',
      precioFamiliar: 30.0,
      precioPersonal: 14.0,
      imagen: 'assets/images/pizzas/africana.png',
    ),
  ];

  // 🍗 MOSTRITOS (Broaster Ala, Pecho, Pierna)
  static final List<Mostrito> mostritos = [
    Mostrito(
      nombre: 'Mostrito Ala',
      descripcion: 'Broaster Ala + Chaufa + Papas Fritas + Gaseosa',
      precio: 11.0,
      imagen: 'assets/images/mostritos/mostrito_ala.png',
    ),
    Mostrito(
      nombre: 'Mostrito Pecho',
      descripcion: 'Broaster Pecho + Chaufa + Papas Fritas + Gaseosa',
      precio: 14.0,
      imagen: 'assets/images/mostritos/mostrito_pecho.png',
    ),
    Mostrito(
      nombre: 'Mostrito Pierna',
      descripcion: 'Broaster Pierna + Chaufa + Papas Fritas + Gaseosa',
      precio: 12.0,
      imagen: 'assets/images/mostritos/mostrito_pierna.png',
    ),
  ];

  // 🍕 PIZZAS ESPECIALES 2 SABORES (Según carta completa)
  static final List<PizzaEspecial> pizzasEspeciales = [
    PizzaEspecial(
      nombre: 'Americana y Pepperoni',
      descripcion: 'Mitad americana + Mitad pepperoni + gaseosa 750ml',
      precio: 35.0,
      imagen: 'assets/images/pizzas/americana_pepperoni.png',
      tipo: '2 Sabores',
    ),
    PizzaEspecial(
      nombre: 'Hawaiana y Pepperoni',
      descripcion: 'Mitad hawaiana + Mitad pepperoni + gaseosa 750ml',
      precio: 35.0,
      imagen: 'assets/images/pizzas/hawaiana_pepperoni.png',
      tipo: '2 Sabores',
    ),
    PizzaEspecial(
      nombre: 'Americana y Tocino',
      descripcion: 'Mitad americana + Mitad tocino + gaseosa 750ml',
      precio: 36.0,
      imagen: 'assets/images/pizzas/americana_tocino.png',
      tipo: '2 Sabores',
    ),
    PizzaEspecial(
      nombre: 'Hawaiana y Tocino',
      descripcion: 'Mitad hawaiana + Mitad tocino + gaseosa 750ml',
      precio: 36.0,
      imagen: 'assets/images/pizzas/hawaiana_tocino.png',
      tipo: '2 Sabores',
    ),
    PizzaEspecial(
      nombre: 'Pepperoni y Tocino',
      descripcion: 'Mitad pepperoni + Mitad tocino + gaseosa 750ml',
      precio: 37.0,
      imagen: 'assets/images/pizzas/pepperoni_tocino.png',
      tipo: '2 Sabores',
    ),
    PizzaEspecial(
      nombre: 'Dúo 4 Sabores',
      descripcion: 'Pizza 1: Mitad hawaiana + Mitad americana. Pizza 2: Mitad pepperoni + Mitad tocino',
      precio: 55.0,
      imagen: 'assets/images/pizzas/duo_4_sabores.png',
      tipo: '4 Sabores',
    ),
  ];

  // 🍗 COMBOS BROASTER (Según carta completa)
  static final List<Combo> combosBroaster = [
    Combo(
      nombre: 'Combo 1',
      descripcion: '2 alitas + papas fritas + cremas + gaseosa 355ml',
      precio: 11.0,
      imagen: 'assets/images/combos/combo_1.png',
    ),
    Combo(
      nombre: 'Combo 2',
      descripcion: '2 piezas de pollo + papas fritas + cremas + gaseosa 355ml',
      precio: 13.0,
      imagen: 'assets/images/combos/combo_2.png',
    ),
    Combo(
      nombre: 'Combo 3',
      descripcion: '4 piezas de pollo + papas fritas + cremas + gaseosa 750ml',
      precio: 25.0,
      imagen: 'assets/images/combos/combo_3.png',
    ),
    Combo(
      nombre: 'Combo 4',
      descripcion: '6 piezas de pollo + papas fritas + cremas + gaseosa 750ml',
      precio: 35.0,
      imagen: 'assets/images/combos/combo_4.png',
    ),
    Combo(
      nombre: 'Combo 5',
      descripcion: '8 piezas de pollo + papas fritas + cremas + gaseosa 750ml',
      precio: 48.0,
      imagen: 'assets/images/combos/combo_5.png',
    ),
  ];

  // 🔥 FUSIONES (PIZZA + BROASTER) - según carta
  static final List<Combo> fusiones = [
    Combo(
      nombre: 'Fusión Junior',
      descripcion: 'Pizza personal (sabor a elección) + Pepsi jumbo + 2 broaster + papas fritas + 2 panes al ajo',
      precio: 28.0,
      imagen: 'assets/images/combos/fusion_junior.png',
    ),
    Combo(
      nombre: 'Familiar + Broaster',
      descripcion: 'Pizza familiar (sabor a elección) + 6 brazitos de pollo + 1 Pepsi jumbo',
      precio: 35.0,
      imagen: 'assets/images/combos/familiar_broaster.png',
    ),
    Combo(
      nombre: 'Fusión Familiar',
      descripcion: 'Pizza familiar (sabor a elección) + 4 piezas de pollo broaster + papas fritas + 2 Pepsi + 4 panes al ajo',
      precio: 50.0,
      imagen: 'assets/images/combos/fusion_familiar.png',
    ),
  ];

  // 🔥 ADICIONALES DISPONIBLES PARA PIZZAS FAMILIARES (30cm - 8 tajadas)
  static final List<Adicional> adicionalesFamiliar = [
    Adicional(
      nombre: 'Queso Extra',
      precio: 8.0,
      icono: '🧀',
    ),
    Adicional(
      nombre: 'Brazitos de Pollo',
      precio: 6.0,
      icono: '🍗',
    ),
    Adicional(
      nombre: 'Gaseosa Jumbo',
      precio: 4.0,
      icono: '🥤',
    ),
    Adicional(
      nombre: 'Doble Carne',
      precio: 8.0,
      icono: '🥩',
    ),
    Adicional(
      nombre: 'Champiñones',
      precio: 5.0,
      icono: '🍄',
    ),
    Adicional(
      nombre: 'Aceitunas',
      precio: 4.0,
      icono: '🫒',
    ),
    Adicional(
      nombre: 'Pepperoni Extra',
      precio: 6.0,
      icono: '🌶️',
    ),
  ];

  // 🔥 ADICIONALES DISPONIBLES PARA PIZZAS PERSONALES (18cm - 4 tajadas)
  static final List<Adicional> adicionalesPersonal = [
    Adicional(
      nombre: 'Queso Extra',
      precio: 4.0,
      icono: '🧀',
    ),
    Adicional(
      nombre: 'Brazitos de Pollo',
      precio: 3.0,
      icono: '🍗',
    ),
    Adicional(
      nombre: 'Gaseosa Personal',
      precio: 2.5,
      icono: '🥤',
    ),
    Adicional(
      nombre: 'Doble Carne',
      precio: 4.0,
      icono: '🥩',
    ),
    Adicional(
      nombre: 'Champiñones',
      precio: 3.0,
      icono: '🍄',
    ),
    Adicional(
      nombre: 'Aceitunas',
      precio: 2.5,
      icono: '🫒',
    ),
    Adicional(
      nombre: 'Pepperoni Extra',
      precio: 3.5,
      icono: '🌶️',
    ),
  ];

  // 🔥 ADICIONALES PARA COMBOS CON PIZZAS (FUSIONES Y PIZZAS ESPECIALES)
  static final List<Adicional> adicionalesCombo = [
    Adicional(
      nombre: 'Queso Extra',
      precio: 6.0,
      icono: '🧀',
    ),
    Adicional(
      nombre: 'Brazitos de Pollo Extra',
      precio: 5.0,
      icono: '🍗',
    ),
    Adicional(
      nombre: 'Gaseosa Extra',
      precio: 3.0,
      icono: '🥤',
    ),
    Adicional(
      nombre: 'Doble Carne',
      precio: 6.0,
      icono: '🥩',
    ),
  ];

  // 🎯 MÉTODO PARA OBTENER ADICIONALES SEGÚN EL TIPO DE PRODUCTO
  static List<Adicional> getAdicionalesDisponibles(String tamano) {
    switch (tamano) {
      case 'Familiar':
        return adicionalesFamiliar;
      case 'Personal':
        return adicionalesPersonal;
      case '2 Sabores':
      case '4 Sabores':
      case 'Fusión':
        return adicionalesCombo;
      default:
        return []; // Sin adicionales para mostritos y combos broaster puros
    }
  }

  // 🎯 MÉTODOS PARA OBTENER LISTAS ORDENADAS POR PRECIO
  
  static List<Pizza> get pizzasFamiliaresOrdenadas {
    List<Pizza> lista = List.from(pizzas);
    lista.sort((a, b) => a.precioFamiliar.compareTo(b.precioFamiliar));
    return lista;
  }

  static List<Pizza> get pizzasPersonalesOrdenadas {
    List<Pizza> lista = List.from(pizzas);
    lista.sort((a, b) => a.precioPersonal.compareTo(b.precioPersonal));
    return lista;
  }

  static List<Mostrito> get mostritosOrdenados {
    List<Mostrito> lista = List.from(mostritos);
    lista.sort((a, b) => a.precio.compareTo(b.precio));
    return lista;
  }

  static List<PizzaEspecial> get pizzasEspecialesOrdenadas {
    List<PizzaEspecial> lista = List.from(pizzasEspeciales);
    lista.sort((a, b) => a.precio.compareTo(b.precio));
    return lista;
  }

  static List<Combo> get combosBroasterOrdenados {
    List<Combo> lista = List.from(combosBroaster);
    lista.sort((a, b) => a.precio.compareTo(b.precio));
    return lista;
  }

  static List<Combo> get fusionesOrdenadas {
    List<Combo> lista = List.from(fusiones);
    lista.sort((a, b) => a.precio.compareTo(b.precio));
    return lista;
  }
}