import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chama_ai/main.dart';
import 'package:chama_ai/modelos.dart';

// Rodar com: flutter test
void main() {
  test('percentual de presença do aluno', () {
    Turma turma = Turma('Teste');
    Aluno ana = Aluno('Ana');
    turma.alunos.add(ana);

    Chamada dia1 = Chamada('04/11');
    dia1.marcarOuDesmarcar(ana); // veio
    Chamada dia2 = Chamada('06/11'); // faltou
    turma.chamadas.add(dia1);
    turma.chamadas.add(dia2);

    expect(turma.presencasDoAluno(ana), 1);
    expect(turma.percentualDoAluno(ana), 50);
    expect(turma.percentualDaChamada(dia1), 100);
  });

  testWidgets('fazer uma chamada', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: TelaTurmas()));

    // Abre a turma de exemplo
    await tester.tap(find.text('Turma A'));
    await tester.pumpAndSettle();

    // Nova chamada -> Salvar (com a data de hoje)
    await tester.tap(find.text('Nova chamada'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    expect(find.text('0 de 3 presentes (0%)'), findsOneWidget);
    await tester.tap(find.text('Ana'));
    await tester.pump();
    expect(find.text('1 de 3 presentes (33%)'), findsOneWidget);
  });
}
