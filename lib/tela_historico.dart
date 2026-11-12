import 'package:flutter/material.dart';

import 'modelos.dart';

// Tela do histórico de um aluno: em quais dias veio ou faltou.
// Só mostra informação, então pode ser StatelessWidget.
class TelaHistorico extends StatelessWidget {
  final Turma turma;
  final Aluno aluno;

  const TelaHistorico({super.key, required this.turma, required this.aluno});

  @override
  Widget build(BuildContext context) {
    double percentual = turma.percentualDoAluno(aluno);

    return Scaffold(
      appBar: AppBar(title: Text('Histórico de ${aluno.nome}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Veio em ${turma.presencasDoAluno(aluno)} de '
            '${turma.chamadas.length} chamadas '
            '(${percentual.toStringAsFixed(0)}%)',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: percentual / 100),
          const SizedBox(height: 8),
          for (Chamada chamada in turma.chamadas)
            ListTile(
              title: Text(chamada.data),
              subtitle: Text(chamada.estaPresente(aluno) ? 'Presente' : 'Faltou'),
            ),
        ],
      ),
    );
  }
}
