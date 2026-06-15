import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../models/food.dart';
import '../data/food_database.dart';

class FoodSelectionScreen extends StatefulWidget {
  final List<MealItem> existingItems;

  const FoodSelectionScreen({super.key, required this.existingItems});

  @override
  State<FoodSelectionScreen> createState() => _FoodSelectionScreenState();
}

class _FoodSelectionScreenState extends State<FoodSelectionScreen> {
  String _selectedCategory = 'all';
  String _searchQuery = '';
  final List<MealItem> _selectedItems = [];
  final Map<String, double> _selectedGrams = {};

  @override
  void initState() {
    super.initState();
    _selectedItems.addAll(widget.existingItems);
    for (var item in widget.existingItems) {
      _selectedGrams[item.foodId] = item.grams;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Food> foods;
    
    if (_selectedCategory == 'all') {
      foods = FoodDatabase.searchFoods(_searchQuery);
    } else {
      foods = FoodDatabase.getFoodsByCategory(_selectedCategory)
          .where((food) => food.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar Alimentos'),
        backgroundColor: Colors.green,
        actions: [
          if (_selectedItems.isNotEmpty)
            TextButton.icon(
              onPressed: _saveSelection,
              icon: const Icon(Icons.check, color: Colors.white),
              label: const Text(
                'Salvar',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar alimentos...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          
          // Category filter
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCategoryChip('all', 'Todos'),
                ...FoodDatabase.getCategories().map((cat) => 
                  _buildCategoryChip(cat, FoodDatabase.getCategoryName(cat)),
                ),
              ],
            ),
          ),
          
          const Divider(),
          
          // Food list
          Expanded(
            child: foods.isEmpty
                ? Center(
                    child: Text(
                      'Nenhum alimento encontrado',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: foods.length,
                    itemBuilder: (context, index) {
                      final food = foods[index];
                      final isSelected = _selectedItems.any((item) => item.foodId == food.id);
                      final grams = _selectedGrams[food.id] ?? food.servingSize;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Text(
                            food.emoji ?? '🍽️',
                            style: const TextStyle(fontSize: 32),
                          ),
                          title: Text(food.name),
                          subtitle: Text(
                            '${food.calories.toStringAsFixed(0)} kcal/100g | '
                            'P: ${food.protein}g | C: ${food.carbs}g | G: ${food.fat}g',
                          ),
                          trailing: isSelected
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                                      onPressed: () => _removeFood(food),
                                    ),
                                    SizedBox(
                                      width: 60,
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                                          border: OutlineInputBorder(),
                                        ),
                                        controller: TextEditingController(
                                          text: grams.toStringAsFixed(0),
                                        )..selection = TextSelection.fromPosition(
                                            TextPosition(offset: grams.toStringAsFixed(0).length),
                                          ),
                                        onSubmitted: (value) {
                                          final newGrams = double.tryParse(value);
                                          if (newGrams != null && newGrams > 0) {
                                            _updateGrams(food, newGrams);
                                          }
                                        },
                                      ),
                                    ),
                                    const Text('g', style: TextStyle(fontSize: 12)),
                                  ],
                                )
                              : IconButton(
                                  icon: const Icon(Icons.add_circle, color: Colors.green),
                                  onPressed: () => _addFood(food),
                                ),
                        ),
                      );
                    },
                  ),
          ),
          
          // Selected items summary
          if (_selectedItems.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: const Border(top: BorderSide(color: Colors.grey)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${_selectedItems.length} alimento(s) selecionado(s)',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total: ${_totalCalories.toStringAsFixed(0)} kcal',
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category, String label) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = category;
          });
        },
        selectedColor: Colors.green.withOpacity(0.3),
        checkmarkColor: Colors.green,
      ),
    );
  }

  void _addFood(Food food) {
    final nutrients = food.getNutrients(food.servingSize);
    setState(() {
      _selectedItems.add(MealItem(
        foodId: food.id,
        foodName: food.name,
        grams: food.servingSize,
        calories: nutrients['calories']!,
        protein: nutrients['protein']!,
        carbs: nutrients['carbs']!,
        fat: nutrients['fat']!,
      ));
      _selectedGrams[food.id] = food.servingSize;
    });
  }

  void _removeFood(Food food) {
    setState(() {
      _selectedItems.removeWhere((item) => item.foodId == food.id);
      _selectedGrams.remove(food.id);
    });
  }

  void _updateGrams(Food food, double grams) {
    final nutrients = food.getNutrients(grams);
    setState(() {
      final index = _selectedItems.indexWhere((item) => item.foodId == food.id);
      if (index != -1) {
        _selectedItems[index] = MealItem(
          foodId: food.id,
          foodName: food.name,
          grams: grams,
          calories: nutrients['calories']!,
          protein: nutrients['protein']!,
          carbs: nutrients['carbs']!,
          fat: nutrients['fat']!,
        );
        _selectedGrams[food.id] = grams;
      }
    });
  }

  double get _totalCalories => _selectedItems.fold(0, (sum, item) => sum + item.calories);

  void _saveSelection() {
    Navigator.of(context).pop(_selectedItems);
  }
}
