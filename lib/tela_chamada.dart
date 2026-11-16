import 'package:flutter/material.dart';

import 'cores.dart';
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
              style: ElevatedButton.styleFrom(backgroundColor: corFalta),
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
            // Resumo: quantos vieram, em destaque
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [corPrincipal, Color(0xFF6366F1)],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${rascunho.presentes.length} de ${turma.alunos.length} presentes '
                    '(${percentual.toStringAsFixed(0)}%)',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: percentual / 100,
                      minHeight: 10,
                      color: corDestaque,
                      backgroundColor: Colors.white24,
                    ),
                  ),
                ],
              ),
            ),

            // Lista de alunos: verde quando está presente
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    for (Aluno aluno in turma.alunos)
                      CheckboxListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        tileColor: rascunho.estaPresente(aluno)
                            ? corPresente.withValues(alpha: 0.10)
                            : null,
                        activeColor: corPresente,
                        title: Text(aluno.nome),
                        subtitle: Text(
                          rascunho.estaPresente(aluno) ? 'Presente' : 'Ausente',
                          style: TextStyle(
                            color: rascunho.estaPresente(aluno)
                                ? corPresente
                                : Colors.grey,
                          ),
                        ),
                        value: rascunho.estaPresente(aluno),
                        onChanged: (valor) {
                          setState(() {
                            rascunho.marcarOuDesmarcar(aluno);
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),

            // Salva a chamada e volta para a tela da turma.
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: corPresente),
              icon: const Icon(Icons.check_circle),
              label: const Text('Finalizar'),
              onPressed: finalizar,
            ),
          ],
        ),
      ),
    );
  }
}
