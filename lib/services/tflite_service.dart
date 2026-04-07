import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class TFLiteService {
  Interpreter? _interpreter;
  List<String> _labels = [];

  Future<void> init() async {
    print('[TFLite] Initializing model...');
    await loadModel();
    await loadLabels();
    print(
        '[TFLite] Model initialization complete. Interpreter: ${_interpreter != null}');
  }

  Future<void> loadModel() async {
    print('[TFLite] Loading model asset...');
    _interpreter =
        await Interpreter.fromAsset('assets/model/model_unquant.tflite');
    print('[TFLite] Model loaded successfully');
  }

  Future<void> loadLabels() async {
    print('[TFLite] Loading labels...');
    final labelsData = await rootBundle.loadString('assets/model/labels.txt');
    _labels = labelsData
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList(growable: false);
    print('[TFLite] Loaded ${_labels.length} labels');
  }

  Interpreter get interpreter {
    if (_interpreter == null) {
      throw StateError(
          'TFLite interpreter has not been initialized. Call init() first.');
    }
    return _interpreter!;
  }

  List<String> get labels => List.unmodifiable(_labels);

  List<int> get inputShape => interpreter.getInputTensor(0).shape;
  List<int> get outputShape => interpreter.getOutputTensor(0).shape;

  Future<Map<String, dynamic>> classifyImage(Uint8List imageBytes) async {
    print(
        '[TFLite] classifyImage called. Interpreter initialized: ${_interpreter != null}');
    if (_interpreter == null) {
      throw StateError(
          'TFLite interpreter has not been initialized. Call init() first.');
    }
    final interpreter = this.interpreter;
    final inputShape = interpreter.getInputTensor(0).shape;

    final inputHeight = inputShape.length >= 3 ? inputShape[1] : 224;
    final inputWidth = inputShape.length >= 4 ? inputShape[2] : 224;

    final decoded = img.decodeImage(imageBytes);
    if (decoded == null) {
      throw StateError('Unable to decode image bytes.');
    }

    final resized = img.copyResize(
      decoded,
      width: inputWidth,
      height: inputHeight,
      interpolation: img.Interpolation.average,
    );

    final inputTensor = <List<List<List<double>>>>[
      List.generate(
        inputHeight,
        (y) => List.generate(
          inputWidth,
          (x) {
            final pixel = resized.getPixel(x, y);
            return <double>[
              pixel.r / 255.0,
              pixel.g / 255.0,
              pixel.b / 255.0,
            ];
          },
          growable: false,
        ),
        growable: false,
      ),
    ];

    final outputShape = interpreter.getOutputTensor(0).shape;
    final outputLength = outputShape.length > 1
        ? outputShape.sublist(1).reduce((value, element) => value * element)
        : 1;
    final outputBuffer = List.generate(
      outputShape[0],
      (_) => List<double>.filled(outputLength, 0.0),
      growable: false,
    );

    interpreter.run(inputTensor, outputBuffer);

    final scores = outputBuffer.first;
    if (scores.isEmpty) {
      throw StateError('Model returned an empty output tensor.');
    }

    final bestIndex = _argMax(scores);
    final predictedLabel =
        bestIndex < _labels.length ? _labels[bestIndex] : 'Class $bestIndex';
    final confidence = scores[bestIndex];

    return {
      'label': predictedLabel,
      'confidence': confidence,
      'index': bestIndex,
    };
  }

  Future<Map<String, dynamic>> classifyImageAsset(String assetPath) async {
    final assetData = await rootBundle.load(assetPath);
    return classifyImage(assetData.buffer.asUint8List());
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
  }

  int _argMax(List<double> values) {
    var bestIndex = 0;
    var bestValue = values.first;

    for (var index = 1; index < values.length; index++) {
      if (values[index] > bestValue) {
        bestValue = values[index];
        bestIndex = index;
      }
    }
    return bestIndex;
  }
}
