import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/enrutador.dart';
import '../../../../app/theme/colores.dart';
import '../../../auth/presentacion/proveedores/proveedores_auth.dart';

class PaginaModoBarbero extends ConsumerWidget {
  const PaginaModoBarbero({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puedeIngresar = ref.watch(viewModelAuthProvider).maybeWhen(
          autenticado: (usuario) => usuario.esBarbero,
          orElse: () => false,
        );
    if (!puedeIngresar) {
      return Scaffold(
        backgroundColor: ColoresApp.fondo,
        appBar: AppBar(
          title: const Text('Modo Barbero'),
          backgroundColor: ColoresApp.primario,
          foregroundColor: ColoresApp.secundario,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Este usuario no tiene habilitado el rol BARBERO.'),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => context.go(Rutas.perfil),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Volver a Mi perfil'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Modo Barbero')),
      body: const Center(child: Text('Panel del barbero — en construcción')),
    );
  }
}
