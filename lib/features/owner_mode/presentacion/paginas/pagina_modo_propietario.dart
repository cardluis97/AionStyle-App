import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/router/enrutador.dart';
import '../../../../app/theme/colores.dart';
import '../../../auth/dominio/entidades/rol_usuario.dart';
import '../../../auth/presentacion/proveedores/proveedores_auth.dart';

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
  final _sucursales = TextEditingController(text: '1');
  final _departamento = TextEditingController();
  final _municipio = TextEditingController();
  final _direccion = TextEditingController();
  final _cuenta = TextEditingController();
  final _horarios = TextEditingController();
  final _servicios = TextEditingController();
  final _precios = TextEditingController();
  final _nombreDueno = TextEditingController();
  final _emailDueno = TextEditingController();
  final _celularDueno = TextEditingController();
  final _dniDueno = TextEditingController();
  final List<_BarberoFormulario> _barberos = [_BarberoFormulario()];
  final List<XFile?> _fotos = [null, null, null];

  @override
  void initState() {
    super.initState();
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
  }

  @override
  void dispose() {
    for (final controlador in [
      _nombreNegocio, _telefonoNegocio, _sucursales, _departamento,
      _municipio, _direccion, _cuenta, _horarios, _servicios, _precios,
      _nombreDueno, _emailDueno, _celularDueno, _dniDueno,
    ]) {
      controlador.dispose();
    }
    for (final barbero in _barberos) {
      barbero.dispose();
    }
    super.dispose();
  }

  Future<void> _seleccionarFoto(int indice) async {
    final foto = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (foto != null) setState(() => _fotos[indice] = foto);
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;
    if (_fotos.any((foto) => foto == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adjunta las 3 fotos del negocio.')),
      );
      return;
    }
    ref.read(viewModelAuthProvider.notifier).activarRol(RolUsuario.dueno);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tu negocio fue registrado correctamente.')),
    );
    context.go(Rutas.miNegocio);
  }

  @override
  Widget build(BuildContext context) {
    final titulo = widget.esAlta ? 'Ingresar como dueño' : 'Mi negocio';
    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      appBar: AppBar(
        title: Text(titulo),
        backgroundColor: ColoresApp.primario,
        foregroundColor: ColoresApp.secundario,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            _seccion('Datos del negocio', [
              _campo('Nombre negocio', _nombreNegocio),
              _campo('Teléfono del negocio', _telefonoNegocio,
                  teclado: TextInputType.phone),
              _campo('Cantidad de sucursales', _sucursales,
                  teclado: TextInputType.number),
              _campo('Departamento negocio principal', _departamento),
              _campo('Municipio negocio principal', _municipio),
              _campo('Dirección exacta del negocio', _direccion),
              _campo('Cuenta bancaria (opcional)', _cuenta),
              _campo('Horarios de atención', _horarios),
              _campo('Servicios disponibles', _servicios,
                  hint: 'Ej. Corte clásico, barba, tintura'),
              _campo('Precio por servicio', _precios,
                  teclado: TextInputType.number),
              const SizedBox(height: 4),
              Text('Fotos del negocio', style: _subtitulo(context)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(3, (indice) {
                  final foto = _fotos[indice];
                  return OutlinedButton.icon(
                    onPressed: () => _seleccionarFoto(indice),
                    icon: Icon(foto == null
                        ? Icons.add_a_photo_outlined
                        : Icons.check_circle_outline),
                    label: Text(foto == null ? 'Foto ${indice + 1}' : 'Adjunta'),
                  );
                }),
              ),
            ]),
            _seccion('Datos personales del dueño', [
              _campo('Nombre completo del dueño', _nombreDueno),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Tipo de negocio'),
                items: const [
                  DropdownMenuItem(value: 'Barbería', child: Text('Barbería')),
                  DropdownMenuItem(
                      value: 'Salón de belleza', child: Text('Salón de belleza')),
                ],
                onChanged: (_) {},
              ),
              _campo('Email', _emailDueno, teclado: TextInputType.emailAddress),
              _campo('Celular', _celularDueno, teclado: TextInputType.phone),
              _campo('Número de DNI', _dniDueno,
                  teclado: TextInputType.number),
            ]),
            _seccion('Personal a cargo', [
              ..._barberos.asMap().entries.map(
                    (entrada) => _formularioBarbero(entrada.key, entrada.value),
                  ),
              OutlinedButton.icon(
                onPressed: () => setState(
                  () => _barberos.add(_BarberoFormulario()),
                ),
                icon: const Icon(Icons.person_add_alt_1),
                label: const Text('Añadir barbero'),
              ),
            ]),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _guardar,
              icon: const Icon(Icons.check),
              label: Text(widget.esAlta ? 'Registrar negocio' : 'Guardar cambios'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColoresApp.primario,
                foregroundColor: ColoresApp.secundario,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _seccion(String titulo, List<Widget> children) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: _subtitulo(context)),
            const SizedBox(height: 8),
            Card(
              color: ColoresApp.secundario,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(children: children),
              ),
            ),
          ],
        ),
      );

  TextStyle? _subtitulo(BuildContext context) =>
      Theme.of(context).textTheme.titleMedium?.copyWith(
            color: ColoresApp.primario,
            fontWeight: FontWeight.w700,
          );

  Widget _campo(String etiqueta, TextEditingController controlador,
          {TextInputType? teclado, String? hint}) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: TextFormField(
          controller: controlador,
          keyboardType: teclado,
          validator: (valor) => valor == null || valor.trim().isEmpty
              ? 'Este campo es obligatorio'
              : null,
          decoration: InputDecoration(labelText: etiqueta, hintText: hint),
        ),
      );

  Widget _formularioBarbero(int indice, _BarberoFormulario barbero) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        color: ColoresApp.fondo,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: Text('Barbero ${indice + 1}', style: _subtitulo(context))),
                  if (_barberos.length > 1)
                    IconButton(
                      onPressed: () => setState(() {
                        barbero.dispose();
                        _barberos.removeAt(indice);
                      }),
                      icon: const Icon(Icons.delete_outline),
                      color: ColoresApp.error,
                    ),
                ],
              ),
              _campo('Nombre de barbero', barbero.nombre),
              _campo('Años de experiencia', barbero.experiencia,
                  teclado: TextInputType.number),
              _campo('Servicios que ejerce', barbero.servicios),
              _campo('Horario de trabajo', barbero.horario),
              _campo('Correo electrónico', barbero.correo,
                  teclado: TextInputType.emailAddress),
              _campo('Número de DNI', barbero.dni,
                  teclado: TextInputType.number),
            ],
          ),
        ),
      );
}

class _BarberoFormulario {
  final nombre = TextEditingController();
  final experiencia = TextEditingController();
  final servicios = TextEditingController();
  final horario = TextEditingController();
  final correo = TextEditingController();
  final dni = TextEditingController();

  void dispose() {
    nombre.dispose();
    experiencia.dispose();
    servicios.dispose();
    horario.dispose();
    correo.dispose();
    dni.dispose();
  }
}
