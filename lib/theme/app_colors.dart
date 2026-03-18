import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Constructor privado — no se puede instanciar

  // ── Opción 1: Paleta verde-teal (ACTIVA) ───────────────────────

  /// Fondo general de pantallas
  static const background = Color(0xFFF2F4F3);

  /// Color primario (botones principales, íconos de inputs) — Verde teal
  static const primary = Color(0xFF1B4F4A);

  /// Texto principal (títulos, labels)
  static const textPrimary = Color(0xFF1A1A1A);

  /// Texto secundario (subtítulos, placeholders, texto legal)
  static const textSecondary = Color(0xFF9A9E9D);

  /// Fondo de inputs y botones secundarios
  static const inputFill = Color(0xFFE8ECEA);

  /// Placeholder de texto en inputs
  static const placeholder = Color(0xFFADADAD);

  /// Color de divisores
  static const divider = Color(0xFFD0D5D3);

  // ── Colores módulo procesos ───────────────────────────

  /// Texto/íconos sobre fondo primario
  static const onPrimary = Colors.white;

  /// Color para procesos de materia y acción editar
  static const processSubject = Color(0xFFFF9800);

  /// Estado activo
  static const processActive = Color(0xFF4CAF50);

  /// Estado inactivo y acción eliminar
  static const processDanger = Color(0xFFD32F2F);

  // ── Opción 2: Paleta azul profundo ───────────────────────────
  // static const background    = Color(0xFFF8F9FA);   // Blanco suave
  // static const primary       = Color(0xFF1A73E8);   // Azul profundo
  // static const textPrimary   = Color(0xFF1C1E21);   // Negro suave
  // static const textSecondary = Color(0xFF8A8D91);   // Gris medio
  // static const inputFill     = Color(0xFFEAECEF);   // Gris muy claro
  // static const placeholder   = Color(0xFFADADAD);   // Placeholder
  // static const divider       = Color(0xFFD0D5D3);   // Divisores
}
