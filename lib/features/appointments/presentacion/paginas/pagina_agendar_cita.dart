import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/enrutador.dart';
import '../../../../app/theme/colores.dart';

enum MetodoPagoCita { efectivo, visa }

class PaginaAgendarCita extends StatefulWidget {
  const PaginaAgendarCita({
    super.key,
    required this.negocioNombre,
    required this.barberoNombre,
    required this.serviciosDisponibles,
    required this.estilosDisponibles,
  });

  final String negocioNombre;
  final String barberoNombre;
  final List<String> serviciosDisponibles;
  final List<String> estilosDisponibles;

  @override
  State<PaginaAgendarCita> createState() => _PaginaAgendarCitaState();
}

class _PaginaAgendarCitaState extends State<PaginaAgendarCita> {
  final _formKey = GlobalKey<FormState>();
  final _numeroTarjetaCtrl = TextEditingController();
  final _nombreTitularCtrl = TextEditingController();
  final _vencimientoCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  final List<_TarjetaVisaGuardada> _tarjetasGuardadas = [
    const _TarjetaVisaGuardada(
      numeroEnmascarado: '**** **** **** 4242',
      titular: 'Usuario Demo',
      vencimiento: '12/29',
    ),
  ];
  int _panelActivo = 0;
  DateTime? _fechaSeleccionada;
  TimeOfDay? _horaSeleccionada;
  MetodoPagoCita _metodoPago = MetodoPagoCita.efectivo;
  final Map<String, String> _estiloSeleccionadoPorServicio = {};
  final Set<String> _serviciosSeleccionados = <String>{};
  int? _indiceTarjetaSeleccionada = 0;
  bool _mostrarFormularioTarjeta = false;

