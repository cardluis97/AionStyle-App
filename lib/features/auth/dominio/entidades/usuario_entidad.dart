import 'package:equatable/equatable.dart';
import 'rol_usuario.dart';
import 'tipo_documento.dart';
import 'proveedor_autenticacion.dart';

class UsuarioEntidad extends Equatable {
  const UsuarioEntidad({
    required this.id,
    required this.nombreCompleto,
    required this.correo,
    this.telefono,
    required this.tipoDocumento,
    required this.numeroDocumento,
    this.imagenPerfil,
    required this.roles,
    required this.proveedorAutenticacion,
  });

  final String id;
  final String nombreCompleto;
  final String correo;
  final String? telefono;
  final TipoDocumento tipoDocumento;
  final String numeroDocumento;
  final String? imagenPerfil;
  final List<RolUsuario> roles;
  final ProveedorAutenticacion proveedorAutenticacion;

  /// Perfil completo = tiene teléfono y número de documento
  bool get perfilCompleto =>
      telefono != null &&
      telefono!.isNotEmpty &&
      numeroDocumento.isNotEmpty;

  bool tieneRol(RolUsuario rol) => roles.contains(rol);

  bool get esCliente => tieneRol(RolUsuario.cliente);
  bool get esBarbero => tieneRol(RolUsuario.barbero);
  bool get esDueno => tieneRol(RolUsuario.dueno);

  UsuarioEntidad copyWith({List<RolUsuario>? roles}) => UsuarioEntidad(
        id: id,
        nombreCompleto: nombreCompleto,
        correo: correo,
        telefono: telefono,
        tipoDocumento: tipoDocumento,
        numeroDocumento: numeroDocumento,
        imagenPerfil: imagenPerfil,
        roles: roles ?? this.roles,
        proveedorAutenticacion: proveedorAutenticacion,
      );

  @override
  List<Object?> get props => [
        id,
        nombreCompleto,
        correo,
        telefono,
        tipoDocumento,
        numeroDocumento,
        imagenPerfil,
        roles,
        proveedorAutenticacion,
      ];
}
