import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String input = ''; // Stores the digits the user is currently typing 
  String expression = '';
  String result = '';
  double firstNum = 0;// Holds the first number entered before selecting an operator
  double secondNum = 0;// Holds the second number entered after selecting an operator
  String operator = '';
  bool isResultShown = false; // We didn’t press '=' yet

  void onButtonClick(String value) {
    setState(() {
      if (value == 'AC') {// Clear everything (input, result, operator)
        input = '';
        expression = '';
        result = '';
        operator = '';
        firstNum = 0;
        secondNum = 0;
        isResultShown = false;
      } else if (value == '+' || value == '-' || value == '*' || value == '/') {// User pressed +, -, *, or / (an operator)
        if (isResultShown) {// If answer is already shown after '='
          firstNum = double.tryParse(result) ?? 0;
          input = '';
          result = '';
          operator = value;
          expression = '$firstNum $operator';
          isResultShown = false;
        } else if (input.isNotEmpty) {// User has entered some number
          if (operator.isNotEmpty) {
            secondNum = double.tryParse(input) ?? 0;
            firstNum = calculate(firstNum, secondNum, operator);
            input = '';
            result = '';
          } else {
            firstNum = double.tryParse(input) ?? 0;
            input = '';
          }
          operator = value;
          expression = '$firstNum $operator';
        }
      } else if (value == '=') {// User pressed '=' to get the answer
        if (operator.isNotEmpty && input.isNotEmpty) {// We have a number and an operator, so we can calculate the answer
          secondNum = double.tryParse(input) ?? 0;
          expression = '$firstNum $operator $secondNum';
          result = calculate(firstNum, secondNum, operator).toString();
          input = '';
          isResultShown = true;
        } else if (operator.isNotEmpty && isResultShown) {// We have a number and an operator, so we can calculate the answer
          double prevResult = double.tryParse(result) ?? 0;
          double newResult;

          if (operator == '+' || operator == '-') {// If the operation is + or - (add or subtract)
            expression = '$prevResult $operator $secondNum';
            newResult = calculate(prevResult, secondNum, operator);
          } else if (operator == '*') {// If the operation is * (multiply)
            expression = '$prevResult $operator $firstNum';
            newResult = calculate(prevResult, firstNum, operator);
          } else if (operator == '/') {// If the operation is / (divide)
            expression = '$prevResult $operator $secondNum';
            newResult = calculate(prevResult, secondNum, operator);
          } else {
            newResult = prevResult;// If no valid operator, just keep the old result
          }

          result = newResult.toString();// Change the answer into a string to display it

        }
      } else {
        if (isResultShown) return;
        input += value; // If result is showing, stop
                       // Otherwise, keep adding the number to input
     }
    });
  }

  double calculate(double a, double b, String op) {// This function does the math based on the operator (+, -, *, /)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Arithmetic Calculator')),
      backgroundColor: const Color.fromARGB(255, 241, 240, 240),
      body: Column(
        children: [
          SizedBox(height: 20),
          // Expression Box
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.centerRight,
            child: Text(
              isResultShown ? expression : input,
              style: TextStyle(color: const Color.fromARGB(255, 185, 121, 65), fontSize: 32),
            ),
          ),
          // Result Box
          if (isResultShown)
            Padding(
              padding: const EdgeInsets.only(top: 20.0, right: 20),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  result,
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Spacer(),
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

  Widget calcBtn(String text, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => onButtonClick(text),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }
}
