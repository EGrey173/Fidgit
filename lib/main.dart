import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ─── SCREENSAVER TRANSITION ────────────────────────────────────────────────
/// Shows `screensaver.png` for 500ms, then replaces itself with the target route.
class Screensaver extends StatefulWidget {
  final String nextRoute;
  const Screensaver(this.nextRoute, {super.key});
  @override
  _ScreensaverState createState() => _ScreensaverState();
}
class _ScreensaverState extends State<Screensaver> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 500), () {
      // Always replace the screensaver route with the target route:
      Navigator.pushReplacementNamed(context, widget.nextRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Assumes you've added 'screensaver.png' under assets/ and in pubspec.yaml
      body: SizedBox.expand(
        child: Image.asset('assets/screensaver.png', fit: BoxFit.cover),
      ),
    );
  }
}

/// Navigates forward *with* a screensaver, stacking the dashboard behind.
void navigateWithScreensaver(BuildContext c, String route) {
  Navigator.push(
    c,
    MaterialPageRoute(builder: (_) => Screensaver(route)),
  );
}

/// Navigates *back* (or replace) with a screensaver, so that you can't return to it.
void navigateReplacementWithScreensaver(BuildContext c, String route) {
  Navigator.pushReplacement(
    c,
    MaterialPageRoute(builder: (_) => Screensaver(route)),
  );
}

/// ─── MAIN APP ─────────────────────────────────────────────────────────────

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'All-in-One App',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/',
      routes: {
        '/': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/dashboard': (_) => const DashboardScreen(),
        '/quiz': (_) => const FinanceQuizScreen(),
        '/budget': (_) => const BudgetTrackerScreen(),
        '/tips': (_) => const FinancialTipsScreen(),
      },
    );
  }
}

/// ─── LOGIN SCREEN ─────────────────────────────────────────────────────────

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  Future<bool> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') == _userCtrl.text &&
           prefs.getString('password') == _passCtrl.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextFormField(
              controller: _userCtrl,
              decoration: const InputDecoration(labelText: 'Username'),
              validator: (v) => v!.isEmpty ? 'Enter a username' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _passCtrl,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (v) => v!.isEmpty ? 'Enter a password' : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate() && await _checkLogin()) {
                  navigateReplacementWithScreensaver(context, '/dashboard');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid credentials')),
                  );
                }
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => navigateWithScreensaver(context, '/register'),
              child: const Text('Create an Account'),
            ),
          ]),
        ),
      ),
    );
  }
}

/// ─── REGISTER SCREEN ────────────────────────────────────────────────────────

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}
class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  Future<void> _saveAccount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _userCtrl.text);
    await prefs.setString('password', _passCtrl.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create an Account')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextFormField(
              controller: _userCtrl,
              decoration: const InputDecoration(labelText: 'Username'),
              validator: (v) => v!.isEmpty ? 'Enter a username' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _passCtrl,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (v) => v!.isEmpty ? 'Enter a password' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _confirmCtrl,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
              validator: (v) =>
                  v != _passCtrl.text ? 'Passwords do not match' : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await _saveAccount();
                  navigateReplacementWithScreensaver(context, '/');
                }
              },
              child: const Text('Create Account'),
            ),
          ]),
        ),
      ),
    );
  }
}

/// ─── DASHBOARD SCREEN ───────────────────────────────────────────────────────

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text(
            'Welcome! What would you like to do?',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => navigateWithScreensaver(context, '/quiz'),
            child: const Text('Take Quiz'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => navigateWithScreensaver(context, '/budget'),
            child: const Text('Budget Tracker'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => navigateWithScreensaver(context, '/tips'),
            child: const Text('Financial Tips'),
          ),
        ]),
      ),
    );
  }
}

/// ─── FINANCE QUIZ SCREEN ────────────────────────────────────────────────────

