import 'package:flutter/material.dart';

import 'dialogo.dart';
import 'modelos.dart';
import 'tela_chamada.dart';
import 'tela_historico.dart';

// Tela de uma turma: lista de alunos e lista de chamadas.
class TelaTurma extends StatefulWidget {
  final Turma turma;

  const TelaTurma({super.key, required this.turma});

  @override
  State<TelaTurma> createState() => _TelaTurmaState();
}

class _TelaTurmaState extends State<TelaTurma> {
  TextEditingController campoNome = TextEditingController();

  void abrirTela(Widget tela) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => tela),
    );
    setState(() {}); // atualiza ao voltar
  }

  @override
  Widget build(BuildContext context) {
    Turma turma = widget.turma;

    // Data de hoje no formato 11/11/2026
    DateTime hoje = DateTime.now();
    String dataDeHoje = '${hoje.day}/${hoje.month}/${hoje.year}';

    return Scaffold(
      appBar: AppBar(title: Text(turma.nome)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ---------- ALUNOS ----------
          const Text('Alunos', style: TextStyle(fontSize: 22)),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: campoNome,
                  decoration: const InputDecoration(labelText: 'Nome do aluno'),
                ),
              ),
              ElevatedButton(
                child: const Text('Adicionar'),
                onPressed: () {
                  if (campoNome.text.isNotEmpty) {
                    setState(() {
                      turma.alunos.add(Aluno(campoNome.text));
                      campoNome.clear();
                    });
                  }
                },
              ),
            ],
          ),
          for (Aluno aluno in turma.alunos)
            ListTile(
              title: Text(aluno.nome),
              subtitle: Text(
                  'Presença: ${turma.percentualDoAluno(aluno).toStringAsFixed(0)}%'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    child: const Text('Histórico'),
                    onPressed: () {
                      abrirTela(TelaHistorico(turma: turma, aluno: aluno));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      abrirDialogo(context, 'Editar aluno', aluno.nome, (nome) {
                        setState(() {
                          aluno.nome = nome;
                        });
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        turma.removerAluno(aluno);
                      });
                    },
                  ),
                ],
              ),
            ),

          const SizedBox(height: 24),

          // ---------- CHAMADAS ----------
          const Text('Chamadas', style: TextStyle(fontSize: 22)),
          ElevatedButton(
            child: const Text('Nova chamada'),
            onPressed: () {
              abrirDialogo(context, 'Data da chamada', dataDeHoje, (data) {
                Chamada nova = Chamada(data);
                setState(() {
                  turma.chamadas.add(nova);
                });
                abrirTela(TelaChamada(turma: turma, chamada: nova));
              });
            },
          ),
          for (Chamada chamada in turma.chamadas)
            ListTile(
              title: Text(chamada.data),
              subtitle: Text('${chamada.presentes.length} de '
                  '${turma.alunos.length} presentes'),
              onTap: () {
                abrirTela(TelaChamada(turma: turma, chamada: chamada));
              },
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    turma.chamadas.remove(chamada);
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}
