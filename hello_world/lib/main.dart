import 'package:flutter/material.dart';
import 'package:hello_world/quize.dart';
import 'package:hello_world/result.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  final quetions = const [
    {
      'questionText': 'What\'s your favorite color?',
      'answers': [
        {'text': 'Black', 'score': 10},
        {'text': 'Red', 'score': 5},
        {'text': 'Green', 'score': 3},
        {'text': 'White', 'score': 1},
      ],
    },
    {
      'questionText': 'What\'s your favorite animal?',
      'answers': [
        {'text': 'Rabbit', 'score': 3},
        {'text': 'Snake', 'score': 11},
        {'text': 'Elephant', 'score': 5},
        {'text': 'Lion', 'score': 9},
      ],
    },
    {
      'questionText': 'Who\'s your favorite instructor?',
      'answers': [
        {'text': 'Max', 'score': 1},
        {'text': 'Max', 'score': 1},
        {'text': 'Max', 'score': 1},
        {'text': 'Max', 'score': 1},
      ],
    },
  ];

  var questionIndex = 0;
  var totalScores = 0;

  void answerQuestion(int score) {
    setState(() {
      totalScores += score;
      questionIndex = questionIndex + 1;
    });
  }

  void _resetQuize() {
    setState(() {
      questionIndex = 0;
      totalScores = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: Text("Home")),
          body: questionIndex < quetions.length
              ? Quize(
                  questionIndex: questionIndex,
                  answerQuestion: answerQuestion,
                  questions: quetions,
                )
              : Result(_resetQuize, totalScores)),
    );
  }
}
