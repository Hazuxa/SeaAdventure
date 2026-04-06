import 'dart:math';
import 'package:flutter/material.dart';
import '../models/trivia_model.dart';

class OceanTriviaScreen extends StatefulWidget {
  const OceanTriviaScreen({super.key});

  @override
  State<OceanTriviaScreen> createState() => _OceanTriviaScreenState();
}

class _OceanTriviaScreenState extends State<OceanTriviaScreen> {
  bool _quizStarted = false;
  bool _quizFinished = false;
  int _currentQuestionIndex = 0;
  int _score = 0;
  List<int> _userAnswers = [];
  QuizCategory? _selectedCategory;
  List<TriviaQuestion> _currentQuestions = [];
  DateTime? _quizStartTime;
  
  void _startCategoryQuiz(QuizCategory category) {
    setState(() {
      _selectedCategory = category;
      _currentQuestions = [...category.questions]..shuffle();
      _currentQuestions = _currentQuestions.take(min(5, _currentQuestions.length)).toList();
      _quizStarted = true;
      _quizFinished = false;
      _currentQuestionIndex = 0;
      _score = 0;
      _userAnswers = [];
      _quizStartTime = DateTime.now();
    });
  }

  void _startMixedQuiz() {
    setState(() {
      _selectedCategory = null;
      _currentQuestions = [...allTriviaQuestions]..shuffle();
      _currentQuestions = _currentQuestions.take(10).toList();
      _quizStarted = true;
      _quizFinished = false;
      _currentQuestionIndex = 0;
      _score = 0;
      _userAnswers = [];
      _quizStartTime = DateTime.now();
    });
  }

  void _answerQuestion(int answerIndex) {
    final currentQuestion = _currentQuestions[_currentQuestionIndex];
    final isCorrect = answerIndex == currentQuestion.correctAnswerIndex;
    
    if (isCorrect) {
      _score += currentQuestion.points;
    }
    
    _userAnswers.add(answerIndex);
    
    if (_currentQuestionIndex < _currentQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      setState(() {
        _quizFinished = true;
      });
    }
  }

