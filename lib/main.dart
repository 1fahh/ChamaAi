import 'package:flutter/material.dart';

import 'cores.dart';
import 'dialogo.dart';
import 'modelos.dart';
import 'tela_turma.dart';

void main() {
  runApp(MaterialApp(
    title: 'ChamaAí',
    debugShowCheckedModeBanner: false,
    theme: temaDoApp(),
    home: const TelaTurmas(),
  ));
}

// Primeira tela: a lista de turmas.
class TelaTurmas extends StatefulWidget {
  const TelaTurmas({super.key});

  @override
  State<TelaTurmas> createState() => _TelaTurmasState();
}

class _TelaTurmasState extends State<TelaTurmas> {
  List<Turma> turmas = [];

  @override
  void initState() {
    super.initState();
    // Uma turma de exemplo para o app não abrir vazio (pode apagar).
    Turma exemplo = Turma('Turma A');
    exemplo.alunos.add(Aluno('Ana'));
    exemplo.alunos.add(Aluno('Bruno'));
    exemplo.alunos.add(Aluno('Carla'));

    Chamada primeiraAula = Chamada('04/11/2026');
    primeiraAula.presentes.add(exemplo.alunos[0]); // Ana veio
    primeiraAula.presentes.add(exemplo.alunos[2]); // Carla veio
    exemplo.chamadas.add(primeiraAula);

    turmas.add(exemplo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ChamaAí')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: corDestaque,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nova turma'),
        onPressed: () {
          abrirDialogo(context, 'Nova turma', '', (nome) {
            setState(() {
              turmas.add(Turma(nome));
            });
          });
        },
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Faixa de boas-vindas
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [corPrincipal, Color(0xFF6366F1)],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                const Icon(Icons.school, color: Colors.white, size: 44),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Minhas turmas',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${turmas.length} turma(s) cadastrada(s)',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (turmas.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Nenhuma turma ainda. Toque em "Nova turma" para começar.',
                textAlign: TextAlign.center,
              ),
            ),

          // Um cartão para cada turma
          for (Turma turma in turmas)
            Card(
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                  backgroundColor: corDestaque,
                  foregroundColor: Colors.white,
                  child: Text(turma.nome[0].toUpperCase()),
                ),
                title: Text(
                  turma.nome,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('${turma.alunos.length} alunos · '
                    '${turma.chamadas.length} chamadas'),
                // Tocar na turma abre a tela dela.
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TelaTurma(turma: turma)),
                  );
                  setState(() {}); // atualiza ao voltar
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: corPrincipal),
                      onPressed: () {
                        abrirDialogo(context, 'Editar turma', turma.nome,
                            (nome) {
                          setState(() {
                            turma.nome = nome;
                          });
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: corFalta),
                      onPressed: () {
                        setState(() {
                          turmas.remove(turma);
                        });
                      },
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
