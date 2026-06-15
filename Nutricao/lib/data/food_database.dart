import '../models/food.dart';

class FoodDatabase {
  static List<Food> getFoods() {
    return [
      // Proteínas
      Food(
        id: '1',
        name: 'Peito de Frango Grelhado',
        category: 'proteins',
        calories: 165,
        protein: 31,
        carbs: 0,
        fat: 3.6,
        emoji: '🍗',
        servingSize: 100,
      ),
      Food(
        id: '2',
        name: 'Ovo Cozido',
        category: 'proteins',
        calories: 155,
        protein: 13,
        carbs: 1.1,
        fat: 11,
        emoji: '🥚',
        servingSize: 100,
      ),
      Food(
        id: '3',
        name: 'Carne Bovida Magra',
        category: 'proteins',
        calories: 250,
        protein: 26,
        carbs: 0,
        fat: 15,
        emoji: '🥩',
        servingSize: 100,
      ),
      Food(
        id: '4',
        name: 'Peixe Branco',
        category: 'proteins',
        calories: 90,
        protein: 18,
        carbs: 0,
        fat: 1,
        emoji: '🐟',
        servingSize: 100,
      ),
      Food(
        id: '5',
        name: 'Atum em Conserva',
        category: 'proteins',
        calories: 116,
        protein: 26,
        carbs: 0,
        fat: 1,
        emoji: '🐟',
        servingSize: 100,
      ),
      Food(
        id: '6',
        name: 'Tofu',
        category: 'proteins',
        calories: 76,
        protein: 8,
        carbs: 1.9,
        fat: 4.8,
        emoji: '🧈',
        servingSize: 100,
      ),
      Food(
        id: '7',
        name: 'Iogurte Natural',
        category: 'proteins',
        calories: 59,
        protein: 10,
        carbs: 3.6,
        fat: 0.4,
        emoji: '🥛',
        servingSize: 100,
      ),
      Food(
        id: '8',
        name: 'Queijo Minas',
        category: 'proteins',
        calories: 320,
        protein: 25,
        carbs: 0,
        fat: 25,
        emoji: '🧀',
        servingSize: 100,
      ),
      
      // Carboidratos
      Food(
        id: '9',
        name: 'Arroz Branco Cozido',
        category: 'carbs',
        calories: 130,
        protein: 2.7,
        carbs: 28,
        fat: 0.3,
        emoji: '🍚',
        servingSize: 100,
      ),
      Food(
        id: '10',
        name: 'Arroz Integral',
        category: 'carbs',
        calories: 111,
        protein: 2.6,
        carbs: 23,
        fat: 0.9,
        emoji: '🍚',
        servingSize: 100,
      ),
      Food(
        id: '11',
        name: 'Feijão Preto Cozido',
        category: 'carbs',
        calories: 132,
        protein: 8.7,
        carbs: 24,
        fat: 0.5,
        emoji: '🫘',
        servingSize: 100,
      ),
      Food(
        id: '12',
        name: 'Batata Cozida',
        category: 'carbs',
        calories: 87,
        protein: 1.9,
        carbs: 20,
        fat: 0.1,
        emoji: '🥔',
        servingSize: 100,
      ),
      Food(
        id: '13',
        name: 'Pão Francês',
        category: 'carbs',
        calories: 285,
        protein: 9,
        carbs: 50,
        fat: 3,
        emoji: '🥖',
        servingSize: 100,
      ),
      Food(
        id: '14',
        name: 'Pão Integral',
        category: 'carbs',
        calories: 250,
        protein: 13,
        carbs: 45,
        fat: 3,
        emoji: '🍞',
        servingSize: 100,
      ),
      Food(
        id: '15',
        name: 'Macarrão Cozido',
        category: 'carbs',
        calories: 131,
        protein: 5,
        carbs: 25,
        fat: 1.1,
        emoji: '🍝',
        servingSize: 100,
      ),
      Food(
        id: '16',
        name: 'Aveia em Flocos',
        category: 'carbs',
        calories: 389,
        protein: 16.9,
        carbs: 66,
        fat: 6.9,
        emoji: '🥣',
        servingSize: 100,
      ),
      Food(
        id: '17',
        name: 'Banana',
        category: 'fruits',
        calories: 89,
        protein: 1.1,
        carbs: 23,
        fat: 0.3,
        emoji: '🍌',
        servingSize: 100,
      ),
      Food(
        id: '18',
        name: 'Maçã',
        category: 'fruits',
        calories: 52,
        protein: 0.3,
        carbs: 14,
        fat: 0.2,
        emoji: '🍎',
        servingSize: 100,
      ),
      
      // Vegetais
      Food(
        id: '19',
        name: 'Alface',
        category: 'vegetables',
        calories: 15,
        protein: 1.4,
        carbs: 2.9,
        fat: 0.2,
        emoji: '🥬',
        servingSize: 100,
      ),
      Food(
        id: '20',
        name: 'Tomate',
        category: 'vegetables',
        calories: 18,
        protein: 0.9,
        carbs: 3.9,
        fat: 0.2,
        emoji: '🍅',
        servingSize: 100,
      ),
      Food(
        id: '21',
        name: 'Brócolis Cozido',
        category: 'vegetables',
        calories: 35,
        protein: 2.4,
        carbs: 7,
        fat: 0.4,
        emoji: '🥦',
        servingSize: 100,
      ),
      Food(
        id: '22',
        name: 'Cenoura',
        category: 'vegetables',
        calories: 41,
        protein: 0.9,
        carbs: 10,
        fat: 0.2,
        emoji: '🥕',
        servingSize: 100,
      ),
      
      // Gorduras
      Food(
        id: '23',
        name: 'Azeite de Oliva',
        category: 'fats',
        calories: 884,
        protein: 0,
        carbs: 0,
        fat: 100,
        emoji: '🫒',
        servingSize: 100,
      ),
      Food(
        id: '24',
        name: 'Abacate',
        category: 'fats',
        calories: 160,
        protein: 2,
        carbs: 8.5,
        fat: 15,
        emoji: '🥑',
        servingSize: 100,
      ),
      Food(
        id: '25',
        name: 'Amendoim',
        category: 'fats',
        calories: 567,
        protein: 25,
        carbs: 16,
        fat: 49,
        emoji: '🥜',
        servingSize: 100,
      ),
      Food(
        id: '26',
        name: 'Manteiga',
        category: 'fats',
        calories: 717,
        protein: 0.9,
        carbs: 0.1,
        fat: 81,
        emoji: '🧈',
        servingSize: 100,
      ),
      
      // Bebidas
      Food(
        id: '27',
        name: 'Leite Integral',
        category: 'beverages',
        calories: 61,
        protein: 3.2,
        carbs: 4.8,
        fat: 3.3,
        emoji: '🥛',
        servingSize: 100,
      ),
      Food(
        id: '28',
        name: 'Leite Desnatado',
        category: 'beverages',
        calories: 35,
        protein: 3.4,
        carbs: 5,
        fat: 0.1,
        emoji: '🥛',
        servingSize: 100,
      ),
      Food(
        id: '29',
        name: 'Suco de Laranja Natural',
        category: 'beverages',
        calories: 45,
        protein: 0.7,
        carbs: 10.4,
        fat: 0.2,
        emoji: '🍊',
        servingSize: 100,
      ),
      Food(
        id: '30',
        name: 'Café Preto',
        category: 'beverages',
        calories: 2,
        protein: 0.3,
        carbs: 0,
        fat: 0,
        emoji: '☕',
        servingSize: 100,
      ),
    ];
  }

  static List<Food> getFoodsByCategory(String category) {
    return getFoods().where((food) => food.category == category).toList();
  }

  static List<String> getCategories() {
    return ['proteins', 'carbs', 'vegetables', 'fruits', 'fats', 'beverages'];
  }

  static String getCategoryName(String category) {
    switch (category) {
      case 'proteins':
        return 'Proteínas';
      case 'carbs':
        return 'Carboidratos';
      case 'vegetables':
        return 'Vegetais';
      case 'fruits':
        return 'Frutas';
      case 'fats':
        return 'Gorduras';
      case 'beverages':
        return 'Bebidas';
      default:
        return category;
    }
  }

  static List<Food> searchFoods(String query) {
    final foods = getFoods();
    if (query.isEmpty) return foods;
    return foods.where((food) =>
      food.name.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}
