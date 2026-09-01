/// Banco central de segmentos API.
/// Si cambia un prefijo de modulo, se ajusta solo aqui.
abstract class BancoEndpointsApi {
  static const auth = '/auth';
  static const usuarios = '/usuarios';
  static const negocios = '/negocios';
  static const barberos = '/barberos';
  static const servicios = '/servicios';
  static const citas = '/citas';
  static const pagos = '/pagos';
  static const qr = '/qr';
}

/// Endpoints centralizados para toda la app.
/// Si cambia una ruta puntual, se modifica solo en este archivo.
abstract class ConstantesApi {
  // Autenticacion
  static String get login => '${BancoEndpointsApi.auth}/login';
  static String get registro => '${BancoEndpointsApi.auth}/registro';
  static String get cerrarSesion => '${BancoEndpointsApi.auth}/logout';
  static String get refrescarToken => '${BancoEndpointsApi.auth}/refresh';
  static String get loginGoogle => '${BancoEndpointsApi.auth}/google';

  // Usuarios / Perfil
  static String get perfil => '${BancoEndpointsApi.usuarios}/perfil';
  static String get actualizarPerfil => '${BancoEndpointsApi.usuarios}/perfil';

  // Negocios
  static String get negocios => BancoEndpointsApi.negocios;
  static String negocioPorId(String id) => '${BancoEndpointsApi.negocios}/$id';

  // Barberos
  static String get barberos => BancoEndpointsApi.barberos;
  static String barberoPorId(String id) => '${BancoEndpointsApi.barberos}/$id';
  static String barberosPorNegocio(String negocioId) =>
      '${BancoEndpointsApi.negocios}/$negocioId/barberos';

  // Servicios
  static String get servicios => BancoEndpointsApi.servicios;
  static String serviciosPorNegocio(String negocioId) =>
      '${BancoEndpointsApi.negocios}/$negocioId/servicios';

  // Citas
  static String get citas => BancoEndpointsApi.citas;
  static String citaPorId(String id) => '${BancoEndpointsApi.citas}/$id';
  static String citasPorUsuario(String usuarioId) =>
      '${BancoEndpointsApi.usuarios}/$usuarioId/citas';
  static String cancelarCita(String id) => '${BancoEndpointsApi.citas}/$id/cancelar';

  // Pagos
  static String get pagos => BancoEndpointsApi.pagos;
  static String get intentoPago => '${BancoEndpointsApi.pagos}/intento';
  static String confirmarPago(String pagoId) => '${BancoEndpointsApi.pagos}/$pagoId/confirmar';

  // QR
  static String get validarQr => '${BancoEndpointsApi.qr}/validar';

  // Recibos
  static String reciboPorCita(String citaId) => '${BancoEndpointsApi.citas}/$citaId/recibo';
}
