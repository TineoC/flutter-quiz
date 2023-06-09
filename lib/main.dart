import 'package:flutter/material.dart';
import 'package:quizz/quiz_game.dart';

List<Widget> scoreIcons = [];

void main() => runApp(const Quizzler());

class Quizzler extends StatelessWidget {
  const Quizzler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int correctAnswersCount = 0;
  bool isLoaded = false;
  late QuizGame quiz;

  @override
  void initState() {
    super.initState();

    initializeQuiz();
  }

  void initializeQuiz() {
    quiz = QuizGame();

    quiz.initialize().then((value) {
      setState(() {
        isLoaded = true;
      });
    });
  }

  void resetGame() {
    setState(() {
      correctAnswersCount = 0;
      scoreIcons.clear();
      isLoaded = false;
    });

    initializeQuiz();
  }

  void onOkPressed() {
    resetGame();
    initializeQuiz();
    Navigator.of(context).pop(); // Close the AlertDialog
  }

  void checkAnswer(bool userAnswer) {
    bool answerIsCorrect = quiz.getQuestionAnswer == userAnswer;

    if (answerIsCorrect) {
      setState(() {
        correctAnswersCount++;
        scoreIcons.add(const CorrectIcon());
      });
    } else {
      scoreIcons.add(const IncorrectIcon());
    }

    setState(() {
      if (quiz.isLastQuestion) {
        showResultsAlert();
      }
    });
  }

  void showResultsAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Quiz Results'),
          content:
              Text('You answered $correctAnswersCount questions correctly.'),
          actions: <Widget>[
            TextButton(
              onPressed: onOkPressed,
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Column(
          children: [
            const Text(
              'Quiz Game',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
            Row(
              children: [
                const Text(
                  'Results: ',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                Row(children: scoreIcons),
              ],
            ),
          ],
        ),
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: isLoaded
                  ? Text(
                      quiz.getQuestion(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 25.0,
                        color: Colors.white,
                      ),
                    )
                  : const CircularProgressIndicator(),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green)),
              onPressed: isLoaded ? () => checkAnswer(true) : null,
              child: const Text(
                'Verdadero',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red)),
              onPressed: isLoaded ? () => checkAnswer(true) : null,
              child: const Text(
                'Falso',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class IncorrectIcon extends StatelessWidget {
  const IncorrectIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.close, color: Colors.white);
  }
}

class CorrectIcon extends StatelessWidget {
  const CorrectIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.check, color: Colors.white);
  }
}
