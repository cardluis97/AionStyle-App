// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'usuario_modelo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UsuarioModelo {
  String get id;
  @JsonKey(name: 'nombre_completo')
  String get nombreCompleto;
  String get correo;
  String? get telefono;
  @JsonKey(name: 'tipo_documento')
  String get tipoDocumento;
  @JsonKey(name: 'numero_documento')
  String get numeroDocumento;
  @JsonKey(name: 'imagen_perfil')
  String? get imagenPerfil;
  List<String> get roles;
  @JsonKey(name: 'proveedor_autenticacion')
  String get proveedorAutenticacion;

  /// Create a copy of UsuarioModelo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UsuarioModeloCopyWith<UsuarioModelo> get copyWith =>
      _$UsuarioModeloCopyWithImpl<UsuarioModelo>(
          this as UsuarioModelo, _$identity);

  /// Serializes this UsuarioModelo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UsuarioModelo &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombreCompleto, nombreCompleto) ||
                other.nombreCompleto == nombreCompleto) &&
            (identical(other.correo, correo) || other.correo == correo) &&
            (identical(other.telefono, telefono) ||
                other.telefono == telefono) &&
            (identical(other.tipoDocumento, tipoDocumento) ||
                other.tipoDocumento == tipoDocumento) &&
            (identical(other.numeroDocumento, numeroDocumento) ||
                other.numeroDocumento == numeroDocumento) &&
            (identical(other.imagenPerfil, imagenPerfil) ||
                other.imagenPerfil == imagenPerfil) &&
            const DeepCollectionEquality().equals(other.roles, roles) &&
            (identical(other.proveedorAutenticacion, proveedorAutenticacion) ||
                other.proveedorAutenticacion == proveedorAutenticacion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      nombreCompleto,
      correo,
      telefono,
      tipoDocumento,
      numeroDocumento,
      imagenPerfil,
      const DeepCollectionEquality().hash(roles),
      proveedorAutenticacion);

  @override
  String toString() {
    return 'UsuarioModelo(id: $id, nombreCompleto: $nombreCompleto, correo: $correo, telefono: $telefono, tipoDocumento: $tipoDocumento, numeroDocumento: $numeroDocumento, imagenPerfil: $imagenPerfil, roles: $roles, proveedorAutenticacion: $proveedorAutenticacion)';
  }
}

/// @nodoc
abstract mixin class $UsuarioModeloCopyWith<$Res> {
  factory $UsuarioModeloCopyWith(
          UsuarioModelo value, $Res Function(UsuarioModelo) _then) =
      _$UsuarioModeloCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'nombre_completo') String nombreCompleto,
      String correo,
      String? telefono,
      @JsonKey(name: 'tipo_documento') String tipoDocumento,
      @JsonKey(name: 'numero_documento') String numeroDocumento,
      @JsonKey(name: 'imagen_perfil') String? imagenPerfil,
      List<String> roles,
      @JsonKey(name: 'proveedor_autenticacion') String proveedorAutenticacion});
}

