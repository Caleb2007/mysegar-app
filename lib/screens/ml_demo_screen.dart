import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../services/tflite_service.dart';
import '../theme/app_colors.dart';

class MlDemoScreen extends StatefulWidget {
  static const routeName = '/ml-demo';

  const MlDemoScreen({super.key});

  @override
  State<MlDemoScreen> createState() => _MlDemoScreenState();
}

class _MlDemoScreenState extends State<MlDemoScreen> {
  final TFLiteService _tfliteService = TFLiteService();
  late final ImagePicker _imagePicker;

  Map<String, dynamic>? _result;
  String? _statusMessage;
  bool _isInitializing = true;
  bool _isRunningInference = false;
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
    _initializeModel();
  }

  Future<void> _initializeModel() async {
    try {
      await _tfliteService.init();

      if (!mounted) {
        return;
      }

      setState(() {
        _statusMessage =
            'Model ready. Input: ${_tfliteService.inputShape}, Output: ${_tfliteService.outputShape}';
        _isInitializing = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _statusMessage = error.toString();
        _isInitializing = false;
      });
    }
  }

  Future<void> _runSampleInference() async {
    if (_isRunningInference) {
      return;
    }

    setState(() {
      _isRunningInference = true;
      _result = null;
      _statusMessage =
          'Running inference on assets/images/chicken-salad.png...';
    });

    try {
      final result = await _tfliteService
          .classifyImageAsset('assets/images/chicken-salad.png');

      if (!mounted) {
        return;
      }

      setState(() {
        _result = result;
        _statusMessage = 'Inference completed successfully.';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _statusMessage = 'Inference failed: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isRunningInference = false;
        });
      }
    }
  }

  Future<void> _takePhoto() async {
    if (_isRunningInference) {
      return;
    }

    final XFile? pickedFile = await _imagePicker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile == null) {
      return;
    }

    final bytes = await pickedFile.readAsBytes();

    if (!mounted) {
      return;
    }

    setState(() {
      _isRunningInference = true;
      _imageBytes = bytes;
      _result = null;
      _statusMessage = 'Running inference on captured photo...';
    });

    try {
      final result = await _tfliteService.classifyImage(bytes);

      if (!mounted) {
        return;
      }

      setState(() {
        _result = result;
        _statusMessage = 'Inference completed successfully.';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _statusMessage = 'Inference failed: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isRunningInference = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _tfliteService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buttonEnabled = !_isInitializing && !_isRunningInference;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TFLite Demo'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'On-device TensorFlow Lite inference',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              const Text(
                'This demo loads the bundled model, preprocesses a sample image, runs inference, and shows the top prediction.',
                style: TextStyle(color: AppColors.mutedForeground),
              ),
              const SizedBox(height: 24),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: _imageBytes != null
                    ? Image.memory(
                        _imageBytes!,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/images/chicken-salad.png',
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: buttonEnabled ? _runSampleInference : null,
                  icon: _isRunningInference
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.science_outlined),
                  label: Text(_isRunningInference
                      ? 'Running...'
                      : 'Run Sample Inference'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: buttonEnabled ? _takePhoto : null,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Take Photo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _InfoCard(
                title: 'Status',
                child: Text(
                  _statusMessage ?? 'Preparing model...',
                  style: const TextStyle(height: 1.4),
                ),
              ),
              const SizedBox(height: 12),
              _InfoCard(
                title: 'Top Prediction',
                child: _result == null
                    ? const Text('No inference result yet.')
                    : Text(
                        '${_result!['label']}\nConfidence: ${((_result!['confidence'] as double) * 100).toStringAsFixed(2)}\nClass index: ${_result!['index']}',
                        style: const TextStyle(
                            height: 1.5, fontWeight: FontWeight.w600),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