class FinanceQuizScreen extends StatefulWidget {
  const FinanceQuizScreen({super.key});
  @override
  _FinanceQuizScreenState createState() => _FinanceQuizScreenState();
}
class _FinanceQuizScreenState extends State<FinanceQuizScreen> {
  final Map<String, List<Map<String, dynamic>>> questions = {
    'easy': [
      {
        'question': "1. What is a savings account?",
        'correctAnswers': [
          "A bank account that earns interest",
          "An account used for storing money safely",
          "A financial product that offers interest on deposits"
        ]
      },
      {
        'question': "2. What is a stock?",
        'correctAnswers': [
          "A share in the ownership of a company",
          "An ownership interest in a corporation",
          "A financial security representing partial ownership of a business"
        ]
      },
      {
        'question': "3. What is a budget?",
        'correctAnswers': [
          "A plan for spending and saving money",
          "An estimate of income and expenses",
          "A financial plan outlining how money will be spent"
        ]
      },
    ],
    // ... normal & hard omitted for brevity; include them fully as before ...
  };

  String? selectedDifficulty;
  List<Map<String, dynamic>> askedQuestions = [];
  int currentQuestionIndex = 0;
  final List<Map<String, dynamic>> userAnswers = [];

  Map<String, bool> fuzzyMatch(String userAnswer, List<String> correctAnswers) {
    bool matched = false;
    var uw = userAnswer.toLowerCase().split(' ');
    for (var ans in correctAnswers) {
      var cw = ans.toLowerCase().split(' ');
      var cnt = cw.where((w) => uw.contains(w)).length;
      if (cnt / cw.length * 100 >= 30) {
        matched = true;
        break;
      }
    }
    return {'isCorrect': matched};
  }

  void setDiff(String level) {
    setState(() {
      selectedDifficulty = level;
      askedQuestions = List.from(questions[level]!);
      currentQuestionIndex = 0;
      userAnswers.clear();
    });
  }

  void submit(String answer) {
    if (answer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an answer')),
      );
      return;
    }
    var q = askedQuestions[currentQuestionIndex];
    var res = fuzzyMatch(answer, List<String>.from(q['correctAnswers']));
    userAnswers.add({
      'question': q['question'],
      'userAnswer': answer,
      'correctAnswers': q['correctAnswers'],
      'isCorrect': res['isCorrect'],
    });
    setState(() => currentQuestionIndex++);
    if (currentQuestionIndex >= 3) {
      Future.delayed(const Duration(milliseconds: 300), _feedback);
    }
  }

  void _feedback() {
    int correctCount = userAnswers.where((a) => a['isCorrect']).length;
    String fb = 'You got $correctCount/3 correct.\n\n';
    var wrong = userAnswers.where((a) => !a['isCorrect']);
    if (wrong.isNotEmpty) {
      fb += "Review:\n";
      for (var a in wrong) {
        fb +=
            '"${a['question']}"\nYour: ${a['userAnswer']}\n'
            'Ans: ${(a['correctAnswers'] as List).join(", ")}\n\n';
      }
    } else {
      fb += "Excellent!";
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Quiz Feedback'),
        content: SingleChildScrollView(child: Text(fb)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              navigateReplacementWithScreensaver(context, '/dashboard');
            },
            child: const Text('Back to Dashboard'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (selectedDifficulty == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Finance Quiz')),
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Select Difficulty', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () => setDiff('easy'), child: const Text('Easy')),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: () => setDiff('normal'), child: const Text('Normal')),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: () => setDiff('hard'), child: const Text('Hard')),
          ]),
        ),
      );
    }

    if (currentQuestionIndex < 3) {
      var q = askedQuestions[currentQuestionIndex];
      var ctrl = TextEditingController();
      return Scaffold(
        appBar: AppBar(title: const Text('Finance Quiz')),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('Q${currentQuestionIndex+1}: ${q['question']}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            TextField(controller: ctrl, decoration: const InputDecoration(border: OutlineInputBorder())),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => submit(ctrl.text.trim()),
              child: const Text('Submit Answer'),
            ),
          ]),
        ),
      );
    }

    // Completed quiz summary shows in dialog; screen itself:
    return Scaffold(
      appBar: AppBar(title: const Text('Finance Quiz')),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Quiz Completed!', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => navigateReplacementWithScreensaver(context, '/dashboard'),
            child: const Text('Back to Dashboard'),
          ),
        ]),
      ),
    );
  }
}

/// ─── BUDGET TRACKER SCREEN ─────────────────────────────────────────────────

