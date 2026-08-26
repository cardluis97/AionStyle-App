import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../app/config/configuracion_app.dart';
import '../../../../app/theme/colores.dart';
import '../../../../app/router/enrutador.dart';
import '../../../../app/widgets/logo_aionstyle.dart';
import '../../../../core/utils/ubicacion_obligatoria.dart';
import '../modelos_vista/estado_auth.dart';
import '../proveedores/proveedores_auth.dart';
import '../widgets/campo_email.dart';
import '../widgets/campo_contrasena.dart';
import '../widgets/boton_google.dart';

class PaginaLogin extends ConsumerStatefulWidget {
  const PaginaLogin({super.key});

  @override
  ConsumerState<PaginaLogin> createState() => _PaginaLoginState();
}

class _PaginaLoginState extends ConsumerState<PaginaLogin> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _contrasenaCtrl = TextEditingController();
  String _versionApp = ConfiguracionApp.versionApp;
  bool _redirigiendoInicio = false;

  String get _textoVersion {
    if (_versionApp.isEmpty) return '';
    return 'v$_versionApp';
  }

  @override
  void initState() {
    super.initState();
    _cargarVersionApp();
  }

  Future<void> _cargarVersionApp() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (!mounted) return;
      if (info.version.isEmpty) return;
      setState(() {
        _versionApp = info.version;
      });
    } catch (_) {
      // Si falla la lectura desde plataforma, se usa ConfiguracionApp.versionApp.
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _contrasenaCtrl.dispose();
    super.dispose();
  }

  Future<void> _loginConCorreo() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(viewModelAuthProvider.notifier).loginConCorreo(
          correo: _emailCtrl.text.trim(),
          contrasena: _contrasenaCtrl.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(viewModelAuthProvider);
    final tema = Theme.of(context);

    ref.listen<EstadoAuth>(viewModelAuthProvider, (_, siguiente) {
      siguiente.maybeWhen(
        autenticado: (usuario) async {
          if (_redirigiendoInicio) return;
          _redirigiendoInicio = true;
          final permitido = await exigirUbicacionAntesDeInicio(context);
          if (!mounted) return;
          if (permitido) {
            if (usuario.esBarbero && !usuario.esDueno) {
              context.go(Rutas.qr);
              return;
            }
            context.go(usuario.esDueno ? Rutas.miNegocio : Rutas.inicio);
          }
          _redirigiendoInicio = false;
        },
        perfilIncompleto: (_) => context.go(Rutas.completarPerfil),
        error: (msg) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg))),
        orElse: () {},
      );
    });

    return Scaffold(
      backgroundColor: ColoresApp.terceario,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final anchoCard = math.min(constraints.maxWidth - 34, 620.0);

          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    child: Container(
                      height: constraints.maxHeight * 0.7,
                      decoration: const BoxDecoration(
                        color: ColoresApp.primario,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(74),
                          bottomRight: Radius.circular(74),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 50),
                      const LogoAionStyle(ancho: 360, alto: 180),
                      const SizedBox(height: 8),
                      Center(
                        child: Container(
                          width: anchoCard,
                          margin: const EdgeInsets.only(top: 30, bottom: 12),
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
                          decoration: const BoxDecoration(
                            color: ColoresApp.acento,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(36),
                              topRight: Radius.circular(36),
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Inicia sesión en tu cuenta',
                                  textAlign: TextAlign.center,
                                  style: tema.textTheme.titleLarge?.copyWith(
                                    color: ColoresApp.primario,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                CampoEmail(
                                  controlador: _emailCtrl,
                                  mostrarIcono: true,
                                ),
                                const SizedBox(height: 14),
                                CampoContrasena(
                                  controlador: _contrasenaCtrl,
                                  mostrarIcono: true,
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: estado.maybeWhen(
                                    cargando: () => null,
                                    orElse: () => _loginConCorreo,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(56),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: estado.maybeWhen(
                                    cargando: () => const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: ColoresApp.secundario,
                                      ),
                                    ),
                                    orElse: () => Text(
                                      'Iniciar sesión',
                                      style: tema.textTheme.labelLarge?.copyWith(
                                        color: ColoresApp.primario,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Divider(
                                        color: ColoresApp.primario,
                                        thickness: 1.2,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                      ),
                                      child: Text(
                                        'o',
                                        style:
                                            tema.textTheme.titleMedium?.copyWith(
                                          color: ColoresApp.primario,
                                        ),
                                      ),
                                    ),
                                    const Expanded(
                                      child: Divider(
                                        color: ColoresApp.primario,
                                        thickness: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                BotonGoogle(
                                  onPresionado: estado.maybeWhen(
                                    cargando: () => null,
                                    orElse: () => () => ref
                                        .read(viewModelAuthProvider.notifier)
                                        .loginConGoogle(),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                TextButton(
                                  onPressed: () => context.push(Rutas.registro),
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style:
                                          tema.textTheme.titleMedium?.copyWith(
                                        color: ColoresApp.primario,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 14,
                                      ),
                                      children: const [
                                        TextSpan(text: 'No tienes cuenta? '),
                                        TextSpan(
                                          text: 'Regístrate aquí',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 10,
                    child: Center(
                      child: Visibility(
                        visible: _textoVersion.isNotEmpty,
                        child: Text(
                          _textoVersion,
                          style: tema.textTheme.labelSmall?.copyWith(
                            color: ColoresApp.primario.withValues(alpha: 0.45),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
