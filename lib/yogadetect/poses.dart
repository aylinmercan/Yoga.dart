import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:bitirme/yogadetect/inferance.dart';
import 'package:bitirme/yogadetect/yoga_card.dart';

class Poses extends StatelessWidget {
  final List<CameraDescription> cameras;
  final String title;
  final String model;
  final List<String> asanas;
  final Color color;

  const Poses({required this.cameras, required this.title, required this.model, required this.asanas, required this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(title),
      ),
      body: Center(
        child: Container(
          height: 500,
          child: PageView.builder(
            itemCount: asanas.length,
            controller: PageController(viewportFraction: 0.8),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _onSelect(context, asanas[index]),
                child: Center(
                  child: Container(
                    height: 360,
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: YogaCard(
                      asana: asanas[index],
                      color: color,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onSelect(BuildContext context, String customModelName) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InferencePage(
          cameras: cameras,
          title: customModelName,
          model: "assets/models/posenet_mv1_075_float_from_checkpoints.tflite",
          customModel: customModelName,
        ),
      ),
    );
  }
}