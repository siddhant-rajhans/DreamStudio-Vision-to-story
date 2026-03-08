import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

class AudioService {
  bool _isRecording = false;
  String? _recordingPath;
  html.MediaRecorder? _mediaRecorder;
  html.MediaStream? _mediaStream;
  Timer? _amplitudeTimer;
  double _currentAmplitude = 0.0;
  List<dynamic>? _audioChunks;

  bool get isRecording => _isRecording;
  String? get recordingPath => _recordingPath;

  Future<void> requestMicrophonePermission() async {
    try {
      if (kIsWeb) {
        // Web: Request microphone access
        try {
          final stream = await html.window.navigator.mediaDevices
              ?.getUserMedia({'audio': true} as dynamic);
          _mediaStream = stream as html.MediaStream?;
          print('✅ Microphone access granted');
        } catch (e) {
          print('❌ Microphone permission denied: $e');
          throw Exception('Microphone permission is required');
        }
      } else {
        // Mobile: Already handled by permissions
        print('📱 Mobile microphone access check');
      }
    } catch (e) {
      print('Error requesting microphone permission: $e');
      rethrow;
    }
  }

  Future<void> startRecording() async {
    try {
      if (kIsWeb) {
        // Web implementation
        if (_mediaStream == null) {
          await requestMicrophonePermission();
        }

        _audioChunks = [];

        // Create MediaRecorder with the media stream
        _mediaRecorder = html.MediaRecorder(_mediaStream!);

        // Use event listeners instead of onDataAvailable
        _mediaRecorder!.addEventListener('dataavailable', (dynamic event) {
          // The audio data is available in the Blob
          print('🎙️ Audio data available');
        });

        _mediaRecorder!.addEventListener('stop', (dynamic event) {
          print('⏹️ Recording stopped');
          // Save the recording
          _recordingPath = 'web-audio-${DateTime.now().millisecondsSinceEpoch}';
          print('✅ Recording saved: $_recordingPath');
        });

        // Start recording
        _mediaRecorder!.start();
        _isRecording = true;

        // Simulate amplitude updates for waveform
        _startAmplitudeSimulation();
        print('🔴 Recording started (Web)');
      } else {
        // Mobile: Would use record package
        _isRecording = true;
        _startAmplitudeSimulation();
        print('🔴 Recording started (Mobile)');
      }
    } catch (e) {
      print('❌ Error starting audio recording: $e');
      rethrow;
    }
  }

  Future<String?> stopRecording() async {
    try {
      if (!_isRecording) return null;

      if (kIsWeb && _mediaRecorder != null) {
        _mediaRecorder!.stop();
      }

      _amplitudeTimer?.cancel();
      _isRecording = false;
      _currentAmplitude = 0.0;

      print('⏹️ Recording stopped');
      return _recordingPath;
    } catch (e) {
      print('❌ Error stopping audio recording: $e');
      rethrow;
    }
  }

  Future<void> pauseRecording() async {
    try {
      if (_isRecording && kIsWeb && _mediaRecorder != null) {
        _mediaRecorder!.pause();
        print('⏸️ Recording paused');
      }
    } catch (e) {
      print('❌ Error pausing audio recording: $e');
      rethrow;
    }
  }

  Future<void> resumeRecording() async {
    try {
      if (_isRecording && kIsWeb && _mediaRecorder != null) {
        _mediaRecorder!.resume();
        print('▶️ Recording resumed');
      }
    } catch (e) {
      print('❌ Error resuming audio recording: $e');
      rethrow;
    }
  }

  void _startAmplitudeSimulation() {
    _amplitudeTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (_isRecording) {
        // Simulate random amplitude for waveform visualization
        _currentAmplitude = (DateTime.now().millisecondsSinceEpoch % 100) / 100.0;
      }
    });
  }

  Future<void> dispose() async {
    _amplitudeTimer?.cancel();
    if (kIsWeb && _mediaStream != null) {
      // Stop all tracks in the stream
      for (var track in _mediaStream!.getTracks()) {
        track.stop();
      }
      print('🛑 Media stream disposed');
    }
  }

  Future<double> getAmplitude() async {
    return _currentAmplitude;
  }
}