  @override
  void dispose() {
    _numeroTarjetaCtrl.dispose();
    _nombreTitularCtrl.dispose();
    _vencimientoCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

    bool get _serviciosCompletos => _serviciosSeleccionados.isNotEmpty;

    bool get _estiloCompleto {
      if (_serviciosSeleccionados.isEmpty) return false;
      for (final servicio in _serviciosSeleccionados) {
        final estilo = _estiloSeleccionadoPorServicio[servicio];
        if (estilo == null || estilo.trim().isEmpty) {
          return false;
        }
      }
      return true;
    }

  bool get _fechaCompleta => _fechaSeleccionada != null;

  bool get _horaCompleta => _horaSeleccionada != null;

  bool get _pagoCompleto {
    if (_metodoPago == MetodoPagoCita.efectivo) return true;
    return _indiceTarjetaSeleccionada != null;
  }

  bool get _puedeAgregarMasTarjetas => _tarjetasGuardadas.length < 3;

  bool get _requiereFormularioTarjeta {
    return _metodoPago == MetodoPagoCita.visa && _mostrarFormularioTarjeta;
  }

  _TarjetaVisaGuardada? get _tarjetaVisaSeleccionada {
    if (_indiceTarjetaSeleccionada == null) return null;
    if (_indiceTarjetaSeleccionada! < 0 ||
        _indiceTarjetaSeleccionada! >= _tarjetasGuardadas.length) {
      return null;
    }
    return _tarjetasGuardadas[_indiceTarjetaSeleccionada!];
  }

  Map<String, List<String>> get _estilosPorServicio {
    final mapa = <String, List<String>>{};
    final servicios = widget.serviciosDisponibles;
    final estilos = widget.estilosDisponibles;
    if (servicios.isEmpty || estilos.isEmpty) {
      return mapa;
    }

    final cantidadServicios = servicios.length;
    final cantidadEstilos = estilos.length;
    for (var i = 0; i < cantidadServicios; i++) {
      final servicio = servicios[i];
      final estilosServicio = <String>{};
      for (var j = 0; j < cantidadEstilos; j++) {
        final estilo = estilos[j];
        if ((j % cantidadServicios) == i) {
          estilosServicio.add(estilo);
        }
      }
      if (estilosServicio.isEmpty) {
        estilosServicio.add(estilos[i % cantidadEstilos]);
      }
      mapa[servicio] = estilosServicio.toList();
    }
    return mapa;
  }

  List<String> _estilosParaServicio(String servicio) {
    final lista = List<String>.from(_estilosPorServicio[servicio] ?? const <String>[])
      ..sort();
    return lista;
  }

  double _precioServicioEstilo(String servicio, String estilo) {
    final firmaServicio = servicio.runes.fold<int>(0, (a, b) => a + b);
    final firmaEstilo = estilo.runes.fold<int>(0, (a, b) => a + b);
    final base = 70 + (firmaServicio % 7) * 10;
    final extra = (firmaEstilo % 5) * 10;
    return (base + extra).toDouble();
  }

  double get _precioSeleccionado {
    var total = 0.0;
    for (final servicio in _serviciosSeleccionados) {
      final estilo = _estiloSeleccionadoPorServicio[servicio];
      if (estilo == null || estilo.isEmpty) continue;
      total += _precioServicioEstilo(servicio, estilo);
    }
    return total;
  }

  String get _estilosResumen {
    if (_serviciosSeleccionados.isEmpty) return 'Pendiente';
    final partes = <String>[];
    final servicios = _serviciosSeleccionados.toList()..sort();
    for (final servicio in servicios) {
      final estilo = _estiloSeleccionadoPorServicio[servicio];
      if (estilo == null || estilo.isEmpty) {
        partes.add('$servicio: Pendiente');
      } else {
        final precio = _precioServicioEstilo(servicio, estilo);
        partes.add('$servicio: $estilo (Lps ${precio.toStringAsFixed(2)})');
      }
    }
    return partes.join(' | ');
  }

  String get _fechaTexto {
    if (_fechaSeleccionada == null) return 'Pendiente';
    return '${_fechaSeleccionada!.day.toString().padLeft(2, '0')}/${_fechaSeleccionada!.month.toString().padLeft(2, '0')}/${_fechaSeleccionada!.year}';
  }

  String get _horaTexto {
    if (_horaSeleccionada == null) return 'Pendiente';
    return _formatearHora12(_horaSeleccionada!);
  }

  int? get _duracionEstimadaMinutos {
    if (!_estiloCompleto) return null;
    var total = 0;
    for (final servicio in _serviciosSeleccionados) {
      final estilo = _estiloSeleccionadoPorServicio[servicio];
      if (estilo == null || estilo.isEmpty) continue;
      final indiceEstilo = widget.estilosDisponibles
          .indexWhere((item) => item.toLowerCase() == estilo.toLowerCase());
      final base = indiceEstilo < 0 ? 25 : 20 + ((indiceEstilo % 6) * 5);
      total += base;
    }
    final firmaBarbero = widget.barberoNombre.runes.fold<int>(0, (a, b) => a + b);
    final ajusteBarbero = (firmaBarbero % 4) * 5;
    return (total + ajusteBarbero).clamp(15, 300).toInt();
  }

  TimeOfDay _sumarMinutosHora(TimeOfDay hora, int minutos) {
    final totalMinutos = (hora.hour * 60 + hora.minute + minutos) % (24 * 60);
    return TimeOfDay(hour: totalMinutos ~/ 60, minute: totalMinutos % 60);
  }

  String get _horaFinalTexto {
    if (_horaSeleccionada == null) return 'Pendiente';
    final duracion = _duracionEstimadaMinutos;
    if (duracion == null) return 'Pendiente';
    final horaFinal = _sumarMinutosHora(_horaSeleccionada!, duracion);
    return _formatearHora12(horaFinal);
  }

  String _formatearHora12(TimeOfDay hora) {
    final hora12 = hora.hourOfPeriod == 0 ? 12 : hora.hourOfPeriod;
    final minuto = hora.minute.toString().padLeft(2, '0');
    final periodo = hora.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hora12:$minuto $periodo';
  }

  String get _metodoPagoTexto {
    if (_metodoPago == MetodoPagoCita.efectivo) {
      return 'Efectivo';
    }
    final tarjeta = _tarjetaVisaSeleccionada;
    if (tarjeta == null) {
      return 'Visa';
    }
    return 'Visa ${tarjeta.numeroEnmascarado}';
  }

  List<TimeOfDay> get _horasDisponibles {
    final base = <TimeOfDay>[];
    for (var h = 9; h <= 19; h++) {
      base.add(TimeOfDay(hour: h, minute: 0));
      if (h != 19) {
        base.add(TimeOfDay(hour: h, minute: 30));
      }
    }
    if (_fechaSeleccionada == null) return base;

    final dia = _fechaSeleccionada!.weekday;
    if (dia == DateTime.sunday) {
      return base
          .where((t) => t.hour >= 10 && t.hour <= 15)
          .toList(growable: false);
    }
    return base;
  }

  Future<void> _seleccionarFecha() async {
    final ahora = DateTime.now();
    DateTime? fecha;
    try {
      fecha = await showDatePicker(
        context: context,
        locale: const Locale('es', 'ES'),
        initialDate: _fechaSeleccionada ?? ahora,
        firstDate: ahora,
        lastDate: ahora.add(const Duration(days: 60)),
        helpText: 'Selecciona fecha de cita',
        builder: (context, child) {
          final tema = Theme.of(context);
          final esquema = tema.colorScheme;
          return Theme(
            data: tema.copyWith(
              colorScheme: esquema.copyWith(
                surface: tema.brightness == Brightness.dark
                    ? ColoresApp.primario
                    : ColoresApp.secundario,
                onSurface: tema.brightness == Brightness.dark
                    ? ColoresApp.secundario
                    : ColoresApp.texto,
              ),
            ),
            child: child ?? const SizedBox.shrink(),
          );
        },
      );
    } catch (_) {
      // Fallback si el locale es-ES no esta registrado en el host.
      fecha = await showDatePicker(
        context: context,
        initialDate: _fechaSeleccionada ?? ahora,
        firstDate: ahora,
        lastDate: ahora.add(const Duration(days: 60)),
        helpText: 'Selecciona fecha de cita',
      );
    }
    if (fecha != null) {
      setState(() {
        _fechaSeleccionada = fecha;
        _horaSeleccionada = null;
      });
    }
  }

  Future<void> _seleccionarHora() async {
    if (_fechaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Primero selecciona la fecha.')),
      );
      return;
    }

    final disponible = _horasDisponibles;
    final propuesta = await showTimePicker(
      context: context,
      initialTime: disponible.first,
      initialEntryMode: TimePickerEntryMode.dial,
      helpText: 'Selecciona hora de llegada',
      builder: (context, child) {
        final tema = Theme.of(context);
        final esquema = tema.colorScheme;
        return Localizations.override(
          context: context,
          locale: const Locale('en', 'US'),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: Theme(
              data: tema.copyWith(
                colorScheme: esquema.copyWith(
                  surface: tema.brightness == Brightness.dark
                      ? ColoresApp.primario
                      : ColoresApp.secundario,
                  onSurface: tema.brightness == Brightness.dark
                      ? ColoresApp.secundario
                      : ColoresApp.texto,
                ),
              ),
              child: child ?? const SizedBox.shrink(),
            ),
          ),
        );
      },
    );

