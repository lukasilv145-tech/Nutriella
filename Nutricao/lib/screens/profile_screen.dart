import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/user.dart';
import 'registration_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final bmi = user.calculateBMI();
    final bmiStatus = _getBMIStatus(bmi);
    final tdee = user.calculateTDEE();
    final calorieGoal = user.calculateCalorieGoal();
    final macroGoals = user.calculateMacroGoals();
    final waterGoal = user.calculateWaterGoal();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User info card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.green,
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${user.age} anos • ${user.gender == 'male' ? 'Masculino' : 'Feminino'}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Body measurements
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Medidas Corporais',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildMeasurementRow('Peso', '${user.weight.toStringAsFixed(1)} kg'),
                    _buildMeasurementRow('Altura', '${user.height.toStringAsFixed(0)} cm'),
                    _buildMeasurementRow('IMC', '${bmi.toStringAsFixed(1)}', bmiStatus),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Goals
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Metas Diárias',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildMeasurementRow('Calorias', '${calorieGoal.toStringAsFixed(0)} kcal'),
                    _buildMeasurementRow('Proteína', '${macroGoals['protein']!.toStringAsFixed(1)} g'),
                    _buildMeasurementRow('Carboidratos', '${macroGoals['carbs']!.toStringAsFixed(1)} g'),
                    _buildMeasurementRow('Gorduras', '${macroGoals['fat']!.toStringAsFixed(1)} g'),
                    _buildMeasurementRow('Água', '${(waterGoal / 1000).toStringAsFixed(1)} L'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Metabolic info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informações Metabólicas',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildMeasurementRow('TMB', '${user.calculateBMR().toStringAsFixed(0)} kcal'),
                    _buildMeasurementRow('TDEE', '${tdee.toStringAsFixed(0)} kcal'),
                    _buildMeasurementRow(
                      'Objetivo',
                      _getGoalName(user.goal),
                    ),
                    _buildMeasurementRow(
                      'Nível de Atividade',
                      _getActivityName(user.activityLevel),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Edit button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const RegistrationScreen()),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text('Editar Perfil'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 12),

            // Logout button
            OutlinedButton.icon(
              onPressed: () {
                _showLogoutDialog(context, userProvider);
              },
              icon: const Icon(Icons.logout),
              label: const Text('Sair / Resetar'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeasurementRow(String label, String value, [String? status]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey[700]),
          ),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              if (status != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _getBMIStatus(double bmi) {
    if (bmi < 18.5) return 'Abaixo do peso';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Sobrepeso';
    if (bmi < 35) return 'Obesidade I';
    if (bmi < 40) return 'Obesidade II';
    return 'Obesidade III';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Normal':
        return Colors.green;
      case 'Abaixo do peso':
      case 'Sobrepeso':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  String _getGoalName(String goal) {
    switch (goal) {
      case 'lose_weight':
        return 'Perder peso';
      case 'gain_muscle':
        return 'Ganhar músculos';
      case 'maintain':
        return 'Manter peso';
      default:
        return goal;
    }
  }

  String _getActivityName(double level) {
    if (level <= 1.2) return 'Sedentário';
    if (level <= 1.375) return 'Levemente ativo';
    if (level <= 1.55) return 'Moderadamente ativo';
    if (level <= 1.725) return 'Muito ativo';
    return 'Extremamente ativo';
  }

  void _showLogoutDialog(BuildContext context, UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Deseja realmente sair e resetar todos os dados?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              userProvider.clearUser();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }
}
