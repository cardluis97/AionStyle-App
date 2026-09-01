enum RolUsuario {
  cliente,
  barbero,
  dueno;

  String get nombre => switch (this) {
        RolUsuario.cliente => 'CLIENTE',
        RolUsuario.barbero => 'BARBERO',
        RolUsuario.dueno => 'DUEÑO',
      };

  static RolUsuario desdeTexto(String texto) => switch (texto.toUpperCase()) {
      '1' => RolUsuario.cliente,
      '2' => RolUsuario.barbero,
      '3' => RolUsuario.dueno,
        'CLIENTE' => RolUsuario.cliente,
        'BARBERO' => RolUsuario.barbero,
        'DUEÑO' || 'DUENO' => RolUsuario.dueno,
        _ => throw ArgumentError('Rol desconocido: $texto'),
      };
}
