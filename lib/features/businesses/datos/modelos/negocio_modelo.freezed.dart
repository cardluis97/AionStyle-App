// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'negocio_modelo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NegocioModelo {
  String get id;
  String get nombre;
  String get direccion;
  String? get telefono;
  @JsonKey(name: 'foto_principal')
  String? get fotoPrincipal;
  double get calificacion;
  @JsonKey(name: 'total_resenas')
  int get totalResenas;

  /// Create a copy of NegocioModelo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NegocioModeloCopyWith<NegocioModelo> get copyWith =>
      _$NegocioModeloCopyWithImpl<NegocioModelo>(
          this as NegocioModelo, _$identity);

  /// Serializes this NegocioModelo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NegocioModelo &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.direccion, direccion) ||
                other.direccion == direccion) &&
            (identical(other.telefono, telefono) ||
                other.telefono == telefono) &&
            (identical(other.fotoPrincipal, fotoPrincipal) ||
                other.fotoPrincipal == fotoPrincipal) &&
            (identical(other.calificacion, calificacion) ||
                other.calificacion == calificacion) &&
            (identical(other.totalResenas, totalResenas) ||
                other.totalResenas == totalResenas));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nombre, direccion, telefono,
      fotoPrincipal, calificacion, totalResenas);

  @override
  String toString() {
    return 'NegocioModelo(id: $id, nombre: $nombre, direccion: $direccion, telefono: $telefono, fotoPrincipal: $fotoPrincipal, calificacion: $calificacion, totalResenas: $totalResenas)';
  }
}

/// @nodoc
abstract mixin class $NegocioModeloCopyWith<$Res> {
  factory $NegocioModeloCopyWith(
          NegocioModelo value, $Res Function(NegocioModelo) _then) =
      _$NegocioModeloCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String nombre,
      String direccion,
      String? telefono,
      @JsonKey(name: 'foto_principal') String? fotoPrincipal,
      double calificacion,
      @JsonKey(name: 'total_resenas') int totalResenas});
}

