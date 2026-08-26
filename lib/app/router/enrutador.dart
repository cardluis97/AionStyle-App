import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentacion/paginas/pagina_login.dart';
import '../../features/auth/presentacion/paginas/pagina_registro.dart';
import '../../features/auth/presentacion/paginas/pagina_completar_perfil.dart';
import '../../features/home/presentacion/paginas/pagina_inicio.dart';
import '../../features/appointments/presentacion/paginas/pagina_citas.dart';
import '../../features/appointments/presentacion/paginas/pagina_agendar_cita.dart';
import '../../features/appointments/presentacion/paginas/pagina_confirmacion_cita.dart';
import '../../features/profile/presentacion/paginas/pagina_perfil.dart';
import '../../features/profile/presentacion/paginas/pagina_cambiar_contrasena.dart';
import '../../features/profile/presentacion/paginas/pagina_eliminar_cuenta.dart';
import '../../features/profile/presentacion/paginas/pagina_favoritos.dart';
import '../../features/profile/presentacion/paginas/pagina_informacion_personal.dart';
import '../../features/profile/presentacion/paginas/pagina_politicas_condiciones.dart';
import '../../features/barbers/presentacion/paginas/pagina_barberos.dart';
import '../../features/businesses/presentacion/paginas/pagina_negocios.dart';
import '../../features/businesses/presentacion/paginas/pagina_detalle_negocio.dart';
import '../../features/payments/presentacion/paginas/pagina_pagos.dart';
import '../../features/qr/presentacion/paginas/pagina_qr.dart';
import '../../features/settings/presentacion/paginas/pagina_configuracion.dart';
import '../../features/barber_mode/presentacion/paginas/pagina_modo_barbero.dart';
import '../../features/owner_mode/presentacion/paginas/pagina_modo_propietario.dart';
import '../../features/owner_mode/presentacion/paginas/pagina_firma_contrato_dueno.dart';
import '../../features/owner_mode/presentacion/paginas/pagina_reporte_ventas.dart';
import '../../features/owner_mode/presentacion/paginas/pagina_calendario_negocio.dart';
import '../widgets/navegacion_principal.dart';

// Rutas nombradas
abstract class Rutas {
  static const splash = '/';
  static const login = '/login';
  static const registro = '/registro';
  static const completarPerfil = '/completar-perfil';
  static const inicio = '/inicio';
  static const citas = '/citas';
  static const agendarCita = '/agendar-cita';
  static const confirmacionCita = '/confirmacion-cita';
  static const perfil = '/perfil';
  static const perfilInformacionPersonal = '/perfil/informacion-personal';
  static const perfilCambiarContrasena = '/perfil/cambiar-contrasena';
  static const perfilFavoritos = '/perfil/favoritos';
  static const perfilPoliticasCondiciones = '/perfil/politicas-condiciones';
  static const perfilEliminarCuenta = '/perfil/eliminar-cuenta';
  static const barberos = '/barberos';
  static const negocios = '/negocios';
  static const pagos = '/pagos';
  static const qr = '/qr';
  static const configuracion = '/configuracion';
  static const modoBarbero = '/modo-barbero';
  static const modoPropietario = '/modo-propietario';
  static const miNegocio = '/mi-negocio';
  static const reporteVentas = '/reporte-ventas';
  static const calendarioNegocio = '/calendario-negocio';
  static const firmaContratoDueno = '/firma-contrato-dueno';

  static const nombreInicio = 'inicio';
  static const nombreCitas = 'citas';
  static const nombrePerfil = 'perfil';
  static const nombrePerfilInformacionPersonal = 'perfil-informacion-personal';
  static const nombrePerfilCambiarContrasena = 'perfil-cambiar-contrasena';
  static const nombrePerfilFavoritos = 'perfil-favoritos';
  static const nombrePerfilPoliticasCondiciones = 'perfil-politicas-condiciones';
  static const nombrePerfilEliminarCuenta = 'perfil-eliminar-cuenta';
  static const nombrePagos = 'pagos';
  static const nombreQr = 'qr';
  static const nombreModoBarbero = 'modo-barbero';
  static const nombreModoPropietario = 'modo-propietario';
  static const nombreMiNegocio = 'mi-negocio';
  static const nombreReporteVentas = 'reporte-ventas';
  static const nombreCalendarioNegocio = 'calendario-negocio';
  static const nombreFirmaContratoDueno = 'firma-contrato-dueno';
  static const nombreNegocios = 'negocios';
  static const nombreDetalleNegocio = 'detalle-negocio';
}

final enrutadorProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Rutas.login,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: Rutas.login,
        builder: (context, state) => const PaginaLogin(),
      ),
      GoRoute(
        path: Rutas.registro,
        builder: (context, state) => const PaginaRegistro(),
      ),
      GoRoute(
        path: Rutas.completarPerfil,
        builder: (context, state) => const PaginaCompletarPerfil(),
      ),
      GoRoute(
        path: Rutas.firmaContratoDueno,
        name: Rutas.nombreFirmaContratoDueno,
        builder: (context, state) => const PaginaFirmaContratoDueno(),
      ),
      ShellRoute(
        builder: (context, state, child) => NavegacionPrincipal(child: child),
        routes: [
          GoRoute(
            path: Rutas.inicio,
            name: Rutas.nombreInicio,
            builder: (context, state) => const PaginaInicio(),
          ),
          GoRoute(
            path: Rutas.citas,
            name: Rutas.nombreCitas,
            builder: (context, state) {
              final p = state.uri.queryParameters;
              return PaginaCitas(
                negocioNombre: p['negocio'],
                barberoNombre: p['barbero'],
                corte: p['corte'],
                servicios: p['servicios'],
                precio: double.tryParse(p['precio'] ?? ''),
                fecha: p['fecha'],
                hora: p['hora'],
                horaInicio: p['horaInicio'],
                horaFin: p['horaFin'],
                metodoPago: p['pago'],
                codigoQr: p['qr'],
              );
            },
          ),
          GoRoute(
            path: Rutas.agendarCita,
            builder: (context, state) {
              final negocio = state.uri.queryParameters['negocio'] ?? 'Negocio';
              final barbero = state.uri.queryParameters['barbero'] ?? 'Barbero';
              final serviciosCadena = state.uri.queryParameters['servicios'] ?? '';
              final estilosCadena =
                  state.uri.queryParameters['estilos'] ??
                  state.uri.queryParameters['especialidades'] ?? '';
              final servicios = serviciosCadena.isEmpty
                  ? <String>[]
                  : serviciosCadena.split('|');
              final estilos = estilosCadena.isEmpty
                  ? <String>[]
                  : estilosCadena.split('|');
              return PaginaAgendarCita(
                negocioNombre: negocio,
                barberoNombre: barbero,
                serviciosDisponibles: servicios,
                estilosDisponibles: estilos,
              );
            },
          ),
          GoRoute(
            path: Rutas.confirmacionCita,
            builder: (context, state) {
              final p = state.uri.queryParameters;
              final precio = double.tryParse(p['precio'] ?? '') ?? 0;
              return PaginaConfirmacionCita(
                negocioNombre: p['negocio'] ?? 'Negocio',
                barberoNombre: p['barbero'] ?? 'Barbero',
                corte: p['corte'] ?? 'Corte',
                servicios: p['servicios'] ?? '',
                precio: precio,
                fecha: p['fecha'] ?? 'Sin fecha',
                horaInicio: p['horaInicio'] ?? p['hora'] ?? 'Sin hora',
                horaFinal: p['horaFin'] ?? 'Sin hora final',
                metodoPago: p['pago'] ?? 'Efectivo',
                codigoQr: p['qr'] ?? 'AIONSTYLE|SIN_QR',
              );
            },
          ),
          GoRoute(
            path: Rutas.perfil,
            name: Rutas.nombrePerfil,
            builder: (context, state) => const PaginaPerfil(),
          ),
          GoRoute(
            path: Rutas.perfilInformacionPersonal,
            name: Rutas.nombrePerfilInformacionPersonal,
            builder: (context, state) => const PaginaInformacionPersonal(),
          ),
          GoRoute(
            path: Rutas.perfilCambiarContrasena,
            name: Rutas.nombrePerfilCambiarContrasena,
            builder: (context, state) => const PaginaCambiarContrasena(),
          ),
          GoRoute(
            path: Rutas.perfilFavoritos,
            name: Rutas.nombrePerfilFavoritos,
            builder: (context, state) => const PaginaFavoritos(),
          ),
          GoRoute(
            path: Rutas.perfilPoliticasCondiciones,
            name: Rutas.nombrePerfilPoliticasCondiciones,
            builder: (context, state) => const PaginaPoliticasCondiciones(),
          ),
          GoRoute(
            path: Rutas.perfilEliminarCuenta,
            name: Rutas.nombrePerfilEliminarCuenta,
            builder: (context, state) => const PaginaEliminarCuenta(),
          ),
          GoRoute(
            path: Rutas.barberos,
            builder: (context, state) => const PaginaBarberos(),
          ),
          GoRoute(
            path: Rutas.negocios,
            name: Rutas.nombreNegocios,
            builder: (context, state) => const PaginaNegocios(),
          ),
          GoRoute(
            path: '${Rutas.negocios}/:id',
            name: Rutas.nombreDetalleNegocio,
            builder: (context, state) => PaginaDetalleNegocio(
              negocioId: state.pathParameters['id'] ?? '',
            ),
          ),
          GoRoute(
            path: Rutas.pagos,
            name: Rutas.nombrePagos,
            builder: (context, state) => const PaginaPagos(),
          ),
          GoRoute(
            path: Rutas.qr,
            name: Rutas.nombreQr,
            builder: (context, state) => const PaginaQr(),
          ),
          GoRoute(
            path: Rutas.configuracion,
            builder: (context, state) => const PaginaConfiguracion(),
          ),
          GoRoute(
            path: Rutas.modoBarbero,
            name: Rutas.nombreModoBarbero,
            builder: (context, state) => const PaginaModoBarbero(),
          ),
          GoRoute(
            path: Rutas.modoPropietario,
            name: Rutas.nombreModoPropietario,
            builder: (context, state) => const PaginaModoPropietario(),
          ),
          GoRoute(
            path: Rutas.miNegocio,
            name: Rutas.nombreMiNegocio,
            builder: (context, state) => const PaginaModoPropietario(
              esAlta: false,
            ),
          ),
          GoRoute(
            path: Rutas.reporteVentas,
            name: Rutas.nombreReporteVentas,
            builder: (context, state) => const PaginaReporteVentas(),
          ),
          GoRoute(
            path: Rutas.calendarioNegocio,
            name: Rutas.nombreCalendarioNegocio,
            builder: (context, state) => const PaginaCalendarioNegocio(),
          ),
        ],
      ),
    ],
  );
});
