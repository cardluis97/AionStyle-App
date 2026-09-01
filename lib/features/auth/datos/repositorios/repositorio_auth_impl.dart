import 'package:dartz/dartz.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/constants/constantes_app.dart';
import '../../../../core/errors/excepciones.dart';
import '../../../../core/errors/fallos.dart';
import '../../../../core/storage/almacenamiento_seguro.dart';
import '../../../../core/utils/resultado.dart';
import '../../dominio/entidades/usuario_entidad.dart';
import '../../dominio/entidades/tipo_documento.dart';
import '../../dominio/repositorios/repositorio_auth.dart';
import '../fuentes_de_datos/fuente_auth_local.dart';
import '../fuentes_de_datos/fuente_auth_remota.dart';
import '../modelos/usuario_modelo.dart';

class RepositorioAuthImpl implements RepositorioAuth {
  const RepositorioAuthImpl({
    required this.fuenteLocal,
    required this.fuenteRemota,
    required this.almacenamiento,
    required this.googleSignIn,
  });

  final FuenteDatosAuthLocal fuenteLocal;
  final FuenteDatosAuthRemota fuenteRemota;
  final AlmacenamientoSeguro almacenamiento;
  final GoogleSignIn googleSignIn;

  @override
  Future<Resultado<UsuarioEntidad>> loginConCorreo({
    required String correo,
    required String contrasena,
  }) async {
    try {
      final modelo = await fuenteLocal.loginConCorreo(
        correo: correo,
        contrasena: contrasena,
      );
      return Right(modelo.aEntidad());
    } on ExcepcionNoAutorizado {
      return const Left(FalloNoAutorizado());
    } on ExcepcionSinConexion {
      return const Left(FalloSinConexion());
    } on ExcepcionServidor catch (e) {
      return Left(FalloServidor(e.mensaje));
    }
  }

  @override
  Future<Resultado<UsuarioEntidad>> loginConGoogle() async {
    try {
      final cuenta = await googleSignIn.signIn();
      if (cuenta == null) return const Left(FalloServidor('Inicio cancelado'));

      final autenticacion = await cuenta.authentication;
      final idToken = autenticacion.idToken;
      if (idToken == null) {
        return const Left(FalloServidor('No se obtuvo token de Google'));
      }

      final modelo = await fuenteLocal.loginConGoogle(idToken);
      return Right(modelo.aEntidad());
    } on ExcepcionSinConexion {
      return const Left(FalloSinConexion());
    } on ExcepcionServidor catch (e) {
      return Left(FalloServidor(e.mensaje));
    }
  }

  @override
  Future<Resultado<UsuarioEntidad>> registrar({
    required String nombreCompleto,
    required TipoDocumento tipoDocumento,
    required String numeroDocumento,
    required String telefono,
    required String correo,
    required String contrasena,
  }) async {
    try {
      final modelo = await fuenteRemota.registrarse(
        nombreCompleto: nombreCompleto,
        tipoDocumento: tipoDocumento.nombre,
        numeroDocumento: numeroDocumento,
        telefono: telefono,
        correo: correo,
        contrasena: contrasena,
      );
      return Right(modelo.aEntidad());
    } on ExcepcionSinConexion {
      return const Left(FalloSinConexion());
    } on ExcepcionServidor catch (e) {
      return Left(FalloServidor(e.mensaje));
    }
  }

  @override
  Future<Resultado<UsuarioEntidad>> completarPerfil({
    required String usuarioId,
    required String nombreCompleto,
    required TipoDocumento tipoDocumento,
    required String numeroDocumento,
    required String telefono,
  }) async {
    try {
      final modelo = await fuenteLocal.completarPerfil(
        usuarioId: usuarioId,
        nombreCompleto: nombreCompleto,
        tipoDocumento: tipoDocumento.nombre,
        numeroDocumento: numeroDocumento,
        telefono: telefono,
      );
      return Right(modelo.aEntidad());
    } on ExcepcionSinConexion {
      return const Left(FalloSinConexion());
    } on ExcepcionServidor catch (e) {
      return Left(FalloServidor(e.mensaje));
    }
  }

  @override
  Future<ResultadoVacio> cerrarSesion() async {
    try {
      await fuenteLocal.cerrarSesion();
      await almacenamiento.eliminar(ConstantesApp.claveTokenAcceso);
      await almacenamiento.eliminar(ConstantesApp.claveTokenRefresco);
      // En web o sin sesion Google activa, signOut puede fallar y no debe
      // impedir el cierre de sesion local.
      try {
        await googleSignIn.signOut();
      } catch (_) {
        // Ignorado intencionalmente.
      }
      return const Right(null);
    } on ExcepcionServidor catch (e) {
      return Left(FalloServidor(e.mensaje));
    } catch (_) {
      return const Right(null);
    }
  }

  @override
  Future<Resultado<UsuarioEntidad?>> obtenerUsuarioActual() async {
    final token = await almacenamiento.leer(ConstantesApp.claveTokenAcceso);
    if (token == null) return const Right(null);
    // TODO: decodificar JWT o hacer llamada a /perfil
    return const Right(null);
  }
}
