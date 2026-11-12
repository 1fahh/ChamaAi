import 'package:flutter/material.dart';

import '../modelos.dart';
import 'dialogos.dart';
import 'tela_chamada.dart';
import 'tela_historico.dart';

/// Tela de uma turma, com duas abas:
/// - Alunos: adicionar, abrir o histórico (botão "Histórico") e,
///   pelo menu ⋮, editar o nome ou remover.
/// - Chamadas: fazer a chamada de um dia e ver as anteriores.
class TelaTurma extends StatefulWidget {
  final Turma turma;

  const TelaTurma({super.key, required this.turma});

  @override
  State<TelaTurma> createState() => _TelaTurmaState();
}

class _TelaTurmaState extends State<TelaTurma> {
  final campoNome = TextEditingController();

  Turma get turma => widget.turma;

  // ---------------- Turma ----------------

  Future<void> editarNomeTurma() async {
    final nome = await pedirTexto(context,
        titulo: 'Editar turma', textoInicial: turma.nome);
    if (nome == null) return;
    setState(() => turma.nome = nome);
  }

  // ---------------- Alunos ----------------

  void adicionarAluno() {
    setState(() {
      turma.adicionarAluno(campoNome.text);
      campoNome.clear();
    });
  }

  Future<void> editarAluno(Aluno aluno) async {
    final nome = await pedirTexto(context,
        titulo: 'Editar aluno', textoInicial: aluno.nome);
    if (nome == null) return;
    setState(() => aluno.nome = nome);
  }

  Future<void> removerAluno(Aluno aluno) async {
    if (await confirmar(context, 'Remover ${aluno.nome} da turma?')) {
      setState(() => turma.removerAluno(aluno));
    }
  }

  Future<void> abrirHistorico(Aluno aluno) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => TelaHistorico(turma: turma, aluno: aluno)),
    );
    setState(() {});
  }

  // ---------------- Chamadas ----------------

  /// Escolhe o dia no calendário e abre a chamada daquele dia.
  Future<void> novaChamada() async {
    final dia = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (dia == null) return;
    abrirChamada(turma.chamadaDoDia(dia));
  }

  Future<void> abrirChamada(Chamada chamada) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => TelaChamada(turma: turma, chamada: chamada)),
    );
    setState(() {});
  }

  Future<void> removerChamada(Chamada chamada) async {
    if (await confirmar(
        context, 'Remover a chamada de ${formatarData(chamada.data)}?')) {
      setState(() => turma.chamadas.remove(chamada));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(turma.nome),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Editar nome da turma',
              onPressed: editarNomeTurma,
            ),
          ],
          bottom: const TabBar(
            tabs: [Tab(text: 'Alunos'), Tab(text: 'Chamadas')],
          ),
        ),
        body: TabBarView(
          children: [abaAlunos(), abaChamadas()],
        ),
      ),
    );
  }

  Widget abaAlunos() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: campoNome,
                  decoration:
                      const InputDecoration(labelText: 'Nome do aluno'),
                  onSubmitted: (_) => adicionarAluno(),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: adicionarAluno,
                child: const Text('Adicionar'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: turma.alunos.length,
            itemBuilder: (context, i) {
              final aluno = turma.alunos[i];
              return ListTile(
                leading: CircleAvatar(child: Text(aluno.nome[0])),
                title: Text(aluno.nome),
                subtitle: Text('Presença: '
                    '${turma.percentualDe(aluno).toStringAsFixed(0)}%'),
                onTap: () => abrirHistorico(aluno),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Botão bem visível para abrir o histórico de presença
                    OutlinedButton.icon(
                      onPressed: () => abrirHistorico(aluno),
                      icon: const Icon(Icons.history),
                      label: const Text('Histórico'),
                    ),
                    // Menu "⋮" com as opções de editar e remover
                    PopupMenuButton<String>(
                      onSelected: (opcao) {
                        if (opcao == 'editar') editarAluno(aluno);
                        if (opcao == 'remover') removerAluno(aluno);
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                            value: 'editar', child: Text('Editar nome')),
                        PopupMenuItem(value: 'remover', child: Text('Remover')),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget abaChamadas() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: novaChamada,
            icon: const Icon(Icons.calendar_today),
            label: const Text('Fazer chamada'),
          ),
        ),
        Expanded(
          child: turma.chamadas.isEmpty
              ? const Center(child: Text('Nenhuma chamada feita ainda.'))
              : ListView.builder(
                  itemCount: turma.chamadas.length,
                  itemBuilder: (context, i) {
                    final chamada = turma.chamadas[i];
                    return ListTile(
                      leading: const Icon(Icons.event),
                      title: Text(formatarData(chamada.data)),
                      subtitle: Text('${chamada.presentes.length} de '
                          '${turma.alunos.length} presentes '
                          '(${turma.percentualDaChamada(chamada).toStringAsFixed(0)}%)'),
                      onTap: () => abrirChamada(chamada),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        tooltip: 'Remover chamada',
                        onPressed: () => removerChamada(chamada),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
