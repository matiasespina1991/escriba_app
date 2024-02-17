import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import '../../widgets/AppBar/template_app_bar.dart';

import 'package:path_provider/path_provider.dart';

class MyAudioHandler extends BaseAudioHandler with SeekHandler {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();

  bool _isRecording = false;
  String? _tempFilePath;

  Future<void> init() async {
    await _recorder.openRecorder();
    await _player.openPlayer();
    final tempDir = await getTemporaryDirectory();
    _tempFilePath = '${tempDir.path}/grabacion.aac';
  }

  Future<void> startRecording() async {
    await _recorder.startRecorder(toFile: _tempFilePath);
    _isRecording = true;
  }

  Future<void> stopRecording() async {
    await _recorder.stopRecorder();
    _isRecording = false;
  }

  Future<void> playRecording() async {
    if (_tempFilePath != null) {
      await _player.startPlayer(fromURI: _tempFilePath);
    }
  }

  Future<void> stopPlaying() async {
    await _player.stopPlayer();
  }
}

late final AudioHandler _audioHandler;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    initAudioService();
  }

  Future<void> initAudioService() async {
    _audioHandler = await AudioService.init(
      builder: () => MyAudioHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.yourcompany.yourapp.audio',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationOngoing: true,
      ),
    );
    await (_audioHandler as MyAudioHandler).init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EscribaAppBar(
        title: 'Home',
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome'),
            ElevatedButton(
              onPressed: () async {
                await (_audioHandler as MyAudioHandler).startRecording();
              },
              child: Text('Start Recording'),
            ),
            ElevatedButton(
              onPressed: () async {
                await (_audioHandler as MyAudioHandler).stopRecording();
              },
              child: Text('Stop Recording'),
            ),
            ElevatedButton(
              onPressed: () async {
                await (_audioHandler as MyAudioHandler).playRecording();
              },
              child: Text('Play Recording'),
            ),
          ],
        ),
      ),
    );
  }
}
