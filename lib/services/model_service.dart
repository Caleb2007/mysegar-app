import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class ClassificationResult {
  const ClassificationResult({
    required this.label,
    required this.score,
    required this.index,
  });

  final String label;
  final double score;
  final int index;
}

class ModelService {
  ModelService({
    this.modelAssetPath = 'assets/model_unquant.tflite',
    this.labelsAssetPath = 'assets/labels.txt',
  });

  final String modelAssetPath;
  final String labelsAssetPath;

  Interpreter? _interpreter;
  List<String> _labels = const [];
  bool _isInitializing = false;

  bool get isLoaded => _interpreter != null;
  List<int> get inputShape => _interpreter?.getInputTensor(0).shape ?? const [];
  List<int> get outputShape => _interpreter?.getOutputTensor(0).shape ?? const [];

  Future<void> loadModel() async {
    if (_interpreter != null || _isInitializing) {
      return;
    }

    _isInitializing = true;

    try {
      final options = InterpreterOptions()..threads = 2;
      final interpreter = await Interpreter.fromAsset(modelAssetPath, options: options);
      final rawLabels = await rootBundle.loadString(labelsAssetPath);

      _labels = rawLabels
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toList(growable: false);
      _interpreter = interpreter;
    } on TfliteFlutterException catch (error) {
      throw ModelException('Failed to initialize TensorFlow Lite interpreter: $error');
    } on FlutterError catch (error) {
      throw ModelException('Failed to load model assets: ${error.message}');
    } catch (error) {
      throw ModelException('Unexpected model initialization error: $error');
    } finally {
      _isInitializing = false;
    }
  }

  Future<ClassificationResult> classifyImageBytes(Uint8List imageBytes) async {
    final interpreter = _interpreter;
    if (interpreter == null) {
      throw const ModelException('Model is not loaded. Call loadModel() first.');
    }

    final shape = interpreter.getInputTensor(0).shape;
    if (shape.length != 4 || shape[0] != 1 || shape[3] != 3) {
      throw ModelException('Expected an image input tensor shaped like [1, height, width, 3], got $shape');
    }

    final inputHeight = shape[1];
    final inputWidth = shape[2];
    final inputType = interpreter.getInputTensor(0).type;
    final processedInput = await Isolate.run(
      () => _preprocessImage(
        imageBytes,
        inputWidth: inputWidth,
        inputHeight: inputHeight,
        tensorType: inputType,
      ),
    );

    final outputTensor = interpreter.getOutputTensor(0);
    final outputShape = outputTensor.shape;
    final outputBuffer = List.generate(
      outputShape[0],
      (_) => List<double>.filled(outputShape[1], 0),
      growable: false,
    );

    await Future<void>.microtask(() => interpreter.run(processedInput, outputBuffer));

    final scores = outputBuffer.first;
    if (scores.isEmpty) {
      throw const ModelException('Model returned an empty output tensor.');
    }

    final bestIndex = _argMax(scores);
    return ClassificationResult(
      label: _labelForIndex(bestIndex),
      score: scores[bestIndex],
      index: bestIndex,
    );
  }

  Future<ClassificationResult> classifyImageAsset(String assetPath) async {
    final imageData = await rootBundle.load(assetPath);
    return classifyImageBytes(imageData.buffer.asUint8List());
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
  }

  static Object _preprocessImage({
    required Uint8List imageBytes,
    required int inputWidth,
    required int inputHeight,
    required TfLiteType tensorType,
  }) {
    final decodedImage = img.decodeImage(imageBytes);
    if (decodedImage == null) {
      throw const ModelException('Unable to decode the selected image.');
    }

    final resized = img.copyResize(
      decodedImage,
      width: inputWidth,
      height: inputHeight,
      interpolation: img.Interpolation.average,
    );

    if (tensorType == TfLiteType.float32) {
      return [
        List.generate(inputHeight, (y) {
          return List.generate(inputWidth, (x) {
            final pixel = resized.getPixel(x, y);
            return [
              pixel.r / 255.0,
              pixel.g / 255.0,
              pixel.b / 255.0,
            ];
          }, growable: false);
        }, growable: false),
      ];
    }

    if (tensorType == TfLiteType.uint8) {
      return [
        List.generate(inputHeight, (y) {
          return List.generate(inputWidth, (x) {
            final pixel = resized.getPixel(x, y);
            return [pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt()];
          }, growable: false);
        }, growable: false),
      ];
    }

    throw ModelException('Unsupported input tensor type: $tensorType');
  }

  int _argMax(List<double> values) {
    var bestIndex = 0;
    var bestScore = values.first;

    for (var index = 1; index < values.length; index++) {
      if (values[index] > bestScore) {
        bestScore = values[index];
        bestIndex = index;
      }
    }

    return bestIndex;
  }

  String _labelForIndex(int index) {
    if (index < 0 || index >= _labels.length) {
      return 'Class $index';
    }

    final rawLabel = _labels[index];
    final firstSpace = rawLabel.indexOf(' ');
    return firstSpace == -1 ? rawLabel : rawLabel.substring(firstSpace + 1);
  }
}

class ModelException implements Exception {
  const ModelException(this.message);

  final String message;

  @override
  String toString() => message;
}
