import 'package:freezed_annotation/freezed_annotation.dart';
import '../../dominio/entidades/usuario_entidad.dart';
import '../../dominio/entidades/rol_usuario.dart';
import '../../dominio/entidades/tipo_documento.dart';
import '../../dominio/entidades/proveedor_autenticacion.dart';

part 'usuario_modelo.freezed.dart';
part 'usuario_modelo.g.dart';

@freezed
abstract class UsuarioModelo with _$UsuarioModelo {
  const factory UsuarioModelo({
    required String id,
    @JsonKey(name: 'nombre_completo') required String nombreCompleto,
    required String correo,
    String? telefono,
    @JsonKey(name: 'tipo_documento') required String tipoDocumento,
    @JsonKey(name: 'numero_documento') required String numeroDocumento,
    @JsonKey(name: 'imagen_perfil') String? imagenPerfil,
    @Default(['CLIENTE']) List<String> roles,
    @JsonKey(name: 'proveedor_autenticacion')
    @Default('CORREO')
    String proveedorAutenticacion,
  }) = _UsuarioModelo;

  factory UsuarioModelo.fromJson(Map<String, dynamic> json) =>
      _$UsuarioModeloFromJson(json);
}

extension UsuarioModeloX on UsuarioModelo {
  UsuarioEntidad aEntidad() => UsuarioEntidad(
        id: id,
        nombreCompleto: nombreCompleto,
        correo: correo,
        telefono: telefono,
        tipoDocumento: TipoDocumento.desdeTexto(tipoDocumento),
        numeroDocumento: numeroDocumento,
        imagenPerfil: imagenPerfil,
        roles: roles.map(RolUsuario.desdeTexto).toList(),
        proveedorAutenticacion:
            ProveedorAutenticacion.desdeTexto(proveedorAutenticacion),
      );
}
