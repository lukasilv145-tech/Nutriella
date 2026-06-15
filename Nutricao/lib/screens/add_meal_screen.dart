import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meal_provider.dart';
import '../models/meal.dart';
import '../data/food_database.dart';
import 'food_selection_screen.dart';

class AddMealScreen extends StatefulWidget {
  final DateTime date;

  const AddMealScreen({super.key, required this.date});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  String _selectedMealType = 'breakfast';
  final List<MealItem> _selectedItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Refeição'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // Meal type selector
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Tipo de Refeição',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildMealTypeChip('breakfast', 'Café da Manhã', Icons.breakfast_dining),
                      const SizedBox(width: 8),
                      _buildMealTypeChip('lunch', 'Almoço', Icons.lunch_dining),
                      const SizedBox(width: 8),
                      _buildMealTypeChip('dinner', 'Jantar', Icons.dinner_dining),
                      const SizedBox(width: 8),
                      _buildMealTypeChip('snack', 'Lanche', Icons.cookie),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          
          // Selected items
          Expanded(
            child: _selectedItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.restaurant_menu, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhum alimento selecionado',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: _openFoodSelection,
                          icon: const Icon(Icons.add),
                          label: const Text('Adicionar Alimentos'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _selectedItems.length,
                    itemBuilder: (context, index) {
                      final item = _selectedItems[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(item.foodName),
                          subtitle: Text('${item.grams.toStringAsFixed(0)}g - ${item.calories.toStringAsFixed(0)} kcal'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _selectedItems.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
          
          // Summary and save button
          if (_selectedItems.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: const Border(top: BorderSide(color: Colors.grey)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSummaryRow('Calorias', _totalCalories, 'kcal'),
                  _buildSummaryRow('Proteína', _totalProtein, 'g'),
                  _buildSummaryRow('Carboidratos', _totalCarbs, 'g'),
                  _buildSummaryRow('Gorduras', _totalFat, 'g'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _openFoodSelection,
                          icon: const Icon(Icons.add),
                          label: const Text('Mais Alimentos'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[600],
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _saveMeal,
                          icon: const Icon(Icons.save),
                          label: const Text('Salvar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMealTypeChip(String type, String label, IconData icon) {
    final isSelected = _selectedMealType == type;
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedMealType = type;
        });
      },
      selectedColor: Colors.green.withOpacity(0.3),
      checkmarkColor: Colors.green,
    );
  }

  Widget _buildSummaryRow(String label, double value, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            '${value.toStringAsFixed(1)} $unit',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  double get _totalCalories => _selectedItems.fold(0, (sum, item) => sum + item.calories);
  double get _totalProtein => _selectedItems.fold(0, (sum, item) => sum + item.protein);
  double get _totalCarbs => _selectedItems.fold(0, (sum, item) => sum + item.carbs);
  double get _totalFat => _selectedItems.fold(0, (sum, item) => sum + item.fat);

  void _openFoodSelection() async {
    final result = await Navigator.of(context).push<List<MealItem>>(
      MaterialPageRoute(
        builder: (_) => FoodSelectionScreen(existingItems: _selectedItems),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedItems.clear();
        _selectedItems.addAll(result);
      });
    }
  }

  void _saveMeal() {
    if (_selectedItems.isEmpty) return;

    final meal = Meal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: _selectedMealType,
      date: widget.date,
      items: List.from(_selectedItems),
    );

    Provider.of<MealProvider>(context, listen: false).addMeal(meal);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Refeição salva com sucesso!')),
    );
    
    Navigator.of(context).pop();
  }
}
