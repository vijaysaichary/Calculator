import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp()); // Start the app by running CalculatorApp
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arithmetic Calculator',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: CalculatorScreen(), // Show our calculator screen
      debugShowCheckedModeBanner: false, // Remove debug banner
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  // Controller for the input field
  TextEditingController expressionController = TextEditingController();

  // Display result text
  String displayText = '0';

  // To track if we are starting a new calculation
  bool isNewCalculation = true;

  // Inserts text at the current cursor position
  void insertAtCursor(String text) {
    final selection = expressionController.selection;
    final cursorPos = selection.start;
    String newText = expressionController.text.replaceRange(
      cursorPos,
      cursorPos,
      text,
    );
    expressionController.text = newText;
    expressionController.selection =
        TextSelection.collapsed(offset: cursorPos + text.length);
  }

  // Called when a number button is pressed
  void onNumberPressed(String number) {
    insertAtCursor(number);
  }

  // Called when an operator (+, -, x, /) is pressed
  void onOperationPressed(String op) {
    insertAtCursor(op);
  }

  // Clears everything (AC button)
  void onClearPressed() {
    setState(() {
      expressionController.clear();
      displayText = '0';
      isNewCalculation = true;
    });
  }

  // Called when "=" is pressed
  void onEqualsPressed() {
    String exp = expressionController.text;
    exp = exp.replaceAll('x', '*'); // Replace 'x' with '*' for multiplication
    try {
      final result = _evaluateExpression(exp);
      setState(() {
        displayText = result.toString(); // Show the result
      });
    } catch (e) {
      setState(() {
        displayText = 'Error'; // Show error if calculation fails
      });
    }
  }

  // Very simple expression evaluator (no operator precedence)
  double _evaluateExpression(String exp) {
    exp = exp.replaceAll(' ', ''); // Remove spaces
    List<String> tokens = [];
    String numberBuffer = '';

    // Break the expression into numbers and operators
    for (int i = 0; i < exp.length; i++) {
      String char = exp[i];
      if ('0123456789.'.contains(char)) {
        numberBuffer += char;
      } else if ('+-*/'.contains(char)) {
        if (numberBuffer.isNotEmpty) {
          tokens.add(numberBuffer);
          numberBuffer = '';
        }
        tokens.add(char);
      }
    }
    if (numberBuffer.isNotEmpty) tokens.add(numberBuffer);

    // Start calculation from left to right
    double result = double.parse(tokens[0]);
    for (int i = 1; i < tokens.length; i += 2) {
      String op = tokens[i];
      double num = double.parse(tokens[i + 1]);
      if (op == '+') result += num;
      if (op == '-') result -= num;
      if (op == '*') result *= num;
      if (op == '/') result /= num;
    }
    return result;
  }

  // Builds a single calculator button
  Widget buildButton(String text, Color bgColor, Color txtColor, VoidCallback onPressed) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            foregroundColor: txtColor,
            padding: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Arithmetic Calculator', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Input field
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: expressionController,
                style: TextStyle(fontSize: 28, color: Colors.white),
                cursorColor: Colors.orange,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter expression',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            // Result display
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  displayText,
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            // Calculator buttons
            Column(
              children: [
                Row(
                  children: [
                    buildButton('7', Colors.grey[800]!, Colors.white, () => onNumberPressed('7')),
                    buildButton('8', Colors.grey[800]!, Colors.white, () => onNumberPressed('8')),
                    buildButton('9', Colors.grey[800]!, Colors.white, () => onNumberPressed('9')),
                    buildButton('/', Colors.blue, Colors.white, () => onOperationPressed('/')),
                  ],
                ),
                Row(
                  children: [
                    buildButton('4', Colors.grey[800]!, Colors.white, () => onNumberPressed('4')),
                    buildButton('5', Colors.grey[800]!, Colors.white, () => onNumberPressed('5')),
                    buildButton('6', Colors.grey[800]!, Colors.white, () => onNumberPressed('6')),
                    buildButton('x', Colors.blue, Colors.white, () => onOperationPressed('x')),
                  ],
                ),
                Row(
                  children: [
                    buildButton('1', Colors.grey[800]!, Colors.white, () => onNumberPressed('1')),
                    buildButton('2', Colors.grey[800]!, Colors.white, () => onNumberPressed('2')),
                    buildButton('3', Colors.grey[800]!, Colors.white, () => onNumberPressed('3')),
                    buildButton('-', Colors.blue, Colors.white, () => onOperationPressed('-')),
                  ],
                ),
                Row(
                  children: [
                    buildButton('AC', Colors.red, Colors.white, onClearPressed),
                    buildButton('0', Colors.grey[800]!, Colors.white, () => onNumberPressed('0')),
                    buildButton('=', Colors.orange, Colors.white, onEqualsPressed),
                    buildButton('+', Colors.blue, Colors.white, () => onOperationPressed('+')),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
