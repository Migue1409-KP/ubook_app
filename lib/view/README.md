# View

Esta carpeta contiene las **vistas (pantallas)** de la aplicación siguiendo la arquitectura MVVM.

## Propósito

Las vistas son responsables de la interfaz de usuario y deben:

- Mostrar los datos al usuario
- Capturar las interacciones del usuario
- Observar y reaccionar a los cambios en el ViewModel
- Delegar la lógica de negocio al ViewModel correspondiente

## Ejemplos de contenido

- Páginas/Screens completas de la aplicación
- Diferentes pantallas de navegación
- Interfaces específicas de cada feature/módulo

## Convenciones

- Los archivos deben nombrarse en snake_case terminando en `_view.dart` o `_screen.dart`
- Cada vista debe ser lo más "tonta" posible, sin lógica de negocio
- Las vistas se comunican con ViewModels, nunca directamente con Models
- Usar widgets de la carpeta `/widgets` para componentes reutilizables
