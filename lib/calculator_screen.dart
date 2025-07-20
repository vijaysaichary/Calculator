import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String input = ''; // Stores user input as text
  String expression = '';// Current expression
  String result = ''; // Result after calculation
  String operator = ''; // Stores the operator 
  bool isResultShown = false; // to show result after '=' pressed


  TextEditingController expressionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    expressionController.text = '';
    // When the text changes if we already showed the result, calculate again with the new text
    expressionController.addListener(() {
      if (isResultShown) {
        expression = expressionController.text;
        recalculateFromExpression(expression);
      } else {
        expression = expressionController.text;
      }
    });
  }
   // Calculate the answer again from the current expression
  void recalculateFromExpression(String expr) {
    try {
      String exp = expr.replaceAll(' ', '');// Remove spaces
      String op = '';
      for (var o in ['+', '-', '*', '/']) {
        if (exp.contains(o)) {
          op = o;
          break;
        }
      }
      if (op.isEmpty) return; // No operator found
      var parts = exp.split(op);
      if (parts.length < 2) return;// Need two numbers

      double num1 = double.tryParse(parts[0]) ?? 0;
      double num2 = double.tryParse(parts[1]) ?? 0;

      double res = calculate(num1, num2, op);
      setState(() {
        operator = op;
        result = res.toString();
        expression = expr;
      });
    } catch (e) {
      // ignore invalid input
    }
  }

  // Insert given text at current cursor position
  void insertAtCursor(String value) {
    final text = expressionController.text;
    final selection = expressionController.selection;
    final cursorPos = selection.start >= 0 ? selection.start : text.length;

    final newText = text.replaceRange(cursorPos, cursorPos, value);

    expressionController.text = newText;
    expressionController.selection = TextSelection.fromPosition(
      TextPosition(offset: cursorPos + value.length),
    );
  }

  void onButtonClick(String value) {// Handle button click 
    setState(() {
      if (value == 'AC') {
        expression = '';
        result = '';
        operator = '';
        isResultShown = false;
        expressionController.text = '';
      } else if (value == '+' || value == '-' || value == '*' || value == '/') {
        String exp = expressionController.text.replaceAll(' ', '');
        String opInExp = '';
        int opIndex = -1;

        for (var o in ['+', '-', '*', '/']) {// Check if expression already has an operator
          opIndex = exp.indexOf(o);
          if (opIndex != -1) {
            opInExp = o;
            break;
          }
        }

        if (opInExp.isNotEmpty && opIndex != -1) {
          var parts = exp.split(opInExp);
          if (parts.length == 2) {
            // If cursor is next to operator, replace it
            final cursorPos = expressionController.selection.start;
            if (cursorPos == opIndex + 1) {
              final beforeOp = parts[0];
              final afterOp = parts[1];
              final newText = beforeOp + value + afterOp;
              expressionController.text = newText;
              expressionController.selection = TextSelection.collapsed(offset: opIndex + 1);
              operator = value;
            } else {
              // Else: insert at cursor
              insertAtCursor(value);
              operator = value;
            }
          } else {
            insertAtCursor(value);
            operator = value;
          }
        } else {// No existing operator, just insert new operator
          insertAtCursor(value);
          operator = value;
        }
        // Recalculate if result is already shown
        if (isResultShown) {
          recalculateFromExpression(expressionController.text);
        }
      } else if (value == '=') {
        recalculateFromExpression(expressionController.text);
        isResultShown = true;
      } else {
        insertAtCursor(value);
      }
    });
  }
  // Actual calculation based on operator
  double calculate(double a, double b, String op) {
    switch (op) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '*':
        return a * b;
      case '/':
        return b != 0 ? a / b : double.nan;
      default:
        return 0;
    }
  }
  //to build calculator button
  Widget calcBtn(String text, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => onButtonClick(text),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Arithmetic Calculator')),
      backgroundColor: const Color.fromARGB(255, 241, 240, 240),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Display input expression
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: expressionController,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Color.fromARGB(255, 185, 121, 65), fontSize: 32),
              readOnly: false,
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
          if (isResultShown && result.isNotEmpty)// Show result below when calculated
            Padding(
              padding: const EdgeInsets.only(top: 20.0, right: 20),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  result,
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          const Spacer(),
          Row(
            children: [
              calcBtn('7', Colors.grey),
              calcBtn('8', Colors.grey),
              calcBtn('9', Colors.grey),
              calcBtn('/', Colors.blue),
            ],
          ),
          Row(
            children: [
              calcBtn('4', Colors.grey),
              calcBtn('5', Colors.grey),
              calcBtn('6', Colors.grey),
              calcBtn('*', Colors.blue),
            ],
          ),
          Row(
            children: [
              calcBtn('1', Colors.grey),
              calcBtn('2', Colors.grey),
              calcBtn('3', Colors.grey),
              calcBtn('-', Colors.blue),
            ],
          ),
          Row(
            children: [
              calcBtn('AC', Colors.red),
              calcBtn('0', Colors.grey),
              calcBtn('=', Colors.orange),
              calcBtn('+', Colors.blue),
            ],
          ),
        ],
      ),
    );
  }
}
