import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

typedef void Callback(List<dynamic> list, int h, int w);

class Camera extends StatefulWidget {
  final List<CameraDescription>? cameras;
  final Callback? setRecognitions;

  const Camera({this.cameras, this.setRecognitions});

  @override
  _CameraState createState() => _CameraState();
}
class _CameraState extends State<Camera> {
  CameraController? controller;
  bool isDetecting = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  void initializeCamera() async {
    if (widget.cameras == null || widget.cameras!.isEmpty) {
      print('No camera is found');
      return;
    }

    controller = CameraController(
      widget.cameras![0], // Use the first available camera
      ResolutionPreset.high,
    );

    try {
      await controller!.initialize();
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
      return;
    }

    if (!mounted) return;

    setState(() {});

    controller!.startImageStream((CameraImage img) {
      if (!isDetecting) {
        isDetecting = true;

        int startTime = DateTime.now().millisecondsSinceEpoch;
        Tflite.runPoseNetOnFrame(
          bytesList: img.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          imageHeight: img.height,
          imageWidth: img.width,
          numResults: 1,
          rotation: -90,
          threshold: 0.2,
          nmsRadius: 10,
        ).then((recognitions) {
          int endTime = DateTime.now().millisecondsSinceEpoch;
          print("Detection took ${endTime - startTime} milliseconds");

          if (recognitions != null && recognitions.isNotEmpty) {
            print('Recognitions:');
            for (var recognition in recognitions) {
              print('Label: ${recognition['label']}');
              print('Confidence: ${recognition['confidence']}');
              print('Location: ${recognition['rect']}');
            }
          } else {
            print('No recognitions');
          }

          if (widget.setRecognitions != null) {
            widget.setRecognitions!(recognitions ?? [], img.height, img.width);
          } else {
            print('No setRecognitions callback provided');
          }

          isDetecting = false;
        }).catchError((e) {
          print('Error running pose detection: $e');
        });
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Container();
    }

    Size screen = MediaQuery.of(context).size;
    double screenH = math.max(screen.height, screen.width);
    double screenW = math.min(screen.height, screen.width);
    Size previewSize = controller!.value.previewSize!;
    double previewH = math.max(previewSize.height, previewSize.width);
    double previewW = math.min(previewSize.height, previewSize.width);
    double screenRatio = screenH / screenW;
    double previewRatio = previewH / previewW;

    return OverflowBox(
      maxHeight: screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
      maxWidth: screenRatio > previewRatio ? screenH / previewH * previewW : screenW,
      child: CameraPreview(controller!),
    );
  }
}
