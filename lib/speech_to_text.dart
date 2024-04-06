import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'backend_service.dart'; // Make sure you have this setup
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/foundation.dart' show kIsWeb, kReleaseMode;

class SpeechToTextPage extends StatefulWidget {
  @override
  _SpeechToTextPageState createState() => _SpeechToTextPageState();
}

class _SpeechToTextPageState extends State<SpeechToTextPage> {
  late stt.SpeechToText _speech;
  late FlutterTts flutterTts;
  bool _isListening = false;
  String _text = '';
  bool _isFieldReadOnly = true;
  late TextEditingController _textEditingController;
  // static const String localBaseUrl = 'http://127.0.0.1:5000/';
  // static const String productionBaseUrl = 'https://voiceai-app-f156169b04de.herokuapp.com';

  // static const String baseUrl = bool.fromEnvironment('dart.vm.product')
  //     ? productionBaseUrl
  //     : localBaseUrl;
  // static String get baseUrl {
  //   if (foundation.kReleaseMode) {
  //     // Use the Heroku URL in release mode
  //     return 'https://voiceai-app-f156169b04de.herokuapp.com';
  //   } else {
  //     // Check if the app is running on Android
  //     if (Platform.isAndroid) {
  //       // Use the Android emulator's base URL
  //       return 'http://10.0.2.2:5000'; // Use 10.0.2.2 for Android emulator
  //     } else {
  //       // Use the local server URL in debug mode for other platforms
  //       return 'http://127.0.0.1:5000/';
  //     }
  //   }
  // }

  static String get baseUrl {
    // When running on the web, decide based on the release mode
    if (kIsWeb) {
      return kReleaseMode
          ? 'https://voiceai-app-f156169b04de.herokuapp.com' // Production URL for web release
          : 'http://127.0.0.1:5000'; // Local server URL for web debug
    } 
    // For Android emulator in debug mode
    else if (!kIsWeb && !kReleaseMode && Platform.isAndroid) {
      return 'http://10.0.2.2:5000'; // Special IP for Android emulator
    } 
    // Fallback for other non-web cases, including debug mode on devices other than Android emulator
    else {
      return 'http://127.0.0.1:5000'; // Local server URL
    }
  }

  List<String> prompts = [
    "What is the patient's first name?",
    "What is the patient's last name?",
    "What is the patient's date of birth?",
    "What is the patient's social security number?",
    "What is the patient's zip code?",
  ];
  List<String> answers = ['', '', '', '', ''];
  int currentPromptIndex = 0;
  bool _showSubmitButton = false;
  List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _speech = stt.SpeechToText();
    flutterTts = FlutterTts();
    flutterTts.setLanguage("en-US");
    flutterTts.setPitch(1.0);
    flutterTts.setSpeechRate(0.4);
    flutterTts.awaitSpeakCompletion(true);
    _controllers = List.generate(prompts.length, (index) => TextEditingController());
    initializeTts();
  }

  @override
  void dispose() {
    // Dispose your controllers when they're no longer needed
    _controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  Future<void> initializeTts() async {
    await flutterTts.getLanguages;
    await flutterTts.setLanguage("en-US");
    _speakQuestion();
  }

  Future _speakQuestion() async {
  if (currentPromptIndex < prompts.length) {
    var result = await flutterTts.speak(prompts[currentPromptIndex]);
    if (result == 1) { // Check if speaking was successful
    }
  } else { // This else block needs to be inside the async function.
    setState(() {
      _showSubmitButton = true;
    });
  }
}

void _startListeningAfterSpeaking() {
  Future.delayed(Duration(seconds: 1), () { // Add a short delay to ensure TTS has fully stopped
    _listen(); // Start listening for the answer
  });
}

void _listen()  {
  print("Listen method called");
  if (!_isListening && !_speech.isListening) { // Check if we're not already listening
     _speech.initialize(
      onStatus: (val) {
        print("onStatus: $val");
        if (val == 'done') {
          setState(() => _isListening = false);
        }
      },
      onError: (val) => print('onError: $val'),
    ).then((initialized) {
      print("Speech to Text Initialized: $initialized");
      if (initialized) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            print("Result received: ${val.recognizedWords}");
            if (val.recognizedWords.isNotEmpty) {
              _speech.stop(); // Stop listening
              // _submitField(val.recognizedWords); // Process the recognized words
              setState(() {
                // Update the text field with the recognized words
                _textEditingController.text = val.recognizedWords;
                Future.delayed(Duration(seconds: 5), () {
                  // _submitField(val.recognizedWords);
                });
                // _submitField(val.recognizedWords); // Process the recognized words
              });
            }
          },
          listenFor: Duration(seconds: 30), // Adjust based on your needs
          pauseFor: Duration(seconds: 5),
          partialResults: false // Adjust based on your preference
        );
      }
    });
  }
}

