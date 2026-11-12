import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chama_ai/main.dart';
import 'package:chama_ai/modelos.dart';

// Rodar com: flutter test
void main() {
  test('presença por dia e percentual do aluno', () {
    final turma = Turma('Teste');
    turma.adicionarAluno('Ana');
    turma.adicionarAluno('Bruno');
    final ana = turma.alunos[0];

    final dia1 = turma.chamadaDoDia(DateTime(2026, 11, 4));
    dia1.alternarPresenca(ana);
    turma.chamadaDoDia(DateTime(2026, 11, 6)); // Ana faltou

    expect(turma.presencasDe(ana), 1);
    expect(turma.percentualDe(ana), 50);
    expect(turma.percentualDaChamada(dia1), 50);

    // Pedir o mesmo dia de novo devolve a mesma chamada.
    expect(turma.chamadaDoDia(DateTime(2026, 11, 4)), same(dia1));
    expect(turma.chamadas.length, 2);
  });

  test('remover aluno tira ele das chamadas', () {
    final turma = Turma('Teste');
    turma.adicionarAluno('Ana');
    final ana = turma.alunos[0];
    turma.chamadaDoDia(DateTime(2026, 11, 4)).alternarPresenca(ana);

    turma.removerAluno(ana);
    expect(turma.alunos, isEmpty);
    expect(turma.chamadas[0].presentes, isEmpty);
  });

  testWidgets('criar turma', (tester) async {
    await tester.pumpWidget(ListaChamadaApp(turmas: []));

    await tester.tap(find.text('Nova turma'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Turma B');
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    expect(find.text('Turma B'), findsOneWidget);
  });

  testWidgets('fazer chamada de um dia existente', (tester) async {
    await tester.pumpWidget(ListaChamadaApp(turmas: dadosDeExemplo()));

    await tester.tap(find.text('Desenvolvimento de Apps'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Chamadas'));
    await tester.pumpAndSettle();
    expect(find.text('3 de 5 presentes (60%)'), findsOneWidget);

    // Abre a chamada de 06/11 e marca mais um aluno.
    await tester.tap(find.text('06/11/2026'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bruno'));
    await tester.pump();
    expect(find.text('4 de 5 presentes (80%)'), findsOneWidget);
  });

  testWidgets('botão Histórico abre o histórico do aluno', (tester) async {
    await tester.pumpWidget(ListaChamadaApp(turmas: dadosDeExemplo()));

    await tester.tap(find.text('Desenvolvimento de Apps'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Histórico').at(1)); // Bruno
    await tester.pumpAndSettle();

    expect(find.text('Histórico de Bruno'), findsOneWidget);
    expect(find.text('1 de 2 aulas (50%)'), findsOneWidget);
  });
}
