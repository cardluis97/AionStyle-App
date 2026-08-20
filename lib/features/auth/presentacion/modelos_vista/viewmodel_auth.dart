import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../dominio/casos_de_uso/caso_uso_iniciar_sesion.dart';
import '../../dominio/casos_de_uso/caso_uso_iniciar_sesion_google.dart';
import '../../dominio/casos_de_uso/caso_uso_cerrar_sesion.dart';
import '../../dominio/casos_de_uso/caso_uso_registrarse.dart';
import '../../dominio/casos_de_uso/caso_uso_completar_perfil.dart';
import '../../dominio/entidades/rol_usuario.dart';
import '../../dominio/entidades/tipo_documento.dart';
import 'estado_auth.dart';

class ViewModelAuth extends StateNotifier<EstadoAuth> {
  ViewModelAuth({
    required this.casoUsoLoginCorreo,
    required this.casoUsoLoginGoogle,
    required this.casoUsoCerrarSesion,
    required this.casoUsoRegistrar,
    required this.casoUsoCompletarPerfil,
  }) : super(const EstadoAuth.inicial());

  final CasoUsoLoginCorreo casoUsoLoginCorreo;
  final CasoUsoLoginGoogle casoUsoLoginGoogle;
  final CasoUsoCerrarSesion casoUsoCerrarSesion;
  final CasoUsoRegistrar casoUsoRegistrar;
  final CasoUsoCompletarPerfil casoUsoCompletarPerfil;

  Future<void> loginConCorreo({
    required String correo,
    required String contrasena,
  }) async {
    state = const EstadoAuth.cargando();
    final resultado = await casoUsoLoginCorreo.ejecutar(
      correo: correo,
      contrasena: contrasena,
    );
    resultado.fold(
      (fallo) => state = EstadoAuth.error(fallo.mensaje),
      (usuario) => state = EstadoAuth.autenticado(usuario),
    );
  }

  Future<void> loginConGoogle() async {
    state = const EstadoAuth.cargando();
    final resultado = await casoUsoLoginGoogle.ejecutar();
    resultado.fold(
      (fallo) => state = EstadoAuth.error(fallo.mensaje),
      (usuario) {
        // Si el perfil está incompleto, redirigir a completar datos
        state = usuario.perfilCompleto
            ? EstadoAuth.autenticado(usuario)
            : EstadoAuth.perfilIncompleto(usuario);
      },
    );
  }

  Future<void> registrar({
    required String nombreCompleto,
    required TipoDocumento tipoDocumento,
    required String numeroDocumento,
    required String telefono,
    required String correo,
    required String contrasena,
  }) async {
    state = const EstadoAuth.cargando();
    final resultado = await casoUsoRegistrar.ejecutar(
      nombreCompleto: nombreCompleto,
      tipoDocumento: tipoDocumento,
      numeroDocumento: numeroDocumento,
      telefono: telefono,
      correo: correo,
      contrasena: contrasena,
    );
    resultado.fold(
      (fallo) => state = EstadoAuth.error(fallo.mensaje),
      (usuario) => state = EstadoAuth.autenticado(usuario),
    );
  }

  Future<void> completarPerfil({
    required String usuarioId,
    required String nombreCompleto,
    required TipoDocumento tipoDocumento,
    required String numeroDocumento,
    required String telefono,
  }) async {
    state = const EstadoAuth.cargando();
    final resultado = await casoUsoCompletarPerfil.ejecutar(
      usuarioId: usuarioId,
      nombreCompleto: nombreCompleto,
      tipoDocumento: tipoDocumento,
      numeroDocumento: numeroDocumento,
      telefono: telefono,
    );
    resultado.fold(
      (fallo) => state = EstadoAuth.error(fallo.mensaje),
      (usuario) => state = EstadoAuth.autenticado(usuario),
    );
  }

  Future<void> cerrarSesion() async {
    await casoUsoCerrarSesion.ejecutar();
    state = const EstadoAuth.noAutenticado();
  }

  void activarRol(RolUsuario rol) {
    state.maybeWhen(
      autenticado: (usuario) {
        if (!usuario.tieneRol(rol)) {
          state = EstadoAuth.autenticado(
            usuario.copyWith(roles: [...usuario.roles, rol]),
          );
        }
      },
      orElse: () {},
    );
  }
}
