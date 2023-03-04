import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'camera_view.dart';
import 'painters/face_detector_painter.dart';

Detector Det = Detector();
class FaceDetectorView_A extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FaceDetectorViewState();
}

class _FaceDetectorViewState extends State<FaceDetectorView_A> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
    ),
  );
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  double RemindTextSize = 25;
  double RemindPaddingSize = 10;
  double TargetWidth = 0;
  double TargetHeight = 0;
  final periodicTimer = Timer.periodic(
    const Duration(seconds: 1),
      (timer){

      },
  );

  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: <Widget>[
        CameraView(
          title: 'Face Detector',
          customPaint: _customPaint,
          text: _text,
          onImage: (inputImage) {
            processImage(inputImage);
          },
          initialDirection: CameraLensDirection.front,
        ),
        Positioned(
          bottom: 100,
          child:Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: new BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            child: Text("請於架設好鏡頭後\n正臉面對鏡頭\n完成後按下Start",
              style: TextStyle(fontSize: 25,color: Colors.red,height: 1.2,inherit: false),
            ),
          ),
        ),
        Positioned(
          bottom: 20.0,
          left: 20,
          child:ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(10.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),),
                textStyle: const TextStyle(fontSize: 30),
              ),
              child:Text("Start"),
              onPressed:(){

              }
          ),
        ),
      ],
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final faces = await _faceDetector.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = FaceDetectorPainter(
          faces,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation);
      _customPaint = CustomPaint(painter: painter);
    } else {
      String text = 'Faces found: ${faces.length}\n\n';
      for (final face in faces) {
        text += 'face: ${face.boundingBox}\n\n';
      }
      _text = text;
      // TODO: set _customPaint to draw boundingRect on top of image
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
class Detector{

}