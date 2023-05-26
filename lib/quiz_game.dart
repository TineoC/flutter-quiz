import 'dart:convert';

import 'package:http/http.dart' as http;

class Question {
  final String category;
  final String question;
  final bool answer;

  Question({
    required this.category,
    required this.question,
    required this.answer,
  });
}

class QuizGame {
  late List<Question> _questions = [];
  late int _questionIndex = 0;

  Future<void> fetchData() async {
    final url = Uri.parse(
        'https://opentdb.com/api.php?amount=8&category=15&difficulty=easy&type=boolean');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      // Error handling
      print('Request failed with status: ${response.statusCode}.');
    }

    // Successful API call
    final responseData = json.decode(response.body);

    // Process the data and create Question objects
    final results = responseData['results'];
    _questions = List<Question>.generate(results.length, (index) {
      final result = results[index];
      final category = result['category'];
      final question = result['question'];
      final answer = result['correct_answer'] == 'True';

      return Question(
        category: category,
        question: question,
        answer: answer,
      );
    });
  }

  Future<void> initialize() async {
    await fetchData();
  }

  Future<String> getQuestion() async {
    await initialize();
    String question = _questions[_questionIndex].question;
    _questionIndex += 1;
    return question;
  }

  bool get getQuestionAnswer {
    return _questions[_questionIndex].answer;
  }

  bool get isLastQuestion {
    return _questions.length == _questionIndex - 1;
  }
}
