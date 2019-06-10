import 'package:flutter/material.dart';
import 'package:http/src/response.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:thirdeye/services/mlab.dart';
import 'package:tts/tts.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     theme: ThemeData(
       primaryColor: Colors.white,
       textTheme: TextTheme(
         body1: TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold),
       )
     ),

     home:new _homeWgt(),
    );
  }
}

class _homeWgt extends StatefulWidget{
  @override
  _homeWgtState createState() => _homeWgtState();
  }
  
  class _homeWgtState extends State <_homeWgt> {

  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;

  String resultText = "Double tap anywhere to start listening";


@override
  void initState() {
    super.initState();
    initSpeechRecognizer();
  }

  void initSpeechRecognizer(){
    _speechRecognition = SpeechRecognition();
    List<String> queries = [];

    void myLogic() async{
      if(resultText=="new request"){
          await speak("Sure! where do you need to go?");
          Future.delayed(Duration(seconds: 2),()=>mainLogic());
        }
        else if(resultText.contains("please")){
          await speak("Thanks! I'll notify once a volunteer has been assigned.");
          Mlab data = Mlab(userName: "Anuroop", purpose: resultText.toString());
          createPost(data);
        }
        }
    
    _speechRecognition.setAvailabilityHandler(
      (bool result) => setState(() => _isAvailable = result),
    );

    _speechRecognition.setRecognitionStartedHandler(
      () => setState(() => _isListening = true),
    );

    _speechRecognition.setRecognitionResultHandler(
      (String speech) => setState((){
        debugPrint("$queries");
        resultText=speech;
      })
    );

    _speechRecognition.setRecognitionCompleteHandler(
      (){
        setState(() {_isListening = false; myLogic();});    
        },
    );

    _speechRecognition.activate().then(
          (result) => setState(() => _isAvailable = result),
        );
  }

  void mainLogic(){
  if (_isAvailable && !_isListening){
    _speechRecognition.listen(locale: "en_US").then((result) => debugPrint(result));
    }
  }

  speak(String txt) async {
  var setLanguage = await Tts.setLanguage("en-US");
  Tts.speak(txt);
}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: Text("Third Eye", style: Theme.of(context).textTheme.body1, textAlign: TextAlign.center,), backgroundColor: Theme.of(context).primaryColor,centerTitle: true,),
      body: new GestureDetector(
        onDoubleTap: ()=>mainLogic(),
      ),
      bottomNavigationBar: new BottomAppBar( child: new SizedBox(height: 70,
            child: new Center(child: new Text(resultText, style: Theme.of(context).textTheme.body1),)
          ),
          color: Theme.of(context).primaryColor,
    ),
    
    );
  }
}