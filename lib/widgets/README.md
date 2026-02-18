# Widgets

Esta carpeta contiene **widgets reutilizables y transversales** de la aplicación.

## Propósito

Los widgets de esta carpeta son componentes compartidos que:

- Se utilizan en múltiples pantallas o vistas
- Proveen funcionalidad común y reutilizable
- Mantienen consistencia visual en toda la aplicación
- Reducen la duplicación de código de UI

## Ejemplos de contenido

- Botones personalizados
- Campos de texto customizados
- Cards y contenedores reutilizables
- Diálogos y modales comunes
- AppBar y DrawerNavigation personalizados
- Loaders y indicadores de progreso
- Widgets de error y estados vacíos

## Convenciones

- Los archivos deben nombrarse en snake_case (ej: `custom_button.dart`, `loading_indicator.dart`)
- Cada widget debe ser autónomo y parametrizable
- Documentar las propiedades requeridas y opcionales
- Mantener los widgets lo más genéricos posible para máxima reutilización
- Agrupar widgets relacionados en subcarpetas si es necesario
