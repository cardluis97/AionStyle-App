import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/enrutador.dart';
import '../../../../app/theme/colores.dart';
import '../../../appointments/presentacion/widgets/factura_cita_widget.dart';
import '../../../auth/presentacion/proveedores/proveedores_auth.dart';

enum FiltroAgendaBarbero { pendientes, canceladas, historial }
enum PeriodoAgendaBarbero { dia, semana, mes }
enum EstadoAgendaBarbero { pendiente, cancelada, finalizada }

class PaginaModoBarbero extends ConsumerStatefulWidget {
  const PaginaModoBarbero({super.key});

  @override
  ConsumerState<PaginaModoBarbero> createState() => _PaginaModoBarberoState();
}

class _PaginaModoBarberoState extends ConsumerState<PaginaModoBarbero> {
  FiltroAgendaBarbero _filtro = FiltroAgendaBarbero.pendientes;
  PeriodoAgendaBarbero _periodo = PeriodoAgendaBarbero.dia;

  final Set<String> _citasIniciadas = <String>{};
  final Set<String> _citasFinalizadas = <String>{};
  final Set<String> _citasOpinadas = <String>{};

  @override
  Widget build(BuildContext context) {
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

    final citas = _citasPorFiltro();
    final pendientes = _citasPorEstado(EstadoAgendaBarbero.pendiente).length;
    final enCurso = _citasPorEstado(EstadoAgendaBarbero.pendiente)
        .where((cita) =>
            _citasIniciadas.contains(cita.id) && !_citasFinalizadas.contains(cita.id))
        .length;
    final finalizadasMes = _citasPorEstado(EstadoAgendaBarbero.finalizada)
        .where((cita) => _esMismoMes(cita.fechaHora, DateTime.now()))
        .length;

    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      appBar: AppBar(
        title: const Text('Rol B | Barbero y estilista'),
        backgroundColor: ColoresApp.primario,
        foregroundColor: ColoresApp.secundario,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: _ResumenKpi(
                  titulo: 'Pendientes',
                  valor: pendientes.toString(),
                  icono: Icons.schedule,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ResumenKpi(
                  titulo: 'En curso',
                  valor: enCurso.toString(),
                  icono: Icons.cut,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ResumenKpi(
                  titulo: 'Historial mes',
                  valor: finalizadasMes.toString(),
                  icono: Icons.history,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _BotonFiltro(
                  titulo: 'Pendientes',
                  activo: _filtro == FiltroAgendaBarbero.pendientes,
                  onTap: () => setState(() => _filtro = FiltroAgendaBarbero.pendientes),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _BotonFiltro(
                  titulo: 'Canceladas',
                  activo: _filtro == FiltroAgendaBarbero.canceladas,
                  onTap: () => setState(() => _filtro = FiltroAgendaBarbero.canceladas),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _BotonFiltro(
                  titulo: 'Historial',
                  activo: _filtro == FiltroAgendaBarbero.historial,
                  onTap: () => setState(() => _filtro = FiltroAgendaBarbero.historial),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_filtro != FiltroAgendaBarbero.historial)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ChipPeriodo(
                  titulo: 'Del dia',
                  activo: _periodo == PeriodoAgendaBarbero.dia,
                  onTap: () => setState(() => _periodo = PeriodoAgendaBarbero.dia),
                ),
                _ChipPeriodo(
                  titulo: 'De la semana',
                  activo: _periodo == PeriodoAgendaBarbero.semana,
                  onTap: () => setState(() => _periodo = PeriodoAgendaBarbero.semana),
                ),
                _ChipPeriodo(
                  titulo: 'Del mes',
                  activo: _periodo == PeriodoAgendaBarbero.mes,
                  onTap: () => setState(() => _periodo = PeriodoAgendaBarbero.mes),
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
                child: _TarjetaAgendaBarbero(
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

  List<_CitaBarberoVista> _citasBase() {
    final ahora = DateTime.now();
    return [
      _CitaBarberoVista(
        id: 'cita_b_01',
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
        estadoBase: EstadoAgendaBarbero.pendiente,
      ),
      _CitaBarberoVista(
        id: 'cita_b_02',
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
        estadoBase: EstadoAgendaBarbero.pendiente,
      ),
      _CitaBarberoVista(
        id: 'cita_b_03',
        clienteNombre: 'Ruben Arias',
        negocioNombre: 'Salon Eclipse',
        barberoNombre: 'Usuario B',
        corte: 'Corte ejecutivo',
        servicios: 'Corte ejecutivo',
        precio: 300,
        fechaHora: DateTime(ahora.year, ahora.month, ahora.day - 1, 11, 15),
        duracionMinutos: 60,
        metodoPago: 'Tarjeta',
        codigoQr: 'AIONSTYLE|ROLB|ECLIPSE|RUBENARIAS|EJECUTIVO',
        estadoBase: EstadoAgendaBarbero.cancelada,
      ),
      _CitaBarberoVista(
        id: 'cita_b_04',
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
        estadoBase: EstadoAgendaBarbero.finalizada,
      ),
      _CitaBarberoVista(
        id: 'cita_b_05',
        clienteNombre: 'Kevin Banegas',
        negocioNombre: 'Studio Norte',
        barberoNombre: 'Usuario B',
        corte: 'Diseno freestyle',
        servicios: 'Diseno + barba',
        precio: 400,
        fechaHora: DateTime(ahora.year, ahora.month - 1, 18, 16, 30),
        duracionMinutos: 70,
        metodoPago: 'Tarjeta',
        codigoQr: 'AIONSTYLE|ROLB|NORTE|KEVINB|FREESTYLE',
        estadoBase: EstadoAgendaBarbero.finalizada,
      ),
    ];
  }

  List<_CitaBarberoVista> _citasPorEstado(EstadoAgendaBarbero estado) {
    return _citasBase().where((cita) => _estadoActual(cita) == estado).toList();
  }

  List<_CitaBarberoVista> _citasPorFiltro() {
    final base = _citasBase();

    if (_filtro == FiltroAgendaBarbero.historial) {
      final historial = base
          .where((cita) => _estadoActual(cita) == EstadoAgendaBarbero.finalizada)
          .where((cita) => _esMismoMes(cita.fechaHora, DateTime.now()))
          .toList()
        ..sort((a, b) => b.fechaHora.compareTo(a.fechaHora));
      return historial;
    }

    final estado = _filtro == FiltroAgendaBarbero.pendientes
        ? EstadoAgendaBarbero.pendiente
        : EstadoAgendaBarbero.cancelada;

    return base
        .where((cita) => _estadoActual(cita) == estado)
        .where((cita) => _coincidePeriodo(cita.fechaHora))
        .toList()
      ..sort((a, b) => a.fechaHora.compareTo(b.fechaHora));
  }

  EstadoAgendaBarbero _estadoActual(_CitaBarberoVista cita) {
    if (_citasFinalizadas.contains(cita.id)) {
      return EstadoAgendaBarbero.finalizada;
    }
    return cita.estadoBase;
  }

  bool _coincidePeriodo(DateTime fecha) {
    final ahora = DateTime.now();
    switch (_periodo) {
      case PeriodoAgendaBarbero.dia:
        return _esMismoDia(fecha, ahora);
      case PeriodoAgendaBarbero.semana:
        final inicio = _inicioSemana(ahora);
        final fin = inicio.add(const Duration(days: 7));
        return !fecha.isBefore(inicio) && fecha.isBefore(fin);
      case PeriodoAgendaBarbero.mes:
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
      case FiltroAgendaBarbero.pendientes:
        return 'No hay citas pendientes para el periodo seleccionado.';
      case FiltroAgendaBarbero.canceladas:
        return 'No hay citas canceladas para el periodo seleccionado.';
      case FiltroAgendaBarbero.historial:
        return 'Aun no hay historial finalizado este mes.';
    }
  }

  Future<void> _mostrarDetalleCita(_CitaBarberoVista cita) async {
    final estado = _estadoActual(cita);
    final enCurso = _citasIniciadas.contains(cita.id) && !_citasFinalizadas.contains(cita.id);
    final puedeOperar = estado == EstadoAgendaBarbero.pendiente;
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
                                  this.context.push(Rutas.qr);
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
                        if (estado == EstadoAgendaBarbero.finalizada) ...[
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

  Future<void> _mostrarModalOpinarCliente(_CitaBarberoVista cita) async {
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

class _ResumenKpi extends StatelessWidget {
  const _ResumenKpi({
    required this.titulo,
    required this.valor,
    required this.icono,
  });

  final String titulo;
  final String valor;
  final IconData icono;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ColoresApp.secundario,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ColoresApp.primario.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          Icon(icono, color: ColoresApp.primario, size: 18),
          const SizedBox(height: 4),
          Text(
            valor,
            style: const TextStyle(
              color: ColoresApp.primario,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: ColoresApp.textoClaro,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaAgendaBarbero extends StatelessWidget {
  const _TarjetaAgendaBarbero({
    required this.cita,
    required this.estado,
    required this.enCurso,
    required this.onVerDetalle,
  });

  final _CitaBarberoVista cita;
  final EstadoAgendaBarbero estado;
  final bool enCurso;
  final VoidCallback onVerDetalle;

  @override
  Widget build(BuildContext context) {
    final estadoTexto = switch (estado) {
      EstadoAgendaBarbero.pendiente => enCurso ? 'En curso' : 'Pendiente',
      EstadoAgendaBarbero.cancelada => 'Cancelada',
      EstadoAgendaBarbero.finalizada => 'Finalizada',
    };

    final colorEstado = switch (estado) {
      EstadoAgendaBarbero.pendiente => enCurso ? ColoresApp.advertencia : ColoresApp.exito,
      EstadoAgendaBarbero.cancelada => ColoresApp.error,
      EstadoAgendaBarbero.finalizada => ColoresApp.primario,
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

class _CitaBarberoVista {
  const _CitaBarberoVista({
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
  final EstadoAgendaBarbero estadoBase;
}
