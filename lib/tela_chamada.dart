import 'package:flutter/material.dart';

import 'modelos.dart';

// Tela da chamada de um dia: marcar quem está presente.
// As marcações só são salvas quando a pessoa clica em "Finalizar".
class TelaChamada extends StatefulWidget {
  final Turma turma;
  final Chamada chamada;

  const TelaChamada({super.key, required this.turma, required this.chamada});

  @override
  State<TelaChamada> createState() => _TelaChamadaState();
}

class _TelaChamadaState extends State<TelaChamada> {
  // Rascunho: uma cópia da chamada para marcar sem salvar ainda.
  late Chamada rascunho;

  @override
  void initState() {
    super.initState();
    rascunho = Chamada(widget.chamada.data);
    rascunho.presentes.addAll(widget.chamada.presentes);
  }

  // Salva as marcações na chamada de verdade e volta para a turma.
  void finalizar() {
    Turma turma = widget.turma;
    Chamada chamada = widget.chamada;
    chamada.presentes = rascunho.presentes;
    if (!turma.chamadas.contains(chamada)) {
      turma.chamadas.add(chamada);
    }
    Navigator.pop(context);
  }

  // Seta de voltar: pergunta antes de sair sem salvar.
  void perguntarSeQuerSair() {
    showDialog(
      context: context,
      builder: (contextoDialogo) {
        return AlertDialog(
          title: const Text('Cancelar a chamada?'),
          content:
              const Text('Se você voltar agora, a chamada não será salva.'),
          actions: [
            TextButton(
              child: const Text('Continuar chamada'),
              onPressed: () {
                Navigator.pop(contextoDialogo); // fecha só o aviso
              },
            ),
            ElevatedButton(
              child: const Text('Sair sem salvar'),
              onPressed: () {
                Navigator.pop(contextoDialogo); // fecha o aviso
                Navigator.pop(context); // volta para a turma
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Turma turma = widget.turma;
    double percentual = turma.percentualDaChamada(rascunho);

    // PopScope segura a seta de voltar para mostrar o aviso.
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (saiu, resultado) {
        if (!saiu) {
          perguntarSeQuerSair();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Chamada ${rascunho.data}')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              '${rascunho.presentes.length} de ${turma.alunos.length} presentes '
              '(${percentual.toStringAsFixed(0)}%)',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: percentual / 100),
            const SizedBox(height: 8),
            for (Aluno aluno in turma.alunos)
              CheckboxListTile(
                title: Text(aluno.nome),
                value: rascunho.estaPresente(aluno),
                onChanged: (valor) {
                  setState(() {
                    rascunho.marcarOuDesmarcar(aluno);
                  });
                },
              ),
            const SizedBox(height: 16),
            // Salva a chamada e volta para a tela da turma.
            ElevatedButton(
              onPressed: finalizar,
              child: const Text('Finalizar'),
            ),
          ],
        ),
      ),
    );
  }
}
