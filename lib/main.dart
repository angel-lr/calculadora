import 'package:flutter/material.dart';
import 'calculator_logic.dart';

void main() => runApp(const CalculadoraApp());

class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const CalculadoraScreen(),
    );
  }
}

class CalculadoraScreen extends StatefulWidget {
  const CalculadoraScreen({super.key});

  @override
  State<CalculadoraScreen> createState() => _CalculadoraScreenState();
}

class _CalculadoraScreenState extends State<CalculadoraScreen> {
  final CalculatorLogic logic = CalculatorLogic();
  final Color colorCafe = const Color(0xFF705C53);

  void onButtonPressed(String text) {
    setState(() {
      if (text == "=") {
        logic.calculate();
      } else if (text == "AC") {
        logic.clear();
      } else if (text == "⌫") {
        logic.deleteLast();
      } else {
        logic.addToExpression(text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            bool isLandscape = orientation == Orientation.landscape;
            return Column(
              children: [
                // Pantalla de resultados
                Expanded(
                  flex: isLandscape ? 2 : 3, // Proporción dinámica
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    alignment: Alignment.bottomRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(logic.result, 
                              style: TextStyle(fontSize: isLandscape ? 40 : 55, 
                              color: colorCafe, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Text(logic.expression, 
                          style: TextStyle(fontSize: isLandscape ? 18 : 24, color: Colors.black54)),
                      ],
                    ),
                  ),
                ),
                // Contenedor del Teclado
                Expanded(
                  flex: isLandscape ? 5 : 6,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: colorCafe,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    // Usamos Center para que el GridView no se pegue arriba
                    child: Center(
                      child: isLandscape ? _buildScientificLayout() : _buildPortraitLayout(),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPortraitLayout() {
    return GridView.count(
      shrinkWrap: true, // Permite que el Center funcione correctamente
      crossAxisCount: 5,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 0.85, // Botones más altos (verticales) para llenar el vacío
      physics: const NeverScrollableScrollPhysics(),
      children: [
        '7', '8', '9', '/', 'AC',
        '4', '5', '6', 'x', '⌫',
        '1', '2', '3', '+', '-',
        '(', '0', ')', '.', '=',
      ].map((text) => _calcButton(text)).toList(),
    );
  }

  Widget _buildScientificLayout() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 8,
      crossAxisSpacing: 6,
      mainAxisSpacing: 6,
      childAspectRatio: 2.3, // Botones muy bajos para evitar el overflow horizontal
      physics: const NeverScrollableScrollPhysics(),
      children: [
        'sin', 'cos', 'tan', '7', '8', '9', '/', 'AC',
        'log', 'ln', 'sqrt', '4', '5', '6', 'x', '⌫',
        'exp', '^', '!', '1', '2', '3', '+', '-',
        'pi', 'e', 'rad', '(', '0', ')', '.', '=',
      ].map((text) => _calcButton(text)).toList(),
    );
  }

  Widget _calcButton(String text) {
    bool isScientific = ['sin', 'cos', 'tan', 'log', 'ln', 'sqrt', 'exp', '^', '!', 'pi', 'e', 'rad'].contains(text);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 3,
      ),
      onPressed: isScientific ? null : () => onButtonPressed(text),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18, 
          color: isScientific ? Colors.grey : colorCafe,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}