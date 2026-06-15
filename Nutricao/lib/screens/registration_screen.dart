import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/user.dart';
import 'home_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  
  String _gender = 'male';
  String _goal = 'maintain';
  double _activityLevel = 1.2;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final user = User(
        name: _nameController.text,
        age: int.parse(_ageController.text),
        weight: double.parse(_weightController.text),
        height: double.parse(_heightController.text),
        gender: _gender,
        goal: _goal,
        activityLevel: _activityLevel,
        createdAt: DateTime.now(),
      );

      Provider.of<UserProvider>(context, listen: false).registerUser(user);
      
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.person_add,
                size: 80,
                color: Colors.green,
              ),
              const SizedBox(height: 20),
              const Text(
                'Vamos conhecer você!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Idade',
                        prefixIcon: Icon(Icons.cake),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Idade obrigatória';
                        }
                        final age = int.tryParse(value);
                        if (age == null || age < 10 || age > 100) {
                          return 'Idade inválida';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Peso (kg)',
                        prefixIcon: Icon(Icons.monitor_weight),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Peso obrigatório';
                        }
                        final weight = double.tryParse(value);
                        if (weight == null || weight < 30 || weight > 300) {
                          return 'Peso inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Altura (cm)',
                  prefixIcon: Icon(Icons.height),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Altura obrigatória';
                  }
                  final height = double.tryParse(value);
                  if (height == null || height < 100 || height > 250) {
                    return 'Altura inválida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              const Text(
                'Gênero',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Masculino'),
                      value: 'male',
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Feminino'),
                      value: 'female',
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              const Text(
                'Qual seu objetivo?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('Perder peso'),
                    subtitle: const Text('Déficit calórico'),
                    value: 'lose_weight',
                    groupValue: _goal,
                    onChanged: (value) {
                      setState(() {
                        _goal = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Manter peso'),
                    subtitle: const Text('Manter equilíbrio'),
                    value: 'maintain',
                    groupValue: _goal,
                    onChanged: (value) {
                      setState(() {
                        _goal = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Ganhar músculos'),
                    subtitle: const Text('Superávit calórico'),
                    value: 'gain_muscle',
                    groupValue: _goal,
                    onChanged: (value) {
                      setState(() {
                        _goal = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              const Text(
                'Nível de atividade física',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Slider(
                value: _activityLevel,
                min: 1.2,
                max: 1.9,
                divisions: 7,
                label: _getActivityLabel(_activityLevel),
                onChanged: (value) {
                  setState(() {
                    _activityLevel = value;
                  });
                },
              ),
              Text(
                _getActivityDescription(_activityLevel),
                style: const TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Começar',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getActivityLabel(double value) {
    if (value <= 1.2) return 'Sedentário';
    if (value <= 1.375) return 'Levemente ativo';
    if (value <= 1.55) return 'Moderadamente ativo';
    if (value <= 1.725) return 'Muito ativo';
    return 'Extremamente ativo';
  }

  String _getActivityDescription(double value) {
    if (value <= 1.2) return 'Pouco ou nenhum exercício';
    if (value <= 1.375) return 'Exercício leve 1-3 dias/semana';
    if (value <= 1.55) return 'Exercício moderado 3-5 dias/semana';
    if (value <= 1.725) return 'Exercício intenso 6-7 dias/semana';
    return 'Exercício muito intenso ou trabalho físico';
  }
}
