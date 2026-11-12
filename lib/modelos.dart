// Classes do app: Aluno, Chamada (presença de um dia) e Turma.

/// Um aluno. O nome pode ser editado.
class Aluno {
  String nome;

  Aluno(this.nome);
}

/// A chamada de um dia: guarda a data e a lista de quem estava presente.
class Chamada {
  DateTime data;
  List<Aluno> presentes = [];

  Chamada(this.data);

  /// O aluno estava presente neste dia?
  bool estaPresente(Aluno aluno) => presentes.contains(aluno);

  /// Marca ou desmarca a presença do aluno.
  void alternarPresenca(Aluno aluno) {
    if (estaPresente(aluno)) {
      presentes.remove(aluno);
    } else {
      presentes.add(aluno);
    }
  }
}

/// Uma turma: tem nome, alunos e as chamadas de cada dia.
class Turma {
  String nome;
  List<Aluno> alunos = [];
  List<Chamada> chamadas = [];

  Turma(this.nome);

  /// Adiciona um aluno (ignora nome vazio).
  void adicionarAluno(String nome) {
    if (nome.trim().isEmpty) return;
    alunos.add(Aluno(nome.trim()));
  }

  /// Remove o aluno da turma e das chamadas.
  void removerAluno(Aluno aluno) {
    alunos.remove(aluno);
    for (final chamada in chamadas) {
      chamada.presentes.remove(aluno);
    }
  }

  /// Devolve a chamada do dia. Se ainda não existe, cria uma nova.
  Chamada chamadaDoDia(DateTime dia) {
    for (final chamada in chamadas) {
      if (mesmoDia(chamada.data, dia)) return chamada;
    }
    final nova = Chamada(dia);
    chamadas.add(nova);
    // Mantém as chamadas da mais recente para a mais antiga.
    chamadas.sort((a, b) => b.data.compareTo(a.data));
    return nova;
  }

  /// Quantas aulas o aluno teve presença.
  int presencasDe(Aluno aluno) =>
      chamadas.where((c) => c.estaPresente(aluno)).length;

  /// Percentual de presença do aluno em todas as chamadas (0 a 100).
  double percentualDe(Aluno aluno) =>
      chamadas.isEmpty ? 0 : presencasDe(aluno) / chamadas.length * 100;

  /// Percentual de presença da turma em uma chamada (0 a 100).
  double percentualDaChamada(Chamada chamada) =>
      alunos.isEmpty ? 0 : chamada.presentes.length / alunos.length * 100;
}

/// true se as duas datas são do mesmo dia (ignora a hora).
bool mesmoDia(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Formata a data como 11/11/2026.
String formatarData(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/'
    '${d.month.toString().padLeft(2, '0')}/${d.year}';
