import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  TextEditingController expressionController = TextEditingController();
  String result = '';

  void onButtonClick(String value) {
    setState(() {
      if (value == 'AC') {
        expressionController.text = '';
        result = '';
      } else if (value == '=') {
        try {
          Parser p = Parser();
          Expression exp = p.parse(expressionController.text);
          double eval = exp.evaluate(EvaluationType.REAL, ContextModel());
          result = eval.toString();
        } catch (e) {
          result = 'Error';
        }
      } else {
        expressionController.text += value;
        expressionController.selection = TextSelection.fromPosition(
          TextPosition(offset: expressionController.text.length),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Arithmetic Calculator')),
      backgroundColor: const Color.fromARGB(255, 241, 240, 240),
      body: Column(
        children: [
          SizedBox(height: 20),
          // Editable expression input
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
            child: TextField(
              controller: expressionController,
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: const Color.fromARGB(255, 185, 121, 65), fontSize: 32),
              decoration: InputDecoration(border: InputBorder.none),
            ),
          ),
          if (result.isNotEmpty)
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
