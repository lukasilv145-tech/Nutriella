import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/user_provider.dart';
import '../providers/meal_provider.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final mealProvider = Provider.of<MealProvider>(context);
    final user = userProvider.user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final today = DateTime.now();
    final weekAgo = today.subtract(const Duration(days: 7));

    // Calculate weekly averages
    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;
    int daysWithData = 0;

    final dailyData = <Map<String, dynamic>>[];

    for (int i = 0; i < 7; i++) {
      final date = weekAgo.add(Duration(days: i));
      final calories = mealProvider.getTotalCaloriesForDate(date);
      final protein = mealProvider.getTotalProteinForDate(date);
      final carbs = mealProvider.getTotalCarbsForDate(date);
      final fat = mealProvider.getTotalFatForDate(date);

      if (calories > 0) {
        totalCalories += calories;
        totalProtein += protein;
        totalCarbs += carbs;
        totalFat += fat;
        daysWithData++;
      }

      dailyData.add({
        'date': date,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
      });
    }

    final avgCalories = daysWithData > 0 ? totalCalories / daysWithData : 0;
    final avgProtein = daysWithData > 0 ? totalProtein / daysWithData : 0;
    final avgCarbs = daysWithData > 0 ? totalCarbs / daysWithData : 0;
    final avgFat = daysWithData > 0 ? totalFat / daysWithData : 0;

    final calorieGoal = user.calculateCalorieGoal();
    final macroGoals = user.calculateMacroGoals();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estatísticas'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Weekly summary
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Média Semanal (Últimos 7 dias)',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildStatRow('Calorias', avgCalories, calorieGoal, 'kcal', Colors.orange),
                    _buildStatRow('Proteína', avgProtein, macroGoals['protein']!, 'g', Colors.red),
                    _buildStatRow('Carboidratos', avgCarbs, macroGoals['carbs']!, 'g', Colors.blue),
                    _buildStatRow('Gorduras', avgFat, macroGoals['fat']!, 'g', Colors.yellow),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Weekly calorie chart
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Calorias Diárias',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  if (value.toInt() >= 0 && value.toInt() < dailyData.length) {
                                    final date = dailyData[value.toInt()]['date'] as DateTime;
                                    return Text(
                                      '${date.day}/${date.month}',
                                      style: const TextStyle(fontSize: 10),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: dailyData.asMap().entries.map((entry) {
                                return FlSpot(
                                  entry.key.toDouble(),
                                  (entry.value['calories'] as double),
                                );
                              }).toList(),
                              isCurved: true,
                              color: Colors.orange,
                              barWidth: 3,
                              dotData: FlDotData(show: true),
                            ),
                            LineChartBarData(
                              spots: List.generate(7, (index) => FlSpot(index.toDouble(), calorieGoal)),
                              color: Colors.grey,
                              barWidth: 2,
                              dotData: FlDotData(show: false),
                              dashArray: [5, 5],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Macro distribution pie chart
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Distribuição de Macros',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartDataSection(
                              value: avgProtein * 4,
                              title: 'Proteína\n${(avgProtein * 4 / (avgProtein * 4 + avgCarbs * 4 + avgFat * 9) * 100).toStringAsFixed(0)}%',
                              color: Colors.red,
                              radius: 50,
                            ),
                            PieChartDataSection(
                              value: avgCarbs * 4,
                              title: 'Carbos\n${(avgCarbs * 4 / (avgProtein * 4 + avgCarbs * 4 + avgFat * 9) * 100).toStringAsFixed(0)}%',
                              color: Colors.blue,
                              radius: 50,
                            ),
                            PieChartDataSection(
                              value: avgFat * 9,
                              title: 'Gorduras\n${(avgFat * 9 / (avgProtein * 4 + avgCarbs * 4 + avgFat * 9) * 100).toStringAsFixed(0)}%',
                              color: Colors.yellow,
                              radius: 50,
                            ),
                          ],
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Goal progress
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Progresso em Relação à Meta',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildProgressBar('Calorias', avgCalories, calorieGoal, Colors.orange),
                    _buildProgressBar('Proteína', avgProtein, macroGoals['protein']!, Colors.red),
                    _buildProgressBar('Carboidratos', avgCarbs, macroGoals['carbs']!, Colors.blue),
                    _buildProgressBar('Gorduras', avgFat, macroGoals['fat']!, Colors.yellow),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, double current, double goal, String unit, Color color) {
    final percentage = goal > 0 ? (current / goal * 100) : 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Row(
            children: [
              Text(
                '${current.toStringAsFixed(1)} $unit',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Text(
                '/ ${goal.toStringAsFixed(1)} $unit',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${percentage.toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(String label, double current, double goal, Color color) {
    final progress = goal > 0 ? (current / goal).clamp(0.0, 1.5) : 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label),
              Text('${(progress * 100).toStringAsFixed(0)}%'),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }
}
