import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../app/theme/colores.dart';

class PaginaCalendarioNegocio extends StatefulWidget {
  const PaginaCalendarioNegocio({super.key});

  @override
  State<PaginaCalendarioNegocio> createState() => _PaginaCalendarioNegocioState();
}

class _PaginaCalendarioNegocioState extends State<PaginaCalendarioNegocio> {
  final Map<DateTime, _ActividadEspecialDia> _agendaPorDia =
      <DateTime, _ActividadEspecialDia>{};

  final List<String> _barberos = const [
    'Carlos Martinez',
    'Andres Mejia',
    'Jose Aguilar',
    'Miguel Torres',
  ];

  DateTime _diaEnfoque = _normalizarFecha(DateTime.now());
  DateTime? _inicioRango;
  DateTime? _finRango;

  List<DateTime> get _diasSeleccionados {
    if (_inicioRango == null) return <DateTime>[];
    final inicio = _normalizarFecha(_inicioRango!);
    final fin = _normalizarFecha(_finRango ?? _inicioRango!);
    final dias = <DateTime>[];
    var cursor = inicio;
    while (!cursor.isAfter(fin)) {
      dias.add(cursor);
      cursor = cursor.add(const Duration(days: 1));
    }
    return dias;
  }

  Future<void> _onRangoSeleccionado(
    DateTime? inicio,
    DateTime? fin,
    DateTime diaEnfoque,
  ) async {
    if (inicio == null) return;

    setState(() {
      _inicioRango = _normalizarFecha(inicio);
      _finRango = _normalizarFecha(fin ?? inicio);
      _diaEnfoque = _normalizarFecha(diaEnfoque);
    });

    await _abrirModalAccionDias();
  }

  Future<void> _abrirModalAccionDias({DateTime? diaEdicion}) async {
    final diasObjetivo = diaEdicion == null ? _diasSeleccionados : <DateTime>[diaEdicion];
    if (diasObjetivo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona al menos un dia en el calendario.')),
      );
      return;
    }

    final base = _agendaPorDia[diasObjetivo.first];
    var accion = base?.accion ?? _TipoAccionCalendario.cierreNegocio;
    final barberosNoDisponibles =
        Set<String>.from(base?.barberosNoDisponibles ?? <String>{});

