import 'package:flutter/material.dart';

// =============================================================================
// AULA 1 — CONTADOR (revisão Flutter/Dart)
// =============================================================================
// Este arquivo contém a tela do contador que usamos na primeira aula.
// É aberta pelo menu principal (main.dart) quando o usuário toca em "Aula 1".
// Os comentários abaixo são os mesmos da versão didática do contador.
// =============================================================================

// Tela da Aula 1: StatefulWidget com estado (contador)
class Aula1ContadorPage extends StatefulWidget {
  const Aula1ContadorPage({super.key});

  @override
  State<Aula1ContadorPage> createState() => _Aula1ContadorPageState();
}

class _Aula1ContadorPageState extends State<Aula1ContadorPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  void _multiplyCounter() {
    setState(() {
      _counter *= 2;
    });
  }

  void _divideCounter() {
    setState(() {
      _counter ~/= 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Aula 1 — Contador'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text('Você pressionou o botão este número de vezes:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: _counter < 0 ? Colors.red : Colors.blue,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                onPressed: _incrementCounter,
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ),
              const SizedBox(height: 10),
              FloatingActionButton(
                onPressed: _decrementCounter,
                tooltip: 'Decrement',
                backgroundColor: Colors.red[100],
                child: const Icon(Icons.remove, color: Colors.red),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                onPressed: _multiplyCounter,
                tooltip: 'Multiply',
                backgroundColor: Colors.green[100],
                child: const Icon(
                  Icons.dynamic_feed_sharp,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              FloatingActionButton(
                onPressed: _divideCounter,
                tooltip: 'Divide',
                backgroundColor: Colors.yellow[100],
                child: const Icon(
                  Icons.do_disturb_off_outlined,
                  color: Colors.yellow,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
