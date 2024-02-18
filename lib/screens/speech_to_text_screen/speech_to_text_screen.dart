import 'package:flutter/material.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechToTextScreen extends StatefulWidget {
  const SpeechToTextScreen({Key? key}) : super(key: key);

  @override
  _SpeechToTextScreenState createState() => _SpeechToTextScreenState();
}

class _SpeechToTextScreenState extends State<SpeechToTextScreen> {
  late final stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';
  double _confidence = 1.0;
  List<String> listOfRecognizedText = [];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      finalTimeout: const Duration(seconds: 60),
      onStatus: (val) {
        print('onStatus: $val');
        if (val == 'notListening') {
          Future.delayed(const Duration(seconds: 1), () {
            _continueListening();
          });
        }
      },
      onError: (val) => print('onError: $val'),
    );
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) {
          setState(() {
            _text = val.recognizedWords;
            if (_text.isNotEmpty) {
              listOfRecognizedText.add(_text);
            }

            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          });
        },
        listenFor: const Duration(seconds: 60),
        localeId: 'es-ES',
      );
    }
  }

  void _continueListening() {
    if (_isListening) {
      _speech.listen(
        onResult: (val) {
          setState(() {
            _text = val.recognizedWords;
            if (_text.isNotEmpty) {
              listOfRecognizedText.add(_text);
            }
          });
        },
        listenFor: const Duration(seconds: 60),
      );
    }
  }

  void _stopListening() async {
    setState(() => _isListening = false);
    _speech.stop();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(_text);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech to Text'),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _isListening ? _stopListening : _startListening,
              child: Text(_isListening ? 'Stop Recording' : 'Start Recording'),
            ),
            const SizedBox(height: 20),
            Text(
              "Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%",
            ),
            const SizedBox(height: 20),
            if (listOfRecognizedText.isNotEmpty)
              Text(
                listOfRecognizedText.join(' '),
              )
          ],
        ),
      ),
    );
  }
}
