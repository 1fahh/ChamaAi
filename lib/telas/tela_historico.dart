import 'package:flutter/material.dart';

import '../modelos.dart';

/// Histórico de um aluno: percentual geral e presença em cada dia.
/// Só mostra dados, então é um StatelessWidget.
class TelaHistorico extends StatelessWidget {
  final Turma turma;
  final Aluno aluno;

  const TelaHistorico({super.key, required this.turma, required this.aluno});

  @override
  Widget build(BuildContext context) {
    final percentual = turma.percentualDe(aluno);

    return Scaffold(
      appBar: AppBar(title: Text('Histórico de ${aluno.nome}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '${turma.presencasDe(aluno)} de ${turma.chamadas.length} aulas '
              '(${percentual.toStringAsFixed(0)}%)',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: percentual / 100, minHeight: 10),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: turma.chamadas.length,
                itemBuilder: (context, i) {
                  final chamada = turma.chamadas[i];
                  final presente = chamada.estaPresente(aluno);
                  return ListTile(
                    leading: Icon(
                      presente ? Icons.check_circle : Icons.cancel,
                      color: presente ? Colors.green : Colors.red,
                    ),
                    title: Text(formatarData(chamada.data)),
                    subtitle: Text(presente ? 'Presente' : 'Faltou'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