void _nextQuestion() {
  // Save the current answer to the corresponding controller before moving to the next question
  if (_textEditingController.text.isNotEmpty) {
    answers[currentPromptIndex] = _textEditingController.text;
    _controllers[currentPromptIndex].text = _textEditingController.text;
  }

  // Check if there are more questions
  if (currentPromptIndex < prompts.length - 1) {
    setState(() {
      currentPromptIndex++;
      _textEditingController.clear(); // Clear the text field for the next spoken answer
    });
    Future.delayed(Duration(milliseconds: 500), () {
      _speakQuestion();
    });
  } else {
    // Transition to the submit state
    setState(() {
      _showSubmitButton = true;
    });
  }
}
  void _submitField(String fieldValue) {
    answers[currentPromptIndex] = fieldValue;
    _controllers[currentPromptIndex].text = fieldValue;
    if (currentPromptIndex < prompts.length - 1) {
      setState(() {
        currentPromptIndex++;
      });
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _textEditingController.text = ''; // Now clear text here, after a delay
        });
        _speakQuestion();
      });
    } else {
      setState(() {
        _showSubmitButton = true;
      });
    }
  }


void _submitRecord(List<String> updatedAnswers) async {
  final url = Uri.parse("$baseUrl/save_record");
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'first_name': updatedAnswers[0],
      'last_name': updatedAnswers[1],
      'dob': updatedAnswers[2],
      'ssn': updatedAnswers[3],
      'zip_code': updatedAnswers[4],
    }),
  );

  if (response.statusCode == 201) {
    _showSnackBar(context, 'Record saved successfully.');
  } else if (response.statusCode == 409) {
    _showSnackBar(context, 'Record already exists.');
  } else {
    _showSnackBar(context, 'An error occurred while saving the record.');
  }
}

void _showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}



@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: FittedBox(
        fit: BoxFit.fitWidth,
        child: Text("Welcome to AI Enabled Application"),
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        if (!_isListening) _listen();
      },
      child: Icon(_isListening ? Icons.mic_off : Icons.mic),
    ),

    body: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (!_showSubmitButton) ...[
              Text(
                prompts[currentPromptIndex],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  hintText: 'Listening...',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Enable TextField editing
                      setState(() {
                        _isFieldReadOnly = false; // This line needs modification.
                      });
                    },
                    child: Text('Edit'),
                  ),
                  ElevatedButton(
                      onPressed: _nextQuestion,
                      child: Text('Next'),
                  ),
                ],
              ),
            ] else ...[
              Text("Review your answers before submitting:"),
              ...List.generate(prompts.length, (index) {
                // Use the existing _controllers list for this purpose
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text("${prompts[index]}:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    TextField(
                      controller: _controllers[index], // Make sure _controllers is properly initialized in initState
                      decoration: InputDecoration(
                        hintText: 'Enter your answer',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                );
              }),
              ElevatedButton(
                onPressed: () {
                  // Collect all answers from controllers and pass them to the submission method
                  List<String> updatedAnswers = _controllers.map((controller) => controller.text).toList();
                  _submitRecord(updatedAnswers); // Adjust the _submitRecord method accordingly
                },
                child: Text('Submit'),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
}
