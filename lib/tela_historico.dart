import 'package:flutter/material.dart';

import 'cores.dart';
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
          // Resumo com a cor do percentual
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: corDoPercentual(percentual),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${percentual.toStringAsFixed(0)}% de presença',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Veio em ${turma.presencasDoAluno(aluno)} de '
                  '${turma.chamadas.length} chamadas',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: percentual / 100,
                    minHeight: 10,
                    color: Colors.white,
                    backgroundColor: Colors.white24,
                  ),
                ),
              ],
            ),
          ),

          // Um cartão com cada dia: verde se veio, vermelho se faltou
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  tituloDaSecao(Icons.history, 'Dias de aula'),
                  const SizedBox(height: 8),
                  for (Chamada chamada in turma.chamadas)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        chamada.estaPresente(aluno)
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: chamada.estaPresente(aluno)
                            ? corPresente
                            : corFalta,
                        size: 32,
                      ),
                      title: Text(chamada.data),
                      subtitle: Text(
                        chamada.estaPresente(aluno) ? 'Presente' : 'Faltou',
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