/// @nodoc
class _$UsuarioModeloCopyWithImpl<$Res>
    implements $UsuarioModeloCopyWith<$Res> {
  _$UsuarioModeloCopyWithImpl(this._self, this._then);

  final UsuarioModelo _self;
  final $Res Function(UsuarioModelo) _then;

  /// Create a copy of UsuarioModelo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombreCompleto = null,
    Object? correo = null,
    Object? telefono = freezed,
    Object? tipoDocumento = null,
    Object? numeroDocumento = null,
    Object? imagenPerfil = freezed,
    Object? roles = null,
    Object? proveedorAutenticacion = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nombreCompleto: null == nombreCompleto
          ? _self.nombreCompleto
          : nombreCompleto // ignore: cast_nullable_to_non_nullable
              as String,
      correo: null == correo
          ? _self.correo
          : correo // ignore: cast_nullable_to_non_nullable
              as String,
      telefono: freezed == telefono
          ? _self.telefono
          : telefono // ignore: cast_nullable_to_non_nullable
              as String?,
      tipoDocumento: null == tipoDocumento
          ? _self.tipoDocumento
          : tipoDocumento // ignore: cast_nullable_to_non_nullable
              as String,
      numeroDocumento: null == numeroDocumento
          ? _self.numeroDocumento
          : numeroDocumento // ignore: cast_nullable_to_non_nullable
              as String,
      imagenPerfil: freezed == imagenPerfil
          ? _self.imagenPerfil
          : imagenPerfil // ignore: cast_nullable_to_non_nullable
              as String?,
      roles: null == roles
          ? _self.roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      proveedorAutenticacion: null == proveedorAutenticacion
          ? _self.proveedorAutenticacion
          : proveedorAutenticacion // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [UsuarioModelo].
extension UsuarioModeloPatterns on UsuarioModelo {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_UsuarioModelo value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UsuarioModelo() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_UsuarioModelo value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UsuarioModelo():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_UsuarioModelo value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UsuarioModelo() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            @JsonKey(name: 'nombre_completo') String nombreCompleto,
            String correo,
            String? telefono,
            @JsonKey(name: 'tipo_documento') String tipoDocumento,
            @JsonKey(name: 'numero_documento') String numeroDocumento,
            @JsonKey(name: 'imagen_perfil') String? imagenPerfil,
            List<String> roles,
            @JsonKey(name: 'proveedor_autenticacion')
            String proveedorAutenticacion)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UsuarioModelo() when $default != null:
        return $default(
            _that.id,
            _that.nombreCompleto,
            _that.correo,
            _that.telefono,
            _that.tipoDocumento,
            _that.numeroDocumento,
            _that.imagenPerfil,
            _that.roles,
            _that.proveedorAutenticacion);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            @JsonKey(name: 'nombre_completo') String nombreCompleto,
            String correo,
            String? telefono,
            @JsonKey(name: 'tipo_documento') String tipoDocumento,
            @JsonKey(name: 'numero_documento') String numeroDocumento,
            @JsonKey(name: 'imagen_perfil') String? imagenPerfil,
            List<String> roles,
            @JsonKey(name: 'proveedor_autenticacion')
            String proveedorAutenticacion)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UsuarioModelo():
        return $default(
            _that.id,
            _that.nombreCompleto,
            _that.correo,
            _that.telefono,
            _that.tipoDocumento,
            _that.numeroDocumento,
            _that.imagenPerfil,
            _that.roles,
            _that.proveedorAutenticacion);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            @JsonKey(name: 'nombre_completo') String nombreCompleto,
            String correo,
            String? telefono,
            @JsonKey(name: 'tipo_documento') String tipoDocumento,
            @JsonKey(name: 'numero_documento') String numeroDocumento,
            @JsonKey(name: 'imagen_perfil') String? imagenPerfil,
            List<String> roles,
            @JsonKey(name: 'proveedor_autenticacion')
            String proveedorAutenticacion)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UsuarioModelo() when $default != null:
        return $default(
            _that.id,
            _that.nombreCompleto,
            _that.correo,
            _that.telefono,
            _that.tipoDocumento,
            _that.numeroDocumento,
            _that.imagenPerfil,
            _that.roles,
            _that.proveedorAutenticacion);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UsuarioModelo implements UsuarioModelo {
  const _UsuarioModelo(
      {required this.id,
      @JsonKey(name: 'nombre_completo') required this.nombreCompleto,
      required this.correo,
      this.telefono,
      @JsonKey(name: 'tipo_documento') required this.tipoDocumento,
      @JsonKey(name: 'numero_documento') required this.numeroDocumento,
      @JsonKey(name: 'imagen_perfil') this.imagenPerfil,
      final List<String> roles = const ['CLIENTE'],
      @JsonKey(name: 'proveedor_autenticacion')
      this.proveedorAutenticacion = 'CORREO'})
      : _roles = roles;
  factory _UsuarioModelo.fromJson(Map<String, dynamic> json) =>
      _$UsuarioModeloFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'nombre_completo')
  final String nombreCompleto;
  @override
  final String correo;
  @override
  final String? telefono;
  @override
  @JsonKey(name: 'tipo_documento')
  final String tipoDocumento;
  @override
  @JsonKey(name: 'numero_documento')
  final String numeroDocumento;
  @override
  @JsonKey(name: 'imagen_perfil')
  final String? imagenPerfil;
  final List<String> _roles;
  @override
  @JsonKey()
  List<String> get roles {
    if (_roles is EqualUnmodifiableListView) return _roles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_roles);
  }

  @override
  @JsonKey(name: 'proveedor_autenticacion')
  final String proveedorAutenticacion;

  /// Create a copy of UsuarioModelo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UsuarioModeloCopyWith<_UsuarioModelo> get copyWith =>
      __$UsuarioModeloCopyWithImpl<_UsuarioModelo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UsuarioModeloToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UsuarioModelo &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombreCompleto, nombreCompleto) ||
                other.nombreCompleto == nombreCompleto) &&
            (identical(other.correo, correo) || other.correo == correo) &&
            (identical(other.telefono, telefono) ||
                other.telefono == telefono) &&
            (identical(other.tipoDocumento, tipoDocumento) ||
                other.tipoDocumento == tipoDocumento) &&
            (identical(other.numeroDocumento, numeroDocumento) ||
                other.numeroDocumento == numeroDocumento) &&
            (identical(other.imagenPerfil, imagenPerfil) ||
                other.imagenPerfil == imagenPerfil) &&
            const DeepCollectionEquality().equals(other._roles, _roles) &&
            (identical(other.proveedorAutenticacion, proveedorAutenticacion) ||
                other.proveedorAutenticacion == proveedorAutenticacion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      nombreCompleto,
      correo,
      telefono,
      tipoDocumento,
      numeroDocumento,
      imagenPerfil,
      const DeepCollectionEquality().hash(_roles),
      proveedorAutenticacion);

  @override
  String toString() {
    return 'UsuarioModelo(id: $id, nombreCompleto: $nombreCompleto, correo: $correo, telefono: $telefono, tipoDocumento: $tipoDocumento, numeroDocumento: $numeroDocumento, imagenPerfil: $imagenPerfil, roles: $roles, proveedorAutenticacion: $proveedorAutenticacion)';
  }
}

