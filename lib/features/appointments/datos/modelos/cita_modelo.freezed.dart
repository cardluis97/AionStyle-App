// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cita_modelo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CitaModelo {
  String get id;
  @JsonKey(name: 'usuario_id')
  String get usuarioId;
  @JsonKey(name: 'barbero_id')
  String get barberoId;
  @JsonKey(name: 'negocio_id')
  String get negocioId;
  @JsonKey(name: 'servicio_id')
  String get servicioId;
  @JsonKey(name: 'fecha_hora')
  DateTime get fechaHora;
  String get estado;
  double? get precio;
  String? get notas;

  /// Create a copy of CitaModelo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CitaModeloCopyWith<CitaModelo> get copyWith =>
      _$CitaModeloCopyWithImpl<CitaModelo>(this as CitaModelo, _$identity);

  /// Serializes this CitaModelo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CitaModelo &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.usuarioId, usuarioId) ||
                other.usuarioId == usuarioId) &&
            (identical(other.barberoId, barberoId) ||
                other.barberoId == barberoId) &&
            (identical(other.negocioId, negocioId) ||
                other.negocioId == negocioId) &&
            (identical(other.servicioId, servicioId) ||
                other.servicioId == servicioId) &&
            (identical(other.fechaHora, fechaHora) ||
                other.fechaHora == fechaHora) &&
            (identical(other.estado, estado) || other.estado == estado) &&
            (identical(other.precio, precio) || other.precio == precio) &&
            (identical(other.notas, notas) || other.notas == notas));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, usuarioId, barberoId,
      negocioId, servicioId, fechaHora, estado, precio, notas);

  @override
  String toString() {
    return 'CitaModelo(id: $id, usuarioId: $usuarioId, barberoId: $barberoId, negocioId: $negocioId, servicioId: $servicioId, fechaHora: $fechaHora, estado: $estado, precio: $precio, notas: $notas)';
  }
}

/// @nodoc
abstract mixin class $CitaModeloCopyWith<$Res> {
  factory $CitaModeloCopyWith(
          CitaModelo value, $Res Function(CitaModelo) _then) =
      _$CitaModeloCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'usuario_id') String usuarioId,
      @JsonKey(name: 'barbero_id') String barberoId,
      @JsonKey(name: 'negocio_id') String negocioId,
      @JsonKey(name: 'servicio_id') String servicioId,
      @JsonKey(name: 'fecha_hora') DateTime fechaHora,
      String estado,
      double? precio,
      String? notas});
}

/// @nodoc
class _$CitaModeloCopyWithImpl<$Res> implements $CitaModeloCopyWith<$Res> {
  _$CitaModeloCopyWithImpl(this._self, this._then);

  final CitaModelo _self;
  final $Res Function(CitaModelo) _then;

  /// Create a copy of CitaModelo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? usuarioId = null,
    Object? barberoId = null,
    Object? negocioId = null,
    Object? servicioId = null,
    Object? fechaHora = null,
    Object? estado = null,
    Object? precio = freezed,
    Object? notas = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      usuarioId: null == usuarioId
          ? _self.usuarioId
          : usuarioId // ignore: cast_nullable_to_non_nullable
              as String,
      barberoId: null == barberoId
          ? _self.barberoId
          : barberoId // ignore: cast_nullable_to_non_nullable
              as String,
      negocioId: null == negocioId
          ? _self.negocioId
          : negocioId // ignore: cast_nullable_to_non_nullable
              as String,
      servicioId: null == servicioId
          ? _self.servicioId
          : servicioId // ignore: cast_nullable_to_non_nullable
              as String,
      fechaHora: null == fechaHora
          ? _self.fechaHora
          : fechaHora // ignore: cast_nullable_to_non_nullable
              as DateTime,
      estado: null == estado
          ? _self.estado
          : estado // ignore: cast_nullable_to_non_nullable
              as String,
      precio: freezed == precio
          ? _self.precio
          : precio // ignore: cast_nullable_to_non_nullable
              as double?,
      notas: freezed == notas
          ? _self.notas
          : notas // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [CitaModelo].
extension CitaModeloPatterns on CitaModelo {
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
    TResult Function(_CitaModelo value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CitaModelo() when $default != null:
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
    TResult Function(_CitaModelo value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CitaModelo():
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
    TResult? Function(_CitaModelo value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CitaModelo() when $default != null:
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
            @JsonKey(name: 'usuario_id') String usuarioId,
            @JsonKey(name: 'barbero_id') String barberoId,
            @JsonKey(name: 'negocio_id') String negocioId,
            @JsonKey(name: 'servicio_id') String servicioId,
            @JsonKey(name: 'fecha_hora') DateTime fechaHora,
            String estado,
            double? precio,
            String? notas)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CitaModelo() when $default != null:
        return $default(
            _that.id,
            _that.usuarioId,
            _that.barberoId,
            _that.negocioId,
            _that.servicioId,
            _that.fechaHora,
            _that.estado,
            _that.precio,
            _that.notas);
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
            @JsonKey(name: 'usuario_id') String usuarioId,
            @JsonKey(name: 'barbero_id') String barberoId,
            @JsonKey(name: 'negocio_id') String negocioId,
            @JsonKey(name: 'servicio_id') String servicioId,
            @JsonKey(name: 'fecha_hora') DateTime fechaHora,
            String estado,
            double? precio,
            String? notas)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CitaModelo():
        return $default(
            _that.id,
            _that.usuarioId,
            _that.barberoId,
            _that.negocioId,
            _that.servicioId,
            _that.fechaHora,
            _that.estado,
            _that.precio,
            _that.notas);
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
            @JsonKey(name: 'usuario_id') String usuarioId,
            @JsonKey(name: 'barbero_id') String barberoId,
            @JsonKey(name: 'negocio_id') String negocioId,
            @JsonKey(name: 'servicio_id') String servicioId,
            @JsonKey(name: 'fecha_hora') DateTime fechaHora,
            String estado,
            double? precio,
            String? notas)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CitaModelo() when $default != null:
        return $default(
            _that.id,
            _that.usuarioId,
            _that.barberoId,
            _that.negocioId,
            _that.servicioId,
            _that.fechaHora,
            _that.estado,
            _that.precio,
            _that.notas);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CitaModelo implements CitaModelo {
  const _CitaModelo(
      {required this.id,
      @JsonKey(name: 'usuario_id') required this.usuarioId,
      @JsonKey(name: 'barbero_id') required this.barberoId,
      @JsonKey(name: 'negocio_id') required this.negocioId,
      @JsonKey(name: 'servicio_id') required this.servicioId,
      @JsonKey(name: 'fecha_hora') required this.fechaHora,
      required this.estado,
      this.precio,
      this.notas});
  factory _CitaModelo.fromJson(Map<String, dynamic> json) =>
      _$CitaModeloFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'usuario_id')
  final String usuarioId;
  @override
  @JsonKey(name: 'barbero_id')
  final String barberoId;
  @override
  @JsonKey(name: 'negocio_id')
  final String negocioId;
  @override
  @JsonKey(name: 'servicio_id')
  final String servicioId;
  @override
  @JsonKey(name: 'fecha_hora')
  final DateTime fechaHora;
  @override
  final String estado;
  @override
  final double? precio;
  @override
  final String? notas;

