// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'negocio_modelo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NegocioModelo _$NegocioModeloFromJson(Map<String, dynamic> json) =>
    _NegocioModelo(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      direccion: json['direccion'] as String,
      telefono: json['telefono'] as String?,
      fotoPrincipal: json['foto_principal'] as String?,
      calificacion: (json['calificacion'] as num?)?.toDouble() ?? 0.0,
      totalResenas: (json['total_resenas'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$NegocioModeloToJson(_NegocioModelo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'direccion': instance.direccion,
      'telefono': instance.telefono,
      'foto_principal': instance.fotoPrincipal,
      'calificacion': instance.calificacion,
      'total_resenas': instance.totalResenas,
    };
