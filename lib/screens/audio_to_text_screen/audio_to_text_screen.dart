import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:record/record.dart';

class AudioToTextScreen extends StatefulWidget {
  const AudioToTextScreen({Key? key}) : super(key: key);

  @override
  _AudioToTextScreenState createState() => _AudioToTextScreenState();
}

class _AudioToTextScreenState extends State<AudioToTextScreen> {
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  String? _currentRecordingPath;

  Future<void> _startRecording() async {
    bool hasPermission = await _recorder.hasPermission();

    if (!hasPermission) {
      // Manejar la falta de permisos aquí
      return;
    }

    final tempDir = await getTemporaryDirectory();
    final filePath =
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.wav';
    _currentRecordingPath = filePath;

    await _recorder.start(const RecordConfig(encoder: AudioEncoder.wav),
        path: filePath);
    setState(() {
      _isRecording = true;
    });
  }

  Future<void> _stopRecording() async {
    await _recorder.stop();
    final filePath = _currentRecordingPath;
    if (filePath != null) {
      await _uploadFile(filePath);
    }
    setState(() {
      _isRecording = false;
      _currentRecordingPath = null;
    });
  }

  Future<void> _uploadFile(String filePath) async {
    File file = File(filePath);
    try {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.wav';
      await FirebaseStorage.instance.ref(fileName).putFile(file);
      debugPrint('File uploaded successfully!');
    } catch (e) {
      debugPrint('Error uploading file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record and Upload Audio'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isRecording ? _stopRecording : _startRecording,
              child: Text(_isRecording ? 'Stop and Upload' : 'Start Recording'),
            ),
          ],
        ),
      ),
    );
  }
}
