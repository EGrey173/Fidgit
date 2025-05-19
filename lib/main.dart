import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };
  runApp(const MyApp());
}

// Main App with Named Routes and Green Theme.
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login and Quiz & Budget App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.green.shade50,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 237, 255, 237),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.green.shade800,
          ),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: Colors.green.shade50,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/quiz': (context) => const FinanceQuizScreen(),
        '/budget': (context) => const BudgetTrackerScreen(),
        '/tips': (context) => const FinancialTipsScreen(),
      },
    );
  }
}
//login
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Check credentials using SharedPreferences.
  Future<bool> checkLogin(String username, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');
    String? storedPassword = prefs.getString('password');
    return storedUsername == username && storedPassword == password;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _loginFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter a username' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter a password' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_loginFormKey.currentState!.validate()) {
                      bool success = await checkLogin(
                        usernameController.text,
                        passwordController.text,
                      );
                      if (success) {
                        // Navigate to the dashboard screen.
                        Navigator.pushNamed(context, '/dashboard');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Invalid credentials.')),
                        );
                      }
                    }
                  },
                  child: const Text('Login'),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text('Create an Account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------------
// Registration Screen
// ------------------------
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _registerFormKey = GlobalKey<FormState>();
  final TextEditingController newUsernameController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> saveAccount(String username, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create an Account')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _registerFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: newUsernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter a username' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter a password' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: 'Confirm Password'),
                  validator: (value) {
                    if (value!.isEmpty) return 'Confirm your password';
                    if (value != newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_registerFormKey.currentState!.validate()) {
                      await saveAccount(newUsernameController.text,
                          newPasswordController.text);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Account created successfully!')),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Create Account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------------
// Dashboard Screen
// ------------------------
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Welcome! What would you like to do?",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/quiz');
                },
                child: const Text("Take Quiz"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/budget');
                },
                child: const Text("Budget Tracker"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/tips');
                },
                child: const Text("Financial Tips"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text("Stock Recommendations"),
                onPressed: () {
                  //do nothing HAHAHA GET PRANKED MR DAVVISON HASHAHSDHAHAHSHAAHAHAHHAHAHAH
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------
// Finance Quiz Screen
// ------------------------
class FinanceQuizScreen extends StatefulWidget {
  const FinanceQuizScreen({super.key});
  @override
  _FinanceQuizScreenState createState() => _FinanceQuizScreenState();
}

class _FinanceQuizScreenState extends State<FinanceQuizScreen> {
  // Quiz variables.
  int currentQuestionIndex = 0;
  String? selectedDifficulty;
  List<Map<String, dynamic>> askedQuestions = [];
  List<Map<String, dynamic>> userAnswers = [];

  // Questions for each difficulty.
  final Map<String, List<Map<String, dynamic>>> questions = {
    'easy': [
      {
        'question': "1. What is a savings account?",
        'correctAnswers': [
          "A bank account that earns interest",
          "An account used for storing money safely",
          "A financial product that offers interest on deposits"
        ],
        'topic': "personal savings"
      },
      {
        'question': "2. What is a stock?",
        'correctAnswers': [
          "A share in the ownership of a company",
          "An ownership interest in a corporation",
          "A financial security representing partial ownership of a business"
        ],
        'topic': "stock market/real estate"
      },
      {
        'question': "3. What is a budget?",
        'correctAnswers': [
          "A plan for spending and saving money",
          "An estimate of income and expenses",
          "A financial plan outlining how money will be spent"
        ],
        'topic': "personal spending"
      }
    ],
    'normal': [
      {
        'question': "4. What is the difference between a debit card and a credit card?",
        'correctAnswers': [
          "A debit card uses your own money, while a credit card borrows money from a lender",
          "A debit card withdraws funds from your bank account, credit cards let you borrow funds",
          "Debit cards are linked to checking accounts, credit cards involve borrowed funds"
        ],
        'topic': "personal spending"
      },
      {
        'question': "5. What is a stock market?",
        'correctAnswers': [
          "A marketplace where shares of companies are bought and sold",
          "A public exchange where securities are traded",
          "A system for buying and selling shares in publicly traded companies"
        ],
        'topic': "stock market/real estate"
      },
      {
        'question': "6. What is an emergency fund?",
        'correctAnswers': [
          "A savings account meant to cover unexpected expenses",
          "Money set aside for financial emergencies",
          "A reserve of funds used during financial crises"
        ],
        'topic': "personal savings"
      }
    ],
    'hard': [
      {
        'question': "7. What is compound interest, and how is it calculated?",
        'correctAnswers': [
          "Compound interest is interest on interest, and it is calculated by multiplying the initial principal amount by one plus the annual interest rate raised to the power of the number of periods",
          "Interest calculated on both the initial principal and the accumulated interest",
          "Interest on a loan or deposit calculated based on both the initial principal and the interest that has been added over time"
        ],
        'topic': "personal savings"
      },
      {
        'question': "8. What is real estate investment?",
        'correctAnswers': [
          "Buying property to generate income or appreciate in value",
          "Investing in real property for profit",
          "The purchase of land or buildings for financial return"
        ],
        'topic': "stock market/real estate"
      },
      {
        'question': "9. How can you reduce discretionary spending?",
        'correctAnswers': [
          "By cutting back on non-essential purchases like entertainment and dining out",
          "By limiting spending on wants rather than needs",
          "Reducing unnecessary expenses in your budget"
        ],
        'topic': "personal spending"
      }
    ],
  };

  // Fuzzy match function.
  Map<String, bool> fuzzyMatch(String userAnswer, List<String> correctAnswers) {
    bool matchedCorrect = false;
    for (var correctAnswer in correctAnswers) {
      List<String> correctWords = correctAnswer.toLowerCase().split(' ');
      List<String> userWords = userAnswer.toLowerCase().split(' ');
      int totalCorrectWords = correctWords.length;
      int matchedWords =
          correctWords.where((word) => userWords.contains(word)).length;
      double percentageMatched = (matchedWords / totalCorrectWords) * 100;
      if (percentageMatched >= 30) {
        matchedCorrect = true;
      }
    }
    return {'isCorrect': matchedCorrect};
  }

  // Initialize quiz by selecting a difficulty.
  void setDifficulty(String level) {
    setState(() {
      selectedDifficulty = level;
      askedQuestions = List<Map<String, dynamic>>.from(questions[level]!);
      currentQuestionIndex = 0;
      userAnswers = [];
    });
  }

  // Evaluate answer.
  void submitAnswer(String answer) {
    if (answer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter an answer before submitting!")),
      );
      return;
    }
    final currentQuestion = askedQuestions[currentQuestionIndex];
    List<String> correctAnswers =
        List<String>.from(currentQuestion['correctAnswers']);
    Map<String, bool> fuzzyResult = fuzzyMatch(answer, correctAnswers);
    userAnswers.add({
      'question': currentQuestion['question'],
      'userAnswer': answer,
      'correctAnswers': correctAnswers,
      'isCorrect': fuzzyResult['isCorrect'],
    });
    setState(() {
      currentQuestionIndex++;
    });
    if (currentQuestionIndex >= 3) {
      Future.delayed(const Duration(milliseconds: 300), () {
        giveFeedback();
      });
    }
  }

  // Display feedback in a scrollable dialog.
  void giveFeedback() {
    int correctCount = userAnswers.where((a) => a['isCorrect'] == true).length;
    String feedbackText =
        'Quiz finished! You answered $correctCount out of 3 questions correctly.\n\n';
    List<Map<String, dynamic>> incorrectAnswers =
        userAnswers.where((a) => a['isCorrect'] == false).toList();
    if (incorrectAnswers.isNotEmpty) {
      feedbackText += "Here's where you can improve:\n";
      for (var answer in incorrectAnswers) {
        feedbackText +=
            'For the question "${answer['question']}", you answered "${answer['userAnswer']}". The correct answers were: "${answer['correctAnswers'].join('", "')}".\n';
      }
    } else {
      feedbackText += "Excellent work! You got everything right!";
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.green.shade50,
        title: const Text("Quiz Feedback"),
        content: SingleChildScrollView(child: Text(feedbackText)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetQuiz();
            },
            child: const Text("Retry Quiz"),
          ),
        ],
      ),
    );
  }

  // Reset quiz.
  void resetQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      userAnswers = [];
      selectedDifficulty = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (selectedDifficulty == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Finance Quiz")),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Select Difficulty", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => setDifficulty('easy'),
                child: const Text("Easy"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => setDifficulty('normal'),
                child: const Text("Normal"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => setDifficulty('hard'),
                child: const Text("Hard"),
              ),
            ],
          ),
        ),
      );
    } else if (currentQuestionIndex < 3) {
      final currentQuestion = askedQuestions[currentQuestionIndex];
      final TextEditingController answerController = TextEditingController();
      return Scaffold(
        appBar: AppBar(title: const Text("Finance Quiz")),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Question ${currentQuestionIndex + 1}",
                  style: const TextStyle(fontSize: 22)),
              const SizedBox(height: 20),
              Text(currentQuestion['question'],
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              TextField(
                controller: answerController,
                decoration: const InputDecoration(
                  hintText: "Type your answer",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  submitAnswer(answerController.text.trim());
                  answerController.clear();
                },
                child: const Text("Submit Answer"),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: const Text("Finance Quiz")),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Quiz Completed!", style: TextStyle(fontSize: 24)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: resetQuiz,
                  child: const Text("Retry Quiz"),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

// ------------------------
// Budget Tracker Screen
// ------------------------
class BudgetTrackerScreen extends StatefulWidget {
  const BudgetTrackerScreen({super.key});
  @override
  _BudgetTrackerScreenState createState() => _BudgetTrackerScreenState();
}

class _BudgetTrackerScreenState extends State<BudgetTrackerScreen> {
  double budget = 0.0;
  double spent = 0.0;
  final List<double> expenseList = [];
  
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController expenseController = TextEditingController();
  
  String status = "";
  
  void setBudget() {
    final double? inputBudget = double.tryParse(budgetController.text);
    if (inputBudget == null || inputBudget <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid budget.")),
      );
      return;
    }
    setState(() {
      budget = inputBudget;
      status = "Budget set successfully!";
    });
  }
  
  void addExpense() {
    final double? expense = double.tryParse(expenseController.text);
    if (expense == null || expense < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid expense.")),
      );
      return;
    }
    double newSpent = spent + expense;
    setState(() {
      if (newSpent > budget) {
        status = "You have exceeded your budget!";
      } else {
        spent = newSpent;
        expenseList.add(expense);
        status =
            "You have \$${(budget - spent).toStringAsFixed(2)} remaining in your budget.";
      }
      expenseController.clear();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Budget Tracker")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              const Text("Budget Tracker",
                  style: TextStyle(fontSize: 24, color: Colors.green)),
              const SizedBox(height: 20),
              // Budget input section.
              TextField(
                controller: budgetController,
                decoration: const InputDecoration(
                  labelText: "Enter your budget",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                enabled: budget == 0.0,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: setBudget,
                child: const Text("Set Budget"),
              ),
              const SizedBox(height: 20),
              // Only show tracker if budget is set.
              if (budget > 0) ...[
                const Text("Track Your Spending",
                    style: TextStyle(fontSize: 20, color: Colors.greenAccent)),
                const SizedBox(height: 10),
                TextField(
                  controller: expenseController,
                  decoration: const InputDecoration(
                    labelText: "Add an expense",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: addExpense,
                  child: const Text("Add Expense"),
                ),
                const SizedBox(height: 20),
                Text(status,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                const Text("Expenses:", style: TextStyle(fontSize: 18)),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: expenseList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.green.shade200, // Set expense card to a green tone.
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text(
                          "\$${expenseList[index].toStringAsFixed(2)}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------
// Financial Tips Screen
// ------------------------
class FinancialTipsScreen extends StatefulWidget {
  const FinancialTipsScreen({super.key});
  @override
  _FinancialTipsScreenState createState() => _FinancialTipsScreenState();
}

class _FinancialTipsScreenState extends State<FinancialTipsScreen> {
  // List of tips.
  final List<String> tips = [
    "Save 10% of your income each month.",
    "Track your daily expenses to understand your spending habits.",
    "Avoid impulse buying and wait 24 hours before making purchases.",
    "To increase the amount of money you have, get more money.",
    "To cut expenses, spend less.",
    "Invest in a diversified portfolio.",
    "To improve your credit score, focus on improving your credit score.",
    "Set up an emergency fund with at least 3 months' worth of expenses.",
    "To save money, don't spend as much money."
  ];
  int currentTipIndex = 0;
  final Set<String> favoriteTips = {};

  // Cycle to the next tip.
  void showNextTip() {
    setState(() {
      currentTipIndex = (currentTipIndex + 1) % tips.length;
    });
  }

  // Toggle favorite status of current tip.
  void toggleFavorite() {
    setState(() {
      String currentTip = tips[currentTipIndex];
      if (favoriteTips.contains(currentTip)) {
        favoriteTips.remove(currentTip);
      } else {
        favoriteTips.add(currentTip);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String currentTip = tips[currentTipIndex];
    return Scaffold(
      appBar: AppBar(title: const Text("Financial Tips")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              const Text("Financial Tips",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.green,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              // Tip Section
              Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  border: Border.all(color: Colors.green.shade300),
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(currentTip, style: const TextStyle(fontSize: 16)),
                    ),
                    IconButton(
                      icon: Icon(
                        favoriteTips.contains(currentTip)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: favoriteTips.contains(currentTip)
                            ? Colors.red
                            : Colors.green.shade800,
                      ),
                      onPressed: toggleFavorite,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: showNextTip,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text("Next Tip"),
              ),
              const SizedBox(height: 30),
              // Favorited Tips Section
              const Text("Favorited Tips",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 10),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: favoriteTips
                    .map(
                      (tip) => Card(
                        color: Colors.green.shade700, // Darker green for favorited tips.
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            tip,
                            style: const TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
