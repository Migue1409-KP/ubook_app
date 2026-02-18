# ViewModel

Esta carpeta contiene los **ViewModels** de la aplicación siguiendo la arquitectura MVVM.

## Propósito

Los ViewModels actúan como intermediarios entre Views y Models, siendo responsables de:

- Contener la lógica de presentación y de negocio
- Gestionar el estado de la UI
- Procesar las interacciones del usuario
- Transformar datos del Model para la View
- Llamar a servicios, repositorios o casos de uso
- Notificar cambios a las vistas (usando ChangeNotifier, Provider, Riverpod, etc.)

## Ejemplos de contenido

- ViewModels específicos para cada pantalla o feature
- Controladores de estado
- Lógica de validación de formularios
- Manejo de llamadas asíncronas

## Convenciones

- Los archivos deben nombrarse en snake_case terminando en `_view_model.dart`
- Extender `ChangeNotifier` o usar el sistema de gestión de estado elegido
- No deben contener referencias a widgets de Flutter (mantener independencia)
- Cada ViewModel típicamente corresponde a una View específica
