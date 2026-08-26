import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../app/theme/colores.dart';
import '../../../appointments/presentacion/widgets/factura_cita_widget.dart';
import '../../../auth/presentacion/proveedores/proveedores_auth.dart';

enum FiltroQrBarbero { pendientes, canceladas, historial }
enum PeriodoQrBarbero { dia, semana, mes }
enum EstadoQrCita { pendiente, cancelada, finalizada }

class PaginaQr extends ConsumerStatefulWidget {
  const PaginaQr({super.key});

  @override
  ConsumerState<PaginaQr> createState() => _PaginaQrState();
}

class _PaginaQrState extends ConsumerState<PaginaQr> {
  final MobileScannerController _controlador = MobileScannerController();
  bool _escaneado = false;

  FiltroQrBarbero _filtro = FiltroQrBarbero.pendientes;
  PeriodoQrBarbero _periodo = PeriodoQrBarbero.dia;
  final Set<String> _citasIniciadas = <String>{};
  final Set<String> _citasFinalizadas = <String>{};
  final Set<String> _citasOpinadas = <String>{};

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  void _onDeteccion(BarcodeCapture captura) {
    if (_escaneado) return;
    final codigo = captura.barcodes.firstOrNull?.rawValue;
    if (codigo == null) return;
    _escaneado = true;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('QR detectado: $codigo')),
    );
    Navigator.of(context).pop();
  }

  Future<void> _abrirEscaner() async {
    _escaneado = false;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.86,
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Stack(
            children: [
              MobileScanner(controller: _controlador, onDetect: _onDeteccion),
              Center(
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    border: Border.all(color: ColoresApp.secundario, width: 3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: ColoresApp.secundario),
                ),
              ),
              const Positioned(
                bottom: 28,
                left: 0,
                right: 0,
                child: Text(
                  'Apunta al codigo QR de la cita',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColoresApp.secundario,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final estadoAuth = ref.watch(viewModelAuthProvider);

    final usuario = estadoAuth.maybeWhen(
      autenticado: (usuario) => usuario,
      perfilIncompleto: (usuario) => usuario,
      orElse: () => null,
    );

    final correo = usuario?.correo.trim().toLowerCase() ?? '';
    final usuarioBloqueado = correo == 'usuarioa@aionstyle.com';
    final rolEscaner = (usuario?.esBarbero ?? false) || (usuario?.esDueno ?? false);
    final puedeEscanear = usuario != null && rolEscaner && !usuarioBloqueado;

    final esEmpleadoBarbero = usuario?.esBarbero == true && !(usuario?.esDueno == true);

    if (esEmpleadoBarbero) {
      final citas = _citasPorFiltro();
      return Scaffold(
        backgroundColor: ColoresApp.fondo,
        appBar: AppBar(
          title: const Text('QR y agenda de trabajo'),
          backgroundColor: ColoresApp.primario,
          foregroundColor: ColoresApp.secundario,
          actions: [
            IconButton(
              onPressed: _abrirEscaner,
              icon: const Icon(Icons.qr_code_scanner),
              tooltip: 'Escanear QR',
            ),
            IconButton(
              onPressed: _controlador.toggleTorch,
              icon: const Icon(Icons.flash_on),
              tooltip: 'Linterna',
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Expanded(
                  child: _BotonFiltro(
                    titulo: 'Pendientes',
                    activo: _filtro == FiltroQrBarbero.pendientes,
                    onTap: () => setState(() => _filtro = FiltroQrBarbero.pendientes),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _BotonFiltro(
                    titulo: 'Canceladas',
                    activo: _filtro == FiltroQrBarbero.canceladas,
                    onTap: () => setState(() => _filtro = FiltroQrBarbero.canceladas),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _BotonFiltro(
                    titulo: 'Historial',
                    activo: _filtro == FiltroQrBarbero.historial,
                    onTap: () => setState(() => _filtro = FiltroQrBarbero.historial),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_filtro != FiltroQrBarbero.historial)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _ChipPeriodo(
                    titulo: 'Del dia',
                    activo: _periodo == PeriodoQrBarbero.dia,
                    onTap: () => setState(() => _periodo = PeriodoQrBarbero.dia),
                  ),
                  _ChipPeriodo(
                    titulo: 'De la semana',
                    activo: _periodo == PeriodoQrBarbero.semana,
                    onTap: () => setState(() => _periodo = PeriodoQrBarbero.semana),
                  ),
                  _ChipPeriodo(
                    titulo: 'Del mes',
                    activo: _periodo == PeriodoQrBarbero.mes,
                    onTap: () => setState(() => _periodo = PeriodoQrBarbero.mes),
                  ),
                ],
              )
            else
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ColoresApp.secundario,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: ColoresApp.primario.withValues(alpha: 0.2)),
                ),
                child: const Text(
                  'Historial mensual ordenado de la fecha mas reciente a la mas lejana.',
                  style: TextStyle(
                    color: ColoresApp.texto,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            if (citas.isEmpty)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: ColoresApp.secundario,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ColoresApp.primario.withValues(alpha: 0.2)),
                ),
                child: Text(
                  _mensajeVacio(),
                  style: const TextStyle(color: ColoresApp.primario),
                ),
              )
            else
              ...citas.map(
                (cita) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _TarjetaCitaQr(
                    cita: cita,
                    estado: _estadoActual(cita),
                    enCurso: _citasIniciadas.contains(cita.id) && !_citasFinalizadas.contains(cita.id),
                    onVerDetalle: () => _mostrarDetalleCita(cita),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    if (!puedeEscanear) {
      return Scaffold(
        appBar: AppBar(title: const Text('Escanear QR')),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: esquema.onSurfaceVariant.withValues(alpha: 0.35)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_outline, size: 42, color: esquema.onSurface),
                const SizedBox(height: 12),
                Text(
                  'No tienes permisos para escanear codigos QR.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  usuarioBloqueado
                      ? 'La cuenta usuarioa@aionstyle.com solo puede usar funciones de cliente.'
                      : 'Esta accion esta disponible para roles BARBERO o DUEÑO.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: esquema.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: _controlador.toggleTorch,
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_ios),
            onPressed: _controlador.switchCamera,
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(controller: _controlador, onDetect: _onDeteccion),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: esquema.onSurface, width: 3),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Text(
              'Apunta al código QR de la cita',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: esquema.onSurface,
                    fontSize: 16,
                  ) ??
                  const TextStyle(
                    color: ColoresApp.secundario,
                    fontSize: 16,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  List<_CitaQrVista> _citasBase() {
    final ahora = DateTime.now();
    return [
      _CitaQrVista(
        id: 'qr_b_01',
        clienteNombre: 'Carlos Palma',
        negocioNombre: 'Barberia Central',
        barberoNombre: 'Usuario B',
        corte: 'Fade clasico',
        servicios: 'Corte + lavado',
        precio: 220,
        fechaHora: DateTime(ahora.year, ahora.month, ahora.day, 9, 30),
        duracionMinutos: 45,
        metodoPago: 'Tarjeta',
        codigoQr: 'AIONSTYLE|ROLB|CENTRAL|CARLOSPALMA|FADE',
        estadoBase: EstadoQrCita.pendiente,
      ),
      _CitaQrVista(
        id: 'qr_b_02',
        clienteNombre: 'Marta Solis',
        negocioNombre: 'Barberia Central',
        barberoNombre: 'Usuario B',
        corte: 'Perfilado premium',
        servicios: 'Barba + cejas',
        precio: 280,
        fechaHora: DateTime(ahora.year, ahora.month, ahora.day + 2, 14, 0),
        duracionMinutos: 50,
        metodoPago: 'Efectivo',
        codigoQr: 'AIONSTYLE|ROLB|CENTRAL|MARTASOLIS|PERFILADO',
        estadoBase: EstadoQrCita.pendiente,
      ),
      _CitaQrVista(
        id: 'qr_b_03',
        clienteNombre: 'Ruben Arias',
        negocioNombre: 'Salon Eclipse',
        barberoNombre: 'Usuario B',
        corte: 'Corte ejecutivo',
        servicios: 'Corte ejecutivo',
        precio: 300,
        fechaHora: DateTime(ahora.year, ahora.month, (ahora.day > 1 ? ahora.day - 1 : 1), 11, 15),
        duracionMinutos: 60,
        metodoPago: 'Tarjeta',
        codigoQr: 'AIONSTYLE|ROLB|ECLIPSE|RUBENARIAS|EJECUTIVO',
        estadoBase: EstadoQrCita.cancelada,
      ),
      _CitaQrVista(
        id: 'qr_b_04',
        clienteNombre: 'Evelyn Campos',
        negocioNombre: 'Salon Eclipse',
        barberoNombre: 'Usuario B',
        corte: 'Corte y brushing',
        servicios: 'Corte + brushing',
        precio: 350,
        fechaHora: DateTime(ahora.year, ahora.month, (ahora.day > 4 ? ahora.day - 4 : 1), 10, 0),
        duracionMinutos: 55,
        metodoPago: 'Efectivo',
        codigoQr: 'AIONSTYLE|ROLB|ECLIPSE|EVELYNCAMPOS|BRUSHING',
        estadoBase: EstadoQrCita.finalizada,
      ),
      _CitaQrVista(
        id: 'qr_b_05',
        clienteNombre: 'Kevin Banegas',
        negocioNombre: 'Studio Norte',
        barberoNombre: 'Usuario B',
        corte: 'Diseno freestyle',
        servicios: 'Diseno + barba',
        precio: 400,
        fechaHora: DateTime(ahora.year, ahora.month, 2, 16, 30),
        duracionMinutos: 70,
        metodoPago: 'Tarjeta',
        codigoQr: 'AIONSTYLE|ROLB|NORTE|KEVINB|FREESTYLE',
        estadoBase: EstadoQrCita.finalizada,
      ),
    ];
  }

  EstadoQrCita _estadoActual(_CitaQrVista cita) {
    if (_citasFinalizadas.contains(cita.id)) {
      return EstadoQrCita.finalizada;
    }
    return cita.estadoBase;
  }

  List<_CitaQrVista> _citasPorFiltro() {
    final base = _citasBase();

    if (_filtro == FiltroQrBarbero.historial) {
      final historial = base
          .where((cita) => _estadoActual(cita) == EstadoQrCita.finalizada)
          .where((cita) => _esMismoMes(cita.fechaHora, DateTime.now()))
          .toList()
        ..sort((a, b) => b.fechaHora.compareTo(a.fechaHora));
      return historial;
    }

    final estado = _filtro == FiltroQrBarbero.pendientes
        ? EstadoQrCita.pendiente
        : EstadoQrCita.cancelada;

    return base
        .where((cita) => _estadoActual(cita) == estado)
        .where((cita) => _coincidePeriodo(cita.fechaHora))
        .toList()
      ..sort((a, b) => a.fechaHora.compareTo(b.fechaHora));
  }

  bool _coincidePeriodo(DateTime fecha) {
    final ahora = DateTime.now();
    switch (_periodo) {
      case PeriodoQrBarbero.dia:
        return _esMismoDia(fecha, ahora);
      case PeriodoQrBarbero.semana:
        final inicio = _inicioSemana(ahora);
        final fin = inicio.add(const Duration(days: 7));
        return !fecha.isBefore(inicio) && fecha.isBefore(fin);
      case PeriodoQrBarbero.mes:
        return _esMismoMes(fecha, ahora);
    }
  }

  DateTime _inicioSemana(DateTime fecha) {
    final soloDia = DateTime(fecha.year, fecha.month, fecha.day);
    return soloDia.subtract(Duration(days: soloDia.weekday - DateTime.monday));
  }

  bool _esMismoDia(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _esMismoMes(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month;
  }

  String _mensajeVacio() {
    switch (_filtro) {
      case FiltroQrBarbero.pendientes:
        return 'No hay citas pendientes para el periodo seleccionado.';
      case FiltroQrBarbero.canceladas:
        return 'No hay citas canceladas para el periodo seleccionado.';
      case FiltroQrBarbero.historial:
        return 'Aun no hay historial finalizado este mes.';
    }
  }

  Future<void> _mostrarDetalleCita(_CitaQrVista cita) async {
    final estado = _estadoActual(cita);
    final enCurso = _citasIniciadas.contains(cita.id) && !_citasFinalizadas.contains(cita.id);
    final puedeOperar = estado == EstadoQrCita.pendiente;
    final yaOpino = _citasOpinadas.contains(cita.id);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.6,
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
                    clienteNombre: cita.clienteNombre,
                    negocioNombre: cita.negocioNombre,
                    barberoNombre: cita.barberoNombre,
                    corte: cita.corte,
                    servicios: cita.servicios,
                    precio: cita.precio,
                    fecha: _formatearFecha(cita.fechaHora),
                    horaInicio: _formatearHora(cita.fechaHora),
                    horaFinal: _formatearHora(cita.fechaHora.add(Duration(minutes: cita.duracionMinutos))),
                    metodoPago: cita.metodoPago,
                    codigoQr: cita.codigoQr,
                    mostrarQr: false,
                    accionesInferiores: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _abrirEscaner();
                                },
                                icon: const Icon(Icons.qr_code_scanner),
                                label: const Text('Escanear'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: ColoresApp.primario,
                                  side: const BorderSide(color: ColoresApp.primario),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: !puedeOperar
                                    ? null
                                    : () {
                                        Navigator.of(context).pop();
                                        setState(() {
                                          if (enCurso) {
                                            _citasFinalizadas.add(cita.id);
                                          } else {
                                            _citasIniciadas.add(cita.id);
                                          }
                                        });
                                        ScaffoldMessenger.of(this.context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              enCurso
                                                  ? 'Corte finalizado para ${cita.clienteNombre}.'
                                                  : 'Corte iniciado para ${cita.clienteNombre}.',
                                            ),
                                          ),
                                        );
                                      },
                                icon: Icon(enCurso ? Icons.stop_circle : Icons.play_circle),
                                label: Text(enCurso ? 'Finalizar corte' : 'Empezar corte'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColoresApp.primario,
                                  foregroundColor: ColoresApp.secundario,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (estado == EstadoQrCita.finalizada)
                          ElevatedButton.icon(
                            onPressed: yaOpino
                                ? null
                                : () {
                                    Navigator.of(context).pop();
                                    _mostrarModalOpinarCliente(cita);
                                  },
                            icon: const Icon(Icons.star_rate_rounded),
                            label: Text(yaOpino ? 'Opinion enviada' : 'Opinar sobre cliente'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColoresApp.dorado,
                              foregroundColor: ColoresApp.primario,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _mostrarModalOpinarCliente(_CitaQrVista cita) async {
    var estrellas = 0;
    final valor = await showDialog<int>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Opinar sobre ${cita.clienteNombre}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Selecciona de 1 a 5 estrellas'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: List.generate(5, (index) {
                      final activa = index < estrellas;
                      return IconButton(
                        onPressed: () => setDialogState(() => estrellas = index + 1),
                        icon: Icon(
                          activa ? Icons.star : Icons.star_outline,
                          color: activa ? ColoresApp.dorado : ColoresApp.textoClaro,
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
                  onPressed: estrellas == 0 ? null : () => Navigator.of(context).pop(estrellas),
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );

    if (!mounted || valor == null) return;

    setState(() {
      _citasOpinadas.add(cita.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opinion enviada para ${cita.clienteNombre}: $valor estrellas.'),
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    return '$dia/$mes/${fecha.year}';
  }

  String _formatearHora(DateTime fecha) {
    final hora = fecha.hour % 12 == 0 ? 12 : fecha.hour % 12;
    final minutos = fecha.minute.toString().padLeft(2, '0');
    final sufijo = fecha.hour >= 12 ? 'PM' : 'AM';
    return '$hora:$minutos $sufijo';
  }
}

class _TarjetaCitaQr extends StatelessWidget {
  const _TarjetaCitaQr({
    required this.cita,
    required this.estado,
    required this.enCurso,
    required this.onVerDetalle,
  });

  final _CitaQrVista cita;
  final EstadoQrCita estado;
  final bool enCurso;
  final VoidCallback onVerDetalle;

  @override
  Widget build(BuildContext context) {
    final estadoTexto = switch (estado) {
      EstadoQrCita.pendiente => enCurso ? 'En curso' : 'Pendiente',
      EstadoQrCita.cancelada => 'Cancelada',
      EstadoQrCita.finalizada => 'Finalizada',
    };

    final colorEstado = switch (estado) {
      EstadoQrCita.pendiente => enCurso ? ColoresApp.advertencia : ColoresApp.exito,
      EstadoQrCita.cancelada => ColoresApp.error,
      EstadoQrCita.finalizada => ColoresApp.primario,
    };

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColoresApp.secundario,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColoresApp.primario.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  cita.clienteNombre,
                  style: const TextStyle(
                    color: ColoresApp.primario,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorEstado.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: colorEstado.withValues(alpha: 0.45)),
                ),
                child: Text(
                  estadoTexto,
                  style: TextStyle(
                    color: colorEstado,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            '${cita.negocioNombre} | ${cita.corte}',
            style: const TextStyle(color: ColoresApp.texto, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            'Fecha: ${_formatearFecha(cita.fechaHora)}  ${_formatearHora(cita.fechaHora)}',
            style: const TextStyle(color: ColoresApp.textoClaro),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onVerDetalle,
              style: OutlinedButton.styleFrom(
                foregroundColor: ColoresApp.primario,
                side: const BorderSide(color: ColoresApp.primario),
              ),
              child: const Text('Ver detalle'),
            ),
          ),
        ],
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    return '$dia/$mes/${fecha.year}';
  }

  String _formatearHora(DateTime fecha) {
    final hora = fecha.hour % 12 == 0 ? 12 : fecha.hour % 12;
    final minutos = fecha.minute.toString().padLeft(2, '0');
    final sufijo = fecha.hour >= 12 ? 'PM' : 'AM';
    return '$hora:$minutos $sufijo';
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
    return Material(
      color: activo ? ColoresApp.primario : ColoresApp.secundario,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ColoresApp.primario),
          ),
          child: Center(
            child: Text(
              titulo,
              style: TextStyle(
                color: activo ? ColoresApp.secundario : ColoresApp.primario,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChipPeriodo extends StatelessWidget {
  const _ChipPeriodo({
    required this.titulo,
    required this.activo,
    required this.onTap,
  });

  final String titulo;
  final bool activo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      selected: activo,
      onSelected: (_) => onTap(),
      label: Text(titulo),
      selectedColor: ColoresApp.primario,
      backgroundColor: ColoresApp.secundario,
      side: const BorderSide(color: ColoresApp.primario),
      labelStyle: TextStyle(
        color: activo ? ColoresApp.secundario : ColoresApp.primario,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _CitaQrVista {
  const _CitaQrVista({
    required this.id,
    required this.clienteNombre,
    required this.negocioNombre,
    required this.barberoNombre,
    required this.corte,
    this.servicios,
    required this.precio,
    required this.fechaHora,
    required this.duracionMinutos,
    required this.metodoPago,
    required this.codigoQr,
    required this.estadoBase,
  });

  final String id;
  final String clienteNombre;
  final String negocioNombre;
  final String barberoNombre;
  final String corte;
  final String? servicios;
  final double precio;
  final DateTime fechaHora;
  final int duracionMinutos;
  final String metodoPago;
  final String codigoQr;
  final EstadoQrCita estadoBase;
}
