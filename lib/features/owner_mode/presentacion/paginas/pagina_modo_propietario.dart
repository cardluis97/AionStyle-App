import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/router/enrutador.dart';
import '../../../../app/theme/colores.dart';
import '../../../auth/dominio/entidades/rol_usuario.dart';
import '../../../auth/presentacion/proveedores/proveedores_auth.dart';
import 'pagina_firma_contrato_dueno.dart';

class PaginaModoPropietario extends ConsumerStatefulWidget {
  const PaginaModoPropietario({super.key, this.esAlta = true});

  final bool esAlta;

  @override
  ConsumerState<PaginaModoPropietario> createState() =>
      _PaginaModoPropietarioState();
}

class _PaginaModoPropietarioState
    extends ConsumerState<PaginaModoPropietario> {
  final _formKey = GlobalKey<FormState>();
  final _nombreNegocio = TextEditingController();
  final _telefonoNegocio = TextEditingController();
  final _departamento = TextEditingController();
  final _municipio = TextEditingController();
  final _colonia = TextEditingController();
  final _cuenta = TextEditingController();
  final _nombreDueno = TextEditingController();
  final _emailDueno = TextEditingController();
  final _celularDueno = TextEditingController();
  final _dniDueno = TextEditingController();
  final List<_PersonalFormulario> _personal = [_PersonalFormulario()];

  final List<_HorarioDia> _horariosSemana = _diasSemana
      .map((dia) => _HorarioDia(nombreDia: dia))
      .toList();

  final Map<String, Set<String>> _serviciosSeleccionados = {};
  final Map<String, Map<String, TextEditingController>> _preciosServicios = {};

  final List<XFile?> _fotos = [null, null, null];
  final Map<int, Uint8List> _fotosBytes = {};
  XFile? _dniFrenteDueno;
  Uint8List? _dniFrenteDuenoBytes;
  XFile? _dniReversoDueno;
  Uint8List? _dniReversoDuenoBytes;
  _TipoComprobanteDueno? _tipoComprobanteDueno;
  XFile? _comprobanteDueno;
  Uint8List? _comprobanteDuenoBytes;
  final PageController _controladorFotos = PageController();

  int _panelActivo = 0;
  int _indiceFotoActual = 0;
  int _cantidadSucursales = 1;
  String _codigoPaisNegocio = '+504';
  _TipoNegocio? _tipoNegocio;
  bool _modoEdicionMiNegocio = false;

  @override
  void initState() {
    super.initState();
    _modoEdicionMiNegocio = widget.esAlta;
    final estadoAuth = ref.read(viewModelAuthProvider);
    estadoAuth.maybeWhen(
          autenticado: (usuario) {
            _nombreDueno.text = usuario.nombreCompleto;
            _emailDueno.text = usuario.correo;
            _celularDueno.text = usuario.telefono ?? '';
            _dniDueno.text = usuario.numeroDocumento;
          },
          orElse: () {},
        );
    if (!widget.esAlta &&
        !estadoAuth.maybeWhen(
          autenticado: (usuario) => usuario.esDueno,
          orElse: () => false,
        )) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go(Rutas.perfil);
      });
    }

    if (!widget.esAlta) {
      _cargarDatosDemoMiNegocio();
    }
  }

  @override
  void dispose() {
    for (final controlador in [
      _nombreNegocio, _telefonoNegocio, _departamento,
      _municipio, _colonia, _cuenta,
      _nombreDueno, _emailDueno, _celularDueno, _dniDueno,
    ]) {
      controlador.dispose();
    }
    for (final controladoresCategoria in _preciosServicios.values) {
      for (final controlador in controladoresCategoria.values) {
        controlador.dispose();
      }
    }
    for (final persona in _personal) {
      persona.dispose();
    }
    _controladorFotos.dispose();
    super.dispose();
  }

  void _cargarDatosDemoMiNegocio() {
    if (_nombreNegocio.text.trim().isNotEmpty) return;

    _nombreNegocio.text = 'Barberia Central Norte';
    _telefonoNegocio.text = '9988-7766';
    _departamento.text = 'Francisco Morazan';
    _municipio.text = 'Distrito Central';
    _colonia.text = 'Colonia Palmira';
    _cuenta.text = 'BAC 001-778899-22';
    _cantidadSucursales = 2;
    _codigoPaisNegocio = '+504';
    _tipoNegocio = _TipoNegocio.barberia;

    for (final dia in _horariosSemana) {
      if (dia.nombreDia == 'Domingo') {
        dia.cerrado = true;
        dia.apertura = null;
        dia.cierre = null;
      } else {
        dia.cerrado = false;
        dia.apertura = const TimeOfDay(hour: 9, minute: 0);
        dia.cierre = const TimeOfDay(hour: 19, minute: 0);
      }
    }

    _serviciosSeleccionados
      ..clear()
      ..addAll({
        'Corte de cabello': {'Corte clasico', 'Fade / Degradado'},
        'Barba': {'Perfilado de barba'},
      });

    for (final categoria in _preciosServicios.values) {
      for (final controlador in categoria.values) {
        controlador.dispose();
      }
    }
    _preciosServicios
      ..clear()
      ..addAll({
        'Corte de cabello': {
          'Corte clasico': TextEditingController(text: '120'),
          'Fade / Degradado': TextEditingController(text: '180'),
        },
        'Barba': {
          'Perfilado de barba': TextEditingController(text: '90'),
        },
      });

    if (_personal.isEmpty) {
      _personal.add(_PersonalFormulario());
    }

    final persona = _personal.first;
    persona.nombre.text = 'Jose Aguilar';
    persona.experiencia.text = '6';
    persona.correo.text = 'jose.aguilar@aionstyle.com';
    persona.dni.text = '0801199912345';
    persona.serviciosSeleccionados = {'Corte clasico', 'Fade / Degradado'};
    persona.minutosPorServicio['Corte clasico'] =
      TextEditingController(text: '30');
    persona.minutosPorServicio['Fade / Degradado'] =
      TextEditingController(text: '45');
    persona.diasTrabajo = {'Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes'};
    persona.horaEntrada = const TimeOfDay(hour: 9, minute: 0);
    persona.horaSalida = const TimeOfDay(hour: 18, minute: 0);
  }

  Future<void> _abrirSelectorPaisNegocio() async {
    final busquedaCtrl = TextEditingController();
    var resultados = List<_CodigoPais>.from(_codigosPaisBasicos);

    final seleccionado = await showModalBottomSheet<_CodigoPais>(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColoresApp.primario,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: busquedaCtrl,
                      autofocus: true,
                      style: const TextStyle(color: ColoresApp.secundario),
                      decoration: InputDecoration(
                        labelText: 'Buscar pais',
                        labelStyle: const TextStyle(color: ColoresApp.secundario),
                        hintStyle: const TextStyle(color: ColoresApp.secundario),
                        filled: true,
                        fillColor: ColoresApp.primario,
                        prefixIcon: const Icon(
                          Icons.search,
                          color: ColoresApp.secundario,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: ColoresApp.secundario.withValues(alpha: 0.4),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: ColoresApp.acento,
                            width: 1.6,
                          ),
                        ),
                      ),
                      onChanged: (valor) {
                        final q = valor.trim().toLowerCase();
                        setModalState(() {
                          resultados = _codigosPaisBasicos
                              .where(
                                (item) =>
                                    item.pais.toLowerCase().contains(q) ||
                                    item.codigo.toLowerCase().contains(q),
                              )
                              .toList();
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 320,
                      child: resultados.isEmpty
                          ? const Center(
                              child: Text(
                                'No se encontraron paises.',
                                style: TextStyle(color: ColoresApp.secundario),
                              ),
                            )
                          : ListView.builder(
                              itemCount: resultados.length,
                              itemBuilder: (context, index) {
                                final item = resultados[index];
                                return ListTile(
                                  title: Text(
                                    item.pais,
                                    style: const TextStyle(
                                      color: ColoresApp.secundario,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    item.codigo,
                                    style: const TextStyle(
                                      color: ColoresApp.secundario,
                                    ),
                                  ),
                                  onTap: () => Navigator.of(context).pop(item),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    busquedaCtrl.dispose();

    if (seleccionado != null && mounted) {
      setState(() => _codigoPaisNegocio = seleccionado.codigo);
    }
  }

  Future<void> _seleccionarFoto(int indice) async {
    final foto = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (foto == null) return;
    try {
      final bytes = await foto.readAsBytes();
      setState(() {
        _fotos[indice] = foto;
        _fotosBytes[indice] = bytes;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo cargar la imagen seleccionada.')),
      );
    }
  }

  Future<void> _seleccionarHoraDia(int indice, {required bool apertura}) async {
    final horaInicial = apertura
        ? _horariosSemana[indice].apertura ?? const TimeOfDay(hour: 8, minute: 0)
        : _horariosSemana[indice].cierre ?? const TimeOfDay(hour: 18, minute: 0);
    final horaSeleccionada = await showTimePicker(
      context: context,
      initialTime: horaInicial,
      builder: (context, child) {
        final tema = Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: ColoresApp.primario,
                onPrimary: ColoresApp.secundario,
              ),
        );
        final media = MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false);
        return Localizations.override(
          context: context,
          locale: const Locale('en', 'US'),
          child: MediaQuery(
            data: media,
            child: Theme(data: tema, child: child!),
          ),
        );
      },
    );

    if (horaSeleccionada == null) return;

    setState(() {
      final dia = _horariosSemana[indice];
      if (apertura) {
        dia.apertura = horaSeleccionada;
      } else {
        dia.cierre = horaSeleccionada;
      }
      dia.cerrado = false;
    });
  }

  void _onToggleServicio(String categoria, String item, bool valor) {
    final seleccionadosCategoria =
        _serviciosSeleccionados.putIfAbsent(categoria, () => <String>{});
    final preciosCategoria =
        _preciosServicios.putIfAbsent(categoria, () => <String, TextEditingController>{});

    setState(() {
      if (valor) {
        seleccionadosCategoria.add(item);
        preciosCategoria.putIfAbsent(item, () => TextEditingController());
      } else {
        seleccionadosCategoria.remove(item);
        final controlador = preciosCategoria.remove(item);
        controlador?.dispose();
      }
    });
  }

  bool _validarHorarios() {
    for (final dia in _horariosSemana) {
      if (dia.cerrado) continue;
      if (dia.apertura == null || dia.cierre == null) return false;
      final aperturaMinutos = dia.apertura!.hour * 60 + dia.apertura!.minute;
      final cierreMinutos = dia.cierre!.hour * 60 + dia.cierre!.minute;
      if (cierreMinutos <= aperturaMinutos) return false;
    }
    return true;
  }

  bool _validarServiciosSeleccionados() {
    final hayServicios = _serviciosSeleccionados.values.any((items) => items.isNotEmpty);
    if (!hayServicios) return false;

    for (final entradaCategoria in _serviciosSeleccionados.entries) {
      final preciosCategoria = _preciosServicios[entradaCategoria.key] ?? {};
      for (final item in entradaCategoria.value) {
        final precio = preciosCategoria[item]?.text.trim() ?? '';
        final valor = double.tryParse(precio);
        if (valor == null || valor <= 0) {
          return false;
        }
      }
    }
    return true;
  }

  bool _esTextoValido(TextEditingController controlador) {
    return controlador.text.trim().isNotEmpty;
  }

  bool get _datosNegocioCompletos {
    return _esTextoValido(_nombreNegocio) &&
        _esTextoValido(_telefonoNegocio) &&
        _esTextoValido(_departamento) &&
        _esTextoValido(_municipio) &&
        _esTextoValido(_colonia) &&
        _tipoNegocio != null &&
        _validarHorarios();
  }

  bool get _serviciosCompletos => _validarServiciosSeleccionados();

  bool get _fotosCompletas => _fotos.every((foto) => foto != null);

  bool get _datosDuenoCompletos {
    return _esTextoValido(_nombreDueno) &&
        _esTextoValido(_emailDueno) &&
        _esTextoValido(_celularDueno) &&
      _esTextoValido(_dniDueno) &&
      _dniFrenteDueno != null &&
      _dniReversoDueno != null &&
      _tipoComprobanteDueno != null &&
      _comprobanteDueno != null;
  }

  bool get _personalCompleto {
    if (_personal.isEmpty) return false;
    for (final persona in _personal) {
      if (!_esTextoValido(persona.nombre) ||
          !_esTextoValido(persona.experiencia) ||
          !_esTextoValido(persona.correo) ||
          !_esTextoValido(persona.dni)) {
        return false;
      }
      if ((persona.serviciosSeleccionados ?? const <String>{}).isEmpty) {
        return false;
      }
      for (final servicio in persona.serviciosSeleccionados ?? const <String>{}) {
        final minutosTexto =
            persona.minutosPorServicio[servicio]?.text.trim() ?? '';
        final minutos = int.tryParse(minutosTexto);
        if (minutos == null || minutos <= 0 || minutos > 600) {
          return false;
        }
      }
      final diasTrabajo = (persona.diasTrabajo ?? const <String>{});
      if (diasTrabajo.isEmpty) return false;
      if (persona.horaEntrada == null || persona.horaSalida == null) return false;
      if (!_rangoPersonalDentroHorarioNegocio(
        diasTrabajo: diasTrabajo,
        horaEntrada: persona.horaEntrada!,
        horaSalida: persona.horaSalida!,
      )) return false;
      if (persona.foto == null || persona.fotoBytes == null) return false;
    }
    return true;
  }

  List<String> get _itemsServiciosNegocio {
    final items = <String>{};
    for (final seleccionados in _serviciosSeleccionados.values) {
      items.addAll(seleccionados);
    }
    final lista = items.toList()..sort();
    return lista;
  }

  List<String> get _categoriasServiciosNegocio {
    final categorias = <String>[];
    for (final entrada in _serviciosSeleccionados.entries) {
      if (entrada.value.isNotEmpty) {
        categorias.add(entrada.key);
      }
    }
    categorias.sort();
    return categorias;
  }

  List<String> get _resumenHorariosNegocio {
    final grupos = <String, List<String>>{};
    for (final dia in _horariosSemana) {
      if (dia.cerrado || dia.apertura == null || dia.cierre == null) continue;
      final clave =
          '${_formatearHora12h(dia.apertura!)} - ${_formatearHora12h(dia.cierre!)}';
      grupos.putIfAbsent(clave, () => <String>[]).add(dia.nombreDia);
    }

    final resumen = <String>[];
    for (final entrada in grupos.entries) {
      final dias = _resumirDiasConsecutivos(entrada.value);
      resumen.add('$dias: ${entrada.key}');
    }
    return resumen;
  }

  String get _ubicacionNegocioVistaPrevia {
    final colonia = _colonia.text.trim();
    if (colonia.isEmpty) {
      return 'Colonia';
    }
    return colonia;
  }

  String _resumirDiasConsecutivos(List<String> dias) {
    if (dias.isEmpty) return '';

    final indices = <int>[];
    for (final dia in dias) {
      final indice = _diasSemana.indexOf(dia);
      if (indice >= 0) indices.add(indice);
    }
    indices.sort();
    if (indices.isEmpty) return dias.join(', ');

    final partes = <String>[];
    var inicio = indices.first;
    var previo = indices.first;

    for (var i = 1; i < indices.length; i++) {
      final actual = indices[i];
      if (actual == previo + 1) {
        previo = actual;
        continue;
      }
      partes.add(_formatearRangoDias(inicio, previo));
      inicio = actual;
      previo = actual;
    }
    partes.add(_formatearRangoDias(inicio, previo));

    return partes.join(', ');
  }

  String _formatearRangoDias(int inicio, int fin) {
    final diaInicio = _abreviaturasDiasSemana[_diasSemana[inicio]] ??
        _diasSemana[inicio].toLowerCase();
    final diaFin =
        _abreviaturasDiasSemana[_diasSemana[fin]] ?? _diasSemana[fin].toLowerCase();
    if (inicio == fin) return diaInicio;
    return '$diaInicio - $diaFin';
  }

  List<String> get _diasDisponiblesNegocio {
    final dias = <String>[];
    for (final dia in _horariosSemana) {
      if (!dia.cerrado && dia.apertura != null && dia.cierre != null) {
        dias.add(dia.nombreDia);
      }
    }
    return dias;
  }

  _HorarioDia? _horarioNegocioPorDia(String nombreDia) {
    for (final dia in _horariosSemana) {
      if (dia.nombreDia == nombreDia) return dia;
    }
    return null;
  }

  int _aMinutos(TimeOfDay hora) => hora.hour * 60 + hora.minute;

  bool _rangoPersonalDentroHorarioNegocio({
    required Set<String> diasTrabajo,
    required TimeOfDay horaEntrada,
    required TimeOfDay horaSalida,
  }) {
    final entradaMin = _aMinutos(horaEntrada);
    final salidaMin = _aMinutos(horaSalida);
    if (salidaMin <= entradaMin) return false;

    for (final nombreDia in diasTrabajo) {
      final horarioNegocio = _horarioNegocioPorDia(nombreDia);
      if (horarioNegocio == null ||
          horarioNegocio.cerrado ||
          horarioNegocio.apertura == null ||
          horarioNegocio.cierre == null) {
        return false;
      }
      final aperturaMin = _aMinutos(horarioNegocio.apertura!);
      final cierreMin = _aMinutos(horarioNegocio.cierre!);
      if (entradaMin < aperturaMin || salidaMin > cierreMin) return false;
    }
    return true;
  }

  Future<void> _seleccionarHoraPersonal(
    _PersonalFormulario persona, {
    required bool entrada,
  }) async {
    final diasTrabajo = (persona.diasTrabajo ?? <String>{});
    if (diasTrabajo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona al menos un dia de trabajo del personal.'),
        ),
      );
      return;
    }

    final horaInicial = entrada
        ? persona.horaEntrada ?? const TimeOfDay(hour: 8, minute: 0)
        : persona.horaSalida ?? const TimeOfDay(hour: 18, minute: 0);

    final horaSeleccionada = await showTimePicker(
      context: context,
      initialTime: horaInicial,
      builder: (context, child) {
        final tema = Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: ColoresApp.primario,
                onPrimary: ColoresApp.secundario,
              ),
        );
        final media = MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false);
        return Localizations.override(
          context: context,
          locale: const Locale('en', 'US'),
          child: MediaQuery(
            data: media,
            child: Theme(data: tema, child: child!),
          ),
        );
      },
    );

    if (horaSeleccionada == null) return;

    final nuevaEntrada = entrada ? horaSeleccionada : persona.horaEntrada;
    final nuevaSalida = entrada ? persona.horaSalida : horaSeleccionada;

    if (nuevaEntrada != null && nuevaSalida != null) {
      final rangoValido = _rangoPersonalDentroHorarioNegocio(
        diasTrabajo: diasTrabajo,
        horaEntrada: nuevaEntrada,
        horaSalida: nuevaSalida,
      );
      if (!rangoValido) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'El horario del personal debe estar dentro del horario de atencion del negocio.',
            ),
          ),
        );
        return;
      }
    }

    setState(() {
      if (entrada) {
        persona.horaEntrada = horaSeleccionada;
      } else {
        persona.horaSalida = horaSeleccionada;
      }
    });
  }

  Future<void> _seleccionarDocumentoDueno({
    required void Function(XFile foto, Uint8List bytes) onSeleccionado,
    required String mensajeError,
  }) async {
    final foto = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (foto == null) return;
    try {
      final bytes = await foto.readAsBytes();
      setState(() => onSeleccionado(foto, bytes));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensajeError)),
      );
    }
  }

  Future<void> _seleccionarFotoPersonal(_PersonalFormulario persona) async {
    final foto = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (foto == null) return;
    try {
      final bytes = await foto.readAsBytes();
      setState(() {
        persona.foto = foto;
        persona.fotoBytes = bytes;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo cargar la foto del personal.')),
      );
    }
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;
    if (_tipoNegocio == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona el tipo de negocio.')),
      );
      return;
    }
    if (!_validarHorarios()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa horarios validos: apertura menor que cierre.'),
        ),
      );
      return;
    }
    if (!_validarServiciosSeleccionados()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona servicios y coloca precio a cada item.'),
        ),
      );
      return;
    }
    if (widget.esAlta && !_datosDuenoCompletos) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Completa datos del dueno: DNI ambas caras y un comprobante (arrendamiento, luz o agua).',
          ),
        ),
      );
      return;
    }
    if (!_personalCompleto) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Revisa personal: experiencia 1-80, servicios con minutos, dias, horario dentro del negocio y foto.',
          ),
        ),
      );
      return;
    }
    if (widget.esAlta && _fotos.any((foto) => foto == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adjunta las 3 fotos del negocio.')),
      );
      return;
    }
    if (widget.esAlta) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const PaginaFirmaContratoDueno(),
        ),
      );
      return;
    }
    ref.read(viewModelAuthProvider.notifier).activarRol(RolUsuario.dueno);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cambios guardados correctamente.')),
    );
    setState(() {
      _modoEdicionMiNegocio = false;
    });
    context.go(Rutas.miNegocio);
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final titulo = widget.esAlta ? 'Ingresar como dueño' : 'Mi negocio';
    final mapaServicios = _tipoNegocio == null
        ? <String, List<String>>{}
        : _catalogoServicios[_tipoNegocio!]!;

    if (!widget.esAlta && !_modoEdicionMiNegocio) {
      return Scaffold(
        backgroundColor: ColoresApp.fondo,
        appBar: AppBar(
          title: Text(titulo),
          backgroundColor: ColoresApp.primario,
          foregroundColor: ColoresApp.secundario,
        ),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ColoresApp.primario,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vista previa bloqueada',
                    style: tema.textTheme.titleMedium?.copyWith(
                      color: ColoresApp.secundario,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Revisa la informacion de tu negocio. Presiona Editar para habilitar cambios en datos, servicios, fotos y personal a cargo.',
                    style: tema.textTheme.bodySmall?.copyWith(
                      color: ColoresApp.secundario.withValues(alpha: 0.88),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _modoEdicionMiNegocio = true;
                        _panelActivo = 0;
                      });
                    },
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Editar mi negocio'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColoresApp.secundario,
                      foregroundColor: ColoresApp.primario,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _resumenVistaBloqueada(tema),
            const SizedBox(height: 12),
            _vistaPreviaNegocio(tema),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      appBar: AppBar(
        title: Text(titulo),
        backgroundColor: ColoresApp.primario,
        foregroundColor: ColoresApp.secundario,
        actions: [
          if (!widget.esAlta)
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _modoEdicionMiNegocio = false;
                });
              },
              icon: const Icon(Icons.visibility_outlined, size: 18),
              label: const Text('Vista previa'),
              style: TextButton.styleFrom(
                foregroundColor: ColoresApp.secundario,
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Text(
              'Formulario de datos del negocio',
              style: tema.textTheme.titleMedium?.copyWith(
                color: ColoresApp.primario,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            _itemAcordeon(
              indice: 0,
              titulo: 'Datos del negocio',
              completo: _datosNegocioCompletos,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _campoAcordeon('Nombre del negocio', _nombreNegocio),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          key: ValueKey(_codigoPaisNegocio),
                          initialValue: _codigoPaisNegocio,
                          readOnly: true,
                          style: _textoClaro(tema),
                          onTap: _abrirSelectorPaisNegocio,
                          decoration: _decoracionAcordeon(
                            tema,
                            etiqueta: 'Pais',
                            icono: Icons.flag_outlined,
                            suffixIcono: Icons.keyboard_arrow_down,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 4,
                        child: _campoAcordeon(
                          'Telefono del negocio',
                          _telefonoNegocio,
                          teclado: TextInputType.phone,
                          icono: Icons.phone_outlined,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9- ]')),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    initialValue: _cantidadSucursales,
                    dropdownColor: ColoresApp.primario,
                    style: _textoClaro(tema),
                    iconEnabledColor: ColoresApp.secundario,
                    decoration: _decoracionAcordeon(
                      tema,
                      etiqueta: 'Cantidad de sucursales',
                      icono: Icons.store_mall_directory_outlined,
                    ),
                    items: List.generate(20, (i) => i + 1)
                        .map(
                          (valor) => DropdownMenuItem<int>(
                            value: valor,
                            child: Text('$valor'),
                          ),
                        )
                        .toList(),
                    onChanged: (valor) {
                      if (valor != null) {
                        setState(() => _cantidadSucursales = valor);
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  _campoAcordeon('Departamento negocio principal', _departamento),
                  _campoAcordeon('Municipio negocio principal', _municipio),
                  _campoAcordeon(
                    'Colonia',
                    _colonia,
                    icono: Icons.place_outlined,
                  ),
                  _campoAcordeon(
                    'Cuenta bancaria (opcional)',
                    _cuenta,
                    requerido: false,
                    icono: Icons.account_balance_outlined,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<_TipoNegocio>(
                    initialValue: _tipoNegocio,
                    dropdownColor: ColoresApp.primario,
                    style: _textoClaro(tema),
                    iconEnabledColor: ColoresApp.secundario,
                    decoration: _decoracionAcordeon(
                      tema,
                      etiqueta: 'Tipo de negocio',
                      icono: Icons.category_outlined,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: _TipoNegocio.barberia,
                        child: Text('Barberia'),
                      ),
                      DropdownMenuItem(
                        value: _TipoNegocio.salonBelleza,
                        child: Text('Salon de belleza'),
                      ),
                    ],
                    onChanged: (valor) {
                      setState(() {
                        _tipoNegocio = valor;
                        _serviciosSeleccionados.clear();
                        for (final categoria in _preciosServicios.values) {
                          for (final controlador in categoria.values) {
                            controlador.dispose();
                          }
                        }
                        _preciosServicios.clear();
                      });
                    },
                    validator: (valor) => valor == null
                        ? 'Selecciona un tipo de negocio'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Horario de atencion',
                    style: tema.textTheme.labelLarge?.copyWith(
                      color: ColoresApp.secundario,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: ColoresApp.secundario.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ColoresApp.secundario.withValues(alpha: 0.24),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 10,
                                child: _celdaTabla('Dia', esEncabezado: true),
                              ),
                              Expanded(
                                flex: 7,
                                child: _celdaTabla('Apertura', esEncabezado: true),
                              ),
                              Expanded(
                                flex: 7,
                                child: _celdaTabla('Cierre', esEncabezado: true),
                              ),
                            ],
                          ),
                        ),
                        ..._horariosSemana.asMap().entries.map((entrada) {
                          final indice = entrada.key;
                          final dia = entrada.value;
                          return Container(
                            margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: ColoresApp.secundario.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 10,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          dia.nombreDia,
                                          overflow: TextOverflow.ellipsis,
                                          style: tema.textTheme.bodySmall?.copyWith(
                                            color: ColoresApp.secundario,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      Checkbox(
                                        value: dia.cerrado,
                                        visualDensity: const VisualDensity(
                                          horizontal: -4,
                                          vertical: -4,
                                        ),
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        activeColor: ColoresApp.acento,
                                        side: BorderSide(
                                          color: ColoresApp.secundario.withValues(alpha: 0.85),
                                        ),
                                        onChanged: (valor) {
                                          setState(() {
                                            dia.cerrado = valor ?? false;
                                            if (dia.cerrado) {
                                              dia.apertura = null;
                                              dia.cierre = null;
                                            }
                                          });
                                        },
                                      ),
                                      Text(
                                        'Cerrado',
                                        style: tema.textTheme.labelSmall?.copyWith(
                                          color: ColoresApp.secundario.withValues(alpha: 0.92),
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 2),
                                    child: OutlinedButton(
                                      onPressed: dia.cerrado
                                          ? null
                                          : () => _seleccionarHoraDia(
                                                indice,
                                                apertura: true,
                                              ),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: ColoresApp.secundario,
                                        side: BorderSide(
                                          color: ColoresApp.secundario.withValues(alpha: 0.5),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 10,
                                        ),
                                      ),
                                      child: Text(
                                        dia.apertura == null
                                            ? 'Elegir'
                                            : _formatearHora12h(dia.apertura!),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 2),
                                    child: OutlinedButton(
                                      onPressed: dia.cerrado
                                          ? null
                                          : () => _seleccionarHoraDia(
                                                indice,
                                                apertura: false,
                                              ),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: ColoresApp.secundario,
                                        side: BorderSide(
                                          color: ColoresApp.secundario.withValues(alpha: 0.5),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 10,
                                        ),
                                      ),
                                      child: Text(
                                        dia.cierre == null
                                            ? 'Elegir'
                                            : _formatearHora12h(dia.cierre!),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
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
            ),
            _itemAcordeon(
              indice: 1,
              titulo: 'Servicios disponibles',
              completo: _serviciosCompletos,
              child: _tipoNegocio == null
                  ? Text(
                      'Selecciona el tipo de negocio para desplegar los servicios.',
                      style: tema.textTheme.bodyMedium?.copyWith(
                        color: ColoresApp.secundario,
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selecciona primero el servicio (categoria) y luego el estilo que ofrece tu negocio.',
                          style: tema.textTheme.bodySmall?.copyWith(
                            color: ColoresApp.secundario.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...mapaServicios.entries.map((entradaCategoria) {
                          final categoria = entradaCategoria.key;
                          final items = entradaCategoria.value;
                          final seleccionados =
                              _serviciosSeleccionados[categoria] ?? <String>{};
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: ColoresApp.secundario.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: ColoresApp.secundario.withValues(alpha: 0.25),
                              ),
                            ),
                            child: ExpansionTile(
                              collapsedIconColor: ColoresApp.secundario,
                              iconColor: ColoresApp.secundario,
                              shape: const Border(),
                              collapsedShape: const Border(),
                              title: Text(
                                categoria,
                                style: tema.textTheme.labelLarge?.copyWith(
                                  color: ColoresApp.secundario,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              subtitle: Text(
                                '${seleccionados.length} estilos seleccionados',
                                style: tema.textTheme.bodySmall?.copyWith(
                                  color: ColoresApp.secundario.withValues(alpha: 0.78),
                                ),
                              ),
                              children: items.map((item) {
                                final estaSeleccionado = seleccionados.contains(item);
                                final controladorPrecio = _preciosServicios[categoria]?[item];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Column(
                                    children: [
                                      CheckboxListTile(
                                        contentPadding: EdgeInsets.zero,
                                        checkColor: ColoresApp.primario,
                                        activeColor: ColoresApp.secundario,
                                        title: Text(
                                          item,
                                          style: tema.textTheme.bodyMedium?.copyWith(
                                            color: ColoresApp.secundario,
                                          ),
                                        ),
                                        value: estaSeleccionado,
                                        onChanged: (valor) => _onToggleServicio(
                                          categoria,
                                          item,
                                          valor ?? false,
                                        ),
                                      ),
                                      if (estaSeleccionado && controladorPrecio != null)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            bottom: 10,
                                          ),
                                          child: TextFormField(
                                            controller: controladorPrecio,
                                            keyboardType: const TextInputType.numberWithOptions(
                                              decimal: true,
                                            ),
                                            style: _textoClaro(tema),
                                            decoration: _decoracionAcordeon(
                                              tema,
                                              etiqueta: 'Precio (L)',
                                              hintTexto: 'Precio de "$item"',
                                              icono: null,
                                              prefijoTexto: 'L ',
                                            ),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9.]'),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
            ),
            _itemAcordeon(
              indice: 2,
              titulo: 'Fotos del negocio',
              completo: _fotosCompletas,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Carga 3 fotos del negocio (desliza horizontalmente).',
                    style: tema.textTheme.bodySmall?.copyWith(
                      color: ColoresApp.secundario.withValues(alpha: 0.78),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 280,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: PageView.builder(
                            controller: _controladorFotos,
                            itemCount: _fotos.length,
                            onPageChanged: (indice) {
                              setState(() => _indiceFotoActual = indice);
                            },
                            itemBuilder: (context, indice) {
                              final foto = _fotos[indice];
                              final bytes = _fotosBytes[indice];
                              return Stack(
                                fit: StackFit.expand,
                                children: [
                                  if (foto == null)
                                    Container(
                                      decoration: BoxDecoration(
                                        color: ColoresApp.secundario.withValues(alpha: 0.08),
                                        border: Border.all(
                                          color: ColoresApp.secundario.withValues(alpha: 0.4),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.add_a_photo_outlined,
                                            size: 46,
                                            color: ColoresApp.secundario,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Foto ${indice + 1}',
                                            style: tema.textTheme.titleSmall?.copyWith(
                                              color: ColoresApp.secundario,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  else if (bytes != null)
                                    Image.memory(bytes, fit: BoxFit.cover)
                                  else
                                    Image.file(
                                      File(foto.path),
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) {
                                        return Container(
                                          color: ColoresApp.secundario.withValues(alpha: 0.08),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'No se pudo mostrar la imagen',
                                            style: tema.textTheme.bodySmall?.copyWith(
                                              color: ColoresApp.secundario,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  Center(
                                    child: FilledButton.tonalIcon(
                                      onPressed: () => _seleccionarFoto(indice),
                                      style: FilledButton.styleFrom(
                                        backgroundColor:
                                            ColoresApp.secundario.withValues(alpha: 0.82),
                                        foregroundColor: ColoresApp.primario,
                                      ),
                                      icon: Icon(
                                        foto == null
                                            ? Icons.add_a_photo_outlined
                                            : Icons.refresh_outlined,
                                      ),
                                      label: Text(foto == null ? 'Agregar' : 'Reemplazar'),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton.filledTonal(
                            onPressed: _indiceFotoActual == 0
                                ? null
                                : () => _controladorFotos.previousPage(
                                      duration: const Duration(milliseconds: 220),
                                      curve: Curves.easeOut,
                                    ),
                            icon: const Icon(Icons.arrow_back_ios_new),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton.filledTonal(
                            onPressed: _indiceFotoActual == _fotos.length - 1
                                ? null
                                : () => _controladorFotos.nextPage(
                                      duration: const Duration(milliseconds: 220),
                                      curve: Curves.easeOut,
                                    ),
                            icon: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: ColoresApp.primario.withValues(alpha: 0.66),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${_indiceFotoActual + 1}/3',
                              style: tema.textTheme.labelMedium?.copyWith(
                                color: ColoresApp.secundario,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Formulario de datos personales del dueno',
              style: tema.textTheme.titleMedium?.copyWith(
                color: ColoresApp.primario,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            _itemAcordeon(
              indice: 3,
              titulo: 'Datos personales del dueno',
              completo: _datosDuenoCompletos,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informacion cargada del perfil actual.',
                    style: tema.textTheme.bodySmall?.copyWith(
                      color: ColoresApp.secundario.withValues(alpha: 0.78),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _campoAcordeon(
                    'Nombre completo del dueno',
                    _nombreDueno,
                    icono: Icons.person_outline,
                  ),
                  _campoAcordeon(
                    'Correo electronico',
                    _emailDueno,
                    teclado: TextInputType.emailAddress,
                    icono: Icons.email_outlined,
                  ),
                  _campoAcordeon(
                    'Celular',
                    _celularDueno,
                    teclado: TextInputType.phone,
                    icono: Icons.phone_outlined,
                  ),
                  _campoAcordeon(
                    'Numero de DNI',
                    _dniDueno,
                    teclado: TextInputType.number,
                    icono: Icons.badge_outlined,
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Documentos del dueno',
                      style: tema.textTheme.labelMedium?.copyWith(
                        color: ColoresApp.secundario,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _cajaDocumentoDueno(
                          tema: tema,
                          titulo: 'DNI frente',
                          bytes: _dniFrenteDuenoBytes,
                          onTap: () => _seleccionarDocumentoDueno(
                            onSeleccionado: (foto, bytes) {
                              _dniFrenteDueno = foto;
                              _dniFrenteDuenoBytes = bytes;
                            },
                            mensajeError: 'No se pudo cargar el DNI frente.',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _cajaDocumentoDueno(
                          tema: tema,
                          titulo: 'DNI reverso',
                          bytes: _dniReversoDuenoBytes,
                          onTap: () => _seleccionarDocumentoDueno(
                            onSeleccionado: (foto, bytes) {
                              _dniReversoDueno = foto;
                              _dniReversoDuenoBytes = bytes;
                            },
                            mensajeError: 'No se pudo cargar el DNI reverso.',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Comprobante a nombre del dueno (subir solo 1)',
                      style: tema.textTheme.labelMedium?.copyWith(
                        color: ColoresApp.secundario,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: _TipoComprobanteDueno.values.map((tipo) {
                      final activo = _tipoComprobanteDueno == tipo;
                      return ChoiceChip(
                        selected: activo,
                        label: Text(tipo.etiqueta),
                        selectedColor: ColoresApp.secundario,
                        backgroundColor:
                            ColoresApp.secundario.withValues(alpha: 0.12),
                        labelStyle: tema.textTheme.bodySmall?.copyWith(
                          color: activo ? ColoresApp.primario : ColoresApp.secundario,
                          fontWeight: FontWeight.w700,
                        ),
                        onSelected: (_) {
                          setState(() {
                            _tipoComprobanteDueno = tipo;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  _cajaDocumentoDueno(
                    tema: tema,
                    titulo: _tipoComprobanteDueno == null
                        ? 'Subir comprobante'
                        : 'Subir ${_tipoComprobanteDueno!.etiqueta}',
                    bytes: _comprobanteDuenoBytes,
                    onTap: _tipoComprobanteDueno == null
                        ? null
                        : () => _seleccionarDocumentoDueno(
                              onSeleccionado: (foto, bytes) {
                                _comprobanteDueno = foto;
                                _comprobanteDuenoBytes = bytes;
                              },
                              mensajeError:
                                  'No se pudo cargar el comprobante seleccionado.',
                            ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Formulario de personal a cargo',
              style: tema.textTheme.titleMedium?.copyWith(
                color: ColoresApp.primario,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            _itemAcordeon(
              indice: 4,
              titulo: 'Personal del negocio',
              completo: _personalCompleto,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Registra barberos o estilistas de tu negocio.',
                    style: tema.textTheme.bodySmall?.copyWith(
                      color: ColoresApp.secundario.withValues(alpha: 0.78),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ..._personal.asMap().entries.map(
                    (entrada) => _tarjetaPersonal(
                      tema: tema,
                      indice: entrada.key,
                      persona: entrada.value,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _personal.add(_PersonalFormulario());
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ColoresApp.secundario,
                        side: BorderSide(
                          color: ColoresApp.secundario.withValues(alpha: 0.8),
                        ),
                      ),
                      icon: const Icon(Icons.person_add_alt_1, size: 18),
                      label: const Text('Agregar personal'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Center(
              child: Text(
                'Vista previa del negocio',
                textAlign: TextAlign.center,
                style: tema.textTheme.titleMedium?.copyWith(
                  color: ColoresApp.acento,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                'Asi se mostrara tu negocio a tus clientes',
                textAlign: TextAlign.center,
                style: tema.textTheme.bodySmall?.copyWith(
                  color: ColoresApp.textoClaro,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _vistaPreviaNegocio(tema),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _guardar,
              icon: const Icon(Icons.check),
              label: Text(
                widget.esAlta ? 'Enviar datos a revision' : 'Guardar cambios',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColoresApp.primario,
                foregroundColor: ColoresApp.secundario,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Siguiente paso: validar vista previa y enviar datos.',
              textAlign: TextAlign.center,
              style: tema.textTheme.bodySmall?.copyWith(
                color: ColoresApp.textoClaro,
              ),
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
          onTap: () => setState(() => _panelActivo = abierto ? -1 : indice),
          child: Container(
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
              border: Border.all(color: ColoresApp.primario),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    titulo,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: ColoresApp.primario,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                _BadgeEstadoAcordeon(completo: completo),
                const SizedBox(width: 8),
                Icon(
                  abierto
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: ColoresApp.primario,
                ),
              ],
            ),
          ),
        ),
        if (abierto)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            decoration: const BoxDecoration(
              color: ColoresApp.primario,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: child,
          ),
      ],
    );
  }

  Widget _campoAcordeon(
    String etiqueta,
    TextEditingController controlador, {
    TextInputType? teclado,
    bool requerido = true,
    int maxLineas = 1,
    IconData? icono = Icons.text_fields,
    List<TextInputFormatter>? inputFormatters,
    String? hintTexto,
    String? Function(String?)? validadorPersonalizado,
  }) {
    final tema = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controlador,
        keyboardType: teclado,
        maxLines: maxLineas,
        style: _textoClaro(tema),
        inputFormatters: inputFormatters,
        validator: (valor) {
          if (validadorPersonalizado != null) {
            final mensaje = validadorPersonalizado(valor);
            if (mensaje != null) return mensaje;
          }
          if (!requerido) return null;
          if (valor == null || valor.trim().isEmpty) {
            return 'Este campo es obligatorio';
          }
          return null;
        },
        decoration: _decoracionAcordeon(
          tema,
          etiqueta: etiqueta,
          icono: icono,
          hintTexto: hintTexto,
        ),
      ),
    );
  }

  InputDecoration _decoracionAcordeon(
    ThemeData tema, {
    required String etiqueta,
    IconData? icono,
    IconData? suffixIcono,
    String? prefijoTexto,
    String? hintTexto,
  }) {
    return InputDecoration(
      labelText: etiqueta,
      hintText: hintTexto,
      hintStyle: tema.textTheme.bodySmall?.copyWith(
        color: ColoresApp.secundario.withValues(alpha: 0.68),
      ),
      labelStyle: tema.textTheme.bodySmall?.copyWith(
        color: ColoresApp.secundario.withValues(alpha: 0.85),
      ),
      prefixIcon:
          icono == null ? null : Icon(icono, color: ColoresApp.secundario),
      suffixIcon: suffixIcono == null
          ? null
          : Icon(suffixIcono, color: ColoresApp.secundario),
      prefixText: prefijoTexto,
      prefixStyle: tema.textTheme.bodyMedium?.copyWith(
        color: ColoresApp.secundario,
        fontWeight: FontWeight.w700,
      ),
      filled: true,
      fillColor: ColoresApp.secundario.withValues(alpha: 0.1),
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
          color: ColoresApp.secundario.withValues(alpha: 0.85),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: ColoresApp.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: ColoresApp.error),
      ),
    );
  }

  TextStyle _textoClaro(ThemeData tema) {
    return tema.textTheme.bodyMedium?.copyWith(color: ColoresApp.secundario) ??
        const TextStyle(color: ColoresApp.secundario);
  }

  Widget _celdaTabla(String texto, {bool esEncabezado = false}) {
    final tema = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: Text(
        texto,
        textAlign: TextAlign.center,
        style: (esEncabezado
                ? tema.textTheme.labelMedium
                : tema.textTheme.bodySmall)
            ?.copyWith(
              color: ColoresApp.secundario,
              fontWeight: esEncabezado ? FontWeight.w700 : FontWeight.w500,
            ),
      ),
    );
  }

  Widget _tarjetaPersonal({
    required ThemeData tema,
    required int indice,
    required _PersonalFormulario persona,
  }) {
    final serviciosNegocio = _itemsServiciosNegocio;
    final diasDisponibles = _diasDisponiblesNegocio;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ColoresApp.secundario.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ColoresApp.secundario.withValues(alpha: 0.22),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => _seleccionarFotoPersonal(persona),
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: ColoresApp.secundario.withValues(alpha: 0.2),
                  backgroundImage: persona.fotoBytes != null
                      ? MemoryImage(persona.fotoBytes!)
                      : null,
                  child: persona.fotoBytes == null
                      ? const Icon(
                          Icons.add_a_photo_outlined,
                          color: ColoresApp.secundario,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  persona.foto == null
                      ? 'Agregar foto del personal'
                      : 'Foto cargada (tocar para cambiar)',
                  style: tema.textTheme.bodySmall?.copyWith(
                    color: ColoresApp.secundario.withValues(alpha: 0.88),
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
                  'Personal ${indice + 1}',
                  style: tema.textTheme.labelLarge?.copyWith(
                    color: ColoresApp.secundario,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (_personal.length > 1)
                IconButton(
                  onPressed: () {
                    setState(() {
                      persona.dispose();
                      _personal.removeAt(indice);
                    });
                  },
                  icon: const Icon(Icons.delete_outline),
                  color: ColoresApp.error,
                  tooltip: 'Eliminar',
                ),
            ],
          ),
          _campoAcordeon(
            'Nombre completo',
            persona.nombre,
            icono: Icons.person_outline,
          ),
          _campoAcordeon(
            'Anos de experiencia',
            persona.experiencia,
            teclado: TextInputType.number,
            icono: Icons.work_outline,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            hintTexto: '1 - 80',
            validadorPersonalizado: (valor) {
              final numero = int.tryParse((valor ?? '').trim());
              if (numero == null) {
                return 'Ingresa un numero valido';
              }
              if (numero < 1 || numero > 80) {
                return 'Debe estar entre 1 y 80';
              }
              return null;
            },
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Servicios que realiza (segun negocio)',
              style: tema.textTheme.labelMedium?.copyWith(
                color: ColoresApp.secundario,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 6),
          if (serviciosNegocio.isEmpty)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ColoresApp.error.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: ColoresApp.error),
              ),
              child: Text(
                'Primero selecciona servicios en "Servicios disponibles".',
                style: tema.textTheme.bodySmall?.copyWith(
                  color: ColoresApp.secundario,
                ),
              ),
            )
          else
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: serviciosNegocio.map((servicio) {
                final activo =
                    (persona.serviciosSeleccionados ?? const <String>{})
                        .contains(servicio);
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
                      final servicios =
                          persona.serviciosSeleccionados ??= <String>{};
                      if (valor) {
                        servicios.add(servicio);
                      } else {
                        servicios.remove(servicio);
                        final controlador =
                            persona.minutosPorServicio.remove(servicio);
                        controlador?.dispose();
                      }
                    });
                  },
                );
              }).toList(),
            ),
          if ((persona.serviciosSeleccionados ?? const <String>{}).isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Duracion por servicio (minutos)',
                    style: tema.textTheme.labelMedium?.copyWith(
                      color: ColoresApp.secundario,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                ...((persona.serviciosSeleccionados ?? const <String>{}).toList()
                      ..sort())
                    .map((servicio) {
                  final controladorMinutos =
                      persona.minutosPorServicio.putIfAbsent(
                    servicio,
                    () => TextEditingController(),
                  );
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextFormField(
                      controller: controladorMinutos,
                      keyboardType: TextInputType.number,
                      style: _textoClaro(tema),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (valor) {
                        final minutos = int.tryParse((valor ?? '').trim());
                        if (minutos == null) {
                          return 'Ingresa minutos validos para $servicio';
                        }
                        if (minutos <= 0 || minutos > 600) {
                          return 'Minutos entre 1 y 600 para $servicio';
                        }
                        return null;
                      },
                      decoration: _decoracionAcordeon(
                        tema,
                        etiqueta: '$servicio (min)',
                        hintTexto: 'Ejemplo: 30',
                        icono: Icons.schedule_outlined,
                      ),
                    ),
                  );
                }),
              ],
            ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Horario personalizado',
              style: tema.textTheme.labelMedium?.copyWith(
                color: ColoresApp.secundario,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 6),
          if (diasDisponibles.isEmpty)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ColoresApp.error.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: ColoresApp.error),
              ),
              child: Text(
                'Primero define el horario del negocio para habilitar horario del personal.',
                style: tema.textTheme.bodySmall?.copyWith(
                  color: ColoresApp.secundario,
                ),
              ),
            )
          else
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: diasDisponibles.map((dia) {
                final activo =
                    (persona.diasTrabajo ?? const <String>{}).contains(dia);
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
                    dia,
                    style: tema.textTheme.bodySmall?.copyWith(
                      color: activo ? ColoresApp.primario : ColoresApp.secundario,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onSelected: (valor) {
                    setState(() {
                      final dias = persona.diasTrabajo ??= <String>{};
                      if (valor) {
                        dias.add(dia);
                      } else {
                        dias.remove(dia);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: diasDisponibles.isEmpty
                      ? null
                      : () => _seleccionarHoraPersonal(persona, entrada: true),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ColoresApp.secundario,
                    side: BorderSide(
                      color: ColoresApp.secundario.withValues(alpha: 0.5),
                    ),
                  ),
                  icon: const Icon(Icons.login_rounded, size: 16),
                  label: Text(
                    persona.horaEntrada == null
                        ? 'Hora entrada'
                        : _formatearHora12h(persona.horaEntrada!),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: diasDisponibles.isEmpty
                      ? null
                      : () => _seleccionarHoraPersonal(persona, entrada: false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ColoresApp.secundario,
                    side: BorderSide(
                      color: ColoresApp.secundario.withValues(alpha: 0.5),
                    ),
                  ),
                  icon: const Icon(Icons.logout_rounded, size: 16),
                  label: Text(
                    persona.horaSalida == null
                        ? 'Hora salida'
                        : _formatearHora12h(persona.horaSalida!),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _campoAcordeon(
            'Correo electronico',
            persona.correo,
            teclado: TextInputType.emailAddress,
            icono: Icons.email_outlined,
          ),
          _campoAcordeon(
            'Numero de DNI',
            persona.dni,
            teclado: TextInputType.number,
            icono: Icons.badge_outlined,
          ),
        ],
      ),
    );
  }

  Widget _vistaPreviaNegocio(ThemeData tema) {
    final servicios = _categoriasServiciosNegocio;
    final horarios = _resumenHorariosNegocio;
    final bytesPortada = _fotosBytes[0];
    final horarioTag = horarios.isEmpty
        ? 'Pendiente definir horarios'
        : horarios.take(2).map(_normalizarLineaHorarioVistaPrevia).join('\n');

    return Container(
      decoration: BoxDecoration(
        color: ColoresApp.primario,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColoresApp.terceario.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: SizedBox(
              height: 178,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (bytesPortada != null)
                    Image.memory(bytesPortada, fit: BoxFit.cover)
                  else
                    Container(
                      color: ColoresApp.fondo,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.storefront_outlined,
                        color: ColoresApp.terceario,
                        size: 42,
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          ColoresApp.primario.withValues(alpha: 0.18),
                          ColoresApp.primario.withValues(alpha: 0.88),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _nombreNegocio.text.trim().isEmpty
                              ? 'Nombre del negocio'
                              : _nombreNegocio.text.trim(),
                          style: tema.textTheme.titleMedium?.copyWith(
                            color: ColoresApp.secundario,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        _tagInfoVistaPrevia(
                          icono: Icons.location_on_outlined,
                          etiqueta: 'Ubicacion',
                          texto: _ubicacionNegocioVistaPrevia,
                        ),
                        const SizedBox(height: 6),
                        _tagInfoVistaPrevia(
                          icono: Icons.schedule_outlined,
                          etiqueta: 'Horarios',
                          texto: horarioTag,
                          maxLineasTexto: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (servicios.isEmpty)
                  Text(
                    'Servicios: pendiente seleccionar.',
                    style: tema.textTheme.bodySmall?.copyWith(
                      color: ColoresApp.secundario.withValues(alpha: 0.8),
                      fontSize: 11,
                    ),
                  )
                else
                  Text(
                    'Servicios: ${servicios.join(', ')}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: tema.textTheme.bodySmall?.copyWith(
                      color: ColoresApp.secundario.withValues(alpha: 0.95),
                      fontSize: 11,
                    ),
                  ),
                const SizedBox(height: 10),
                Text(
                  'Personal a cargo',
                  style: tema.textTheme.labelLarge?.copyWith(
                    color: ColoresApp.secundario,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                if (_personal.isEmpty)
                  Text(
                    'No hay personal agregado.',
                    style: tema.textTheme.bodySmall?.copyWith(
                      color: ColoresApp.secundario.withValues(alpha: 0.8),
                    ),
                  )
                else
                  ..._personal.asMap().entries.map((entrada) {
                    final persona = entrada.value;
                    final dias =
                        (persona.diasTrabajo ?? const <String>{}).toList()..sort();
                    final serviciosPersona =
                        (persona.serviciosSeleccionados ?? const <String>{}).toList()
                          ..sort();
                    final serviciosConMinutos = serviciosPersona
                        .map((servicio) {
                          final minutos =
                              persona.minutosPorServicio[servicio]?.text.trim() ?? '';
                          if (minutos.isEmpty) return servicio;
                          return '$servicio ($minutos min)';
                        })
                        .toList();
                    final horario = persona.horaEntrada != null &&
                            persona.horaSalida != null
                        ? '${_formatearHora12h(persona.horaEntrada!)} - ${_formatearHora12h(persona.horaSalida!)}'
                        : 'Pendiente horario';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: ColoresApp.acento,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: ColoresApp.dorado.withValues(alpha: 0.55),
                        ),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 74,
                              height: 98,
                              color: ColoresApp.fondo,
                              child: persona.fotoBytes == null
                                  ? const Icon(
                                      Icons.person_outline,
                                      color: ColoresApp.terceario,
                                    )
                                  : Image.memory(
                                      persona.fotoBytes!,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  persona.nombre.text.trim().isEmpty
                                      ? 'Personal ${entrada.key + 1}'
                                      : persona.nombre.text.trim(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: tema.textTheme.labelMedium?.copyWith(
                                    color: ColoresApp.primario,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  persona.experiencia.text.trim().isEmpty
                                      ? 'Experiencia pendiente'
                                      : '${persona.experiencia.text.trim()} anos de experiencia',
                                  style: tema.textTheme.bodySmall?.copyWith(
                                    color: ColoresApp.primario.withValues(alpha: 0.78),
                                    fontSize: 10,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  dias.isEmpty
                                      ? 'Disponibilidad: pendiente'
                                      : 'Disponibilidad: ${dias.join(', ')}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: tema.textTheme.bodySmall?.copyWith(
                                    color: ColoresApp.primario,
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  horario,
                                  style: tema.textTheme.bodySmall?.copyWith(
                                    color: ColoresApp.primario,
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  serviciosConMinutos.isEmpty
                                      ? 'Servicios: pendientes'
                                    : 'Servicios: ${serviciosConMinutos.take(2).join(' • ')}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: tema.textTheme.bodySmall?.copyWith(
                                    color: ColoresApp.primario,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
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

  Widget _resumenVistaBloqueada(ThemeData tema) {
    final totalFotos = _fotos.where((foto) => foto != null).length;
    final servicios = _itemsServiciosNegocio;
    final horarios = _resumenHorariosNegocio;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColoresApp.secundario,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Datos de Mi Negocio',
            style: tema.textTheme.labelLarge?.copyWith(
              color: ColoresApp.primario,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          _filaVistaBloqueada('Telefono negocio', '$_codigoPaisNegocio ${_telefonoNegocio.text.trim()}'),
          _filaVistaBloqueada('Sucursales', _cantidadSucursales.toString()),
          _filaVistaBloqueada('Departamento', _departamento.text.trim()),
          _filaVistaBloqueada('Municipio', _municipio.text.trim()),
          _filaVistaBloqueada('Colonia', _colonia.text.trim()),
          _filaVistaBloqueada('Cuenta bancaria', _cuenta.text.trim().isEmpty ? 'No registrada' : _cuenta.text.trim()),
          _filaVistaBloqueada('Horario', horarios.isEmpty ? 'Sin definir' : horarios.join(' | ')),
          _filaVistaBloqueada('Servicios disponibles', servicios.isEmpty ? 'Sin seleccionar' : servicios.join(', ')),
          _filaVistaBloqueada('Fotos del negocio', '$totalFotos/3 cargadas'),
          _filaVistaBloqueada('Correo del dueno', _emailDueno.text.trim()),
          _filaVistaBloqueada('Celular del dueno', _celularDueno.text.trim()),
          _filaVistaBloqueada('Personal a cargo', '${_personal.length} registrado(s)'),
        ],
      ),
    );
  }

  Widget _filaVistaBloqueada(String etiqueta, String valor) {
    final tema = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              etiqueta,
              style: tema.textTheme.bodySmall?.copyWith(
                color: ColoresApp.textoClaro,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 7,
            child: Text(
              valor.isEmpty ? 'Pendiente' : valor,
              style: tema.textTheme.bodySmall?.copyWith(
                color: ColoresApp.primario,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatearHora12h(TimeOfDay hora) {
    final hora24 = hora.hour;
    final minuto = hora.minute.toString().padLeft(2, '0');
    final esPm = hora24 >= 12;
    final hora12 = hora24 % 12 == 0 ? 12 : hora24 % 12;
    final periodo = esPm ? 'PM' : 'AM';
    return '${hora12.toString().padLeft(2, '0')}:$minuto $periodo';
  }

  String _normalizarLineaHorarioVistaPrevia(String linea) {
    final partes = linea.split(': ');
    final dias = partes.first;
    final horas = partes.length > 1
        ? partes.sublist(1).join(': ').replaceFirst(' - ', ' a ')
        : '';
    final resultado = horas.isEmpty ? dias : '$dias $horas';
    return resultado.replaceAllMapped(
      RegExp(r'\b(AM|PM)\b'),
      (match) => match.group(1)!.toLowerCase(),
    );
  }

  Widget _tagInfoVistaPrevia({
    required IconData icono,
    required String etiqueta,
    required String texto,
    int maxLineasTexto = 1,
  }) {
    final tema = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 6, 10, 6),
      decoration: BoxDecoration(
        color: ColoresApp.secundario.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColoresApp.dorado.withValues(alpha: 0.7)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: ColoresApp.secundario,
              shape: BoxShape.circle,
            ),
            child: Icon(icono, size: 12, color: ColoresApp.primario),
          ),
          const SizedBox(width: 7),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  etiqueta,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tema.textTheme.labelSmall?.copyWith(
                    color: ColoresApp.dorado,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  texto,
                  maxLines: maxLineasTexto,
                  overflow: TextOverflow.ellipsis,
                  style: tema.textTheme.bodySmall?.copyWith(
                    color: ColoresApp.secundario,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cajaDocumentoDueno({
    required ThemeData tema,
    required String titulo,
    required Uint8List? bytes,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 116,
        decoration: BoxDecoration(
          color: ColoresApp.secundario.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ColoresApp.secundario.withValues(alpha: 0.35),
          ),
        ),
        child: bytes == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add_photo_alternate_outlined,
                    color: ColoresApp.secundario,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    titulo,
                    textAlign: TextAlign.center,
                    style: tema.textTheme.bodySmall?.copyWith(
                      color: ColoresApp.secundario,
                    ),
                  ),
                ],
              )
            : Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(bytes, fit: BoxFit.cover),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      color: ColoresApp.primario.withValues(alpha: 0.65),
                      child: Text(
                        'Cambiar',
                        textAlign: TextAlign.center,
                        style: tema.textTheme.labelSmall?.copyWith(
                          color: ColoresApp.secundario,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

enum _TipoNegocio { barberia, salonBelleza }

class _HorarioDia {
  _HorarioDia({required this.nombreDia});

  final String nombreDia;
  bool cerrado = false;
  TimeOfDay? apertura;
  TimeOfDay? cierre;
}

class _PersonalFormulario {
  final nombre = TextEditingController();
  final experiencia = TextEditingController();
  final correo = TextEditingController();
  final dni = TextEditingController();
  final Map<String, TextEditingController> minutosPorServicio = {};

  Set<String>? serviciosSeleccionados = <String>{};
  Set<String>? diasTrabajo = <String>{};
  TimeOfDay? horaEntrada;
  TimeOfDay? horaSalida;
  XFile? foto;
  Uint8List? fotoBytes;

  void dispose() {
    nombre.dispose();
    experiencia.dispose();
    correo.dispose();
    dni.dispose();
    for (final controlador in minutosPorServicio.values) {
      controlador.dispose();
    }
  }
}

enum _TipoComprobanteDueno { arrendamiento, luz, agua }

extension _TipoComprobanteDuenoX on _TipoComprobanteDueno {
  String get etiqueta {
    switch (this) {
      case _TipoComprobanteDueno.arrendamiento:
        return 'Arrendamiento';
      case _TipoComprobanteDueno.luz:
        return 'Luz';
      case _TipoComprobanteDueno.agua:
        return 'Agua';
    }
  }
}

class _BadgeEstadoAcordeon extends StatelessWidget {
  const _BadgeEstadoAcordeon({required this.completo});

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

class _CodigoPais {
  const _CodigoPais({required this.pais, required this.codigo});

  final String pais;
  final String codigo;
}

const List<String> _diasSemana = [
  'Lunes',
  'Martes',
  'Miercoles',
  'Jueves',
  'Viernes',
  'Sabado',
  'Domingo',
];

const Map<String, String> _abreviaturasDiasSemana = {
  'Lunes': 'lun',
  'Martes': 'mar',
  'Miercoles': 'mier',
  'Jueves': 'jue',
  'Viernes': 'vie',
  'Sabado': 'sab',
  'Domingo': 'dom',
};

const List<_CodigoPais> _codigosPaisBasicos = [
  _CodigoPais(pais: 'Honduras', codigo: '+504'),
  _CodigoPais(pais: 'Guatemala', codigo: '+502'),
  _CodigoPais(pais: 'El Salvador', codigo: '+503'),
  _CodigoPais(pais: 'Nicaragua', codigo: '+505'),
  _CodigoPais(pais: 'Costa Rica', codigo: '+506'),
  _CodigoPais(pais: 'Panama', codigo: '+507'),
  _CodigoPais(pais: 'Mexico', codigo: '+52'),
  _CodigoPais(pais: 'Colombia', codigo: '+57'),
  _CodigoPais(pais: 'Peru', codigo: '+51'),
  _CodigoPais(pais: 'Argentina', codigo: '+54'),
  _CodigoPais(pais: 'Chile', codigo: '+56'),
  _CodigoPais(pais: 'Espana', codigo: '+34'),
  _CodigoPais(pais: 'Estados Unidos', codigo: '+1'),
];

const Map<_TipoNegocio, Map<String, List<String>>> _catalogoServicios = {
  _TipoNegocio.barberia: {
    'Corte de cabello': [
      'Corte clasico',
      'Fade / Degradado',
      'Low Fade',
      'Mid Fade',
      'High Fade',
      'Skin Fade',
      'Taper Fade',
      'Corte militar',
      'Corte con tijera',
      'Corte escolar',
      'Diseno con maquina/navaja',
    ],
    'Barba': [
      'Perfilado de barba',
      'Recorte de barba',
      'Barba completa',
      'Barba corta',
      'Barba larga',
      'Barba degradada',
      'Diseno de barba',
      'Afeitado clasico',
      'Afeitado con navaja',
    ],
    'Cejas': [
      'Perfilado de cejas',
      'Diseno de cejas con navaja',
      'Diseno de cejas con pinza',
      'Limpieza de cejas',
    ],
    'Tratamientos': [
      'Lavado de cabello',
      'Lavado + acondicionamiento',
      'Hidratacion capilar',
      'Tratamiento anticaspa',
      'Mascarilla capilar',
      'Masaje capilar',
    ],
  },
  _TipoNegocio.salonBelleza: {
    'Corte de cabello': [
      'Corte clasico',
      'Corte en capas',
      'Corte recto',
      'Corte bob',
      'Corte pixie',
      'Corte mariposa',
      'Flequillo',
      'Corte en V',
      'Corte en U',
    ],
    'Peinados': [
      'Peinado casual',
      'Peinado con ondas',
      'Peinado liso',
      'Recogido',
      'Mono',
      'Trenzas',
      'Peinado para eventos',
      'Peinado para bodas',
    ],
    'Coloracion': [
      'Tinte completo',
      'Retoque de raices',
      'Balayage',
      'Mechas',
      'Babylights',
      'Highlights',
      'Ombre',
      'Correccion de color',
      'Tonalizacion',
    ],
    'Tratamientos capilares': [
      'Hidratacion',
      'Keratina',
      'Alisado',
      'Botox capilar',
      'Nanoplastia',
      'Reparacion capilar',
      'Tratamiento anti-frizz',
      'Tratamiento para cabello danado',
    ],
    'Cejas': [
      'Perfilado de cejas',
      'Diseno de cejas',
      'Depilacion con pinza',
      'Depilacion con cera',
      'Henna para cejas',
      'Laminado de cejas',
    ],
    'Pestanas': [
      'Extensiones clasicas',
      'Extensiones volumen',
      'Extensiones hibridas',
      'Lifting de pestanas',
      'Tinte de pestanas',
    ],
    'Depilacion': [
      'Rostro',
      'Cejas',
      'Bozo',
      'Axilas',
      'Brazos',
      'Piernas',
      'Linea de bikini',
    ],
    'Manicure': [
      'Manicure clasica',
      'Manicure semipermanente',
      'Manicure en gel',
      'Unas acrilicas',
      'Unas de polygel',
      'Nail art',
      'Francesa',
      'Diseno personalizado',
    ],
    'Pedicure': [
      'Pedicure clasica',
      'Pedicure semipermanente',
      'Pedicure spa',
      'Pedicure con gel',
      'Exfoliacion',
      'Hidratacion de pies',
    ],
    'Maquillaje': [
      'Maquillaje social',
      'Maquillaje natural',
      'Maquillaje de noche',
      'Maquillaje para eventos',
      'Maquillaje para novia',
      'Maquillaje artistico',
    ],
  },
};
