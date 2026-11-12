import 'package:flutter/material.dart';

import '../modelos.dart';
import 'dialogos.dart';
import 'tela_turma.dart';

/// Tela inicial: lista de turmas. Permite criar, editar e remover turmas.
class TelaTurmas extends StatefulWidget {
  final List<Turma> turmas;

  const TelaTurmas({super.key, required this.turmas});

  @override
  State<TelaTurmas> createState() => _TelaTurmasState();
}

class _TelaTurmasState extends State<TelaTurmas> {
  List<Turma> get turmas => widget.turmas;

  Future<void> criarTurma() async {
    final nome = await pedirTexto(context, titulo: 'Nova turma');
    if (nome == null) return;
    setState(() => turmas.add(Turma(nome)));
  }

  Future<void> editarTurma(Turma turma) async {
    final nome = await pedirTexto(context,
        titulo: 'Editar turma', textoInicial: turma.nome);
    if (nome == null) return;
    setState(() => turma.nome = nome);
  }

  Future<void> removerTurma(Turma turma) async {
    if (await confirmar(context, 'Remover a turma "${turma.nome}"?')) {
      setState(() => turmas.remove(turma));
    }
  }

  Future<void> abrirTurma(Turma turma) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TelaTurma(turma: turma)),
    );
    setState(() {}); // atualiza contadores ao voltar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas turmas')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: criarTurma,
        icon: const Icon(Icons.add),
        label: const Text('Nova turma'),
      ),
      body: turmas.isEmpty
          ? const Center(child: Text('Nenhuma turma. Toque em "Nova turma".'))
          : ListView.builder(
              itemCount: turmas.length,
              itemBuilder: (context, i) {
                final turma = turmas[i];
                return ListTile(
                  leading: const Icon(Icons.groups),
                  title: Text(turma.nome),
                  subtitle: Text('${turma.alunos.length} alunos · '
                      '${turma.chamadas.length} chamadas'),
                  onTap: () => abrirTurma(turma),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: 'Editar turma',
                        onPressed: () => editarTurma(turma),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        tooltip: 'Remover turma',
                        onPressed: () => removerTurma(turma),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
