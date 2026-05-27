/// Configuración de Supabase para el proyecto UBook.
///
/// Los valores se leen primero desde variables de entorno inyectadas en
/// tiempo de compilación (`--dart-define`). Si no se proporcionan, se usan
/// los valores por defecto del entorno de desarrollo.
///
/// Para sobreescribir en CI/CD o producción:
/// ```
/// flutter build apk \
///   --dart-define=SUPABASE_URL=https://tu-proyecto.supabase.co \
///   --dart-define=SUPABASE_ANON_KEY=sb_publishable_...
/// ```
///
/// Nota: el `anonKey` es una clave pública ("publishable") por diseño de
/// Supabase — está pensada para ser expuesta en el cliente.
class SupabaseConfig {
  SupabaseConfig._();

  static const url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://lqegcpkliffyjbtdtlrk.supabase.co',
  );

  static const anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_iAN1WnUHs7XRmyuL4EFO3g_tdKKGEHh',
  );
}
