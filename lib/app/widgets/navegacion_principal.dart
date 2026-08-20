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

    final destinos = <NavigationDestination>[
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
      if (esDueno)
        const NavigationDestination(
          icon: Icon(Icons.storefront_outlined),
          selectedIcon: Icon(Icons.storefront),
          label: 'Mi negocio',
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
        selectedIndex: _indiceActual(context, esDueno),
        onDestinationSelected: (index) => _navegar(context, index, esDueno),
        destinations: destinos,
      ),
    );
  }

  int _indiceActual(BuildContext context, bool esDueno) {
    final ubicacion = GoRouterState.of(context).uri.path;
    if (ubicacion.startsWith(Rutas.citas)) return 1;
    if (ubicacion.startsWith(Rutas.miNegocio)) return 2;
    if (ubicacion.startsWith(Rutas.perfil)) return esDueno ? 3 : 2;
    return 0;
  }

  void _navegar(BuildContext context, int index, bool esDueno) {
    final rutas = <String>[
      Rutas.inicio,
      Rutas.citas,
      if (esDueno) Rutas.miNegocio,
      Rutas.perfil,
    ];

    if (index < 0 || index >= rutas.length) {
      context.go(Rutas.inicio);
      return;
    }

    context.go(rutas[index]);
  }
}
