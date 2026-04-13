import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

import '../app_state.dart';
import '../models/meal_entry.dart';
import '../services/tflite_service.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import 'input2_screen.dart';

class Input1Screen extends StatefulWidget {
  final DateTime date;
  final MealType mealType;

  const Input1Screen({super.key, required this.date, required this.mealType});

  @override
  State<Input1Screen> createState() => _Input1ScreenState();
}

class _Input1ScreenState extends State<Input1Screen> {
  bool _databaseMode = true;
  DishDefinition? _selectedDish;
  
  // ML functionality
  final TFLiteService _tfliteService = TFLiteService();
  final ImagePicker _imagePicker = ImagePicker();
  Uint8List? _imageBytes;
  Map<String, dynamic>? _mlResult;
  bool _isInitializingModel = true;
  bool _isRunningInference = false;
  String? _mlStatusMessage;

  @override
  void initState() {
    super.initState();
    _initializeModel();
  }

  Future<void> _initializeModel() async {
    try {
      await _tfliteService.init();
      if (mounted) {
        setState(() => _isInitializingModel = false);
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _mlStatusMessage = 'Model load failed: $error';
          _isInitializingModel = false;
        });
      }
    }
  }

  Future<void> _takePhoto() async {
    if (_isInitializingModel || _isRunningInference) return;

    final XFile? pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile == null) return;

    final bytes = await pickedFile.readAsBytes();

    if (!mounted) return;

    setState(() {
      _isRunningInference = true;
      _imageBytes = bytes;
      _mlResult = null;
      _mlStatusMessage = 'Analyzing image with AI...';
    });

    try {
      final result = await _tfliteService.classifyImage(bytes);
      if (!mounted) return;

      // Find matching dish from ML prediction
      final matchingDish = _findMatchingDish(result['label']);
      
      setState(() {
        _mlResult = result;
        if (matchingDish != null) {
          _selectedDish = matchingDish;
          _mlStatusMessage = 'Dish detected: ${matchingDish.name}';
        } else {
          _mlStatusMessage = 'Predicted: ${result['label']} (${(result['confidence'] * 100).toStringAsFixed(1)}%)';
        }
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _mlStatusMessage = 'Inference failed: $error');
    } finally {
      if (mounted) {
        setState(() => _isRunningInference = false);
      }
    }
  }

  DishDefinition? _findMatchingDish(String prediction) {
    final state = AppScope.of(context);
    final lowerPrediction = prediction.toLowerCase().trim();
    
    // Direct mapping for known predictions
    switch (lowerPrediction) {
      case 'nasi lemak':
        return state.dishes.firstWhere((dish) => dish.id == 'nasi-lemak');
      case 'chicken rice':
        return state.dishes.firstWhere((dish) => dish.id == 'chicken-rice');
      case 'egg':
        return state.dishes.firstWhere((dish) => dish.id == 'egg-dish');
      default:
        // Fallback: try fuzzy matching on dish name
        for (final dish in state.dishes) {
          if (dish.name.toLowerCase().contains(lowerPrediction) || lowerPrediction.contains(dish.name.toLowerCase())) {
            return dish;
          }
        }
        return null;
    }
  }

  @override
  void dispose() {
    _tfliteService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final buttonEnabled = !_isInitializingModel && !_isRunningInference;

    return GradientScaffold(
      tone: PageTone.green,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new_rounded)), const SizedBox(width: 8), const Text('Input 1', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800))]),
          const SizedBox(height: 20),
          Text(widget.mealType.label, style: const TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          const Text('Choose your food input method', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: 18),
          Row(children: [
            Expanded(child: _modeButton('Database', _databaseMode, () => setState(() => _databaseMode = true))),
            const SizedBox(width: 12),
            Expanded(child: _modeButton('Photo upload', !_databaseMode, () => setState(() => _databaseMode = false))),
          ]),
          const SizedBox(height: 18),
          
          // Show Take Photo button when in photo mode
          if (!_databaseMode) ...[
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: buttonEnabled ? _takePhoto : null,
                icon: _isRunningInference 
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.camera_alt),
                label: Text(_isRunningInference ? 'Analyzing...' : 'Take Photo'),
                style: FilledButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16)),
              ),
            ),
            const SizedBox(height: 18),
            
            // Show captured image if available
            if (_imageBytes != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.memory(_imageBytes!, height: 180, width: double.infinity, fit: BoxFit.cover),
              ),
              const SizedBox(height: 18),
            ],
            
            // Show ML results
            if (_mlResult != null) ...[
              CardShell(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('AI Detection Result', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  const SizedBox(height: 12),
                  Text(_mlResult!['label'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Text('Confidence: ${((_mlResult!['confidence'] as double) * 100).toStringAsFixed(1)}%', style: const TextStyle(fontSize: 14, color: AppColors.mutedForeground)),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: _mlResult!['confidence'] as double,
                      minHeight: 10,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(_selectedDish != null ? AppColors.primary : Colors.orange),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 18),
              
              // Confirm button for matched dish
              if (_selectedDish != null) ...[
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 18)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Input2Screen(date: widget.date, mealType: widget.mealType, dish: _selectedDish!, isPhotoFlow: true),
                        ),
                      );
                    },
                    child: const Text('Confirm & Continue', style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ),
                const SizedBox(height: 18),
              ],
              
              // Message for unmatched prediction
              if (_mlResult != null && _selectedDish == null) ...[
                CardShell(
                  child: Text(
                    'Prediction "${_mlResult!['label']}" not matched to database yet. Please select manually from the list below.',
                    style: const TextStyle(color: AppColors.mutedForeground),
                  ),
                ),
                const SizedBox(height: 18),
              ],
            ],
            
            if (_mlStatusMessage != null && _mlResult == null) ...[
              CardShell(
                child: Text(_mlStatusMessage!, style: const TextStyle(fontSize: 14, color: AppColors.mutedForeground)),
              ),
              const SizedBox(height: 18),
            ],
          ],
          
          const Text('Tap one dish', style: TextStyle(color: AppColors.mutedForeground, fontSize: 16)),
          const SizedBox(height: 12),
          ...state.dishes.map((dish) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: InkWell(
                  onTap: () => setState(() => _selectedDish = dish),
                  child: CardShell(
                    borderColor: _selectedDish?.id == dish.id ? AppColors.primary : AppColors.border,
                    padding: const EdgeInsets.all(14),
                    child: Row(children: [
                      CircleAvatar(radius: 28, backgroundColor: AppColors.primarySoft, backgroundImage: AssetImage(dish.imagePath)),
                      const SizedBox(width: 14),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(dish.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)), Text('Base calories: ${dish.baseCalories} kcal', style: const TextStyle(color: AppColors.mutedForeground))])),
                      Icon(_selectedDish?.id == dish.id ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded, color: AppColors.primary),
                    ]),
                  ),
                ),
              )),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 18)),
              onPressed: _selectedDish == null
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Input2Screen(date: widget.date, mealType: widget.mealType, dish: _selectedDish!, isPhotoFlow: !_databaseMode),
                        ),
                      );
                    },
              child: const Text('Continue to Input 2', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _modeButton(String label, bool active, VoidCallback onTap) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: active ? AppColors.primary : Colors.white,
        foregroundColor: active ? Colors.white : AppColors.foreground,
        side: BorderSide(color: active ? AppColors.primary : AppColors.border),
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      onPressed: onTap,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
    );
  }
}
