import 'package:freezed_annotation/freezed_annotation.dart';
import '../../dominio/entidades/negocio_entidad.dart';

part 'negocio_modelo.freezed.dart';
part 'negocio_modelo.g.dart';

@freezed
abstract class NegocioModelo with _$NegocioModelo {
  const factory NegocioModelo({
    required String id,
    required String nombre,
    required String direccion,
    String? telefono,
    @JsonKey(name: 'foto_principal') String? fotoPrincipal,
    @Default(0.0) double calificacion,
    @JsonKey(name: 'total_resenas') @Default(0) int totalResenas,
  }) = _NegocioModelo;

  factory NegocioModelo.fromJson(Map<String, dynamic> json) =>
      _$NegocioModeloFromJson(json);
}

extension NegocioModeloX on NegocioModelo {
  NegocioEntidad aEntidad() => NegocioEntidad(
        id: id,
        nombre: nombre,
        direccion: direccion,
        telefono: telefono,
        fotoPrincipal: fotoPrincipal,
        calificacion: calificacion,
        totalResenas: totalResenas,
      );
}
