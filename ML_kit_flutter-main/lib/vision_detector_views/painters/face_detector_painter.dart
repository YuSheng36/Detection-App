import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'coordinates_translator.dart';

class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(this.faces, this.absoluteImageSize, this.rotation);

  final List<Face> faces;
  final Size absoluteImageSize;
  final InputImageRotation rotation;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.red;

    for (final face in faces) {
      face.landmarks.forEach((_, landmark) {
        canvas.drawCircle(
            Offset(
              translateX(landmark!.x, rotation, size, absoluteImageSize),
              translateY(landmark.y, rotation, size, absoluteImageSize),
            ),
            1,
            paint);
      });
      canvas.drawRect(
        Rect.fromLTRB(
          translateX(face.boundingBox.left, rotation, size, absoluteImageSize),
          translateY(face.boundingBox.top, rotation, size, absoluteImageSize),
          translateX(face.boundingBox.right, rotation, size, absoluteImageSize),
          translateY(
              face.boundingBox.bottom, rotation, size, absoluteImageSize),
        ),
        paint,
      );

      void paintContour(FaceContourType type) {
        final faceContour = face.contours[type];
        if (faceContour?.points != null) {
          for (final Point point in faceContour!.points) {
            canvas.drawCircle(
                Offset(
                  translateX(
                      point.x.toDouble(), rotation, size, absoluteImageSize),
                  translateY(
                      point.y.toDouble(), rotation, size, absoluteImageSize),
                ),
                1,
                paint);
          }
        }
      }
      void paintLine(
          FaceLandmarkType type1,FaceLandmarkType type2,Paint paintType){
        final FaceLandmark joint1 = face.landmarks[type1]!;
        final FaceLandmark joint2 = face.landmarks[type2]!;
        canvas.drawLine(
        Offset(translateX(joint1.x, rotation, size, absoluteImageSize),
            translateY(joint1.y, rotation, size, absoluteImageSize)),
            Offset(translateX(joint2.x, rotation, size, absoluteImageSize),
            translateY(joint2.y, rotation, size, absoluteImageSize)),
        paintType);
      }

      paintContour(FaceContourType.face);
      paintContour(FaceContourType.leftEyebrowTop);
      paintContour(FaceContourType.leftEyebrowBottom);
      paintContour(FaceContourType.rightEyebrowTop);
      paintContour(FaceContourType.rightEyebrowBottom);
      paintContour(FaceContourType.leftEye);
      paintContour(FaceContourType.rightEye);
      paintContour(FaceContourType.upperLipTop);
      paintContour(FaceContourType.upperLipBottom);
      paintContour(FaceContourType.lowerLipTop);
      paintContour(FaceContourType.lowerLipBottom);
      paintContour(FaceContourType.noseBridge);
      paintContour(FaceContourType.noseBottom);
      paintContour(FaceContourType.leftCheek);
      paintContour(FaceContourType.rightCheek);
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.faces != faces;
  }
}
