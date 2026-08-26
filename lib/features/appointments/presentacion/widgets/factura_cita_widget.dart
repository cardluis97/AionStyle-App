import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../app/theme/colores.dart';

class FacturaCitaWidget extends StatelessWidget {
  const FacturaCitaWidget({
    super.key,
    required this.clienteNombre,
    required this.negocioNombre,
    required this.barberoNombre,
    required this.corte,
    this.servicios,
    required this.precio,
    required this.fecha,
    required this.horaInicio,
    required this.horaFinal,
    required this.metodoPago,
    required this.codigoQr,
    this.mostrarQr = true,
    this.accionesInferiores,
  });

  final String clienteNombre;
  final String negocioNombre;
  final String barberoNombre;
  final String corte;
  final String? servicios;
  final double precio;
  final String fecha;
  final String horaInicio;
  final String horaFinal;
  final String metodoPago;
  final String codigoQr;
  final bool mostrarQr;
  final Widget? accionesInferiores;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColoresApp.secundario,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ColoresApp.terceario.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'FACTURA N° 7',
                style: tema.textTheme.labelLarge?.copyWith(
                  color: ColoresApp.primario,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(
                width: 120,
                height: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/logoNegro.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 10),
          _linea('Cliente', clienteNombre),
          _linea('Negocio', negocioNombre),
          _linea('Barbero', barberoNombre),
          if (servicios != null && servicios!.trim().isNotEmpty)
            _linea('Servicios', servicios!),
          _linea('Corte', corte),
          _linea('Fecha', fecha),
          _linea('Hora de inicio', horaInicio),
          _linea('Hora final', horaFinal),
          _linea('Pago', metodoPago),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL',
                style: tema.textTheme.titleSmall?.copyWith(
                  color: ColoresApp.primario,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Lps ${precio.toStringAsFixed(2)}',
                style: tema.textTheme.titleSmall?.copyWith(
                  color: ColoresApp.primario,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          if (mostrarQr) ...[
            const SizedBox(height: 14),
            Center(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ColoresApp.secundario,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: ColoresApp.terceario.withValues(alpha: 0.2)),
                ),
                child: QrImageView(
                  data: codigoQr,
                  size: 190,
                  eyeStyle: const QrEyeStyle(
                    color: ColoresApp.primario,
                    eyeShape: QrEyeShape.square,
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    color: ColoresApp.primario,
                    dataModuleShape: QrDataModuleShape.square,
                  ),
                  backgroundColor: ColoresApp.secundario,
                ),
              ),
            ),
          ],
          if (accionesInferiores != null) ...[
            const SizedBox(height: 14),
            accionesInferiores!,
          ],
        ],
      ),
    );
  }

  Widget _linea(String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              etiqueta,
              style: const TextStyle(
                color: ColoresApp.primario,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              valor,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: ColoresApp.texto,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
