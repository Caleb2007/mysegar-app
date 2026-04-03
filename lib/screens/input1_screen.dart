import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/screen_header.dart';

class Input1Screen extends StatefulWidget {
  static const routeName = '/input1';

  const Input1Screen({super.key});

  @override
  State<Input1Screen> createState() => _Input1ScreenState();
}

class _Input1ScreenState extends State<Input1Screen> {
  final meals = const ['Breakfast', 'Brunch', 'Lunch', 'Dinner', 'Supper', 'Snack'];
  String selectedMeal = 'Lunch';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ScreenHeader(title: 'Input 1'),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('What type of meal are you having?', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: meals.map((meal) {
                      final selected = meal == selectedMeal;
                      return InkWell(
                        onTap: () => setState(() => selectedMeal = meal),
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          decoration: BoxDecoration(
                            color: selected ? AppColors.primary : AppColors.card,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: selected ? AppColors.primary : AppColors.border, width: 1.5),
                          ),
                          child: Text(
                            meal,
                            style: TextStyle(
                              color: selected ? Colors.white : AppColors.mutedForeground,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  Container(height: 1, color: AppColors.border),
                  const SizedBox(height: 24),
                  const Text('Add Your Food', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(child: _inputCard(Icons.camera_alt_outlined, AppColors.primary, 'Take Photo', 'Snap your meal and let AI detect the food items')),
                      const SizedBox(width: 14),
                      Expanded(child: _inputCard(Icons.restaurant_menu_outlined, AppColors.orange, 'Select Food', 'Browse from our database of Malaysian foods')),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Want to add more items?', style: TextStyle(color: AppColors.mutedForeground)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.add, size: 16, color: AppColors.primary),
                            SizedBox(width: 4),
                            Text('Add', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
              decoration: const BoxDecoration(
                color: AppColors.background,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        side: const BorderSide(color: AppColors.border),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Exit', style: TextStyle(color: AppColors.mutedForeground, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () => Navigator.pushNamed(context, '/input2'),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Next', style: TextStyle(fontWeight: FontWeight.w700)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _inputCard(IconData icon, Color color, String title, String subtitle) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/input2'),
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(color: Color(0x12000000), blurRadius: 8, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(height: 12),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: AppColors.mutedForeground, height: 1.4)),
          ],
        ),
      ),
    );
  }
}
