import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _targetController;
  late String _imagePath;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _targetController = TextEditingController();
    _imagePath = '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) return;
    _initialized = true;

    final profile = AppScope.of(context).profile;
    _nameController.text = profile.name;
    _targetController.text = profile.targetWeightKg.toStringAsFixed(1);
    _imagePath = profile.profileImagePath;
  }
  @override
  Widget build(BuildContext context) {
    final profile = AppScope.of(context).profile;
    return GradientScaffold(
      tone: PageTone.green,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new_rounded)), const SizedBox(width: 8), const Text('Personal Details', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800))]),
          const SizedBox(height: 24),
          Center(child: ProfileAvatar(name: _nameController.text, imagePath: _imagePath, size: 108, onTap: _pickImage, showEditHint: true)),
          const SizedBox(height: 24),
          CardShell(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _editableField('Name', _nameController),
              _editableField('Target weight (kg)', _targetController, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
              const SizedBox(height: 6),
              const Text('Gender', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(profile.gender, style: const TextStyle(color: AppColors.mutedForeground)),
              const SizedBox(height: 16),
              const Text('Goal', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(profile.goal, style: const TextStyle(color: AppColors.mutedForeground)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15)),
                  onPressed: _save,
                  child: const Text('Save', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _editableField(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(filled: true, fillColor: AppColors.secondary, border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
        ),
      ]),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (file == null) return;
    setState(() => _imagePath = file.path);
  }

  Future<void> _save() async {
    final target = double.tryParse(_targetController.text.trim()) ?? AppScope.of(context).profile.targetWeightKg;
    await AppScope.of(context).updatePersonalDetails(name: _nameController.text.trim(), targetWeightKg: target, profileImagePath: _imagePath);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated')));
  }
}
