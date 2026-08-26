// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario_modelo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UsuarioModelo _$UsuarioModeloFromJson(Map<String, dynamic> json) =>
    _UsuarioModelo(
      id: json['id'] as String,
      nombreCompleto: json['nombre_completo'] as String,
      correo: json['correo'] as String,
      telefono: json['telefono'] as String?,
      tipoDocumento: json['tipo_documento'] as String,
      numeroDocumento: json['numero_documento'] as String,
      imagenPerfil: json['imagen_perfil'] as String?,
      roles:
          (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const ['CLIENTE'],
      proveedorAutenticacion:
          json['proveedor_autenticacion'] as String? ?? 'CORREO',
    );

Map<String, dynamic> _$UsuarioModeloToJson(_UsuarioModelo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre_completo': instance.nombreCompleto,
      'correo': instance.correo,
      'telefono': instance.telefono,
      'tipo_documento': instance.tipoDocumento,
      'numero_documento': instance.numeroDocumento,
      'imagen_perfil': instance.imagenPerfil,
      'roles': instance.roles,
      'proveedor_autenticacion': instance.proveedorAutenticacion,
    };
