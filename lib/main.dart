import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import 'aula1.dart';
import 'aula_acessibilidade.dart';

// =============================================================================
// PONTO DE ENTRADA — todo app Flutter começa no main()
// =============================================================================
void main() {
  runApp(const MyApp());
  // No Flutter Web a acessibilidade é opt-in. Isso ativa a árvore de semântica
  // no DOM para leitores de tela e DevTools (Chrome → Elements → Accessibility).
  if (kIsWeb) {
    SemanticsBinding.instance.ensureSemantics();
  }
}

// =============================================================================
// MyApp: widget raiz. Guarda o estado do "Raio-X" de acessibilidade
// (showSemanticsDebugger) pra vocês poderem ligar/desligar na aula e ver
// as caixas e textos que o leitor de tela "enxerga".
// =============================================================================
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _mostrarRaioX = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.blue)),
      // showSemanticsDebugger desenha na tela as regiões semânticas e o texto
      // que o TalkBack/VoiceOver falaria. Ótimo pra aula mesmo no Web.
      showSemanticsDebugger: _mostrarRaioX,
      home: MenuAulasPage(
        mostrarRaioX: _mostrarRaioX,
        aoAlternarRaioX: (valor) => setState(() => _mostrarRaioX = valor),
      ),
    );
  }
}

// =============================================================================
// MENU DE AULAS — tela inicial. Cada item abre uma aula (outra tela).
// =============================================================================
// Quando vocês chamam Navigator.push(), o Flutter empilha a nova tela em cima.
// O AppBar da tela que abriu já vem com o botão "voltar" — ao tocar, ele
// dá pop() e volta pro menu. Vocês vão usar bastante isso nos projetos.
// =============================================================================
class MenuAulasPage extends StatelessWidget {
  const MenuAulasPage({
    super.key,
    required this.mostrarRaioX,
    required this.aoAlternarRaioX,
  });

  final bool mostrarRaioX;
  final ValueChanged<bool> aoAlternarRaioX;

  void _abrirAula(BuildContext context, Widget tela, String titulo) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => tela,
        settings: RouteSettings(name: titulo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu de Aulas'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Controle do Raio-X no AppBar: sempre visível e não some com o debug.
          IconButton(
            icon: Icon(
              mostrarRaioX ? Icons.accessibility : Icons.accessibility_new,
            ),
            tooltip: mostrarRaioX ? 'Desligar Raio-X' : 'Ligar Raio-X',
            onPressed: () => aoAlternarRaioX(!mostrarRaioX),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Aula 1 — Contador (revisão)
          ListTile(
            title: const Text('Aula 1 — Contador'),
            subtitle: const Text('Revisão Flutter: StatefulWidget, setState, layout'),
            leading: const CircleAvatar(child: Icon(Icons.add_circle_outline)),
            onTap: () => _abrirAula(context, const Aula1ContadorPage(), 'Aula 1'),
          ),
          const Divider(),
          // Aula — Acessibilidade
          ListTile(
            title: const Text('Aula — Acessibilidade'),
            subtitle: const Text('Contraste 4,5:1, Semantics, Raio-X'),
            leading: const CircleAvatar(child: Icon(Icons.accessibility_new)),
            onTap: () => _abrirAula(
              context,
              AulaAcessibilidadePage(
                mostrarRaioX: mostrarRaioX,
                aoAlternarRaioX: aoAlternarRaioX,
              ),
              'Acessibilidade',
            ),
          ),
        ],
      ),
    );
  }
}
