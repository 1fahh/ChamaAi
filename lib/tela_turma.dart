import 'package:flutter/material.dart';

import 'cores.dart';
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

  // Uma linha da lista de alunos: inicial, nome, presença e botões.
  Widget linhaDoAluno(Turma turma, Aluno aluno) {
    double percentual = turma.percentualDoAluno(aluno);
    Color cor = corDoPercentual(percentual);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: corPrincipal.withValues(alpha: 0.12),
        foregroundColor: corPrincipal,
        child: Text(aluno.nome[0].toUpperCase()),
      ),
      title: Text(aluno.nome),
      subtitle: Text(
        '${percentual.toStringAsFixed(0)}% presença',
        style: TextStyle(color: cor, fontWeight: FontWeight.bold, fontSize: 13),
      ),
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
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.edit, color: corPrincipal),
            onPressed: () {
              abrirDialogo(context, 'Editar aluno', aluno.nome, (nome) {
                setState(() {
                  aluno.nome = nome;
                });
              });
            },
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.delete_outline, color: corFalta),
            onPressed: () {
              setState(() {
                turma.removerAluno(aluno);
              });
            },
          ),
        ],
      ),
    );
  }

  // Uma linha da lista de chamadas: data e quantos vieram.
  Widget linhaDaChamada(Turma turma, Chamada chamada) {
    double percentual = turma.percentualDaChamada(chamada);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: corDestaque.withValues(alpha: 0.15),
        foregroundColor: corDestaque,
        child: const Icon(Icons.calendar_today, size: 20),
      ),
      title: Text(chamada.data),
      subtitle: Text(
        '${chamada.presentes.length} de ${turma.alunos.length} presentes',
        style: TextStyle(
          color: corDoPercentual(percentual),
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        abrirTela(TelaChamada(turma: turma, chamada: chamada));
      },
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, color: corFalta),
        onPressed: () {
          setState(() {
            turma.chamadas.remove(chamada);
          });
        },
      ),
    );
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
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  tituloDaSecao(
                      Icons.people, 'Alunos (${turma.alunos.length})'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: campoNome,
                          decoration:
                              const InputDecoration(hintText: 'Nome do aluno'),
                        ),
                      ),
                      const SizedBox(width: 8),
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
                  const SizedBox(height: 8),
                  for (Aluno aluno in turma.alunos) linhaDoAluno(turma, aluno),
                ],
              ),
            ),
          ),

          // ---------- CHAMADAS ----------
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  tituloDaSecao(
                      Icons.event_note, 'Chamadas (${turma.chamadas.length})'),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: corDestaque,
                      ),
                      icon: const Icon(Icons.add_task),
                      label: const Text('Nova chamada'),
                      onPressed: () {
                        abrirDialogo(context, 'Data da chamada', dataDeHoje,
                            (texto) {
                          String data = texto.trim();
                          Chamada? existente = turma.chamadaDoDia(data);

                          // Já tem chamada nesse dia: avisa e abre a que já existe.
                          if (existente != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Já existe uma chamada em $data')),
                            );
                            abrirTela(
                                TelaChamada(turma: turma, chamada: existente));
                            return;
                          }

                          // A chamada nova só entra na lista quando clicar em Finalizar.
                          Chamada nova = Chamada(data);
                          abrirTela(TelaChamada(turma: turma, chamada: nova));
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (Chamada chamada in turma.chamadas)
                    linhaDaChamada(turma, chamada),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
