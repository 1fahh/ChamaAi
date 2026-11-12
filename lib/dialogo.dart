import 'package:flutter/material.dart';

// Abre uma caixa com um campo de texto e um botão Salvar.
// Quando a pessoa clica em Salvar, chama a função "aoSalvar" com o texto.
// Usada para: nova turma, editar turma, editar aluno e data da chamada.
void abrirDialogo(
  BuildContext context,
  String titulo,
  String textoInicial,
  Function(String) aoSalvar,
) {
  TextEditingController campo = TextEditingController(text: textoInicial);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(titulo),
        content: TextField(controller: campo, autofocus: true),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // fecha a caixa
              if (campo.text.isNotEmpty) {
                aoSalvar(campo.text);
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      );
    },
  );
}
