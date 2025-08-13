import '../models/models.dart';

class PizzaData {
  // 🍕 PIZZAS EXISTENTES CON NUEVO PRECIO EXTRA GRANDE (sin cambios)
  static final List<Pizza> pizzas = [
    Pizza(
      nombre: 'Americana',
      ingredientes: 'Queso mozzarella, jamón, salchichón',
      precioFamiliar: 26.0,
      precioPersonal: 10.0,
      precioExtraGrande: 48.0,
      imagen: 'assets/images/pizzas/americana.png',
    ),
    Pizza(
      nombre: 'Hawaiana',
      ingredientes: 'Queso mozzarella, jamón, piña',
      precioFamiliar: 28.0,
      precioPersonal: 11.0,
      precioExtraGrande: 50.0,
      imagen: 'assets/images/pizzas/hawaiana.png',
    ),
    Pizza(
      nombre: 'Pepperoni',
      ingredientes: 'Queso mozzarella, pepperoni',
      precioFamiliar: 30.0,
      precioPersonal: 13.0,
      precioExtraGrande: 54.0,
      imagen: 'assets/images/pizzas/pepperoni.png',
    ),
    Pizza(
      nombre: 'Extremo',
      ingredientes: 'Queso mozzarella, tocino, pepperoni, jamon, chorizon, cabanossi',
      precioFamiliar: 32.0,
      precioPersonal: 13.0,
      precioExtraGrande: 55.0,
      imagen: 'assets/images/pizzas/extremo.png',
    ),
    Pizza(
      nombre: 'Tocino',
      ingredientes: 'Queso mozzarella, tocino, jamón',
      precioFamiliar: 29.0,
      precioPersonal: 12.0,
      precioExtraGrande: 52.0,
      imagen: 'assets/images/pizzas/tocino.png',
    ),
    Pizza(
      nombre: 'Africana',
      ingredientes: 'Queso mozzarella, salchichón, jamón, pepperoni, tocino. (todos en tiras)',
      precioFamiliar: 30.0,
      precioPersonal: 13.0,
      precioExtraGrande: 55.0,
      imagen: 'assets/images/pizzas/africana.png',
    ),
  ];

  // 🍗 MOSTRITOS (sin cambios)
  static final List<Mostrito> mostritos = [
    Mostrito(
      nombre: 'Mostrito ala',
      descripcion: 'Broaster ala + chaufa + papas fritas + gaseosa 355ml',
      precio: 11.0,
      imagen: 'assets/images/mostritos/mostrito_ala.png',
    ),
    Mostrito(
      nombre: 'Mostrito pecho',
      descripcion: 'Broaster pecho + chaufa + papas fritas + gaseosa 355ml',
      precio: 14.0,
      imagen: 'assets/images/mostritos/mostrito_pecho.png',
    ),
    Mostrito(
      nombre: 'Mostrito pierna',
      descripcion: 'Broaster pierna + chaufa + papas fritas + gaseosa 355ml',
      precio: 12.0,
      imagen: 'assets/images/mostritos/mostrito_pierna.png',
    ),
  ];

  // 🍕 PIZZAS ESPECIALES 2 SABORES (sin cambios)
  static final List<PizzaEspecial> pizzasEspeciales = [
    PizzaEspecial(
      nombre: 'Americana y pepperoni',
      descripcion: 'Mitad americana + mitad pepperoni + gaseosa 750ml',
      precio: 35.0,
      imagen: 'assets/images/pizzas/americana_pepperoni.png',
      tipo: '2 Sabores',
    ),
    PizzaEspecial(
      nombre: 'Hawaiana y pepperoni',
      descripcion: 'Mitad hawaiana + mitad pepperoni + gaseosa 750ml',
      precio: 35.0,
      imagen: 'assets/images/pizzas/hawaiana_pepperoni.png',
      tipo: '2 Sabores',
    ),
    PizzaEspecial(
      nombre: 'Americana y tocino',
      descripcion: 'Mitad americana + mitad tocino + gaseosa 750ml',
      precio: 36.0,
      imagen: 'assets/images/pizzas/americana_tocino.png',
      tipo: '2 Sabores',
    ),
    PizzaEspecial(
      nombre: 'Hawaiana y tocino',
      descripcion: 'Mitad hawaiana + mitad tocino + gaseosa 750ml',
      precio: 36.0,
      imagen: 'assets/images/pizzas/hawaiana_tocino.png',
      tipo: '2 Sabores',
    ),
    PizzaEspecial(
      nombre: 'Pepperoni y tocino',
      descripcion: 'Mitad pepperoni + mitad tocino + gaseosa 750ml',
      precio: 37.0,
      imagen: 'assets/images/pizzas/pepperoni_tocino.png',
      tipo: '2 Sabores',
    ),
    PizzaEspecial(
      nombre: 'Dúo 4 sabores',
      descripcion: '2 pizzas familiares una mitad hawaiana + americana y otra mitad pepperoni + tocino.',
      precio: 55.0,
      imagen: 'assets/images/pizzas/duo_4_sabores.png',
      tipo: '4 Sabores',
    ),
  ];

