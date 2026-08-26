import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../app/config/configuracion_app.dart';
import '../../../../core/providers/proveedores_core.dart';
import '../../datos/fuentes_de_datos/fuente_auth_local.dart';
import '../../datos/repositorios/repositorio_auth_impl.dart';
import '../../dominio/repositorios/repositorio_auth.dart';
import '../../dominio/casos_de_uso/caso_uso_iniciar_sesion.dart';
import '../../dominio/casos_de_uso/caso_uso_iniciar_sesion_google.dart';
import '../../dominio/casos_de_uso/caso_uso_cerrar_sesion.dart';
import '../../dominio/casos_de_uso/caso_uso_registrarse.dart';
import '../../dominio/casos_de_uso/caso_uso_completar_perfil.dart';
import '../modelos_vista/estado_auth.dart';
import '../modelos_vista/viewmodel_auth.dart';

final GoogleSignIn _googleSignInInstancia = kIsWeb
  ? GoogleSignIn(clientId: ConfiguracionApp.googleClientIdWeb)
  : GoogleSignIn();

// Fuente de datos local (mock)
final fuenteAuthLocalProvider = Provider<FuenteDatosAuthLocal>((ref) {
  return FuenteDatosAuthLocalImpl();
});

// Repositorio
final repositorioAuthProvider = Provider<RepositorioAuth>((ref) {
  return RepositorioAuthImpl(
    fuenteLocal: ref.watch(fuenteAuthLocalProvider),
    almacenamiento: ref.watch(almacenamientoSeguroProvider),
    googleSignIn: _googleSignInInstancia,
  );
});

// Casos de uso
final casoUsoLoginCorreoProvider = Provider((ref) {
  return CasoUsoLoginCorreo(ref.watch(repositorioAuthProvider));
});
final casoUsoLoginGoogleProvider = Provider((ref) {
  return CasoUsoLoginGoogle(ref.watch(repositorioAuthProvider));
});
final casoUsoCerrarSesionProvider = Provider((ref) {
  return CasoUsoCerrarSesion(ref.watch(repositorioAuthProvider));
});
final casoUsoRegistrarProvider = Provider((ref) {
  return CasoUsoRegistrar(ref.watch(repositorioAuthProvider));
});
final casoUsoCompletarPerfilProvider = Provider((ref) {
  return CasoUsoCompletarPerfil(ref.watch(repositorioAuthProvider));
});

// ViewModel
final viewModelAuthProvider =
    StateNotifierProvider<ViewModelAuth, EstadoAuth>((ref) {
  return ViewModelAuth(
    casoUsoLoginCorreo: ref.watch(casoUsoLoginCorreoProvider),
    casoUsoLoginGoogle: ref.watch(casoUsoLoginGoogleProvider),
    casoUsoCerrarSesion: ref.watch(casoUsoCerrarSesionProvider),
    casoUsoRegistrar: ref.watch(casoUsoRegistrarProvider),
    casoUsoCompletarPerfil: ref.watch(casoUsoCompletarPerfilProvider),
  );
});
