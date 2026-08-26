import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentacion/proveedores/proveedores_auth.dart';
import '../router/enrutador.dart';

class NavegacionPrincipal extends ConsumerWidget {
  const NavegacionPrincipal({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estadoAuth = ref.watch(viewModelAuthProvider);
    final esDueno = estadoAuth.maybeWhen(
      autenticado: (usuario) => usuario.esDueno,
      perfilIncompleto: (usuario) => usuario.esDueno,
      orElse: () => false,
    );
    final esBarberoEmpleado = estadoAuth.maybeWhen(
      autenticado: (usuario) => usuario.esBarbero && !usuario.esDueno,
      perfilIncompleto: (usuario) => usuario.esBarbero && !usuario.esDueno,
      orElse: () => false,
    );

    final destinos = esDueno
        ? <NavigationDestination>[
            const NavigationDestination(
              icon: Icon(Icons.storefront_outlined),
              selectedIcon: Icon(Icons.storefront),
              label: 'Mi negocio',
            ),
            const NavigationDestination(
              icon: Icon(Icons.event_outlined),
              selectedIcon: Icon(Icons.event),
              label: 'Calendario',
            ),
            const NavigationDestination(
              icon: Icon(Icons.bar_chart_outlined),
              selectedIcon: Icon(Icons.bar_chart),
              label: 'Reportes',
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Mi perfil',
            ),
          ]
        : esBarberoEmpleado
        ? <NavigationDestination>[
            const NavigationDestination(
              icon: Icon(Icons.content_cut_outlined),
              selectedIcon: Icon(Icons.content_cut),
              label: 'Pendientes',
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Mi perfil',
            ),
          ]
        : <NavigationDestination>[
            const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Inicio',
            ),
            const NavigationDestination(
              icon: Icon(Icons.calendar_today_outlined),
              selectedIcon: Icon(Icons.calendar_today),
              label: 'Citas',
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ];

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indiceActual(context, esDueno, esBarberoEmpleado),
        onDestinationSelected: (index) => _navegar(context, index, esDueno, esBarberoEmpleado),
        destinations: destinos,
      ),
    );
  }

  int _indiceActual(BuildContext context, bool esDueno, bool esBarberoEmpleado) {
    final ubicacion = GoRouterState.of(context).uri.path;
    if (esDueno) {
      if (ubicacion.startsWith(Rutas.calendarioNegocio)) return 1;
      if (ubicacion.startsWith(Rutas.reporteVentas)) return 2;
      if (ubicacion.startsWith(Rutas.perfil)) return 3;
      return 0;
    }
    if (esBarberoEmpleado) {
      if (ubicacion.startsWith(Rutas.perfil)) return 1;
      return 0;
    }
    if (ubicacion.startsWith(Rutas.citas)) return 1;
    if (ubicacion.startsWith(Rutas.miNegocio)) return 2;
    if (ubicacion.startsWith(Rutas.perfil)) return 2;
    return 0;
  }

  void _navegar(BuildContext context, int index, bool esDueno, bool esBarberoEmpleado) {
    final rutas = esDueno
        ? <String>[
            Rutas.miNegocio,
            Rutas.calendarioNegocio,
            Rutas.reporteVentas,
            Rutas.perfil,
          ]
        : esBarberoEmpleado
        ? <String>[Rutas.qr, Rutas.perfil]
        : <String>[Rutas.inicio, Rutas.citas, Rutas.perfil];

    if (index < 0 || index >= rutas.length) {
      if (esDueno) {
        context.go(Rutas.miNegocio);
        return;
      }
      context.go(esBarberoEmpleado ? Rutas.qr : Rutas.inicio);
      return;
    }

    context.go(rutas[index]);
  }
}
