import 'package:freezed_annotation/freezed_annotation.dart';
import '../../dominio/entidades/cita_entidad.dart';

part 'cita_modelo.freezed.dart';
part 'cita_modelo.g.dart';

@freezed
abstract class CitaModelo with _$CitaModelo {
  const factory CitaModelo({
    required String id,
    @JsonKey(name: 'usuario_id') required String usuarioId,
    @JsonKey(name: 'barbero_id') required String barberoId,
    @JsonKey(name: 'negocio_id') required String negocioId,
    @JsonKey(name: 'servicio_id') required String servicioId,
    @JsonKey(name: 'fecha_hora') required DateTime fechaHora,
    required String estado,
    double? precio,
    String? notas,
  }) = _CitaModelo;

  factory CitaModelo.fromJson(Map<String, dynamic> json) =>
      _$CitaModeloFromJson(json);
}

extension CitaModeloX on CitaModelo {
  CitaEntidad aEntidad() => CitaEntidad(
        id: id,
        usuarioId: usuarioId,
        barberoId: barberoId,
        negocioId: negocioId,
        servicioId: servicioId,
        fechaHora: fechaHora,
        estado: EstadoCita.values.firstWhere(
          (e) => e.name == estado,
          orElse: () => EstadoCita.pendiente,
        ),
        precio: precio,
        notas: notas,
      );
}
