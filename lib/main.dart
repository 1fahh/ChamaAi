import 'package:flutter/material.dart';

import 'dialogo.dart';
import 'modelos.dart';
import 'tela_turma.dart';

void main() {
  runApp(const MaterialApp(
    title: 'ChamaAí',
    debugShowCheckedModeBanner: false,
    home: TelaTurmas(),
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
      appBar: AppBar(title: const Text('ChamaAí - Turmas')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          abrirDialogo(context, 'Nova turma', '', (nome) {
            setState(() {
              turmas.add(Turma(nome));
            });
          });
        },
      ),
      body: ListView.builder(
        itemCount: turmas.length,
        itemBuilder: (context, i) {
          Turma turma = turmas[i];
          return ListTile(
            title: Text(turma.nome),
            subtitle: Text('${turma.alunos.length} alunos'),
            // Tocar na turma abre a tela dela.
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaTurma(turma: turma)),
              );
              setState(() {}); // atualiza ao voltar
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    abrirDialogo(context, 'Editar turma', turma.nome, (nome) {
                      setState(() {
                        turma.nome = nome;
                      });
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      turmas.remove(turma);
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
