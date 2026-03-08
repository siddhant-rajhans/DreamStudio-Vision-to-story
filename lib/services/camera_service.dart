import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

class CameraService {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  
  bool get isInitialized => _controller != null && _controller!.value.isInitialized;
  bool get isRecording => _controller != null && _controller!.value.isRecordingVideo;
  
  CameraController? get controller => _controller;

  Future<void> initializeCamera() async {
    try {
      _cameras = await availableCameras();
      
      if (_cameras == null || _cameras!.isEmpty) {
        throw Exception('No cameras available');
      }

      // Use front camera (selfie) by default
      final camera = _cameras!.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras!.first,
      );

      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: true,
      );

      await _controller!.initialize();
    } catch (e) {
      print('Error initializing camera: $e');
      rethrow;
    }
  }

  Future<void> startVideoRecording() async {
    if (!isInitialized || isRecording) return;

    try {
      await _controller!.startVideoRecording();
    } catch (e) {
      print('Error starting video recording: $e');
      rethrow;
    }
  }

  Future<XFile?> stopVideoRecording() async {
    if (!isInitialized || !isRecording) return null;

    try {
      final video = await _controller!.stopVideoRecording();
      return video;
    } catch (e) {
      print('Error stopping video recording: $e');
      rethrow;
    }
  }

  Future<XFile?> takePicture() async {
    if (!isInitialized) return null;

    try {
      final picture = await _controller!.takePicture();
      return picture;
    } catch (e) {
      print('Error taking picture: $e');
      rethrow;
    }
  }

  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
  }

  Future<void> toggleFlash() async {
    if (!isInitialized) return;
    
    final current = _controller!.value.flashMode;
    final next = current == FlashMode.off ? FlashMode.torch : FlashMode.off;
    
    await _controller!.setFlashMode(next);
  }

  Future<void> setZoom(double zoom) async {
    if (!isInitialized) return;
    await _controller!.setZoomLevel(zoom);
  }
}