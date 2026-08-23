import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/enrutador.dart';
import '../../../../app/theme/colores.dart';
import '../../../auth/dominio/entidades/rol_usuario.dart';
import '../../../auth/presentacion/proveedores/proveedores_auth.dart';

class PaginaFirmaContratoDueno extends ConsumerStatefulWidget {
  const PaginaFirmaContratoDueno({super.key});

  @override
  ConsumerState<PaginaFirmaContratoDueno> createState() =>
      _PaginaFirmaContratoDuenoState();
}

class _PaginaFirmaContratoDuenoState
    extends ConsumerState<PaginaFirmaContratoDueno> {
  bool _aceptaContrato = false;
  bool _enviando = false;
  final List<Offset?> _puntosFirma = [];

  bool get _tieneFirma {
    return _puntosFirma.any((punto) => punto != null);
  }

  bool get _puedeEnviar {
    return _aceptaContrato && _tieneFirma && !_enviando;
  }

  Future<void> _enviarRevision() async {
    if (!_aceptaContrato) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes aceptar el contrato.')),
      );
      return;
    }
    if (!_tieneFirma) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes colocar tu firma digital.')),
      );
      return;
    }

    setState(() => _enviando = true);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    ref.read(viewModelAuthProvider.notifier).activarRol(RolUsuario.dueno);

    setState(() => _enviando = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contrato enviado a revision correctamente.')),
    );
    context.go(Rutas.miNegocio);
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      appBar: AppBar(
        title: const Text('Firma de contrato'),
        backgroundColor: ColoresApp.primario,
        foregroundColor: ColoresApp.secundario,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Text(
              'Contrato de afiliacion',
              style: tema.textTheme.titleMedium?.copyWith(
                color: ColoresApp.primario,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 360,
              decoration: BoxDecoration(
                color: ColoresApp.secundario,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: ColoresApp.terceario),
                boxShadow: [
                  BoxShadow(
                    color: ColoresApp.primario.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.picture_as_pdf,
                    size: 54,
                    color: ColoresApp.error,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Vista previa PDF',
                    style: tema.textTheme.titleSmall?.copyWith(
                      color: ColoresApp.primario,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Aqui se mostrara el contrato real en PDF en la siguiente etapa.',
                      textAlign: TextAlign.center,
                      style: tema.textTheme.bodyMedium?.copyWith(
                        color: ColoresApp.textoClaro,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Checkbox(
                    value: _aceptaContrato,
                    activeColor: ColoresApp.primario,
                    checkColor: ColoresApp.secundario,
                    side: const BorderSide(
                      color: ColoresApp.primario,
                      width: 1.6,
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    onChanged: (valor) {
                      setState(() => _aceptaContrato = valor ?? false);
                    },
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Confirmo que lei y acepto los terminos del contrato.',
                    style: tema.textTheme.bodySmall?.copyWith(
                      color: ColoresApp.textoClaro,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Firma digital del dueño',
                    style: tema.textTheme.titleSmall?.copyWith(
                      color: ColoresApp.primario,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() => _puntosFirma.clear());
                  },
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('Limpiar'),
                  style: TextButton.styleFrom(
                    foregroundColor: ColoresApp.primario,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 220,
              decoration: BoxDecoration(
                color: ColoresApp.secundario,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: ColoresApp.terceario,
                  width: 1.2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: GestureDetector(
                  onPanStart: (detalle) {
                    setState(() {
                      _puntosFirma.add(detalle.localPosition);
                    });
                  },
                  onPanUpdate: (detalle) {
                    setState(() {
                      _puntosFirma.add(detalle.localPosition);
                    });
                  },
                  onPanEnd: (_) {
                    setState(() {
                      _puntosFirma.add(null);
                    });
                  },
                  child: CustomPaint(
                    painter: _FirmaPainter(
                      puntos: _puntosFirma,
                      colorTrazo: ColoresApp.texto,
                    ),
                    child: _tieneFirma
                        ? null
                        : Center(
                            child: Text(
                              'Dibuja tu firma aqui',
                              style: tema.textTheme.bodyMedium?.copyWith(
                                color: ColoresApp.textoClaro,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: _puedeEnviar ? _enviarRevision : null,
              icon: _enviando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send_outlined),
              label: Text(_enviando ? 'Enviando...' : 'Enviar a revision'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColoresApp.primario,
                foregroundColor: ColoresApp.secundario,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FirmaPainter extends CustomPainter {
  _FirmaPainter({required this.puntos, required this.colorTrazo});

  final List<Offset?> puntos;
  final Color colorTrazo;

  @override
  void paint(Canvas canvas, Size size) {
    final pincel = Paint()
      ..color = colorTrazo
      ..blendMode = BlendMode.srcOver
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < puntos.length - 1; i++) {
      final puntoActual = puntos[i];
      final puntoSiguiente = puntos[i + 1];
      if (puntoActual != null && puntoSiguiente != null) {
        canvas.drawLine(puntoActual, puntoSiguiente, pincel);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _FirmaPainter oldDelegate) {
    return oldDelegate.puntos != puntos || oldDelegate.colorTrazo != colorTrazo;
  }
}