/// @nodoc
abstract mixin class _$UsuarioModeloCopyWith<$Res>
    implements $UsuarioModeloCopyWith<$Res> {
  factory _$UsuarioModeloCopyWith(
          _UsuarioModelo value, $Res Function(_UsuarioModelo) _then) =
      __$UsuarioModeloCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'nombre_completo') String nombreCompleto,
      String correo,
      String? telefono,
      @JsonKey(name: 'tipo_documento') String tipoDocumento,
      @JsonKey(name: 'numero_documento') String numeroDocumento,
      @JsonKey(name: 'imagen_perfil') String? imagenPerfil,
      List<String> roles,
      @JsonKey(name: 'proveedor_autenticacion') String proveedorAutenticacion});
}

/// @nodoc
class __$UsuarioModeloCopyWithImpl<$Res>
    implements _$UsuarioModeloCopyWith<$Res> {
  __$UsuarioModeloCopyWithImpl(this._self, this._then);

  final _UsuarioModelo _self;
  final $Res Function(_UsuarioModelo) _then;

  /// Create a copy of UsuarioModelo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? nombreCompleto = null,
    Object? correo = null,
    Object? telefono = freezed,
    Object? tipoDocumento = null,
    Object? numeroDocumento = null,
    Object? imagenPerfil = freezed,
    Object? roles = null,
    Object? proveedorAutenticacion = null,
  }) {
    return _then(_UsuarioModelo(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nombreCompleto: null == nombreCompleto
          ? _self.nombreCompleto
          : nombreCompleto // ignore: cast_nullable_to_non_nullable
              as String,
      correo: null == correo
          ? _self.correo
          : correo // ignore: cast_nullable_to_non_nullable
              as String,
      telefono: freezed == telefono
          ? _self.telefono
          : telefono // ignore: cast_nullable_to_non_nullable
              as String?,
      tipoDocumento: null == tipoDocumento
          ? _self.tipoDocumento
          : tipoDocumento // ignore: cast_nullable_to_non_nullable
              as String,
      numeroDocumento: null == numeroDocumento
          ? _self.numeroDocumento
          : numeroDocumento // ignore: cast_nullable_to_non_nullable
              as String,
      imagenPerfil: freezed == imagenPerfil
          ? _self.imagenPerfil
          : imagenPerfil // ignore: cast_nullable_to_non_nullable
              as String?,
      roles: null == roles
          ? _self._roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      proveedorAutenticacion: null == proveedorAutenticacion
          ? _self.proveedorAutenticacion
          : proveedorAutenticacion // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
