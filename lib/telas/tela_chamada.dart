import 'package:flutter/material.dart';

import '../modelos.dart';

/// Chamada de um dia: marcar quem está presente.
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
    final turma = widget.turma;
    final chamada = widget.chamada;
    final percentual = turma.percentualDaChamada(chamada);

    return Scaffold(
      appBar: AppBar(title: Text('Chamada ${formatarData(chamada.data)}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Resumo: "X de Y presentes" + percentual + barra
            Text(
              '${chamada.presentes.length} de ${turma.alunos.length} presentes '
              '(${percentual.toStringAsFixed(0)}%)',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: percentual / 100, minHeight: 10),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: turma.alunos.length,
                itemBuilder: (context, i) {
                  final aluno = turma.alunos[i];
                  final presente = chamada.estaPresente(aluno);
                  return CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(aluno.nome),
                    subtitle: Text(presente ? 'Presente' : 'Ausente'),
                    value: presente,
                    onChanged: (_) =>
                        setState(() => chamada.alternarPresenca(aluno)),
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
