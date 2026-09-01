import 'package:dio/dio.dart';
import '../../../../core/constants/constantes_api.dart';
import '../../../../core/errors/excepciones.dart';
import '../modelos/usuario_modelo.dart';

abstract class FuenteDatosAuthRemota {
  Future<UsuarioModelo> iniciarSesion({
    required String email,
    required String contrasena,
  });

  Future<UsuarioModelo> iniciarSesionGoogle(String idTokenGoogle);

  Future<UsuarioModelo> registrarse({
    required String nombreCompleto,
    required String tipoDocumento,
    required String numeroDocumento,
    required String telefono,
    required String correo,
    required String contrasena,
  });

  Future<void> cerrarSesion();
}

class FuenteDatosAuthRemotaImpl implements FuenteDatosAuthRemota {
  const FuenteDatosAuthRemotaImpl(this._dio);

  final Dio _dio;

  String _extraerMensajeError(dynamic data, {required String porDefecto}) {
    if (data is Map<String, dynamic>) {
      final error = data['error'];
      if (error is String && error.trim().isNotEmpty) {
        return error;
      }
      if (error is Map<String, dynamic>) {
        final mensajeError = error['mensaje'] as String?;
        if (mensajeError != null && mensajeError.trim().isNotEmpty) {
          return mensajeError;
        }
      }

      final mensaje = data['mensaje'] as String?;
      if (mensaje != null && mensaje.trim().isNotEmpty) {
        return mensaje;
      }

      final cuerpo = data['cuerpo'];
      if (cuerpo is Map<String, dynamic>) {
        final mensajeCuerpo = cuerpo['mensaje'] as String?;
        if (mensajeCuerpo != null && mensajeCuerpo.trim().isNotEmpty) {
          return mensajeCuerpo;
        }
      }
    }
    return porDefecto;
  }

  Map<String, dynamic> _extraerCuerpoValido({
    required dynamic data,
    required String mensajeErrorPorDefecto,
    int? codigoHttp,
  }) {
    if (data is! Map<String, dynamic>) {
      throw ExcepcionServidor(
        mensaje: mensajeErrorPorDefecto,
        codigo: codigoHttp,
      );
    }

    final estatusRaw = data['estatus'] ?? data['estado'] ?? '500';
    final estatusTexto = estatusRaw.toString();
    final esExito = estatusTexto == '200' || estatusTexto == '201';

    if (!esExito) {
      throw ExcepcionServidor(
        mensaje: _extraerMensajeError(
          data,
          porDefecto: mensajeErrorPorDefecto,
        ),
        codigo: int.tryParse(estatusTexto) ?? codigoHttp,
      );
    }

    final cuerpo = data['cuerpo'];
    if (cuerpo is! Map<String, dynamic>) {
      throw ExcepcionServidor(
        mensaje: 'La respuesta no incluye un cuerpo válido',
        codigo: int.tryParse(estatusTexto) ?? codigoHttp,
      );
    }

    return cuerpo;
  }

  @override
  Future<UsuarioModelo> iniciarSesion({
    required String email,
    required String contrasena,
  }) async {
    try {
      final respuesta = await _dio.post(
        ConstantesApi.login,
        data: {'email': email, 'contrasena': contrasena},
      );
      return UsuarioModelo.fromJson(respuesta.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ExcepcionServidor(
        mensaje: e.response?.data?['mensaje'] as String? ?? 'Error al iniciar sesión',
        codigo: e.response?.statusCode,
      );
    }
  }

  @override
  Future<UsuarioModelo> iniciarSesionGoogle(String idTokenGoogle) async {
    try {
      final respuesta = await _dio.post(
        ConstantesApi.loginGoogle,
        data: {'id_token': idTokenGoogle},
      );
      return UsuarioModelo.fromJson(respuesta.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ExcepcionServidor(
        mensaje: e.response?.data?['mensaje'] as String? ?? 'Error con Google Sign-In',
        codigo: e.response?.statusCode,
      );
    }
  }

  @override
  Future<UsuarioModelo> registrarse({
    required String nombreCompleto,
    required String tipoDocumento,
    required String numeroDocumento,
    required String telefono,
    required String correo,
    required String contrasena,
  }) async {
    try {
      final respuesta = await _dio.post(
        ConstantesApi.registro,
        data: {
          'nombre_completo': nombreCompleto,
          'tipo_documento': tipoDocumento,
          'numero_documento': numeroDocumento,
          'telefono': telefono,
          'correo': correo,
          'contrasena': contrasena,
          'rol_inicial': 1,
        },
      );
      final cuerpo = _extraerCuerpoValido(
        data: respuesta.data,
        mensajeErrorPorDefecto: 'Error al registrarse',
        codigoHttp: respuesta.statusCode,
      );
      final usuarioJson =
          Map<String, dynamic>.from(cuerpo['usuario'] as Map<String, dynamic>);

      final rolesRaw = usuarioJson['roles'];
      if (rolesRaw is List) {
        usuarioJson['roles'] = rolesRaw.map((rol) => rol.toString()).toList();
      }

      final usuario = UsuarioModelo.fromJson(usuarioJson);
      final tieneRolCliente =
          usuario.roles.contains('1') || usuario.roles.contains('CLIENTE');

      if (tieneRolCliente) {
        return usuario;
      }

      return usuario.copyWith(roles: const ['1']);
    } on DioException catch (e) {
      throw ExcepcionServidor(
        mensaje: _extraerMensajeError(
          e.response?.data,
          porDefecto: 'Error al registrarse',
        ),
        codigo: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> cerrarSesion() async {
    try {
      await _dio.post(ConstantesApi.cerrarSesion);
    } on DioException catch (e) {
      throw ExcepcionServidor(
        mensaje: e.response?.data?['mensaje'] as String? ?? 'Error al cerrar sesión',
        codigo: e.response?.statusCode,
      );
    }
  }
}
