import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/enrutador.dart';
import '../../../../app/theme/colores.dart';
import '../../../auth/presentacion/proveedores/proveedores_auth.dart';
import '../widgets/factura_cita_widget.dart';

class PaginaConfirmacionCita extends ConsumerStatefulWidget {
  const PaginaConfirmacionCita({
    super.key,
    required this.negocioNombre,
    required this.barberoNombre,
    required this.corte,
    required this.servicios,
    required this.precio,
    required this.fecha,
    required this.hora,
    required this.metodoPago,
    required this.codigoQr,
  });

  final String negocioNombre;
  final String barberoNombre;
  final String corte;
  final String servicios;
  final double precio;
  final String fecha;
  final String hora;
  final String metodoPago;
  final String codigoQr;

  @override
  ConsumerState<PaginaConfirmacionCita> createState() => _PaginaConfirmacionCitaState();
}

class _PaginaConfirmacionCitaState extends ConsumerState<PaginaConfirmacionCita> {
  Timer? _temporizador;
  int _segundos = 15;

  String get _rutaCitasConDatos {
    return '${Rutas.citas}?negocio=${Uri.encodeComponent(widget.negocioNombre)}&barbero=${Uri.encodeComponent(widget.barberoNombre)}&corte=${Uri.encodeComponent(widget.corte)}&servicios=${Uri.encodeComponent(widget.servicios)}&precio=${widget.precio.toStringAsFixed(2)}&fecha=${Uri.encodeComponent(widget.fecha)}&hora=${Uri.encodeComponent(widget.hora)}&pago=${Uri.encodeComponent(widget.metodoPago)}&qr=${Uri.encodeComponent(widget.codigoQr)}';
  }

  @override
  void initState() {
    super.initState();
    _temporizador = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_segundos <= 1) {
        timer.cancel();
        context.go(_rutaCitasConDatos);
        return;
      }
      setState(() {
        _segundos -= 1;
      });
    });
  }

  @override
  void dispose() {
    _temporizador?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final estadoAuth = ref.watch(viewModelAuthProvider);
    final clienteNombre = estadoAuth.maybeWhen(
      autenticado: (usuario) => usuario.nombreCompleto,
      perfilIncompleto: (usuario) => usuario.nombreCompleto,
      orElse: () => 'Cliente',
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Factura de cita')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FacturaCitaWidget(
            clienteNombre: clienteNombre,
            negocioNombre: widget.negocioNombre,
            barberoNombre: widget.barberoNombre,
            corte: widget.corte,
            servicios: widget.servicios,
            precio: widget.precio,
            fecha: widget.fecha,
            hora: widget.hora,
            metodoPago: widget.metodoPago,
            codigoQr: widget.codigoQr,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: ColoresApp.fondo,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: ColoresApp.terceario.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.schedule, size: 16, color: ColoresApp.terceario),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Redireccion a Mis Citas en $_segundos s',
                    style: tema.textTheme.bodySmall?.copyWith(
                      color: ColoresApp.textoClaro,
                      fontSize: 11,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => context.go(_rutaCitasConDatos),
                  child: const Text('Ir ahora'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
