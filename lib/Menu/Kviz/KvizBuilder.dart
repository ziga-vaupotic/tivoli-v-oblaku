import 'package:project_tivoli/Menu/Kviz/funQuestions.dart';
import 'package:project_tivoli/Menu/Kviz/funWidget.dart';
import 'package:flutter/material.dart';
import '../../Databases/ExportSQL.dart';
import '../../main.dart';
import 'dart:async';
import 'dart:math';
import 'KvizEnd.dart';

const int cMAXQUESTIONS = 10;

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  PageController controller;
  Question question;
  int index = 0;
  int score = 0;
  List<Question> lSelectedQuestion = [];

  final getUserDB = DatabaseExporter.instance;

  int maxQuestions(int iLenght) {
    if (iLenght > cMAXQUESTIONS) {
      return cMAXQUESTIONS;
    } else {
      return iLenght;
    }
  }

  void selectRandomQuestions() {
    for (int i = 0; i < maxQuestions(questions.length - 1); i++) {
      var iRng = new Random();
      Question pCurrentQuestion = questions[iRng.nextInt(questions.length - 1)];
      if (lSelectedQuestion.contains(pCurrentQuestion)) { 
        i--;
        continue;
      }

      lSelectedQuestion.add(pCurrentQuestion);
    }
  }

  @override
  void initState() {
    super.initState();

    controller = PageController();
    questions.forEach((element) {
      element.isLocked = false;
      element.selectedOption = Option();
    });
    selectRandomQuestions();
    question = lSelectedQuestion.first;
    index = 0;
    score = 0;
  }

  Timer _timer;
  int _start = 3;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            if (lSelectedQuestion.indexOf(question) ==
                lSelectedQuestion.length - 1) {
              getUserDB.updateKvizPoints(score);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => KvizEndPage(score)));
              timer.cancel();
            }

            question =
                lSelectedQuestion[lSelectedQuestion.indexOf(question) + 1];
            index++;
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: QuestionsWidget(
          onChangedPage: (index) => nextQuestion(index: index),
          onClickedOption: selectOption,
          passed_question: lSelectedQuestion,
          index: index,
        ),
      );

  void selectOption(Option option) {
    if (question.isLocked) {
      return;
    } else {
      if (option.isCorrect) {
        score += 100;
      }

      setState(() {
        question.isLocked = true;
        question.selectedOption = option;
        startTimer();
      });
    }
  }

  void nextQuestion({int index}) {
    final nextPage = controller.page + 1;
    final indexPage = index ?? nextPage.toInt();

    setState(() {
      question = lSelectedQuestion[indexPage];
    });
  }
}
