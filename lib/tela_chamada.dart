import 'package:flutter/material.dart';

import 'modelos.dart';

// Tela da chamada de um dia: marcar quem está presente.
class TelaChamada extends StatefulWidget {
  final Turma turma;
  final Chamada chamada;

  const TelaChamada({super.key, required this.turma, required this.chamada});

  @override
  State<TelaChamada> createState() => _TelaChamadaState();
}

class _TelaChamadaState extends State<TelaChamada> {
  @override
  Widget build(BuildContext context) {
    Turma turma = widget.turma;
    Chamada chamada = widget.chamada;
    double percentual = turma.percentualDaChamada(chamada);

    return Scaffold(
      appBar: AppBar(title: Text('Chamada ${chamada.data}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            '${chamada.presentes.length} de ${turma.alunos.length} presentes '
            '(${percentual.toStringAsFixed(0)}%)',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: percentual / 100),
          const SizedBox(height: 8),
          for (Aluno aluno in turma.alunos)
            CheckboxListTile(
              title: Text(aluno.nome),
              value: chamada.estaPresente(aluno),
              onChanged: (valor) {
                setState(() {
                  chamada.marcarOuDesmarcar(aluno);
                });
              },
            ),
        ],
      ),
    );
  }
}