  // COMBOS BROASTER (sin cambios)
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
      descripcion: '8 piezas de pollo + papas fritas + cremas + 2 gaseosa 750ml',
      precio: 48.0,
      imagen: 'assets/images/combos/combo_5.png',
    ),
  ];

  // 🍕 COMBOS PIZZA
  static final List<Combo> combosPizza = [
    Combo(
      nombre: 'Combo clásico',
      descripcion: 'Mitad Americana + mitad Hawaiana + pepsi 750ml + 3 porciones de pan al ajo',
      precio: 32.0,
      imagen: 'assets/images/combos/combo_clasico.png',
    ),
    Combo(
      nombre: 'Combo compartir',
      descripcion: '2 pizzas americanas, tamaño familiar y personal',
      precio: 34.0,
      imagen: 'assets/images/combos/combo_compartir.png',
    ),
    Combo(
      nombre: 'Combo brother',
      descripcion: '3 pizzas personales pepperoni, hawaiana y americana + pepsi 750ml',
      precio: 32.0,
      imagen: 'assets/images/combos/combo_brother.png',
    ),
    Combo(
      nombre: 'Combo familiar',
      descripcion: 'Americana + pepsi 750ml + 3 porciones de pan al ajo',
      precio: 29.0,
      imagen: 'assets/images/combos/combo_familiar_pizza.png',
    ),
    Combo(
      nombre: 'Oferta dúo',
      descripcion: '2 pizzas familiares hawaiana + americana',
      precio: 50.0,
      imagen: 'assets/images/combos/oferta_duo.png',
    ),
  ];

  static final List<Combo> fusiones = [
    Combo(
      nombre: 'Fusión junior',
      descripcion: 'Pizza personal+Pepsi 750ml+2 broaster+papas fritas+2 panes al ajo',
      precio: 28.0,
      imagen: 'assets/images/combos/fusion_junior.png',
    ),
    Combo(
      nombre: 'Familiar + broaster',
      descripcion: 'Pizza familiar + 6 brazitos de pollo + Pepsi 750ml',
      precio: 35.0,
      imagen: 'assets/images/combos/familiar_broaster.png',
    ),
    Combo(
      nombre: 'Combo estrella',
      descripcion: 'Pizza familiar 2 sabores + 6 Bracitos + Porción de papas + Pepsi 750ml',
      precio: 42.0,
      imagen: 'assets/images/combos/combo_estrella.png',
    ),
    Combo(
      nombre: 'Fusión familiar',
      descripcion: 'Pizza familiar + 4 broaster + papas + 2 Pepsi 750 ml + 4 panes de ajo.',
      precio: 50.0,
      imagen: 'assets/images/combos/fusion_familiar.png',
    ),
  ];

  // 🔥 ADICIONALES ACTUALIZADOS PARA PIZZAS PERSONALES
  static final List<Adicional> adicionalesPersonal = [
    // 🍞 PANES AL AJO
    Adicional(
      nombre: '5 panes al ajo clásico',
      precio: 5.0,
      icono: '🍞',
    ),
    Adicional(
      nombre: '10 panes al ajo clásico',
      precio: 9.0,
      icono: '🍞',
    ),
    Adicional(
      nombre: '5 panes al ajo con queso',
      precio: 8.0,
      icono: '🧄',
    ),
    Adicional(
      nombre: '10 panes al ajo con queso',
      precio: 15.0,
      icono: '🧄',
    ),
    // 🧀 QUESO ADICIONAL
    Adicional(
      nombre: 'Queso adicional',
      precio: 4.0,
      icono: '🧀',
    ),
    // 🍗 ALAS Y PAPAS
    Adicional(
      nombre: '2 alas adicionales',
      precio: 9.0,
      icono: '🍗',
    ),
    Adicional(
      nombre: '1 papas adicionales',
      precio: 7.0,
      icono: '🍟',
    ),
    // 🥤 GASEOSAS
    Adicional(
      nombre: 'Pepsi 350ml (primera)',
      precio: 1.0, // 🔥 PRECIO ESPECIAL PARA LA PRIMERA
      icono: '🥤',
    ),
    Adicional(
      nombre: 'Pepsi 350ml',
      precio: 2.0,
      icono: '🥤',
    ),
    Adicional(
      nombre: 'Pepsi 750ml',
      precio: 4.0,
      icono: '🥤',
    ),
  ];

  // 🔥 ADICIONALES PARA PIZZAS FAMILIARES
  static final List<Adicional> adicionalesFamiliar = [
    // 🍞 PANES AL AJO
    Adicional(
      nombre: '5 panes al ajo clásico',
      precio: 5.0,
      icono: '🍞',
    ),
    Adicional(
      nombre: '10 panes al ajo clásico',
      precio: 9.0,
      icono: '🍞',
    ),
    Adicional(
      nombre: '5 panes al ajo con queso',
      precio: 8.0,
      icono: '🧄',
    ),
    Adicional(
      nombre: '10 panes al ajo con queso',
      precio: 15.0,
      icono: '🧄',
    ),
    // 🧀 QUESO ADICIONAL
    Adicional(
      nombre: 'Queso adicional',
      precio: 8.0,
      icono: '🧀',
    ),
    // 🍗 ALAS Y PAPAS
    Adicional(
      nombre: '2 alas adicionales',
      precio: 9.0,
      icono: '🍗',
    ),
    Adicional(
      nombre: '1 papas adicionales',
      precio: 7.0,
      icono: '🍟',
    ),
    // 🥤 GASEOSAS
    Adicional(
      nombre: 'Pepsi 350ml',
      precio: 2.0,
      icono: '🥤',
    ),
    Adicional(
      nombre: 'Pepsi 750ml',
      precio: 4.0,
      icono: '🥤',
    ),
  ];

  // 🔥 ADICIONALES PARA PIZZAS EXTRA GRANDES
  static final List<Adicional> adicionalesExtraGrande = [
    // 🍞 PANES AL AJO
    Adicional(
      nombre: '5 panes al ajo clásico',
      precio: 5.0,
      icono: '🍞',
    ),
    Adicional(
      nombre: '10 panes al ajo clásico',
      precio: 9.0,
      icono: '🍞',
    ),
    Adicional(
      nombre: '5 panes al ajo con queso',
      precio: 8.0,
      icono: '🧄',
    ),
    Adicional(
      nombre: '10 panes al ajo con queso',
      precio: 15.0,
      icono: '🧄',
    ),
    // 🧀 QUESO ADICIONAL
    Adicional(
      nombre: 'Queso adicional',
      precio: 15.0, // 🔥 PRECIO MAYOR PARA EXTRA GRANDE
      icono: '🧀',
    ),
    // 🍗 ALAS Y PAPAS
    Adicional(
      nombre: '2 alas adicionales',
      precio: 9.0,
      icono: '🍗',
    ),
    Adicional(
      nombre: '1 papas adicionales',
      precio: 7.0,
      icono: '🍟',
    ),
    // 🥤 GASEOSAS
    Adicional(
      nombre: 'Pepsi 350ml',
      precio: 2.0,
      icono: '🥤',
    ),
    Adicional(
      nombre: 'Pepsi 750ml',
      precio: 4.0,
      icono: '🥤',
    ),
  ];

  // 🔥 ADICIONALES PARA MOSTRITOS Y COMBOS BROASTER (SIN QUESO)
  static final List<Adicional> adicionalesBroaster = [
    // 🍞 PANES AL AJO
    Adicional(
      nombre: '5 panes al ajo clásico',
      precio: 5.0,
      icono: '🍞',
    ),
    Adicional(
      nombre: '10 panes al ajo clásico',
      precio: 9.0,
      icono: '🍞',
    ),
    Adicional(
      nombre: '5 panes al ajo con queso',
      precio: 8.0,
      icono: '🧄',
    ),
    Adicional(
      nombre: '10 panes al ajo con queso',
      precio: 15.0,
      icono: '🧄',
    ),
    // 🍗 ALAS Y PAPAS (SIN QUESO ADICIONAL)
    Adicional(
      nombre: '2 alas adicionales',
      precio: 9.0,
      icono: '🍗',
    ),
    Adicional(
      nombre: '1 papas adicionales',
      precio: 7.0,
      icono: '🍟',
    ),
    // 🥤 GASEOSAS
    Adicional(
      nombre: 'Pepsi 350ml',
      precio: 2.0,
      icono: '🥤',
    ),
    Adicional(
      nombre: 'Pepsi 750ml',
      precio: 4.0,
      icono: '🥤',
    ),
  ];

  // 🔥 ADICIONALES PARA COMBOS CON PIZZAS (FUSIONES Y PIZZAS ESPECIALES)
  static final List<Adicional> adicionalesCombo = [
    // 🍞 PANES AL AJO
    Adicional(
      nombre: '5 panes al ajo clásico',
      precio: 5.0,
      icono: '🍞',
    ),
    Adicional(
      nombre: '10 panes al ajo clásico',
      precio: 9.0,
      icono: '🍞',
    ),
    Adicional(
      nombre: '5 panes al ajo con queso',
      precio: 8.0,
      icono: '🧄',
    ),
    Adicional(
      nombre: '10 panes al ajo con queso',
      precio: 15.0,
      icono: '🧄',
    ),
    // 🧀 QUESO ADICIONAL
    Adicional(
      nombre: 'Queso adicional',
      precio: 6.0,
      icono: '🧀',
    ),
    // 🍗 ALAS Y PAPAS
    Adicional(
      nombre: '2 alas adicionales',
      precio: 9.0,
      icono: '🍗',
    ),
    Adicional(
      nombre: '1 papas adicionales',
      precio: 7.0,
      icono: '🍟',
    ),
    // 🥤 GASEOSAS
    Adicional(
      nombre: 'Pepsi 350ml',
      precio: 2.0,
      icono: '🥤',
    ),
    Adicional(
      nombre: 'Pepsi 750ml',
      precio: 4.0,
      icono: '🥤',
    ),
  ];

  // 🔥 ADICIONALES ESPECIALES PARA COMBO ESTRELLA Y OFERTA DÚO
  static final List<Adicional> adicionalesEspeciales = [
    // 🍞 PANES AL AJO
    Adicional(
      nombre: '5 panes al ajo clásico',
      precio: 5.0,
      icono: '🍞',
    ),
    Adicional(
      nombre: '10 panes al ajo clásico',
      precio: 9.0,
      icono: '🍞',
    ),
    Adicional(
      nombre: '5 panes al ajo con queso',
      precio: 8.0,
      icono: '🧄',
    ),
    Adicional(
      nombre: '10 panes al ajo con queso',
      precio: 15.0,
      icono: '🧄',
    ),
    // 🧀 QUESO ADICIONAL
    Adicional(
      nombre: 'Queso adicional',
      precio: 6.0,
      icono: '🧀',
    ),
    // 🔄 CAMBIOS GRATUITOS ESPECIALES
    Adicional(
      nombre: 'Cambiar a solo Americana',
      precio: 0.0, // 🔥 GRATUITO
      icono: '🔄',
    ),
    // 🍗 ALAS Y PAPAS
    Adicional(
      nombre: '2 alas adicionales',
      precio: 9.0,
      icono: '🍗',
    ),
    Adicional(
      nombre: '1 papas adicionales',
      precio: 7.0,
      icono: '🍟',
    ),
    // 🥤 GASEOSAS
    Adicional(
      nombre: 'Pepsi 350ml',
      precio: 2.0,
      icono: '🥤',
    ),
    Adicional(
      nombre: 'Pepsi 750ml',
      precio: 4.0,
      icono: '🥤',
    ),
  ];
}