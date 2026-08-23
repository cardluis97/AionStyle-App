import 'package:flutter/material.dart';

import '../../../../app/theme/colores.dart';

class PaginaCalendarioNegocio extends StatefulWidget {
  const PaginaCalendarioNegocio({super.key});

  @override
  State<PaginaCalendarioNegocio> createState() => _PaginaCalendarioNegocioState();
}

class _PaginaCalendarioNegocioState extends State<PaginaCalendarioNegocio> {
  final _motivoCierreCtrl = TextEditingController();
  final _promocionCtrl = TextEditingController();

  final Set<DateTime> _diasSeleccionados = <DateTime>{};
  final Map<DateTime, _ConfiguracionDiaNegocio> _agendaPorDia =
      <DateTime, _ConfiguracionDiaNegocio>{};

  final List<String> _barberos = const [
    'Carlos Martinez',
    'Andres Mejia',
    'Jose Aguilar',
    'Miguel Torres',
  ];

  DateTime _diaActivo = _normalizarFecha(DateTime.now());
  bool _negocioCerrado = false;
  final Set<String> _barberosNoDisponibles = <String>{};

  @override
  void initState() {
    super.initState();
    _diasSeleccionados.add(_diaActivo);
    _cargarConfiguracionDelDia(_diaActivo);
  }

  @override
  void dispose() {
    _motivoCierreCtrl.dispose();
    _promocionCtrl.dispose();
    super.dispose();
  }

  void _cargarConfiguracionDelDia(DateTime dia) {
    final config = _agendaPorDia[dia];
    setState(() {
      _negocioCerrado = config?.cerrado ?? false;
      _motivoCierreCtrl.text = config?.motivoCierre ?? '';
      _promocionCtrl.text = config?.promocion ?? '';
      _barberosNoDisponibles
        ..clear()
        ..addAll(config?.barberosNoDisponibles ?? const <String>{});
    });
  }

  Future<void> _seleccionarRangoDias() async {
    final ahora = DateTime.now();
    final rango = await showDateRangePicker(
      context: context,
      locale: const Locale('es', 'ES'),
      firstDate: DateTime(ahora.year - 2),
      lastDate: DateTime(ahora.year + 3, 12, 31),
      initialDateRange: DateTimeRange(start: _diaActivo, end: _diaActivo),
      helpText: 'Selecciona rango de dias',
      saveText: 'Aplicar',
    );

    if (rango == null) return;

    final dias = <DateTime>{};
    var cursor = _normalizarFecha(rango.start);
    final fin = _normalizarFecha(rango.end);
    while (!cursor.isAfter(fin)) {
      dias.add(cursor);
      cursor = cursor.add(const Duration(days: 1));
    }

    if (!mounted) return;
    setState(() {
      _diasSeleccionados
        ..clear()
        ..addAll(dias);
      _diaActivo = _normalizarFecha(rango.start);
    });
    _cargarConfiguracionDelDia(_diaActivo);
  }

  void _guardarConfiguracion() {
    final motivo = _motivoCierreCtrl.text.trim();
    final promo = _promocionCtrl.text.trim();

    if (_negocioCerrado && motivo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe el motivo del cierre.')),
      );
      return;
    }