/// @nodoc
class _$NegocioModeloCopyWithImpl<$Res>
    implements $NegocioModeloCopyWith<$Res> {
  _$NegocioModeloCopyWithImpl(this._self, this._then);

  final NegocioModelo _self;
  final $Res Function(NegocioModelo) _then;

  /// Create a copy of NegocioModelo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? direccion = null,
    Object? telefono = freezed,
    Object? fotoPrincipal = freezed,
    Object? calificacion = null,
    Object? totalResenas = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nombre: null == nombre
          ? _self.nombre
          : nombre // ignore: cast_nullable_to_non_nullable
              as String,
      direccion: null == direccion
          ? _self.direccion
          : direccion // ignore: cast_nullable_to_non_nullable
              as String,
      telefono: freezed == telefono
          ? _self.telefono
          : telefono // ignore: cast_nullable_to_non_nullable
              as String?,
      fotoPrincipal: freezed == fotoPrincipal
          ? _self.fotoPrincipal
          : fotoPrincipal // ignore: cast_nullable_to_non_nullable
              as String?,
      calificacion: null == calificacion
          ? _self.calificacion
          : calificacion // ignore: cast_nullable_to_non_nullable
              as double,
      totalResenas: null == totalResenas
          ? _self.totalResenas
          : totalResenas // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [NegocioModelo].
extension NegocioModeloPatterns on NegocioModelo {
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
    TResult Function(_NegocioModelo value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NegocioModelo() when $default != null:
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
    TResult Function(_NegocioModelo value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NegocioModelo():
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
    TResult? Function(_NegocioModelo value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NegocioModelo() when $default != null:
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
            String nombre,
            String direccion,
            String? telefono,
            @JsonKey(name: 'foto_principal') String? fotoPrincipal,
            double calificacion,
            @JsonKey(name: 'total_resenas') int totalResenas)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NegocioModelo() when $default != null:
        return $default(_that.id, _that.nombre, _that.direccion, _that.telefono,
            _that.fotoPrincipal, _that.calificacion, _that.totalResenas);
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
            String nombre,
            String direccion,
            String? telefono,
            @JsonKey(name: 'foto_principal') String? fotoPrincipal,
            double calificacion,
            @JsonKey(name: 'total_resenas') int totalResenas)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NegocioModelo():
        return $default(_that.id, _that.nombre, _that.direccion, _that.telefono,
            _that.fotoPrincipal, _that.calificacion, _that.totalResenas);
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
            String nombre,
            String direccion,
            String? telefono,
            @JsonKey(name: 'foto_principal') String? fotoPrincipal,
            double calificacion,
            @JsonKey(name: 'total_resenas') int totalResenas)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NegocioModelo() when $default != null:
        return $default(_that.id, _that.nombre, _that.direccion, _that.telefono,
            _that.fotoPrincipal, _that.calificacion, _that.totalResenas);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _NegocioModelo implements NegocioModelo {
  const _NegocioModelo(
      {required this.id,
      required this.nombre,
      required this.direccion,
      this.telefono,
      @JsonKey(name: 'foto_principal') this.fotoPrincipal,
      this.calificacion = 0.0,
      @JsonKey(name: 'total_resenas') this.totalResenas = 0});
  factory _NegocioModelo.fromJson(Map<String, dynamic> json) =>
      _$NegocioModeloFromJson(json);

  @override
  final String id;
  @override
  final String nombre;
  @override
  final String direccion;
  @override
  final String? telefono;
  @override
  @JsonKey(name: 'foto_principal')
  final String? fotoPrincipal;
  @override
  @JsonKey()
  final double calificacion;
  @override
  @JsonKey(name: 'total_resenas')
  final int totalResenas;

  /// Create a copy of NegocioModelo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NegocioModeloCopyWith<_NegocioModelo> get copyWith =>
      __$NegocioModeloCopyWithImpl<_NegocioModelo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$NegocioModeloToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NegocioModelo &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.direccion, direccion) ||
                other.direccion == direccion) &&
            (identical(other.telefono, telefono) ||
                other.telefono == telefono) &&
            (identical(other.fotoPrincipal, fotoPrincipal) ||
                other.fotoPrincipal == fotoPrincipal) &&
            (identical(other.calificacion, calificacion) ||
                other.calificacion == calificacion) &&
            (identical(other.totalResenas, totalResenas) ||
                other.totalResenas == totalResenas));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nombre, direccion, telefono,
      fotoPrincipal, calificacion, totalResenas);

  @override
  String toString() {
    return 'NegocioModelo(id: $id, nombre: $nombre, direccion: $direccion, telefono: $telefono, fotoPrincipal: $fotoPrincipal, calificacion: $calificacion, totalResenas: $totalResenas)';
  }
}

/// @nodoc
abstract mixin class _$NegocioModeloCopyWith<$Res>
    implements $NegocioModeloCopyWith<$Res> {
  factory _$NegocioModeloCopyWith(
          _NegocioModelo value, $Res Function(_NegocioModelo) _then) =
      __$NegocioModeloCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String nombre,
      String direccion,
      String? telefono,
      @JsonKey(name: 'foto_principal') String? fotoPrincipal,
      double calificacion,
      @JsonKey(name: 'total_resenas') int totalResenas});
}

/// @nodoc
class __$NegocioModeloCopyWithImpl<$Res>
    implements _$NegocioModeloCopyWith<$Res> {
  __$NegocioModeloCopyWithImpl(this._self, this._then);

  final _NegocioModelo _self;
  final $Res Function(_NegocioModelo) _then;

  /// Create a copy of NegocioModelo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? direccion = null,
    Object? telefono = freezed,
    Object? fotoPrincipal = freezed,
    Object? calificacion = null,
    Object? totalResenas = null,
  }) {
    return _then(_NegocioModelo(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nombre: null == nombre
          ? _self.nombre
          : nombre // ignore: cast_nullable_to_non_nullable
              as String,
      direccion: null == direccion
          ? _self.direccion
          : direccion // ignore: cast_nullable_to_non_nullable
              as String,
      telefono: freezed == telefono
          ? _self.telefono
          : telefono // ignore: cast_nullable_to_non_nullable
              as String?,
      fotoPrincipal: freezed == fotoPrincipal
          ? _self.fotoPrincipal
          : fotoPrincipal // ignore: cast_nullable_to_non_nullable
              as String?,
      calificacion: null == calificacion
          ? _self.calificacion
          : calificacion // ignore: cast_nullable_to_non_nullable
              as double,
      totalResenas: null == totalResenas
          ? _self.totalResenas
          : totalResenas // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
