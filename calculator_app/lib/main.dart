
// for iOS calculator app by Huayun Li
import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

// Calculator Brain (Logic)
class CalculatorBrain {
  String _displayValue = '0';
  double? _firstNumber;
  String? _operation;
  bool _shouldResetDisplay = true;
  bool _hasDecimalPoint = false;

  String processInput(String input) {
    switch (input) {
      case '0':
      case '1':
      case '2':
      case '3':
      case '4':
      case '5':
      case '6':
      case '7':
      case '8':
      case '9':
        return _handleNumber(input);
      case '.':
        return _handleDecimalPoint();
      case '+':
      case '-':
      case '×':
      case '÷':
        return _handleOperation(input);
      case '=':
        return _calculateResult();
      case 'AC':
        return _clear();
      case '±':
        return _toggleSign();
      case '%':
        return _calculatePercentage();
      default:
        return _displayValue;
    }
  }

  String _handleNumber(String number) {
    if (_shouldResetDisplay) {
      _displayValue = number;
      _shouldResetDisplay = false;
    } else {
      _displayValue = _displayValue == '0' ? number : _displayValue + number;
    }
    return _displayValue;
  }

  String _handleDecimalPoint() {
    if (_shouldResetDisplay) {
      _displayValue = '0.';
      _shouldResetDisplay = false;
    } else if (!_hasDecimalPoint) {
      _displayValue = _displayValue + '.';
    }
    _hasDecimalPoint = true;
    return _displayValue;
  }

  String _handleOperation(String operation) {
    _hasDecimalPoint = false;
    _firstNumber = double.parse(_displayValue);
    _operation = operation;
    _shouldResetDisplay = true;
    return _displayValue;
  }

  String _calculateResult() {
    if (_firstNumber == null || _operation == null) {
      return _displayValue;
    }

    final secondNumber = double.parse(_displayValue);
    double result;

    switch (_operation) {
      case '+':
        result = _firstNumber! + secondNumber;
        break;
      case '-':
        result = _firstNumber! - secondNumber;
        break;
      case '×':
        result = _firstNumber! * secondNumber;
        break;
      case '÷':
        if (secondNumber == 0) {
          return 'Error';
        }
        result = _firstNumber! / secondNumber;
        break;
      default:
        return _displayValue;
    }

    _displayValue = _formatResult(result);
    _firstNumber = null;
    _operation = null;
    _shouldResetDisplay = true;
    _hasDecimalPoint = _displayValue.contains('.');
    return _displayValue;
  }

  String _clear() {
    _displayValue = '0';
    _firstNumber = null;
    _operation = null;
    _shouldResetDisplay = true;
    _hasDecimalPoint = false;
    return _displayValue;
  }

  String _toggleSign() {
    if (_displayValue == '0') return _displayValue;
    if (_displayValue.startsWith('-')) {
      _displayValue = _displayValue.substring(1);
    } else {
      _displayValue = '-$_displayValue';
    }
    return _displayValue;
  }

  String _calculatePercentage() {
    final number = double.parse(_displayValue);
    _displayValue = _formatResult(number / 100);
    return _displayValue;
  }

  String _formatResult(double result) {
    if (result == result.roundToDouble()) {
      return result.toStringAsFixed(0);
    }
    return result.toStringAsFixed(8).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
  }
}

// Calculator Button Widget
class CalculatorButton extends StatelessWidget {
  final String text;
  final Function(String) onPressed;
  final Color? color;
  final int flex;

  const CalculatorButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color,
    this.flex = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Colors.blueGrey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () => onPressed(text),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// Calculator Screen
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _displayText = '0';
  final CalculatorBrain _brain = CalculatorBrain();

  void _updateDisplay(String value) {
    setState(() {
      _displayText = value;
    });
  }

  void _onButtonPressed(String buttonText) {
    final result = _brain.processInput(buttonText);
    _updateDisplay(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.bottomRight,
              child: Text(
                _displayText,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: GridView.custom(
              padding: const EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              childrenDelegate: SliverChildListDelegate([
                CalculatorButton(text: 'AC', onPressed: _onButtonPressed, color: Colors.grey),
                CalculatorButton(text: '±', onPressed: _onButtonPressed, color: Colors.grey),
                CalculatorButton(text: '%', onPressed: _onButtonPressed, color: Colors.grey),
                CalculatorButton(text: '÷', onPressed: _onButtonPressed, color: Colors.orange),
                CalculatorButton(text: '7', onPressed: _onButtonPressed),
                CalculatorButton(text: '8', onPressed: _onButtonPressed),
                CalculatorButton(text: '9', onPressed: _onButtonPressed),
                CalculatorButton(text: '×', onPressed: _onButtonPressed, color: Colors.orange),
                CalculatorButton(text: '4', onPressed: _onButtonPressed),
                CalculatorButton(text: '5', onPressed: _onButtonPressed),
                CalculatorButton(text: '6', onPressed: _onButtonPressed),
                CalculatorButton(text: '-', onPressed: _onButtonPressed, color: Colors.orange),
                CalculatorButton(text: '1', onPressed: _onButtonPressed),
                CalculatorButton(text: '2', onPressed: _onButtonPressed),
                CalculatorButton(text: '3', onPressed: _onButtonPressed),
                CalculatorButton(text: '+', onPressed: _onButtonPressed, color: Colors.orange),
                CalculatorButton(
                  text: '0',
                  onPressed: _onButtonPressed,
                  flex: 2,
                ),
                CalculatorButton(text: '.', onPressed: _onButtonPressed),
                CalculatorButton(text: '=', onPressed: _onButtonPressed, color: Colors.orange),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// Main App
class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const CalculatorScreen(),
    );
  }
}
