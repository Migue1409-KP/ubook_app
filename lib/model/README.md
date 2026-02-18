# Model

Esta carpeta contiene los **modelos de datos** de la aplicación siguiendo la arquitectura MVVM.

## Propósito

Los modelos representan la estructura de datos de la aplicación y son responsables de:

- Definir las entidades y objetos de negocio
- Estructurar los datos que se reciben de APIs o bases de datos
- Implementar la lógica de serialización/deserialización (JSON, etc.)
- Mantener la representación del estado de datos

## Ejemplos de contenido

- Clases de entidades (User, Book, etc.)
- Modelos de respuesta de API
- Objetos de transferencia de datos (DTOs)
- Extensiones y conversiones de modelos

## Convenciones

- Los archivos deben nombrarse en snake_case (ej: `user_model.dart`, `book.dart`)
- Preferiblemente incluir métodos `fromJson()` y `toJson()` para serialización
- Mantener los modelos inmutables cuando sea posible
