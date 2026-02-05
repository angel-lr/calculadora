import 'package:math_expressions/math_expressions.dart';

class CalculatorLogic {
  String expression = "";
  String result = "0.0";

  void addToExpression(String value) {
    if (value == 'x') value = '*';
    expression += value;
  }

  void clear() {
    expression = "";
    result = "0.0";
  }

  void deleteLast() {
    if (expression.isNotEmpty) {
      expression = expression.substring(0, expression.length - 1);
    }
  }

  /// Evalúa la expresión usando el Parser recomendado por la librería
  void calculate() {
    try {
      // Cambio a GrammarParser para eliminar errores de 'deprecated'
      GrammarParser p = GrammarParser(); 
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      result = eval.toString();
      if (result.endsWith(".0")) {
        result = result.substring(0, result.length - 2);
      }
    } catch (e) {
      result = "Error";
    }
  }
}