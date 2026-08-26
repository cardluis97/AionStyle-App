import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/colores.dart';
import '../../../auth/presentacion/proveedores/proveedores_auth.dart';
import '../widgets/factura_cita_widget.dart';

enum FiltroCitas { pendientes, canceladas, historial }
enum EstadoCitaVista { pendiente, cancelada, finalizada }

class PaginaCitas extends ConsumerStatefulWidget {
  const PaginaCitas({
    super.key,
    this.negocioNombre,
    this.barberoNombre,
    this.corte,
    this.servicios,
    this.precio,
    this.fecha,
    this.hora,
    this.horaInicio,
    this.horaFin,
    this.metodoPago,
    this.codigoQr,
  });

  final String? negocioNombre;
  final String? barberoNombre;
  final String? corte;
  final String? servicios;
  final double? precio;
  final String? fecha;
  final String? hora;
  final String? horaInicio;
  final String? horaFin;
  final String? metodoPago;
  final String? codigoQr;

  @override
  ConsumerState<PaginaCitas> createState() => _PaginaCitasState();
}

class _PaginaCitasState extends ConsumerState<PaginaCitas> {
  FiltroCitas _filtro = FiltroCitas.pendientes;

  bool get _tieneCitaEnviada {
    return widget.negocioNombre != null &&
        widget.barberoNombre != null &&
        widget.corte != null &&
        widget.precio != null &&
        widget.fecha != null &&
          (widget.horaInicio != null || widget.hora != null) &&
        widget.metodoPago != null &&
        widget.codigoQr != null;
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final esquema = tema.colorScheme;
    final estadoAuth = ref.watch(viewModelAuthProvider);
    final clienteNombre = estadoAuth.maybeWhen(
      autenticado: (usuario) => usuario.nombreCompleto,
      perfilIncompleto: (usuario) => usuario.nombreCompleto,
      orElse: () => 'Cliente',
    );

    final citas = _citasPorFiltro();

    return Scaffold(
      backgroundColor: ColoresApp.secundario,
      appBar: AppBar(
        title: const Text('Mis Citas'),
        backgroundColor: ColoresApp.primario,
        foregroundColor: ColoresApp.secundario,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: _BotonFiltro(
                  titulo: 'Pendientes',
                  activo: _filtro == FiltroCitas.pendientes,
                  onTap: () => setState(() => _filtro = FiltroCitas.pendientes),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _BotonFiltro(
                  titulo: 'Canceladas',
                  activo: _filtro == FiltroCitas.canceladas,
                  onTap: () => setState(() => _filtro = FiltroCitas.canceladas),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _BotonFiltro(
                  titulo: 'Historial',
                  activo: _filtro == FiltroCitas.historial,
                  onTap: () => setState(() => _filtro = FiltroCitas.historial),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (citas.isEmpty)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: ColoresApp.secundario,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ColoresApp.primario.withValues(alpha: 0.18),
                ),
              ),
              child: Text(
                _mensajeVacio(),
                style: tema.textTheme.bodyMedium?.copyWith(
                  color: ColoresApp.primario,
                ),
              ),
            )
          else
            ...citas.map(
              (cita) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _TarjetaCita(
                  cita: cita,
                  soloDetalle: _filtro == FiltroCitas.historial,
                  onVerDetalle: () => _mostrarDetalleFactura(
                    context: context,
                    clienteNombre: clienteNombre,
                    cita: cita,
                  ),
                  onOpinar: _filtro == FiltroCitas.historial
                      ? null
                      : () => _mostrarModalOpinar(cita),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<_CitaVista> _citasPorFiltro() {
    final base = <_CitaVista>[
      if (_tieneCitaEnviada)
        _CitaVista(
          negocioNombre: widget.negocioNombre!,
          barberoNombre: widget.barberoNombre!,
          corte: widget.corte!,
          servicios: widget.servicios,
          precio: widget.precio!,
          fecha: widget.fecha!,
          horaInicio: widget.horaInicio ?? widget.hora!,
          horaFin: widget.horaFin ?? 'Pendiente',
          metodoPago: widget.metodoPago!,
          codigoQr: widget.codigoQr!,
          imagenUrl: 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?auto=format&fit=crop&w=120&q=60',
          estado: EstadoCitaVista.pendiente,
        ),
      const _CitaVista(
        negocioNombre: 'Barberia Central',
        barberoNombre: 'Carlos Mendez',
        corte: 'Fade Clasico',
        servicios: 'Corte clasico',
        precio: 18,
        fecha: '22/08/2026',
        horaInicio: '10:30 AM',
        horaFin: '11:05 AM',
        metodoPago: 'Efectivo',
        codigoQr: 'AIONSTYLE|DEMO|CENTRAL|CARLOS|FADE|22/08/2026|10:30 AM|11:05 AM|35|18.00',
        imagenUrl: 'https://images.unsplash.com/photo-1621605815971-fbc98d665033?auto=format&fit=crop&w=120&q=60',
        estado: EstadoCitaVista.pendiente,
      ),
      const _CitaVista(
        negocioNombre: 'Salon Eclipse',
        barberoNombre: 'Andrea Ruiz',
        corte: 'Perfilado Premium',
        servicios: 'Diseno de barba',
        precio: 24,
        fecha: '25/08/2026',
        horaInicio: '4:00 PM',
        horaFin: '4:50 PM',
        metodoPago: 'Visa',
        codigoQr: 'AIONSTYLE|DEMO|ECLIPSE|ANDREA|PERFILADO|25/08/2026|4:00 PM|4:50 PM|50|24.00',
        imagenUrl: 'https://images.unsplash.com/photo-1519415510236-718bdfcd89c8?auto=format&fit=crop&w=120&q=60',
        estado: EstadoCitaVista.cancelada,
      ),
      const _CitaVista(
        negocioNombre: 'Studio Norte',
        barberoNombre: 'Luis Paredes',
        corte: 'Corte y barba',
        servicios: 'Corte ejecutivo | Perfilado de barba',
        precio: 21,
        fecha: '11/08/2026',
        horaInicio: '12:00 PM',
        horaFin: '12:55 PM',
        metodoPago: 'Efectivo',
        codigoQr: 'AIONSTYLE|DEMO|NORTE|LUIS|CORTEYBARBA|11/08/2026|12:00 PM|12:55 PM|55|21.00',
        imagenUrl: 'https://images.unsplash.com/photo-1599351431202-1e0f0137899a?auto=format&fit=crop&w=120&q=60',
        estado: EstadoCitaVista.finalizada,
      ),
    ];

    switch (_filtro) {
      case FiltroCitas.pendientes:
        return base.where((c) => c.estado == EstadoCitaVista.pendiente).toList();
      case FiltroCitas.canceladas:
        return base.where((c) => c.estado == EstadoCitaVista.cancelada).toList();
      case FiltroCitas.historial:
        return base.where((c) => c.estado == EstadoCitaVista.finalizada).toList();
    }
  }

  String _mensajeVacio() {
    switch (_filtro) {
      case FiltroCitas.pendientes:
        return 'No tienes citas pendientes por ahora.';
      case FiltroCitas.canceladas:
        return 'No tienes citas canceladas por ahora.';
      case FiltroCitas.historial:
        return 'Aun no hay citas en historial.';
    }
  }

  Future<void> _mostrarDetalleFactura({
    required BuildContext context,
    required String clienteNombre,
    required _CitaVista cita,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.55,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, controlador) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: ListView(
                controller: controlador,
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                children: [
                  Center(
                    child: Container(
                      width: 46,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: ColoresApp.terceario.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  FacturaCitaWidget(
                    clienteNombre: clienteNombre,
                    negocioNombre: cita.negocioNombre,
                    barberoNombre: cita.barberoNombre,
                    corte: cita.corte,
                    servicios: cita.servicios,
                    precio: cita.precio,
                    fecha: cita.fecha,
                    horaInicio: cita.horaInicio,
                    horaFinal: cita.horaFin,
                    metodoPago: cita.metodoPago,
                    codigoQr: cita.codigoQr,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _mostrarModalOpinar(_CitaVista cita) async {
    var estrellas = 0;
    final tema = Theme.of(context);
    final esquema = tema.colorScheme;

    final valor = await showDialog<int>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Opinar sobre ${cita.barberoNombre}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Selecciona de 1 a 5 estrellas',
                    style: tema.textTheme.bodySmall?.copyWith(
                      color: esquema.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    children: List.generate(5, (index) {
                      final activa = index < estrellas;
                      return IconButton(
                        onPressed: () {
                          setDialogState(() {
                            estrellas = index + 1;
                          });
                        },
                        icon: Icon(
                          activa ? Icons.star : Icons.star_outline,
                          color: activa ? ColoresApp.dorado : esquema.onSurfaceVariant,
                        ),
                      );
                    }),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: estrellas == 0
                      ? null
                      : () => Navigator.of(context).pop(estrellas),
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );

    if (!mounted || valor == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calificacion enviada: $valor estrellas para ${cita.barberoNombre}.'),
      ),
    );
  }
}

class _TarjetaCita extends StatelessWidget {
  const _TarjetaCita({
    required this.cita,
    required this.soloDetalle,
    required this.onVerDetalle,
    required this.onOpinar,
  });

  final _CitaVista cita;
  final bool soloDetalle;
  final VoidCallback onVerDetalle;
  final VoidCallback? onOpinar;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColoresApp.secundario,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ColoresApp.primario.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: ColoresApp.fondo,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    cita.imagenUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [ColoresApp.primario, ColoresApp.terceario],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.content_cut,
                            color: ColoresApp.secundario,
                            size: 24,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cita.negocioNombre,
                      style: tema.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: ColoresApp.primario,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Fecha: ${cita.fecha}  ${cita.horaInicio} - ${cita.horaFin}',
                      style: tema.textTheme.bodySmall?.copyWith(
                        color: ColoresApp.textoClaro,
                      ),
                    ),
                    Text(
                      'Corte: ${cita.corte}',
                      style: tema.textTheme.bodySmall?.copyWith(
                        color: ColoresApp.textoClaro,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Lps ${cita.precio.toStringAsFixed(2)}',
                style: tema.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: ColoresApp.primario,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onVerDetalle,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ColoresApp.primario,
                    side: const BorderSide(color: ColoresApp.primario),
                  ),
                  child: const Text('Ver detalle'),
                ),
              ),
              if (!soloDetalle) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onOpinar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColoresApp.primario,
                      foregroundColor: ColoresApp.secundario,
                    ),
                    child: const Text('Opinar'),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _BotonFiltro extends StatelessWidget {
  const _BotonFiltro({
    required this.titulo,
    required this.activo,
    required this.onTap,
  });

  final String titulo;
  final bool activo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Material(
      color: activo
          ? ColoresApp.primario
          : ColoresApp.secundario,
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ColoresApp.primario, width: 1),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text(
                titulo,
                style: tema.textTheme.labelLarge?.copyWith(
                  color: activo ? ColoresApp.secundario : ColoresApp.primario,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CitaVista {
  const _CitaVista({
    required this.negocioNombre,
    required this.barberoNombre,
    required this.corte,
    this.servicios,
    required this.precio,
    required this.fecha,
    required this.horaInicio,
    required this.horaFin,
    required this.metodoPago,
    required this.codigoQr,
    required this.imagenUrl,
    required this.estado,
  });

  final String negocioNombre;
  final String barberoNombre;
  final String corte;
  final String? servicios;
  final double precio;
  final String fecha;
  final String horaInicio;
  final String horaFin;
  final String metodoPago;
  final String codigoQr;
  final String imagenUrl;
  final EstadoCitaVista estado;
}