    if (propuesta == null) return;

    final esValida = disponible.any(
      (t) => t.hour == propuesta.hour && t.minute == propuesta.minute,
    );

    if (!esValida) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hora no disponible para ese dia.')),
      );
      return;
    }

    setState(() {
      _horaSeleccionada = propuesta;
    });
  }

  void _confirmarCita() {
    final formularioValido = _formKey.currentState?.validate() ?? false;
    if (!formularioValido) return;

    if (_fechaSeleccionada == null || _horaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa fecha y hora para confirmar.')),
      );
      return;
    }

    if (_serviciosSeleccionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona al menos un servicio.')),
      );
      return;
    }

    if (!_estiloCompleto) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona estilo para cada servicio.')),
      );
      return;
    }

    if (_metodoPago == MetodoPagoCita.visa && !_pagoCompleto) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona o guarda una tarjeta Visa para continuar.'),
        ),
      );
      return;
    }

    final marca = DateTime.now().millisecondsSinceEpoch.toString();
    final serviciosTexto = _serviciosSeleccionados.toList()..sort();
    final horaInicio = _horaTexto;
    final horaFinal = _horaFinalTexto;
    final estilosTexto = serviciosTexto
        .map((servicio) => _estiloSeleccionadoPorServicio[servicio] ?? 'Pendiente')
        .join(' | ');
    final codigoQr =
        'AIONSTYLE|$marca|${widget.negocioNombre}|${widget.barberoNombre}|${serviciosTexto.join(', ')}|$estilosTexto|$_fechaTexto|$horaInicio|$horaFinal|${_precioSeleccionado.toStringAsFixed(2)}';

    context.pushReplacement(
      '${Rutas.confirmacionCita}?negocio=${Uri.encodeComponent(widget.negocioNombre)}&barbero=${Uri.encodeComponent(widget.barberoNombre)}&corte=${Uri.encodeComponent(estilosTexto)}&servicios=${Uri.encodeComponent(_estilosResumen)}&precio=${_precioSeleccionado.toStringAsFixed(2)}&fecha=${Uri.encodeComponent(_fechaTexto)}&hora=${Uri.encodeComponent(horaInicio)}&horaInicio=${Uri.encodeComponent(horaInicio)}&horaFin=${Uri.encodeComponent(horaFinal)}&pago=${Uri.encodeComponent(_metodoPagoTexto)}&qr=${Uri.encodeComponent(codigoQr)}',
    );
  }

  void _mostrarFormularioNuevaTarjeta() {
    if (!_puedeAgregarMasTarjetas) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ya tienes 3 tarjetas guardadas. Selecciona una.'),
        ),
      );
      return;
    }
    setState(() {
      _mostrarFormularioTarjeta = true;
      _indiceTarjetaSeleccionada = null;
    });
  }

  void _cancelarFormularioTarjeta() {
    setState(() {
      _mostrarFormularioTarjeta = false;
      if (_tarjetasGuardadas.isNotEmpty) {
        _indiceTarjetaSeleccionada = 0;
      }
      _numeroTarjetaCtrl.clear();
      _nombreTitularCtrl.clear();
      _vencimientoCtrl.clear();
      _cvvCtrl.clear();
    });
  }

  void _guardarTarjetaVisa() {
    final formValido = _formKey.currentState?.validate() ?? false;
    if (!formValido) return;

    final numeroLimpio = _numeroTarjetaCtrl.text.replaceAll(' ', '');
    final ultimos4 = numeroLimpio.substring(numeroLimpio.length - 4);

    setState(() {
      _tarjetasGuardadas.add(
        _TarjetaVisaGuardada(
          numeroEnmascarado: '**** **** **** $ultimos4',
          titular: _nombreTitularCtrl.text.trim(),
          vencimiento: _vencimientoCtrl.text.trim(),
        ),
      );
      _indiceTarjetaSeleccionada = _tarjetasGuardadas.length - 1;
      _mostrarFormularioTarjeta = false;
      _numeroTarjetaCtrl.clear();
      _nombreTitularCtrl.clear();
      _vencimientoCtrl.clear();
      _cvvCtrl.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tarjeta guardada como metodo de pago.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      appBar: AppBar(
        title: const Text('Agendar cita'),
        backgroundColor: ColoresApp.primario,
        foregroundColor: ColoresApp.secundario,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Reserva con ${widget.barberoNombre}',
              style: tema.textTheme.titleMedium?.copyWith(
                color: ColoresApp.primario,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.negocioNombre,
              style: tema.textTheme.bodySmall?.copyWith(
                color: ColoresApp.textoClaro,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            _itemAcordeon(
              indice: 0,
              titulo: 'Servicio y estilo',
              completo: _serviciosCompletos && _estiloCompleto,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selecciona uno o varios servicios',
                    style: tema.textTheme.bodySmall?.copyWith(
                      color: ColoresApp.secundario,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (widget.serviciosDisponibles.isEmpty)
                    Text(
                      'No hay servicios disponibles para este negocio.',
                      style: tema.textTheme.bodySmall?.copyWith(
                        color: ColoresApp.secundario.withValues(alpha: 0.8),
                      ),
                    )
                  else
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: widget.serviciosDisponibles.map((servicio) {
                        final activo = _serviciosSeleccionados.contains(servicio);
                        return FilterChip(
                          selected: activo,
                          showCheckmark: false,
                          selectedColor: ColoresApp.secundario,
                          backgroundColor: ColoresApp.secundario.withValues(alpha: 0.12),
                          side: BorderSide(
                            color: activo
                                ? ColoresApp.secundario
                                : ColoresApp.secundario.withValues(alpha: 0.35),
                          ),
                          label: Text(
                            servicio,
                            style: tema.textTheme.bodySmall?.copyWith(
                              color: activo ? ColoresApp.primario : ColoresApp.secundario,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onSelected: (valor) {
                            setState(() {
                              if (valor) {
                                _serviciosSeleccionados.add(servicio);
                              } else {
                                _serviciosSeleccionados.remove(servicio);
                                _estiloSeleccionadoPorServicio.remove(servicio);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 12),
                  Text(
                    'Estilo por cada servicio seleccionado',
                    style: tema.textTheme.bodySmall?.copyWith(
                      color: ColoresApp.secundario,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_serviciosSeleccionados.isEmpty)
                    Text(
                      'Primero selecciona uno o varios servicios.',
                      style: tema.textTheme.bodySmall?.copyWith(
                        color: ColoresApp.secundario.withValues(alpha: 0.8),
                      ),
                    )
                  else
                    ...(_serviciosSeleccionados.toList()..sort()).map((servicio) {
                      final estilosServicio = _estilosParaServicio(servicio);
                      final estiloActual = _estiloSeleccionadoPorServicio[servicio];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: DropdownButtonFormField<String>(
                          initialValue: estiloActual,
                          isExpanded: true,
                          style: tema.textTheme.bodyMedium?.copyWith(
                            color: ColoresApp.secundario,
                          ),
                          dropdownColor: ColoresApp.primario,
                          iconEnabledColor: ColoresApp.secundario,
                          decoration: InputDecoration(
                            labelText: 'Estilo para $servicio',
                            filled: true,
                            fillColor: ColoresApp.secundario.withValues(alpha: 0.10),
                            labelStyle: tema.textTheme.bodySmall?.copyWith(
                              color: ColoresApp.secundario.withValues(alpha: 0.82),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: ColoresApp.secundario.withValues(alpha: 0.3),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: ColoresApp.secundario.withValues(alpha: 0.3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: ColoresApp.secundario.withValues(alpha: 0.8),
                              ),
                            ),
                          ),
                          items: estilosServicio.map((estilo) {
                            final precio = _precioServicioEstilo(servicio, estilo);
                            return DropdownMenuItem<String>(
                              value: estilo,
                              child: Text(
                                '$estilo - Lps ${precio.toStringAsFixed(2)}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (valor) {
                            setState(() {
                              if (valor == null || valor.isEmpty) {
                                _estiloSeleccionadoPorServicio.remove(servicio);
                              } else {
                                _estiloSeleccionadoPorServicio[servicio] = valor;
                              }
                            });
                          },
                          validator: (valor) {
                            if (!_serviciosSeleccionados.contains(servicio)) {
                              return null;
                            }
                            if (valor == null || valor.isEmpty) {
                              return 'Selecciona estilo para $servicio';
                            }
                            return null;
                          },
                        ),
                      );
                    }),
                ],
              ),
            ),
            _itemAcordeon(
              indice: 1,
              titulo: 'Fecha de cita',
              completo: _fechaCompleta,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.calendar_month_outlined,
                  color: ColoresApp.secundario,
                ),
                title: Text(
                  _fechaTexto == 'Pendiente' ? 'Seleccionar fecha' : _fechaTexto,
                  style: tema.textTheme.bodyMedium?.copyWith(
                    color: ColoresApp.secundario,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'Ver disponibilidad del barbero',
                  style: tema.textTheme.bodySmall?.copyWith(
                    color: ColoresApp.secundario.withValues(alpha: 0.72),
                  ),
                ),
                trailing: TextButton.icon(
                  onPressed: _seleccionarFecha,
                  icon: const Icon(
                    Icons.calendar_month_outlined,
                    size: 16,
                    color: ColoresApp.secundario,
                  ),
                  label: const Text('Elegir'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(
                      color: ColoresApp.secundario.withValues(alpha: 0.45),
                    ),
                    foregroundColor: ColoresApp.secundario,
                  ),
                ),
              ),
            ),
            _itemAcordeon(
              indice: 2,
              titulo: 'Hora de llegada',
              completo: _horaCompleta,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.access_time_outlined,
                      color: ColoresApp.secundario,
                    ),
                    title: Text(
                      _horaTexto == 'Pendiente' ? 'Seleccionar hora' : _horaTexto,
                      style: tema.textTheme.bodyMedium?.copyWith(
                        color: ColoresApp.secundario,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Disponibilidad segun fecha elegida',
                      style: tema.textTheme.bodySmall?.copyWith(
                        color: ColoresApp.secundario.withValues(alpha: 0.72),
                      ),
                    ),
                    trailing: TextButton.icon(
                      onPressed: _seleccionarHora,
                      icon: const Icon(
                        Icons.schedule_outlined,
                        size: 16,
                        color: ColoresApp.secundario,
                      ),
                      label: const Text('Elegir'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: ColoresApp.secundario.withValues(alpha: 0.45),
                        ),
                        foregroundColor: ColoresApp.secundario,
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: _horasDisponibles.take(8).map((hora) {
                      return Chip(
                        label: Text(
                          _formatearHora12(hora),
                          style: tema.textTheme.bodySmall?.copyWith(
                            color: ColoresApp.secundario,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: ColoresApp.secundario.withValues(
                          alpha: 0.12,
                        ),
                        side: BorderSide(
                          color: ColoresApp.secundario.withValues(alpha: 0.3),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            _itemAcordeon(
              indice: 3,
              titulo: 'Metodo de pago',
              completo: _pagoCompleto,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 220,
                      child: SegmentedButton<MetodoPagoCita>(
                        showSelectedIcon: false,
                        style: ButtonStyle(
                          foregroundColor: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return ColoresApp.primario;
                            }
                            return ColoresApp.secundario;
                          }),
                          backgroundColor: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return ColoresApp.terceario;
                            }
                            return ColoresApp.secundario.withValues(alpha: 0.12);
                          }),
                          side: WidgetStateProperty.all(
                            BorderSide(
                              color: ColoresApp.secundario.withValues(alpha: 0.35),
                            ),
                          ),
                        ),
                        segments: const [
                          ButtonSegment<MetodoPagoCita>(
                            value: MetodoPagoCita.efectivo,
                            label: Text('Efectivo'),
                          ),
                          ButtonSegment<MetodoPagoCita>(
                            value: MetodoPagoCita.visa,
                            label: Text('Visa'),
                          ),
                        ],
                        selected: {_metodoPago},
                        onSelectionChanged: (valores) {
                          setState(() {
                            _metodoPago = valores.first;
                            if (_metodoPago == MetodoPagoCita.visa &&
                                _tarjetasGuardadas.isEmpty) {
                              _mostrarFormularioTarjeta = true;
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  if (_metodoPago == MetodoPagoCita.visa) ...[
                    const SizedBox(height: 10),
                    Text(
                      'Tarjetas Visa guardadas',
                      style: tema.textTheme.bodySmall?.copyWith(
                        color: ColoresApp.secundario,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_tarjetasGuardadas.isEmpty)
                      Text(
                        'No tienes tarjetas guardadas. Agrega una para continuar.',
                        style: tema.textTheme.bodySmall?.copyWith(
                          color: ColoresApp.secundario.withValues(alpha: 0.75),
                        ),
                      ),
                    ...List.generate(_tarjetasGuardadas.length, (index) {
                      final tarjeta = _tarjetasGuardadas[index];
                      final seleccionada = _indiceTarjetaSeleccionada == index;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Material(
                          color: ColoresApp.secundario.withValues(
                            alpha: seleccionada ? 0.2 : 0.1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: ColoresApp.secundario.withValues(
                                alpha: seleccionada ? 0.85 : 0.35,
                              ),
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: RadioListTile<int>(
                            value: index,
                            groupValue: _indiceTarjetaSeleccionada,
                            onChanged: (valor) {
                              setState(() {
                                _indiceTarjetaSeleccionada = valor;
                                _mostrarFormularioTarjeta = false;
                              });
                            },
                            activeColor: ColoresApp.secundario,
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            title: Text(
                              tarjeta.numeroEnmascarado,
                              style: tema.textTheme.bodyMedium?.copyWith(
                                color: ColoresApp.secundario,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            subtitle: Text(
                              '${tarjeta.titular} · Vence ${tarjeta.vencimiento}',
                              style: tema.textTheme.bodySmall?.copyWith(
                                color: ColoresApp.secundario.withValues(
                                  alpha: 0.8,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    if (_puedeAgregarMasTarjetas && !_mostrarFormularioTarjeta)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: OutlinedButton.icon(
                          onPressed: _mostrarFormularioNuevaTarjeta,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: ColoresApp.secundario,
                            side: BorderSide(
                              color: ColoresApp.secundario.withValues(alpha: 0.7),
                            ),
                          ),
                          icon: const Icon(Icons.add_card_outlined, size: 18),
                          label: const Text('Anadir tarjeta'),
                        ),
                      ),
                    if (!_puedeAgregarMasTarjetas)
                      Text(
                        'Limite alcanzado: ya guardaste 3 tarjetas Visa.',
                        style: tema.textTheme.bodySmall?.copyWith(
                          color: ColoresApp.secundario.withValues(alpha: 0.8),
                        ),
                      ),
                    if (_mostrarFormularioTarjeta) ...[
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _numeroTarjetaCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(16),
                          _FormateadorNumeroTarjeta(),
                        ],
                        style: tema.textTheme.bodyMedium?.copyWith(
                          color: ColoresApp.secundario,
                        ),
                        decoration: _decoracionCampoVisa(
                          tema,
                          'Numero de tarjeta',
                        ),
                        validator: (valor) {
                          if (!_requiereFormularioTarjeta) return null;
                          final limpio = (valor ?? '').replaceAll(' ', '');
                          if (!RegExp(r'^\d{16}$').hasMatch(limpio)) {
                            return 'Ingresa 16 digitos numericos';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nombreTitularCtrl,
                        textCapitalization: TextCapitalization.words,
                        style: tema.textTheme.bodyMedium?.copyWith(
                          color: ColoresApp.secundario,
                        ),
                        decoration: _decoracionCampoVisa(
                          tema,
                          'Nombre del titular',
                        ),
                        validator: (valor) {
                          if (!_requiereFormularioTarjeta) return null;
                          final nombre = (valor ?? '').trim();
                          if (nombre.length < 3) {
                            return 'Ingresa el nombre del titular';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _vencimientoCtrl,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                                _FormateadorVencimiento(),
                              ],
                              style: tema.textTheme.bodyMedium?.copyWith(
                                color: ColoresApp.secundario,
                              ),
                              decoration: _decoracionCampoVisa(
                                tema,
                                'MM/AA',
                              ),
                              validator: (valor) {
                                if (!_requiereFormularioTarjeta) return null;
                                final v = (valor ?? '').trim();
                                if (!RegExp(r'^(0[1-9]|1[0-2])\/(\d{2})$')
                                    .hasMatch(v)) {
                                  return 'Formato invalido';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _cvvCtrl,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(3),
                              ],
                              obscureText: true,
                              style: tema.textTheme.bodyMedium?.copyWith(
                                color: ColoresApp.secundario,
                              ),
                              decoration: _decoracionCampoVisa(
                                tema,
                                'CVV',
                              ),
                              validator: (valor) {
                                if (!_requiereFormularioTarjeta) return null;
                                if (!RegExp(r'^\d{3}$')
                                    .hasMatch((valor ?? '').trim())) {
                                  return 'CVV invalido';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _cancelarFormularioTarjeta,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: ColoresApp.secundario,
                                side: BorderSide(
                                  color: ColoresApp.secundario.withValues(
                                    alpha: 0.65,
                                  ),
                                ),
                              ),
                              child: const Text('Cancelar'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _guardarTarjetaVisa,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColoresApp.secundario,
                                foregroundColor: ColoresApp.primario,
                              ),
                              child: const Text('Guardar tarjeta'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ],
              ),
            ),
            const SizedBox(height: 10),
            _TarjetaFormulario(
              titulo: 'Resumen de agenda',
              child: Column(
                children: [
                  _filaResumen('Negocio', widget.negocioNombre),
                  _filaResumen('Barbero', widget.barberoNombre),
                  _filaResumen(
                    'Servicio(s)',
                    _serviciosSeleccionados.isEmpty
                        ? 'Pendiente'
                        : (_serviciosSeleccionados.toList()..sort()).join(', '),
                  ),
                  _filaResumen('Estilo(s)', _estilosResumen),
                  _filaResumen(
                    'Precio',
                    !_estiloCompleto
                        ? 'Pendiente'
                        : 'Lps ${_precioSeleccionado.toStringAsFixed(2)}',
                  ),
                  _filaResumen('Fecha', _fechaTexto),
                  _filaResumen('Hora de inicio', _horaTexto),
                  _filaResumen('Hora final', _horaFinalTexto),
                  _filaResumen('Pago', _metodoPagoTexto),
                ],
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: _confirmarCita,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColoresApp.primario,
                foregroundColor: ColoresApp.secundario,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('Confirmar cita'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemAcordeon({
    required int indice,
    required String titulo,
    required bool completo,
    required Widget child,
  }) {
    final abierto = _panelActivo == indice;
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              _panelActivo = indice;
            });
          },
          child: _encabezadoSeccion(
            titulo: titulo,
            abierto: abierto,
            completo: completo,
          ),
        ),
        if (abierto) _cuerpoSeccion(child),
      ],
    );
  }

  Widget _encabezadoSeccion({
    required String titulo,
    required bool abierto,
    required bool completo,
  }) {
    final tema = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(bottom: abierto ? 0 : 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: abierto
            ? ColoresApp.terceario.withValues(alpha: 0.85)
            : ColoresApp.terceario.withValues(alpha: 0.62),
        borderRadius: abierto
            ? const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              )
            : BorderRadius.circular(16),
        border: Border.all(
          color: ColoresApp.primario,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              titulo,
              style: tema.textTheme.labelLarge?.copyWith(
                color: ColoresApp.primario,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _BadgeRequerido(completo: completo),
        ],
      ),
    );
  }

  Widget _cuerpoSeccion(Widget child) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: ColoresApp.primario,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: child,
    );
  }

  Widget _filaResumen(String etiqueta, String valor) {
    final tema = Theme.of(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: ColoresApp.secundario,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              etiqueta,
              style: tema.textTheme.bodySmall?.copyWith(
                color: ColoresApp.textoClaro,
                fontSize: 10,
              ),
            ),
          ),
          Expanded(
            child: Text(
              valor,
              textAlign: TextAlign.end,
              style: tema.textTheme.bodySmall?.copyWith(
                color: ColoresApp.primario,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _decoracionCampoVisa(ThemeData tema, String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: tema.textTheme.bodySmall?.copyWith(
        color: ColoresApp.secundario.withValues(alpha: 0.72),
      ),
      filled: true,
      fillColor: ColoresApp.secundario.withValues(alpha: 0.10),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            BorderSide(color: ColoresApp.secundario.withValues(alpha: 0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            BorderSide(color: ColoresApp.secundario.withValues(alpha: 0.8)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ColoresApp.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ColoresApp.error),
      ),
    );
  }
}

class _TarjetaVisaGuardada {
  const _TarjetaVisaGuardada({
    required this.numeroEnmascarado,
    required this.titular,
    required this.vencimiento,
  });

  final String numeroEnmascarado;
  final String titular;
  final String vencimiento;
}

class _FormateadorNumeroTarjeta extends TextInputFormatter {
  const _FormateadorNumeroTarjeta();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitos = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (var i = 0; i < digitos.length; i++) {
      buffer.write(digitos[i]);
      if ((i + 1) % 4 == 0 && i + 1 != digitos.length) {
        buffer.write(' ');
      }
    }
    final texto = buffer.toString();
    return TextEditingValue(
      text: texto,
      selection: TextSelection.collapsed(offset: texto.length),
    );
  }
}

class _FormateadorVencimiento extends TextInputFormatter {
  const _FormateadorVencimiento();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitos = newValue.text.replaceAll('/', '');
    if (digitos.isEmpty) {
      return const TextEditingValue();
    }

    final texto = digitos.length <= 2
        ? digitos
        : '${digitos.substring(0, 2)}/${digitos.substring(2)}';

    return TextEditingValue(
      text: texto,
      selection: TextSelection.collapsed(offset: texto.length),
    );
  }
}

class _TarjetaFormulario extends StatelessWidget {
  const _TarjetaFormulario({required this.titulo, required this.child});

  final String titulo;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColoresApp.secundario,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ColoresApp.terceario.withValues(alpha: 0.55),
        ),
        boxShadow: [
          BoxShadow(
            color: ColoresApp.primario.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: tema.textTheme.labelLarge?.copyWith(
              color: ColoresApp.primario,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _BadgeRequerido extends StatelessWidget {
  const _BadgeRequerido({required this.completo});

  final bool completo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: completo ? ColoresApp.primario : ColoresApp.error,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        completo ? 'Completado' : 'Requerido',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: ColoresApp.secundario,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
