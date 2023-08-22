import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraModel extends ChangeNotifier {
  List<CameraDescription> _availableCameras = [];
  CameraDescription? _selectedCamera;

  CameraModel(List<CameraDescription> cameras) {
    _availableCameras = cameras;
    _selectedCamera = cameras.isNotEmpty ? cameras.first : null;
  }

  List<CameraDescription> get availableCameras => _availableCameras;
  CameraDescription? get selectedCamera => _selectedCamera;

  void selectCamera(CameraDescription camera) {
    _selectedCamera = camera;
    notifyListeners();
  }
}
