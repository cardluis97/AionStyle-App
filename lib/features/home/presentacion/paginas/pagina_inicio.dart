import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentacion/proveedores/proveedores_auth.dart';
import '../../../businesses/presentacion/widgets/vista_negocios.dart';
import '../../../../app/theme/colores.dart';
import '../../../../app/widgets/logo_aionstyle.dart';

class PaginaInicio extends ConsumerStatefulWidget {
  const PaginaInicio({super.key});

  @override
  ConsumerState<PaginaInicio> createState() => _PaginaInicioState();
}

class _PaginaInicioState extends ConsumerState<PaginaInicio> {
  final TextEditingController _busquedaCtrl = TextEditingController();
  bool _notificacionesLimpias = false;

  @override
  void dispose() {
    _busquedaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final estadoAuth = ref.watch(viewModelAuthProvider);
    final tema = Theme.of(context);

    return Scaffold(
      backgroundColor: ColoresApp.secundario,
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: SizedBox(
              height: 380,
              width: double.infinity,
              child: ClipPath(
                clipper: _FormaEncabezadoInicioClipper(),
                child: Container(
                  color: ColoresApp.primario,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: IgnorePointer(
              child: Container(
                height: 380,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x0F000000),
                      Color(0x00000000),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(2, 10, 10, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Flexible(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: LogoAionStyle(
                            ancho: 148,
                            alto: 60,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: estadoAuth.maybeWhen(
                          autenticado: (usuario) {
                            final esUsuarioDemoCliente =
                                usuario.correo.trim().toLowerCase() ==
                                    'usuarioa@aionstyle.com';
                            final tieneCitaPendiente =
                              esUsuarioDemoCliente && !_notificacionesLimpias;
                            final rolPrincipal = esUsuarioDemoCliente
                                ? 'Cliente'
                                : (usuario.roles.isNotEmpty
                                    ? _capitalizar(usuario.roles.first.nombre)
                                    : 'Cliente');

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        rolPrincipal,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            tema.textTheme.titleMedium?.copyWith(
                                          color: ColoresApp.secundario,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 11.5,
                                        ),
                                      ),
                                      const SizedBox(height: 1),
                                      Text(
                                        usuario.nombreCompleto,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.right,
                                        style:
                                            tema.textTheme.bodyMedium?.copyWith(
                                          color: ColoresApp.secundario,
                                          fontSize: 9.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 7),
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    PopupMenuButton<int>(
                                      tooltip: 'Notificaciones',
                                      offset: const Offset(0, 42),
                                      color: ColoresApp.terceario,
                                      onSelected: (valor) {
                                        if (valor == 1) {
                                          setState(() {
                                            _notificacionesLimpias = true;
                                          });
                                        }
                                      },
                                      itemBuilder: (_) {
                                        return [
                                          PopupMenuItem<int>(
                                            value: 0,
                                            enabled: false,
                                            child: SizedBox(
                                              width: 260,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Notificaciones',
                                                          style: tema
                                                              .textTheme
                                                              .labelLarge
                                                              ?.copyWith(
                                                                color: ColoresApp.primario,
                                                                fontWeight:
                                                                    FontWeight.w700,
                                                              ),
                                                        ),
                                                      ),
                                                      if (tieneCitaPendiente)
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                            setState(() {
                                                              _notificacionesLimpias =
                                                                  true;
                                                            });
                                                          },
                                                          style: TextButton.styleFrom(
                                                            foregroundColor:
                                                                ColoresApp.primario,
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                              horizontal: 6,
                                                              vertical: 2,
                                                            ),
                                                            minimumSize:
                                                                const Size(0, 24),
                                                            tapTargetSize:
                                                                MaterialTapTargetSize
                                                                    .shrinkWrap,
                                                          ),
                                                          child: Text(
                                                            'Limpiar',
                                                            style: tema
                                                                .textTheme
                                                                .labelSmall
                                                                ?.copyWith(
                                                                  fontWeight:
                                                                      FontWeight.w500,
                                                                ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Text(
                                                    tieneCitaPendiente
                                                        ? 'Corte pendiente'
                                                        : 'Sin novedades',
                                                    style: tema
                                                        .textTheme
                                                        .titleSmall
                                                        ?.copyWith(
                                                          color: ColoresApp
                                                              .primario,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Text(
                                                    tieneCitaPendiente
                                                        ? 'Tienes un corte pendiente. Ya deberias acercarte a la barberia para no perder tu turno.'
                                                        : 'No tienes citas pendientes por ahora.',
                                                    style: tema
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                          color: ColoresApp
                                                              .primario
                                                              .withValues(alpha: 0.85),
                                                          height: 1.3,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ];
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Icon(
                                          Icons.notifications_rounded,
                                          color: ColoresApp.acento,
                                          size: 22,
                                        ),
                                      ),
                                    ),
                                    if (tieneCitaPendiente)
                                      Positioned(
                                        top: 9,
                                        right: 11,
                                        child: Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: ColoresApp.advertencia,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: ColoresApp.terceario,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.person_2_outlined,
                                    color: ColoresApp.primario,
                                    size: 20,
                                  ),
                                ),
                              ],
                            );
                          },
                          orElse: () => const SizedBox.shrink(),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
                  child: TextField(
                    controller: _busquedaCtrl,
                    onChanged: (_) => setState(() {}),
                    style: tema.textTheme.bodyLarge?.copyWith(
                      color: ColoresApp.primario,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Buscar barberia, salones o el estilo que deseas',
                      hintStyle: tema.textTheme.bodyMedium?.copyWith(
                        color: ColoresApp.textoClaro,
                        fontSize: 11,
                      ),
                      filled: true,
                      fillColor: ColoresApp.secundario,
                      prefixIcon: const Icon(
                        Icons.search,
                        color: ColoresApp.terceario,
                      ),
                      suffixIcon: _busquedaCtrl.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                _busquedaCtrl.clear();
                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.close,
                                color: ColoresApp.terceario,
                              ),
                            ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(
                          color: ColoresApp.terceario,
                          width: 1.4,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: VistaNegocios(
                    titulo: '',
                    mostrarEncabezado: false,
                    mostrarBuscador: false,
                    busquedaExterna: _busquedaCtrl.text,
                    textoDebajoCategorias:
                        'Negocios cercanos a ti en estos momentos',
                    colorTextoDebajoCategorias: ColoresApp.textoClaro,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _capitalizar(String valor) {
    final limpio = valor.trim().toLowerCase();
    if (limpio.isEmpty) return valor;
    return '${limpio[0].toUpperCase()}${limpio.substring(1)}';
  }
}

class _FormaEncabezadoInicioClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(w, 0)
      ..lineTo(w, h * 0.03)
      ..cubicTo(
        w,
        h * 0.35,
        w * 0.90,
        h * 0.62,
        w * 0.58,
        h * 0.72,
      )
      ..cubicTo(
        w * 0.32,
        h * 0.80,
        w * 0.11,
        h * 0.87,
        w * 0.00,
        h,
      )
      ..lineTo(0, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant _FormaEncabezadoInicioClipper oldClipper) {
    return false;
  }
}
