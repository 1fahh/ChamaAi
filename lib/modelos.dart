// Classes do app: Aluno, Chamada e Turma.

class Aluno {
  String nome;

  Aluno(this.nome);
}

// A chamada de um dia: a data e a lista de quem veio.
class Chamada {
  String data;
  List<Aluno> presentes = [];

  Chamada(this.data);

  bool estaPresente(Aluno aluno) {
    return presentes.contains(aluno);
  }

  // Se está presente, tira. Se não está, coloca.
  void marcarOuDesmarcar(Aluno aluno) {
    if (estaPresente(aluno)) {
      presentes.remove(aluno);
    } else {
      presentes.add(aluno);
    }
  }
}

class Turma {
  String nome;
  List<Aluno> alunos = [];
  List<Chamada> chamadas = [];

  Turma(this.nome);

  // Quantas chamadas o aluno estava presente.
  int presencasDoAluno(Aluno aluno) {
    int total = 0;
    for (Chamada chamada in chamadas) {
      if (chamada.estaPresente(aluno)) {
        total++;
      }
    }
    return total;
  }

  // Percentual de presença do aluno (de 0 a 100).
  double percentualDoAluno(Aluno aluno) {
    if (chamadas.isEmpty) {
      return 0;
    }
    return presencasDoAluno(aluno) / chamadas.length * 100;
  }

  // Percentual de presentes em uma chamada (de 0 a 100).
  double percentualDaChamada(Chamada chamada) {
    if (alunos.isEmpty) {
      return 0;
    }
    return chamada.presentes.length / alunos.length * 100;
  }

  // Quando um aluno sai da turma, sai também das chamadas.
  void removerAluno(Aluno aluno) {
    alunos.remove(aluno);
    for (Chamada chamada in chamadas) {
      chamada.presentes.remove(aluno);
    }
  }
}
