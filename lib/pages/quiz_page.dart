import 'package:flutter/material.dart';

import '../utils/question.dart';
import '../utils/quiz.dart';

import '../ui/answer_button.dart';
import '../ui/question_text.dart';
import '../ui/correct_wrong_overlay.dart';

import '../pages/score_page.dart';

class QuizPage extends StatefulWidget {
  @override
  State createState() => new QuizPageState();
}

class QuizPageState extends State<QuizPage> {

  Question currentQuestion;
  Quiz quiz = new Quiz([
    new Question('Elon musk is human', false),
    new Question('Is pizza healthy', false),
    new Question('Is flutter awesome?', true)
  ]);

  String questionText;
  int questionNumber;
  bool isCorrect;
  bool overlayVisibility = false;

  @override
  void initState() {
    super.initState();
    currentQuestion = quiz.nextQuestion;
    questionText = currentQuestion.question;
    questionNumber = quiz.questionNumber;
  }

  void handleAnswer(bool answer) {
    isCorrect = (currentQuestion.answer == answer);
    quiz.answer(isCorrect);
    this.setState(() {
      overlayVisibility = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new Column(
          children: <Widget>[
            new AnswerButton(true, () => handleAnswer(true)),
            new QuestionText(questionText, questionNumber),
            new AnswerButton(false, () => handleAnswer(false))
          ],
        ),
        overlayVisibility ? new CorrectWrongOverlay(
          isCorrect, 
          () {
            if (quiz.length == questionNumber) {
              Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (BuildContext context) => new ScorePage(quiz.score, quiz.length)), (Route route) => route == null);
            }
            print('object');
            currentQuestion = quiz.nextQuestion;
            this.setState(() {
              overlayVisibility = false;
              questionText = currentQuestion.question;
              questionNumber = quiz.questionNumber;
            });
          }
        ) : new Container()
      ],
    );
  }
}