class BudgetTrackerScreen extends StatefulWidget {
  const BudgetTrackerScreen({super.key});
  @override
  _BudgetTrackerScreenState createState() => _BudgetTrackerScreenState();
}
class _BudgetTrackerScreenState extends State<BudgetTrackerScreen> {
  double budget = 0, spent = 0;
  final List<double> expenses = [];
  final _bCtrl = TextEditingController();
  final _eCtrl = TextEditingController();

  void _setBudget() {
    final b = double.tryParse(_bCtrl.text) ?? -1;
    if (b <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid budget.')),
      );
      return;
    }
    setState(() {
      budget = b;
      spent = 0;
      expenses.clear();
    });
  }

  void _addExpense() {
    final e = double.tryParse(_eCtrl.text) ?? -1;
    if (e < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid expense.')),
      );
      return;
    }
    setState(() {
      spent += e;
      expenses.add(e);
      _eCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    double remaining = budget - spent;
    return Scaffold(
      appBar: AppBar(title: const Text('Budget Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          TextField(
            controller: _bCtrl,
            decoration: const InputDecoration(labelText: 'Enter your budget', border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          ElevatedButton(onPressed: _setBudget, child: const Text('Set Budget')),
          if (budget > 0) ...[
            const SizedBox(height: 20),
            Text('Remaining: \$${remaining.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: _eCtrl,
              decoration: const InputDecoration(labelText: 'Add an expense', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _addExpense, child: const Text('Add Expense')),
            const SizedBox(height: 20),
            const Text('Expenses:', style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (_, i) => Card(
                  color: Colors.green.shade200,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Text('\$${expenses[i].toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ),
          ],
          ElevatedButton(
            onPressed: () => navigateReplacementWithScreensaver(context, '/dashboard'),
            child: const Text('Back to Dashboard'),
          ),
        ]),
      ),
    );
  }
}

/// ─── FINANCIAL TIPS SCREEN ────────────────────────────────────────────────

class FinancialTipsScreen extends StatefulWidget {
  const FinancialTipsScreen({super.key});
  @override
  _FinancialTipsScreenState createState() => _FinancialTipsScreenState();
}
class _FinancialTipsScreenState extends State<FinancialTipsScreen> {
  final tips = [
    "Save 10% of your income each month.",
    "Invest in a diversified portfolio.",
    "Track your daily expenses to understand your spending habits.",
    "Set up an emergency fund with at least 3 months' worth of expenses.",
    "Avoid impulse buying and wait 24 hours before making purchases."
  ];
  int currentTipIndex = 0;
  final Set<String> favoriteTips = {};

  void showNextTip() {
    setState(() {
      currentTipIndex = (currentTipIndex + 1) % tips.length;
    });
  }

  void toggleFavorite() {
    String tip = tips[currentTipIndex];
    setState(() {
      if (favoriteTips.contains(tip)) favoriteTips.remove(tip);
      else favoriteTips.add(tip);
    });
  }

  @override
  Widget build(BuildContext context) {
    String tip = tips[currentTipIndex];
    return Scaffold(
      appBar: AppBar(title: const Text('Financial Tips')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              border: Border.all(color: Colors.green.shade300),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Expanded(child: Text(tip, style: const TextStyle(fontSize: 16))),
                IconButton(
                  icon: Icon(
                    favoriteTips.contains(tip) ? Icons.favorite : Icons.favorite_border,
                    color: favoriteTips.contains(tip) ? Colors.red : Colors.green.shade800,
                  ),
                  onPressed: toggleFavorite,
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton(onPressed: showNextTip, child: const Text('Next Tip')),
          const SizedBox(height: 30),
          const Text('Favorited Tips', style: TextStyle(fontSize: 20)),
          Expanded(
            child: ListView(
              children: favoriteTips
                  .map((t) => Card(
                        color: Colors.green.shade700,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(t, style: const TextStyle(color: Colors.white)),
                        ),
                      ))
                  .toList(),
            ),
          ),
          ElevatedButton(
            onPressed: () => navigateReplacementWithScreensaver(context, '/dashboard'),
            child: const Text('Back to Dashboard'),
          ),
        ]),
      ),
    );
  }
}
