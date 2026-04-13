import 'package:flutter/material.dart';

import '../app_state.dart';
import '../models/user_profile.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import 'app_shell_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController(text: '18');
  final _heightController = TextEditingController(text: '170');
  final _weightController = TextEditingController(text: '74');
  final _targetWeightController = TextEditingController(text: '68');
  String _gender = 'Male';
  String _activity = 'Moderately active';
  String _goal = 'Lose weight';
  final _diseaseController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    _diseaseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      tone: PageTone.green,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
        child: CardShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: Text('Sign In', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800))),
              const SizedBox(height: 8),
              const Center(child: Text('Set up your MySegar details to get started.', style: TextStyle(color: AppColors.mutedForeground))),
              const SizedBox(height: 24),
              _field('Name', _nameController),
              _field('Age', _ageController, keyboardType: TextInputType.number),
              _field('Height (cm)', _heightController, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
              _field('Weight (kg)', _weightController, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
              _field('Target weight (kg)', _targetWeightController, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
              _dropdown('Gender', _gender, ['Male', 'Female'], (v) => setState(() => _gender = v!)),
              _dropdown('Activity level', _activity, ['Sedentary', 'Lightly active', 'Moderately active', 'Very active'], (v) => setState(() => _activity = v!)),
              _dropdown('Goal', _goal, ['Lose weight', 'Maintain weight', 'Gain weight'], (v) => setState(() => _goal = v!)),
              _field('Disease / condition', _diseaseController),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15)),
                  onPressed: _save,
                  child: const Text('Continue', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    final age = int.tryParse(_ageController.text.trim()) ?? 18;
    final height = double.tryParse(_heightController.text.trim()) ?? 170;
    final weight = double.tryParse(_weightController.text.trim()) ?? 74;
    final targetWeight = double.tryParse(_targetWeightController.text.trim()) ?? 68;
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final target = calculateDailyTarget(gender: _gender, age: age, heightCm: height, weightKg: weight, activityLevel: _activity, goal: _goal);
    final profile = UserProfile(
      name: name,
      gender: _gender,
      age: age,
      heightCm: height,
      weightKg: weight,
      targetWeightKg: targetWeight,
      activityLevel: _activity,
      goal: _goal,
      diseaseCondition: _diseaseController.text.trim(),
      dailyTargetCalories: target,
      profileImagePath: '',
    );
    await AppScope.of(context).saveProfile(profile);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const AppShellScreen()));
  }

  Widget _field(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(filled: true, fillColor: AppColors.secondary, border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
        ),
      ]),
    );
  }

  Widget _dropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(filled: true, fillColor: AppColors.secondary, border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
        ),
      ]),
    );
  }
}
