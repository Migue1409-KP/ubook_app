# Theme — Paleta de colores (`AppColors`)

Archivo: `lib/theme/app_colors.dart`

Contiene todos los colores globales de la aplicación UBook, centralizados en la clase `AppColors`.

## Uso

```dart
import 'package:ubook_app/theme/app_colors.dart';

Container(color: AppColors.primary);
```

> **Nota:** El archivo debe estar dentro de `lib/` (no en `assets/`) para que Dart pueda importarlo correctamente.

---

## Opciones de paleta

El archivo incluye dos paletas. Solo una puede estar activa a la vez; la otra debe permanecer comentada.

### Opción 1 — Verde teal *(activa por defecto)*

| Token            | Hex       | Muestra | Descripción                                      |
|------------------|-----------|---------|--------------------------------------------------|
| `background`     | `#F2F4F3` | 🟩      | Fondo general de pantallas                       |
| `primary`        | `#1B4F4A` | 🟩      | Botones principales, íconos de inputs            |
| `textPrimary`    | `#1A1A1A` | ⬛      | Títulos, labels                                  |
| `textSecondary`  | `#9A9E9D` | 🩶      | Subtítulos, placeholders, texto legal            |
| `inputFill`      | `#E8ECEA` | 🟩      | Fondo de inputs y botones secundarios            |
| `placeholder`    | `#ADADAD` | 🩶      | Texto placeholder en inputs                      |
| `divider`        | `#D0D5D3` | 🩶      | Líneas divisoras                                 |

### Opción 2 — Azul profundo

| Token            | Hex       | Muestra | Descripción                                      |
|------------------|-----------|---------|--------------------------------------------------|
| `background`     | `#F8F9FA` | ⬜      | Blanco suave — Fondo general de pantallas        |
| `primary`        | `#1A73E8` | 🟦      | Azul profundo — Botones principales, íconos      |
| `textPrimary`    | `#1C1E21` | ⬛      | Negro suave — Títulos, labels                    |
| `textSecondary`  | `#8A8D91` | 🩶      | Gris medio — Subtítulos, texto legal             |
| `inputFill`      | `#EAECEF` | ⬜      | Gris muy claro — Fondo de inputs                 |
| `placeholder`    | `#ADADAD` | 🩶      | Texto placeholder en inputs                      |
| `divider`        | `#D0D5D3` | 🩶      | Líneas divisoras                                 |

---

## Cómo cambiar de paleta

1. Abrir `lib/theme/app_colors.dart`.
2. Comentar todos los `static const` de la opción activa.
3. Descomentar los `static const` de la opción deseada.