  /// Create a copy of CitaModelo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CitaModeloCopyWith<_CitaModelo> get copyWith =>
      __$CitaModeloCopyWithImpl<_CitaModelo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CitaModeloToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CitaModelo &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.usuarioId, usuarioId) ||
                other.usuarioId == usuarioId) &&
            (identical(other.barberoId, barberoId) ||
                other.barberoId == barberoId) &&
            (identical(other.negocioId, negocioId) ||
                other.negocioId == negocioId) &&
            (identical(other.servicioId, servicioId) ||
                other.servicioId == servicioId) &&
            (identical(other.fechaHora, fechaHora) ||
                other.fechaHora == fechaHora) &&
            (identical(other.estado, estado) || other.estado == estado) &&
            (identical(other.precio, precio) || other.precio == precio) &&
            (identical(other.notas, notas) || other.notas == notas));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, usuarioId, barberoId,
      negocioId, servicioId, fechaHora, estado, precio, notas);

  @override
  String toString() {
    return 'CitaModelo(id: $id, usuarioId: $usuarioId, barberoId: $barberoId, negocioId: $negocioId, servicioId: $servicioId, fechaHora: $fechaHora, estado: $estado, precio: $precio, notas: $notas)';
  }
}

/// @nodoc
abstract mixin class _$CitaModeloCopyWith<$Res>
    implements $CitaModeloCopyWith<$Res> {
  factory _$CitaModeloCopyWith(
          _CitaModelo value, $Res Function(_CitaModelo) _then) =
      __$CitaModeloCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'usuario_id') String usuarioId,
      @JsonKey(name: 'barbero_id') String barberoId,
      @JsonKey(name: 'negocio_id') String negocioId,
      @JsonKey(name: 'servicio_id') String servicioId,
      @JsonKey(name: 'fecha_hora') DateTime fechaHora,
      String estado,
      double? precio,
      String? notas});
}

/// @nodoc
class __$CitaModeloCopyWithImpl<$Res> implements _$CitaModeloCopyWith<$Res> {
  __$CitaModeloCopyWithImpl(this._self, this._then);

  final _CitaModelo _self;
  final $Res Function(_CitaModelo) _then;

  /// Create a copy of CitaModelo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? usuarioId = null,
    Object? barberoId = null,
    Object? negocioId = null,
    Object? servicioId = null,
    Object? fechaHora = null,
    Object? estado = null,
    Object? precio = freezed,
    Object? notas = freezed,
  }) {
    return _then(_CitaModelo(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      usuarioId: null == usuarioId
          ? _self.usuarioId
          : usuarioId // ignore: cast_nullable_to_non_nullable
              as String,
      barberoId: null == barberoId
          ? _self.barberoId
          : barberoId // ignore: cast_nullable_to_non_nullable
              as String,
      negocioId: null == negocioId
          ? _self.negocioId
          : negocioId // ignore: cast_nullable_to_non_nullable
              as String,
      servicioId: null == servicioId
          ? _self.servicioId
          : servicioId // ignore: cast_nullable_to_non_nullable
              as String,
      fechaHora: null == fechaHora
          ? _self.fechaHora
          : fechaHora // ignore: cast_nullable_to_non_nullable
              as DateTime,
      estado: null == estado
          ? _self.estado
          : estado // ignore: cast_nullable_to_non_nullable
              as String,
      precio: freezed == precio
          ? _self.precio
          : precio // ignore: cast_nullable_to_non_nullable
              as double?,
      notas: freezed == notas
          ? _self.notas
          : notas // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
