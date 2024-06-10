import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../models/question.dart';

class GameLogic {
  final FlutterTts flutterTts = FlutterTts();

  Future<void> speakWord(String word) async {
    await flutterTts.speak(word);
  }

  void initializeImageOptions(Question question, List<Question> allQuestions,
      Function(List<String>) callback) {
    List<String> imageOptions = allQuestions.map((q) => q.imagePath).toList();
    imageOptions.remove(
        question.imagePath); // إزالة الإجابة الصحيحة إذا كانت في القائمة
    imageOptions.shuffle();
    imageOptions = imageOptions.take(3).toList(); // اختيار 3 صور عشوائية
    imageOptions.add(question.imagePath); // إضافة الإجابة الصحيحة
    imageOptions.shuffle(); // خلط لتوزيع الإجابة الصحيحة
    callback(imageOptions);
  }

  void handleSelection(String selectedImagePath, Question question,
      BuildContext context, Function(bool, Color?) callback) {
    final gameState = Provider.of<GameState>(context, listen: false);
    bool isCorrect = selectedImagePath == question.imagePath;
    Color? color =
        isCorrect ? Colors.green.withOpacity(0.5) : Colors.red.withOpacity(0.5);

    if (isCorrect) {
      gameState.incrementCorrectAnswers();
    } else {
      gameState.incrementWrongAttempts();
      // إزالة السؤال عند الإجابة الخاطئة
      gameState.allQuestions.remove(question);
    }
    gameState.addAnswer(question.word, isCorrect);

    callback(isCorrect, color);
  }
}