    final aplicado = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Material(
                color: ColoresApp.primario,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(
                    color: ColoresApp.acento.withValues(alpha: 0.9),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Actividad especial',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: ColoresApp.secundario,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _resumenDias(diasObjetivo),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ColoresApp.secundario.withValues(alpha: 0.85),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '1) Selecciona accion',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: ColoresApp.secundario,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _TipoAccionCalendario.values.map((opcion) {
                        final seleccionado = accion == opcion;
                        return ChoiceChip(
                          label: Text(opcion.etiqueta),
                          selected: seleccionado,
                          backgroundColor: ColoresApp.primario,
                          selectedColor: ColoresApp.acento,
                          side: BorderSide(
                            color: seleccionado
                                ? ColoresApp.acento
                                : ColoresApp.secundario.withValues(alpha: 0.5),
                          ),
                          labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: seleccionado
                                ? ColoresApp.primario
                                : ColoresApp.secundario,
                            fontWeight: FontWeight.w700,
                          ),
                          onSelected: (_) {
                            setModalState(() {
                              accion = opcion;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '2) Completa datos',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: ColoresApp.secundario,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (accion == _TipoAccionCalendario.cierreNegocio)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: ColoresApp.terceario.withValues(alpha: 0.22),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: ColoresApp.secundario.withValues(alpha: 0.45),
                          ),
                        ),
                        child: Text(
                          'Se marcara cierre de negocio para los dias seleccionados.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: ColoresApp.secundario,
                          ),
                        ),
                      ),
                    if (accion == _TipoAccionCalendario.barberosNoDisponibles)
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 240),
                        child: SingleChildScrollView(
                          child: Column(
                            children: _barberos.map((barbero) {
                              final activo = barberosNoDisponibles.contains(barbero);
                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () {
                                    setModalState(() {
                                      if (activo) {
                                        barberosNoDisponibles.remove(barbero);
                                      } else {
                                        barberosNoDisponibles.add(barbero);
                                      }
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2),
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          value: activo,
                                          activeColor: ColoresApp.acento,
                                          checkColor: ColoresApp.primario,
                                          onChanged: (valor) {
                                            setModalState(() {
                                              if (valor ?? false) {
                                                barberosNoDisponibles.add(barbero);
                                              } else {
                                                barberosNoDisponibles.remove(barbero);
                                              }
                                            });
                                          },
                                        ),
                                        Expanded(
                                          child: Text(
                                            barbero,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: ColoresApp.secundario,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: ColoresApp.secundario,
                              side: BorderSide(
                                color: ColoresApp.secundario.withValues(alpha: 0.75),
                              ),
                            ),
                            child: const Text('Cancelar'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColoresApp.acento,
                              foregroundColor: ColoresApp.primario,
                            ),
                            onPressed: () {
                              if (accion == _TipoAccionCalendario.barberosNoDisponibles &&
                                  barberosNoDisponibles.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Selecciona al menos un barbero no disponible.',
                                    ),
                                  ),
                                );
                                return;
                              }

                              _aplicarActividad(
                                dias: diasObjetivo,
                                accion: accion,
                                barberosNoDisponibles: barberosNoDisponibles,
                              );
                              Navigator.of(context).pop(true);
                            },
                            child: const Text('Guardar'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ),
              ),
            );
          },
        );
      },
    );

    if (aplicado != true || !mounted) return;
    final plural = diasObjetivo.length == 1 ? 'dia' : 'dias';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Actividad aplicada a ${diasObjetivo.length} $plural.')),
    );
  }

  void _aplicarActividad({
    required List<DateTime> dias,
    required _TipoAccionCalendario accion,
    required Set<String> barberosNoDisponibles,
  }) {
    setState(() {
      for (final dia in dias) {
        _agendaPorDia[dia] = _ActividadEspecialDia(
          accion: accion,
          barberosNoDisponibles:
              accion == _TipoAccionCalendario.barberosNoDisponibles
                  ? Set<String>.from(barberosNoDisponibles)
                  : <String>{},
        );
      }
    });
  }

  void _eliminarActividad(DateTime fecha) {
    setState(() {
      _agendaPorDia.remove(fecha);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Actividad eliminada para ${_formatearFecha(fecha)}.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final ahora = DateTime.now();
    final actividadesOrdenadas = _agendaPorDia.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      appBar: AppBar(
        title: const Text('Calendario del negocio'),
        backgroundColor: ColoresApp.primario,
        foregroundColor: ColoresApp.secundario,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: _decoracionTarjeta(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Calendario',
                  style: tema.textTheme.labelLarge?.copyWith(
                    color: ColoresApp.primario,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Selecciona una fecha inicial y otra final en el calendario para aplicar actividad especial.',
                  style: tema.textTheme.bodySmall?.copyWith(
                    color: ColoresApp.primario.withValues(alpha: 0.75),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                TableCalendar<_ActividadEspecialDia>(
                  firstDay: DateTime(ahora.year - 2, 1, 1),
                  lastDay: DateTime(ahora.year + 3, 12, 31),
                  focusedDay: _diaEnfoque,
                  locale: 'es_ES',
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  availableGestures: AvailableGestures.all,
                  calendarFormat: CalendarFormat.month,
                  rangeSelectionMode: RangeSelectionMode.toggledOn,
                  rangeStartDay: _inicioRango,
                  rangeEndDay: _finRango,
                  selectedDayPredicate: (day) =>
                      isSameDay(day, _inicioRango) && isSameDay(_inicioRango, _finRango),
                  eventLoader: (day) {
                    final normal = _normalizarFecha(day);
                    final item = _agendaPorDia[normal];
                    return item == null ? <_ActividadEspecialDia>[] : <_ActividadEspecialDia>[item];
                  },
                  onRangeSelected: _onRangoSeleccionado,
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _diaEnfoque = _normalizarFecha(focusedDay);
                    });
                  },
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                    defaultTextStyle: tema.textTheme.bodyMedium!.copyWith(
                      color: ColoresApp.primario,
                    ),
                    weekendTextStyle: tema.textTheme.bodyMedium!.copyWith(
                      color: ColoresApp.primario,
                    ),
                    todayDecoration: BoxDecoration(
                      color: ColoresApp.terceario.withValues(alpha: 0.55),
                      shape: BoxShape.circle,
                    ),
                    rangeStartDecoration: const BoxDecoration(
                      color: ColoresApp.primario,
                      shape: BoxShape.circle,
                    ),
                    rangeEndDecoration: const BoxDecoration(
                      color: ColoresApp.primario,
                      shape: BoxShape.circle,
                    ),
                    withinRangeDecoration: BoxDecoration(
                      color: ColoresApp.acento.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    rangeHighlightColor: ColoresApp.acento.withValues(alpha: 0.18),
                    markerDecoration: const BoxDecoration(
                      color: ColoresApp.acento,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                    titleTextStyle: tema.textTheme.titleMedium!.copyWith(
                      color: ColoresApp.primario,
                      fontWeight: FontWeight.w800,
                    ),
                    leftChevronIcon: const Icon(
                      Icons.chevron_left,
                      color: ColoresApp.primario,
                    ),
                    rightChevronIcon: const Icon(
                      Icons.chevron_right,
                      color: ColoresApp.primario,
                    ),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: tema.textTheme.bodySmall!.copyWith(
                      color: ColoresApp.primario,
                      fontWeight: FontWeight.w700,
                    ),
                    weekendStyle: tema.textTheme.bodySmall!.copyWith(
                      color: ColoresApp.primario,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  calendarBuilders: CalendarBuilders<_ActividadEspecialDia>(
                    markerBuilder: (context, day, events) {
                      if (events.isEmpty) return const SizedBox.shrink();
                      final actividad = events.first;
                      return Positioned(
                        bottom: 6,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _colorActividad(actividad.accion),
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: ColoresApp.terceario.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _resumenDias(_diasSeleccionados),
                    style: tema.textTheme.bodySmall?.copyWith(
                      color: ColoresApp.primario,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: _decoracionTarjeta(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Actividades especiales',
                  style: tema.textTheme.labelLarge?.copyWith(
                    color: ColoresApp.primario,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                if (actividadesOrdenadas.isEmpty)
                  Text(
                    'Aun no hay actividades especiales registradas.',
                    style: tema.textTheme.bodySmall?.copyWith(
                      color: ColoresApp.primario.withValues(alpha: 0.75),
                    ),
                  )
                else
                  ...actividadesOrdenadas.map((entrada) {
                    final fecha = entrada.key;
                    final actividad = entrada.value;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: ColoresApp.terceario.withValues(alpha: 0.34),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _colorActividad(actividad.accion).withValues(alpha: 0.65),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            margin: const EdgeInsets.only(top: 6),
                            decoration: BoxDecoration(
                              color: _colorActividad(actividad.accion),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _formatearFecha(fecha),
                                  style: tema.textTheme.labelLarge?.copyWith(
                                    color: ColoresApp.primario,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  actividad.accion.etiqueta,
                                  style: tema.textTheme.bodyMedium?.copyWith(
                                    color: ColoresApp.primario,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                if (actividad.barberosNoDisponibles.isNotEmpty)
                                  Text(
                                    'No disponibles: ${actividad.barberosNoDisponibles.join(', ')}',
                                    style: tema.textTheme.bodySmall?.copyWith(
                                      color: ColoresApp.primario,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          IconButton(
                            tooltip: 'Editar',
                            onPressed: () => _abrirModalAccionDias(diaEdicion: fecha),
                            icon: const Icon(Icons.edit_outlined),
                            color: ColoresApp.primario,
                          ),
                          IconButton(
                            tooltip: 'Eliminar',
                            onPressed: () => _eliminarActividad(fecha),
                            icon: const Icon(Icons.delete_outline),
                            color: ColoresApp.error,
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _colorActividad(_TipoAccionCalendario accion) {
    switch (accion) {
      case _TipoAccionCalendario.cierreNegocio:
        return ColoresApp.error;
      case _TipoAccionCalendario.barberosNoDisponibles:
        return ColoresApp.advertencia;
    }
  }

  BoxDecoration _decoracionTarjeta() {
    return BoxDecoration(
      color: ColoresApp.secundario,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: ColoresApp.terceario.withValues(alpha: 0.5)),
    );
  }

  String _resumenDias(List<DateTime> dias) {
    if (dias.isEmpty) return 'Sin dias seleccionados';
    if (dias.length == 1) {
      return '1 dia: ${_formatearFecha(dias.first)}';
    }
    final ordenados = dias.toList()..sort();
    return '${dias.length} dias: ${_formatearFecha(ordenados.first)} - ${_formatearFecha(ordenados.last)}';
  }

  String _formatearFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    return '$dia/$mes/${fecha.year}';
  }

  static DateTime _normalizarFecha(DateTime fecha) {
    return DateTime(fecha.year, fecha.month, fecha.day);
  }
}

class _ActividadEspecialDia {
  const _ActividadEspecialDia({
    required this.accion,
    required this.barberosNoDisponibles,
  });

  final _TipoAccionCalendario accion;
  final Set<String> barberosNoDisponibles;
}

enum _TipoAccionCalendario {
  cierreNegocio,
  barberosNoDisponibles,
}

extension _TipoAccionCalendarioX on _TipoAccionCalendario {
  String get etiqueta {
    switch (this) {
      case _TipoAccionCalendario.cierreNegocio:
        return 'Cierre de negocio';
      case _TipoAccionCalendario.barberosNoDisponibles:
        return 'Barberos no disponibles';
    }
  }
}
