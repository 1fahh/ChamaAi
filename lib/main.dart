import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'modelos.dart';
import 'telas/tela_turmas.dart';

void main() {
  runApp(ListaChamadaApp(turmas: dadosDeExemplo()));
}

class ListaChamadaApp extends StatelessWidget {
  final List<Turma> turmas;

  const ListaChamadaApp({super.key, required this.turmas});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChamaAí',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      // Deixa o calendário (showDatePicker) em português.
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: TelaTurmas(turmas: turmas),
    );
  }
}

/// Uma turma de exemplo para o app não abrir vazio (pode apagar).
List<Turma> dadosDeExemplo() {
  final turma = Turma('Desenvolvimento de Apps');
  for (final nome in ['Ana', 'Bruno', 'Carla', 'Diego', 'Eduarda']) {
    turma.adicionarAluno(nome);
  }
  final a = turma.alunos;

  // Duas aulas passadas já com presença marcada.
  final dia1 = turma.chamadaDoDia(DateTime(2026, 11, 4));
  dia1.presentes.addAll([a[0], a[1], a[2], a[3]]);
  final dia2 = turma.chamadaDoDia(DateTime(2026, 11, 6));
  dia2.presentes.addAll([a[0], a[2], a[4]]);

  return [turma];
}
