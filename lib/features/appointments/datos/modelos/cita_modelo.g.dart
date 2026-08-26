// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cita_modelo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CitaModelo _$CitaModeloFromJson(Map<String, dynamic> json) => _CitaModelo(
      id: json['id'] as String,
      usuarioId: json['usuario_id'] as String,
      barberoId: json['barbero_id'] as String,
      negocioId: json['negocio_id'] as String,
      servicioId: json['servicio_id'] as String,
      fechaHora: DateTime.parse(json['fecha_hora'] as String),
      estado: json['estado'] as String,
      precio: (json['precio'] as num?)?.toDouble(),
      notas: json['notas'] as String?,
    );

Map<String, dynamic> _$CitaModeloToJson(_CitaModelo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'usuario_id': instance.usuarioId,
      'barbero_id': instance.barberoId,
      'negocio_id': instance.negocioId,
      'servicio_id': instance.servicioId,
      'fecha_hora': instance.fechaHora.toIso8601String(),
      'estado': instance.estado,
      'precio': instance.precio,
      'notas': instance.notas,
    };