    if (_diasSeleccionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona al menos un dia para aplicar cambios.')),
      );
      return;
    }

    final config = _ConfiguracionDiaNegocio(
      cerrado: _negocioCerrado,
      motivoCierre: _negocioCerrado ? motivo : null,
      promocion: promo.isEmpty ? null : promo,
      barberosNoDisponibles: Set<String>.from(_barberosNoDisponibles),
    );

    setState(() {
      for (final dia in _diasSeleccionados) {
        _agendaPorDia[dia] = config;
      }
    });

    final plural = _diasSeleccionados.length > 1 ? 'dias' : 'dia';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Configuracion guardada para ${_diasSeleccionados.length} $plural.')),
    );
  }

  void _limpiarConfiguracionDiasSeleccionados() {
    if (_diasSeleccionados.isEmpty) return;

    setState(() {
      for (final dia in _diasSeleccionados) {
        _agendaPorDia.remove(dia);
      }
      _negocioCerrado = false;
      _motivoCierreCtrl.clear();
      _promocionCtrl.clear();
      _barberosNoDisponibles.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Configuracion eliminada de los dias seleccionados.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final ahora = DateTime.now();
    final eventosOrdenados = _agendaPorDia.entries.toList()
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
          _bloqueTitulo(
            tema: tema,
            titulo: 'Agenda mensual operativa',
            subtitulo:
                'Marca cierres por feriado, promociones y disponibilidad de barberos por fecha.',
          ),
          const SizedBox(height: 12),
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
                  'Mes actual: ${_mesNombre(ahora.month)} ${ahora.year}. Puedes navegar entre meses y anos en el calendario.',
                  style: tema.textTheme.bodySmall?.copyWith(
                    color: ColoresApp.primario.withValues(alpha: 0.75),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: Theme.of(context).colorScheme.copyWith(
                          primary: ColoresApp.primario,
                          onPrimary: ColoresApp.secundario,
                          onSurface: ColoresApp.primario,
                          surface: ColoresApp.secundario,
                          onSurfaceVariant: ColoresApp.primario,
                        ),
                    datePickerTheme: DatePickerThemeData(
                      backgroundColor: ColoresApp.secundario,
                      weekdayStyle: tema.textTheme.bodySmall?.copyWith(
                        color: ColoresApp.primario,
                        fontWeight: FontWeight.w700,
                      ),
                      dayStyle: tema.textTheme.bodyMedium?.copyWith(
                        color: ColoresApp.primario,
                      ),
                      yearStyle: tema.textTheme.bodyMedium?.copyWith(
                        color: ColoresApp.primario,
                      ),
                      headerForegroundColor: ColoresApp.primario,
                    ),
                  ),
                  child: CalendarDatePicker(
                    initialDate: _diaActivo,
                    firstDate: DateTime(ahora.year - 2, 1, 1),
                    lastDate: DateTime(ahora.year + 3, 12, 31),
                    currentDate: DateTime.now(),
                    onDateChanged: (dia) {
                      final normal = _normalizarFecha(dia);
                      setState(() {
                        _diaActivo = normal;
                        _diasSeleccionados
                          ..clear()
                          ..add(normal);
                      });
                      _cargarConfiguracionDelDia(normal);
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _seleccionarRangoDias,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ColoresApp.primario,
                        side: BorderSide(
                          color: ColoresApp.primario.withValues(alpha: 0.6),
                        ),
                      ),
                      icon: const Icon(Icons.date_range_outlined, size: 18),
                      label: const Text('Seleccionar varios dias'),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: ColoresApp.terceario.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _resumenDiasSeleccionados(),
                        style: tema.textTheme.bodySmall?.copyWith(
                          color: ColoresApp.primario,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
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
                  'Configuracion del dia o dias',
                  style: tema.textTheme.labelLarge?.copyWith(
                    color: ColoresApp.primario,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Material(
                  color: Colors.transparent,
                  child: SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: _negocioCerrado,
                    activeThumbColor: ColoresApp.primario,
                    title: Text(
                      'Negocio cerrado por feriado o evento',
                      style: tema.textTheme.bodyMedium?.copyWith(
                        color: ColoresApp.primario,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      'Si esta activo, ese dia no se agenda citas.',
                      style: tema.textTheme.bodySmall?.copyWith(
                        color: ColoresApp.primario.withValues(alpha: 0.8),
                      ),
                    ),
                    onChanged: (valor) {
                      setState(() {
                        _negocioCerrado = valor;
                        if (!valor) _motivoCierreCtrl.clear();
                      });
                    },
                  ),
                ),
                if (_negocioCerrado)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextField(
                      controller: _motivoCierreCtrl,
                      maxLines: 2,
                      style: tema.textTheme.bodyMedium?.copyWith(
                        color: ColoresApp.primario,
                      ),
                      decoration: _decoracionCampo(
                        tema,
                        labelText: 'Motivo del cierre',
                        hintText: 'Ejemplo: Feriado nacional o mantenimiento',
                      ),
                    ),
                  ),
                TextField(
                  controller: _promocionCtrl,
                  maxLines: 2,
                  style: tema.textTheme.bodyMedium?.copyWith(
                    color: ColoresApp.primario,
                  ),
                  decoration: _decoracionCampo(
                    tema,
                    labelText: 'Promocion del dia (opcional)',
                    hintText: 'Ejemplo: 2x1 en corte clasico de 10:00 a 13:00',
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Barberos no disponibles ese dia',
                  style: tema.textTheme.labelMedium?.copyWith(
                    color: ColoresApp.primario,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                ..._barberos.map((barbero) {
                  final activo = _barberosNoDisponibles.contains(barbero);
                  return Material(
                    color: Colors.transparent,
                    child: CheckboxListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: ColoresApp.primario,
                      value: activo,
                      title: Text(
                        barbero,
                        style: tema.textTheme.bodyMedium?.copyWith(
                          color: ColoresApp.primario,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        'Marcar si se enfermo o no estara disponible',
                        style: tema.textTheme.bodySmall?.copyWith(
                          color: ColoresApp.primario.withValues(alpha: 0.8),
                        ),
                      ),
                      onChanged: (valor) {
                        setState(() {
                          if (valor ?? false) {
                            _barberosNoDisponibles.add(barbero);
                          } else {
                            _barberosNoDisponibles.remove(barbero);
                          }
                        });
                      },
                    ),
                  );
                }),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _guardarConfiguracion,
                        icon: const Icon(Icons.save_outlined),
                        label: const Text('Guardar cambios'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColoresApp.primario,
                          foregroundColor: ColoresApp.secundario,
                          minimumSize: const Size.fromHeight(44),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _limpiarConfiguracionDiasSeleccionados,
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Limpiar'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ColoresApp.error,
                          side: const BorderSide(color: ColoresApp.error),
                          minimumSize: const Size.fromHeight(44),
                        ),
                      ),
                    ),
                  ],
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
                  'Agenda guardada',
                  style: tema.textTheme.labelLarge?.copyWith(
                    color: ColoresApp.primario,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                if (eventosOrdenados.isEmpty)
                  Text(
                    'Aun no hay configuraciones guardadas en el calendario.',
                    style: tema.textTheme.bodySmall?.copyWith(
                      color: ColoresApp.primario.withValues(alpha: 0.75),
                    ),
                  )
                else
                  ...eventosOrdenados.map((entrada) {
                    final fecha = entrada.key;
                    final item = entrada.value;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: ColoresApp.terceario.withValues(alpha: 0.34),
                        borderRadius: BorderRadius.circular(10),
                      ),
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
                          const SizedBox(height: 4),
                          if (item.cerrado)
                            Text(
                              'Cierre: ${item.motivoCierre ?? 'Sin detalle'}',
                              style: tema.textTheme.bodySmall?.copyWith(
                                color: ColoresApp.primario,
                              ),
                            )
                          else
                            Text(
                              'Negocio abierto',
                              style: tema.textTheme.bodySmall?.copyWith(
                                color: ColoresApp.primario,
                              ),
                            ),
                          if ((item.promocion ?? '').isNotEmpty)
                            Text(
                              'Promocion: ${item.promocion}',
                              style: tema.textTheme.bodySmall?.copyWith(
                                color: ColoresApp.primario,
                              ),
                            ),
                          if (item.barberosNoDisponibles.isNotEmpty)
                            Text(
                              'No disponibles: ${item.barberosNoDisponibles.join(', ')}',
                              style: tema.textTheme.bodySmall?.copyWith(
                                color: ColoresApp.primario,
                              ),
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

  BoxDecoration _decoracionTarjeta() {
    return BoxDecoration(
      color: ColoresApp.secundario,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: ColoresApp.terceario.withValues(alpha: 0.5)),
    );
  }

  Widget _bloqueTitulo({
    required ThemeData tema,
    required String titulo,
    required String subtitulo,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColoresApp.primario,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: tema.textTheme.titleMedium?.copyWith(
              color: ColoresApp.secundario,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitulo,
            style: tema.textTheme.bodySmall?.copyWith(
              color: ColoresApp.secundario.withValues(alpha: 0.88),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _decoracionCampo(
    ThemeData tema, {
    required String labelText,
    required String hintText,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      labelStyle: tema.textTheme.bodySmall?.copyWith(
        color: ColoresApp.primario.withValues(alpha: 0.85),
      ),
      hintStyle: tema.textTheme.bodySmall?.copyWith(
        color: ColoresApp.primario.withValues(alpha: 0.55),
      ),
      filled: true,
      fillColor: ColoresApp.secundario,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: ColoresApp.primario.withValues(alpha: 0.35),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: ColoresApp.primario.withValues(alpha: 0.85),
          width: 1.4,
        ),
      ),
    );
  }

  String _resumenDiasSeleccionados() {
    if (_diasSeleccionados.isEmpty) return 'Sin dias seleccionados';
    if (_diasSeleccionados.length == 1) {
      return '1 dia: ${_formatearFecha(_diasSeleccionados.first)}';
    }
    final ordenados = _diasSeleccionados.toList()..sort();
    return '${_diasSeleccionados.length} dias: ${_formatearFecha(ordenados.first)} - ${_formatearFecha(ordenados.last)}';
  }

  String _formatearFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    return '$dia/$mes/${fecha.year}';
  }

  String _mesNombre(int mes) {
    const nombres = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    return nombres[mes - 1];
  }

  static DateTime _normalizarFecha(DateTime fecha) {
    return DateTime(fecha.year, fecha.month, fecha.day);
  }
}

class _ConfiguracionDiaNegocio {
  const _ConfiguracionDiaNegocio({
    required this.cerrado,
    required this.motivoCierre,
    required this.promocion,
    required this.barberosNoDisponibles,
  });

  final bool cerrado;
  final String? motivoCierre;
  final String? promocion;
  final Set<String> barberosNoDisponibles;
}
