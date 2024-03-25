import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'backend_service.dart'; // Make sure you have this setup

class SpeechToTextPage extends StatefulWidget {
  @override
  _SpeechToTextPageState createState() => _SpeechToTextPageState();
}

class _SpeechToTextPageState extends State<SpeechToTextPage> {
  late stt.SpeechToText _speech;
  late FlutterTts flutterTts;
  bool _isListening = false;
  String _text = '';
  late TextEditingController _textEditingController;
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
      flutterTts.setCompletionHandler(() {
        Future.delayed(Duration(seconds:1), () {
          _listen();
        });
      });
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
                  _submitField(val.recognizedWords);
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
        // _submitRecord();
      });
    }
  }

  void _submitRecord(List<String> updatedAnswers) async {
    // Logic to submit record to backend
    bool success = await BackendService.saveRecord(
      updatedAnswers[0], // First Name
      updatedAnswers[1], // Last Name
      updatedAnswers[2], // DOB
      updatedAnswers[3], // SSN
      updatedAnswers[4], // Zip Code
    );
    if (success) {
    print('Record saved successfully.');
    // Optionally, navigate to a success page or show a success message.
    // For example, using Navigator to pop or push to a different widget.
    // Navigator.of(context).pop(); // Go back to the previous screen
    // or
    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => SuccessPage()));
  } else {
    print('Failed to save the record.');
    // Optionally, show an error message to the user.
    // You can use a dialog, snackbar, or another method to show the error.
  }
}
    // Optionally, navigate to another page or show a success message


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
      onPressed: _isListening ? null : _listen,
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