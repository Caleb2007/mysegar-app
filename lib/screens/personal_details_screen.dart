import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import 'account_selection_screen.dart';
import 'onboarding_screen.dart';
import 'profile_setup_screen.dart';

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
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _manageAccount,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    foregroundColor: AppColors.foreground,
                  ),
                  child: const Text(
                    'Sign Out or Create New Account',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
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

  Future<void> _manageAccount() async {
    final action = await showModalBottomSheet<_AccountAction>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Account options',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Everything stays on this device. You can sign out and return to a saved account later, or start a brand-new account from onboarding.',
                  style: TextStyle(color: AppColors.mutedForeground),
                ),
                const SizedBox(height: 20),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.logout_rounded),
                  title: const Text('Sign Out'),
                  subtitle: const Text('Go to the local account chooser.'),
                  onTap: () => Navigator.of(context).pop(_AccountAction.signOut),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.person_add_alt_1_rounded),
                  title: const Text('Create New Account'),
                  subtitle: const Text('Start again from onboarding like a fresh install.'),
                  onTap: () => Navigator.of(context).pop(_AccountAction.createNew),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || action == null) return;

    if (action == _AccountAction.signOut) {
      await AppScope.of(context).signOut();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AccountSelectionScreen()),
        (route) => false,
      );
      return;
    }

    await AppScope.of(context).signOut();
    await AppScope.of(context).startNewAccountSetup();
    await AppScope.of(context).resetOnboarding();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const _FreshStartOnboardingScreen()),
      (route) => false,
    );
  }
}

enum _AccountAction {
  signOut,
  createNew,
}

class _FreshStartOnboardingScreen extends StatelessWidget {
  const _FreshStartOnboardingScreen();

  @override
  Widget build(BuildContext context) {
    return OnboardingScreen(
      onGetStarted: () {
        final state = AppScope.of(context);
        state.completeOnboarding();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ProfileSetupScreen()),
        );
      },
    );
  }
}
