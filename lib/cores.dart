import 'package:flutter/material.dart';

// Cores do app em um lugar só.
const Color corPrincipal = Color(0xFF3730A3); // índigo
const Color corDestaque = Color(0xFFFF7A59); // coral
const Color corFundo = Color(0xFFF3F4FA); // cinza bem claro
const Color corPresente = Color(0xFF16A34A); // verde
const Color corFalta = Color(0xFFDC2626); // vermelho
const Color corAtencao = Color(0xFFF59E0B); // amarelo

// Cor do percentual de presença:
// verde a partir de 75%, amarelo a partir de 50% e vermelho abaixo disso.
Color corDoPercentual(double percentual) {
  if (percentual >= 75) {
    return corPresente;
  } else if (percentual >= 50) {
    return corAtencao;
  } else {
    return corFalta;
  }
}

// Título de uma seção: ícone colorido + texto.
Widget tituloDaSecao(IconData icone, String texto) {
  return Row(
    children: [
      CircleAvatar(
        radius: 18,
        backgroundColor: corPrincipal.withValues(alpha: 0.12),
        child: Icon(icone, color: corPrincipal, size: 20),
      ),
      const SizedBox(width: 12),
      Text(
        texto,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ],
  );
}

// Tema do app: cores, cartões arredondados e botões.
ThemeData temaDoApp() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: corPrincipal,
      primary: corPrincipal,
      secondary: corDestaque,
    ),
    scaffoldBackgroundColor: corFundo,
    appBarTheme: const AppBarTheme(
      backgroundColor: corPrincipal,
      foregroundColor: Colors.white,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: corPrincipal,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: corFundo,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
