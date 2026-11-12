import 'package:flutter/material.dart';

/// Abre uma caixa com um campo de texto e devolve o que foi digitado.
/// Devolve null se a pessoa cancelar ou deixar vazio.
/// Usada para criar/editar turma e para editar nome de aluno.
Future<String?> pedirTexto(
  BuildContext context, {
  required String titulo,
  String textoInicial = '',
}) async {
  final campo = TextEditingController(text: textoInicial);
  final texto = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(titulo),
      content: TextField(
        controller: campo,
        autofocus: true,
        decoration: const InputDecoration(labelText: 'Nome'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, campo.text),
          child: const Text('Salvar'),
        ),
      ],
    ),
  );
  if (texto == null || texto.trim().isEmpty) return null;
  return texto.trim();
}

/// Pergunta "tem certeza?" e devolve true se a pessoa confirmar.
Future<bool> confirmar(BuildContext context, String mensagem) async {
  final resposta = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      content: Text(mensagem),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Remover'),
        ),
      ],
    ),
  );
  return resposta ?? false;
}
