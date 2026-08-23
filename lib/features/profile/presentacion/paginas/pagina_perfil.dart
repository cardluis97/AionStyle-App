import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/enrutador.dart';
import '../../../../app/theme/colores.dart';
import '../../../auth/dominio/entidades/usuario_entidad.dart';
import '../../../auth/presentacion/proveedores/proveedores_auth.dart';

class PaginaPerfil extends ConsumerWidget {
  const PaginaPerfil({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estadoAuth = ref.watch(viewModelAuthProvider);
    final usuario = estadoAuth.maybeWhen<UsuarioEntidad?>(
      autenticado: (valor) => valor,
      perfilIncompleto: (valor) => valor,
      orElse: () => null,
    );
    final tieneRolBarbero = usuario?.esBarbero == true;
    final tieneRolDueno = usuario?.esDueno == true;

    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      appBar: AppBar(
        title: const Text('Mi perfil'),
        backgroundColor: ColoresApp.primario,
        foregroundColor: ColoresApp.secundario,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 2,
                color: ColoresApp.terceario,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: ColoresApp.primario,
                        child: const Icon(
                          Icons.person,
                          size: 24,
                          color: ColoresApp.secundario,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    usuario?.nombreCompleto ?? 'Cliente',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ColoresApp.secundario
                                        .withValues(alpha: 0.75),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: const Text(
                                    'Cliente',
                                    style: TextStyle(
                                      color: ColoresApp.primario,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              usuario?.correo ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: ColoresApp.primario
                                        .withValues(alpha: 0.72),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              _SeccionPerfil(
                titulo: 'Cuenta',
                items: [
                  _ItemPerfil(
                    titulo: 'INFORMACION PERSONAL',
                    subtitulo: 'Nombre completo, documento, teléfono y correo',
                    icono: Icons.person_outline,
                    onTap: () => context
                        .pushNamed(Rutas.nombrePerfilInformacionPersonal),
                  ),
                  _ItemPerfil(
                    titulo: 'CAMBIAR CONTRASEÑA',
                    subtitulo: 'Actualiza tu contraseña de acceso',
                    icono: Icons.lock_outline,
                    onTap: () =>
                        context.pushNamed(Rutas.nombrePerfilCambiarContrasena),
                  ),
                  _ItemPerfil(
                    titulo: 'ELIMINAR CUENTA',
                    subtitulo: 'Solicita la baja definitiva de tu cuenta',
                    icono: Icons.delete_outline,
                    onTap: () =>
                        context.pushNamed(Rutas.nombrePerfilEliminarCuenta),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _SeccionPerfil(
                titulo: 'Acceso y roles',
                items: [
                  _ItemPerfil(
                    titulo: tieneRolBarbero
                        ? 'INGRESAR COMO CLIENTE'
                        : 'INGRESAR COMO BARBERO',
                    subtitulo: tieneRolBarbero
                        ? 'Cambia al flujo de cliente'
                        : 'Activa el modo de trabajo de barbero',
                    icono: Icons.content_cut_rounded,
                    onTap: () {
                      if (tieneRolBarbero) {
                        context.go(Rutas.inicio);
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Este usuario no tiene habilitado el rol BARBERO.',
                          ),
                        ),
                      );
                    },
                  ),
                  _ItemPerfil(
                    titulo: tieneRolBarbero
                        ? 'INGRESAR COMO DUEÑO BARBERIA'
                        : tieneRolDueno
                        ? 'INGRESAR COMO CLIENTE'
                        : 'INGRESAR COMO DUEÑO BARBERIA',
                    subtitulo: tieneRolBarbero
                        ? 'Gestiona tu negocio y sucursales'
                        : tieneRolDueno
                        ? 'Cambia al flujo de cliente'
                        : 'Gestiona tu negocio y sucursales',
                    icono: Icons.storefront_outlined,
                    onTap: () {
                      if (tieneRolBarbero) {
                        context.pushNamed(Rutas.nombreModoPropietario);
                        return;
                      }
                      if (tieneRolDueno) {
                        context.go(Rutas.inicio);
                        return;
                      }
                      context.pushNamed(Rutas.nombreModoPropietario);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _SeccionPerfil(
                titulo: 'Preferencias',
                items: [
                  _ItemPerfil(
                    titulo: 'FAVORITOS',
                    subtitulo: 'Barberías y servicios guardados',
                    icono: Icons.favorite_border,
                    onTap: () => context.pushNamed(Rutas.nombrePerfilFavoritos),
                  ),
                  _ItemPerfil(
                    titulo: 'METODOS DE PAGO',
                    subtitulo: 'Tarjetas y pagos guardados',
                    icono: Icons.credit_card_outlined,
                    onTap: () => context.pushNamed(Rutas.nombrePagos),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _SeccionPerfil(
                titulo: 'Información legal',
                items: [
                  _ItemPerfil(
                    titulo: 'POLITICAS Y CONDICIONES',
                    subtitulo: 'Términos, privacidad y condiciones de uso',
                    icono: Icons.description_outlined,
                    onTap: () => context
                        .pushNamed(Rutas.nombrePerfilPoliticasCondiciones),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: () async {
                  await ref.read(viewModelAuthProvider.notifier).cerrarSesion();
                  if (context.mounted) {
                    context.go(Rutas.login);
                  }
                },
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar sesión'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColoresApp.error,
                  foregroundColor: ColoresApp.secundario,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SeccionPerfil extends StatelessWidget {
  const _SeccionPerfil({
    required this.titulo,
    required this.items,
  });

  final String titulo;
  final List<_ItemPerfil> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6, bottom: 8),
          child: Text(
            titulo,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: ColoresApp.primario,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Card(
          elevation: 0,
          color: ColoresApp.terceario,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: ColoresApp.dorado.withValues(alpha: 0.55)),
          ),
          child: Column(
            children: items
                .map(
                  (item) => ListTile(
                    leading: Icon(
                      item.icono,
                      color: item.color ?? ColoresApp.primario,
                    ),
                    title: Text(
                      item.titulo,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: item.subtitulo != null
                        ? Text(
                            item.subtitulo!,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: ColoresApp.primario
                                          .withValues(alpha: 0.78),
                                    ),
                          )
                        : null,
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: ColoresApp.primario,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 2,
                    ),
                    onTap: item.onTap,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _ItemPerfil {
  const _ItemPerfil({
    required this.titulo,
    required this.icono,
    this.subtitulo,
    this.color,
    required this.onTap,
  });

  final String titulo;
  final IconData icono;
  final String? subtitulo;
  final Color? color;
  final VoidCallback onTap;
}