  void _restartQuiz() {
    setState(() {
      _quizStarted = false;
      _quizFinished = false;
      _currentQuestionIndex = 0;
      _score = 0;
      _userAnswers = [];
      _selectedCategory = null;
      _currentQuestions = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001f3f),
      appBar: AppBar(
        title: const Text('Ocean Trivia Challenge'),
        backgroundColor: const Color(0xFF001f3f),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _quizStarted 
          ? (_quizFinished ? _buildResultsScreen() : _buildQuizScreen())
          : _buildCategorySelectionScreen(),
    );
  }

  Widget _buildCategorySelectionScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.deepPurple.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(Icons.lightbulb, color: Colors.white, size: 48),
                const SizedBox(height: 16),
                const Text(
                  'Test Your Ocean Knowledge!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Choose a category or try the mixed challenge!',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Mixed Quiz Button
          _buildMixedQuizButton(),
          const SizedBox(height: 24),

          // Categories Grid
          Text(
            'Select a Category',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.1,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: quizCategories.length,
            itemBuilder: (context, index) => _buildCategoryCard(quizCategories[index]),
          ),
          const SizedBox(height: 24),

          // Stats
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStat('${allTriviaQuestions.length}', 'Questions', Icons.help_outline),
                _buildStat('6', 'Categories', Icons.category),
                _buildStat('∞', 'Fun', Icons.emoji_emotions),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMixedQuizButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade400, Colors.red.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.4),
            blurRadius: 15,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _startMixedQuiz,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.shuffle, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mixed Challenge',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '10 random questions from all categories!',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.8)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(QuizCategory category) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [category.color.withOpacity(0.8), category.color.withOpacity(0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: category.color.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _startCategoryQuiz(category),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(category.icon, color: Colors.white, size: 36),
                const SizedBox(height: 12),
                Text(
                  category.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  '${category.questions.length} questions',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.cyan, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildQuizScreen() {
    final question = _currentQuestions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _currentQuestions.length;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Progress
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withOpacity(0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.cyan),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${_currentQuestionIndex + 1}/${_currentQuestions.length}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              Text(
                'Score: $_score',
                style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Question Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade500, Colors.deepPurple.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getCategoryName(question.category),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  question.question,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getDifficultyIcon(question.difficulty),
                      color: Colors.white.withOpacity(0.7),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${question.points} points',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Answer Options
          ...question.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _answerQuestion(index),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.cyan.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                String.fromCharCode(65 + index),
                                style: const TextStyle(
                                  color: Colors.cyan,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              option,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.5), size: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildResultsScreen() {
    final correctAnswers = _userAnswers.asMap().entries.where((entry) {
      return entry.value == _currentQuestions[entry.key].correctAnswerIndex;
    }).length;
    
    final percentage = (correctAnswers / _currentQuestions.length) * 100;
    final timeTaken = _quizStartTime != null 
        ? DateTime.now().difference(_quizStartTime!) 
        : const Duration(seconds: 0);
    
    String rank;
    String message;
    IconData rankIcon;
    Color rankColor;
    
    if (percentage >= 90) {
      rank = '🏆 Ocean Expert';
      message = 'Amazing! You\'re a true ocean master!';
      rankIcon = Icons.emoji_events;
      rankColor = Colors.amber;
    } else if (percentage >= 70) {
      rank = '🥈 Sea Scholar';
      message = 'Great job! You know your sea stuff!';
      rankIcon = Icons.star;
      rankColor = Colors.blue;
    } else if (percentage >= 50) {
      rank = '🥉 Beach Beginner';
      message = 'Good effort! Keep exploring the ocean!';
      rankIcon = Icons.water;
      rankColor = Colors.cyan;
    } else {
      rank = '🦐 Tide Pool Explorer';
      message = 'Keep learning! The ocean has so much to teach!';
      rankIcon = Icons.waves;
      rankColor = Colors.teal;
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Rank Display
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [rankColor.withOpacity(0.8), rankColor.withOpacity(0.4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: rankColor.withOpacity(0.4),
                  blurRadius: 25,
                  spreadRadius: 8,
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(rankIcon, color: Colors.white, size: 64),
                const SizedBox(height: 16),
                Text(
                  rank,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Stats
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                _buildResultRow('Score', '$_score points'),
                const Divider(color: Colors.white24),
                _buildResultRow('Correct', '$correctAnswers/${_currentQuestions.length}'),
                const Divider(color: Colors.white24),
                _buildResultRow('Accuracy', '${percentage.toStringAsFixed(1)}%'),
                const Divider(color: Colors.white24),
                _buildResultRow('Time', '${timeTaken.inMinutes}:${(timeTaken.inSeconds % 60).toString().padLeft(2, '0')}'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Review Answers Button
          ExpansionTile(
            title: const Text(
              'Review Answers',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            iconColor: Colors.cyan,
            collapsedIconColor: Colors.cyan,
            children: _currentQuestions.asMap().entries.map((entry) {
              final index = entry.key;
              final question = entry.value;
              final userAnswer = _userAnswers[index];
              final isCorrect = userAnswer == question.correctAnswerIndex;
              
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isCorrect ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isCorrect ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isCorrect ? Icons.check_circle : Icons.cancel,
                          color: isCorrect ? Colors.green : Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            question.question,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your answer: ${question.options[userAnswer]}',
                      style: TextStyle(
                        color: isCorrect ? Colors.green : Colors.red,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Correct: ${question.options[question.correctAnswerIndex]}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.cyan.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.cyan.withOpacity(0.3)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.lightbulb, color: Colors.cyan, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              question.funFact,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Play Again Button
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade400, Colors.teal.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _restartQuiz,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.replay, color: Colors.white),
                      const SizedBox(width: 8),
                      const Text(
                        'Play Again!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryName(QuestionCategory category) {
    switch (category) {
      case QuestionCategory.marineLife:
        return '🐠 Marine Life';
      case QuestionCategory.oceanZones:
        return '🌊 Ocean Zones';
      case QuestionCategory.conservation:
        return '💚 Conservation';
      case QuestionCategory.deepSea:
        return '🔮 Deep Sea';
      case QuestionCategory.funFacts:
        return '✨ Fun Facts';
      case QuestionCategory.seaLegends:
        return '📜 Sea Legends';
    }
  }

  IconData _getDifficultyIcon(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return Icons.star;
      case Difficulty.medium:
        return Icons.stars;
      case Difficulty.hard:
        return Icons.workspace_premium;
    }
  }
}
