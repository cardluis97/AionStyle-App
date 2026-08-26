// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'estado_auth.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EstadoAuth {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is EstadoAuth);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'EstadoAuth()';
  }
}

/// @nodoc
class $EstadoAuthCopyWith<$Res> {
  $EstadoAuthCopyWith(EstadoAuth _, $Res Function(EstadoAuth) __);
}

/// Adds pattern-matching-related methods to [EstadoAuth].
extension EstadoAuthPatterns on EstadoAuth {
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
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Inicial value)? inicial,
    TResult Function(_Cargando value)? cargando,
    TResult Function(_Autenticado value)? autenticado,
    TResult Function(_PerfilIncompleto value)? perfilIncompleto,
    TResult Function(_NoAutenticado value)? noAutenticado,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Inicial() when inicial != null:
        return inicial(_that);
      case _Cargando() when cargando != null:
        return cargando(_that);
      case _Autenticado() when autenticado != null:
        return autenticado(_that);
      case _PerfilIncompleto() when perfilIncompleto != null:
        return perfilIncompleto(_that);
      case _NoAutenticado() when noAutenticado != null:
        return noAutenticado(_that);
      case _Error() when error != null:
        return error(_that);
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
  TResult map<TResult extends Object?>({
    required TResult Function(_Inicial value) inicial,
    required TResult Function(_Cargando value) cargando,
    required TResult Function(_Autenticado value) autenticado,
    required TResult Function(_PerfilIncompleto value) perfilIncompleto,
    required TResult Function(_NoAutenticado value) noAutenticado,
    required TResult Function(_Error value) error,
  }) {
    final _that = this;
    switch (_that) {
      case _Inicial():
        return inicial(_that);
      case _Cargando():
        return cargando(_that);
      case _Autenticado():
        return autenticado(_that);
      case _PerfilIncompleto():
        return perfilIncompleto(_that);
      case _NoAutenticado():
        return noAutenticado(_that);
      case _Error():
        return error(_that);
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
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Inicial value)? inicial,
    TResult? Function(_Cargando value)? cargando,
    TResult? Function(_Autenticado value)? autenticado,
    TResult? Function(_PerfilIncompleto value)? perfilIncompleto,
    TResult? Function(_NoAutenticado value)? noAutenticado,
    TResult? Function(_Error value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case _Inicial() when inicial != null:
        return inicial(_that);
      case _Cargando() when cargando != null:
        return cargando(_that);
      case _Autenticado() when autenticado != null:
        return autenticado(_that);
      case _PerfilIncompleto() when perfilIncompleto != null:
        return perfilIncompleto(_that);
      case _NoAutenticado() when noAutenticado != null:
        return noAutenticado(_that);
      case _Error() when error != null:
        return error(_that);
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
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? inicial,
    TResult Function()? cargando,
    TResult Function(UsuarioEntidad usuario)? autenticado,
    TResult Function(UsuarioEntidad usuario)? perfilIncompleto,
    TResult Function()? noAutenticado,
    TResult Function(String mensaje)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Inicial() when inicial != null:
        return inicial();
      case _Cargando() when cargando != null:
        return cargando();
      case _Autenticado() when autenticado != null:
        return autenticado(_that.usuario);
      case _PerfilIncompleto() when perfilIncompleto != null:
        return perfilIncompleto(_that.usuario);
      case _NoAutenticado() when noAutenticado != null:
        return noAutenticado();
      case _Error() when error != null:
        return error(_that.mensaje);
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
  TResult when<TResult extends Object?>({
    required TResult Function() inicial,
    required TResult Function() cargando,
    required TResult Function(UsuarioEntidad usuario) autenticado,
    required TResult Function(UsuarioEntidad usuario) perfilIncompleto,
    required TResult Function() noAutenticado,
    required TResult Function(String mensaje) error,
  }) {
    final _that = this;
    switch (_that) {
      case _Inicial():
        return inicial();
      case _Cargando():
        return cargando();
      case _Autenticado():
        return autenticado(_that.usuario);
      case _PerfilIncompleto():
        return perfilIncompleto(_that.usuario);
      case _NoAutenticado():
        return noAutenticado();
      case _Error():
        return error(_that.mensaje);
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
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? inicial,
    TResult? Function()? cargando,
    TResult? Function(UsuarioEntidad usuario)? autenticado,
    TResult? Function(UsuarioEntidad usuario)? perfilIncompleto,
    TResult? Function()? noAutenticado,
    TResult? Function(String mensaje)? error,
  }) {
    final _that = this;
    switch (_that) {
      case _Inicial() when inicial != null:
        return inicial();
      case _Cargando() when cargando != null:
        return cargando();
      case _Autenticado() when autenticado != null:
        return autenticado(_that.usuario);
      case _PerfilIncompleto() when perfilIncompleto != null:
        return perfilIncompleto(_that.usuario);
      case _NoAutenticado() when noAutenticado != null:
        return noAutenticado();
      case _Error() when error != null:
        return error(_that.mensaje);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _Inicial implements EstadoAuth {
  const _Inicial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Inicial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'EstadoAuth.inicial()';
  }
}

/// @nodoc

class _Cargando implements EstadoAuth {
  const _Cargando();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Cargando);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'EstadoAuth.cargando()';
  }
}

/// @nodoc

class _Autenticado implements EstadoAuth {
  const _Autenticado(this.usuario);

  final UsuarioEntidad usuario;

  /// Create a copy of EstadoAuth
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AutenticadoCopyWith<_Autenticado> get copyWith =>
      __$AutenticadoCopyWithImpl<_Autenticado>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Autenticado &&
            (identical(other.usuario, usuario) || other.usuario == usuario));
  }

  @override
  int get hashCode => Object.hash(runtimeType, usuario);

  @override
  String toString() {
    return 'EstadoAuth.autenticado(usuario: $usuario)';
  }
}

/// @nodoc
abstract mixin class _$AutenticadoCopyWith<$Res>
    implements $EstadoAuthCopyWith<$Res> {
  factory _$AutenticadoCopyWith(
          _Autenticado value, $Res Function(_Autenticado) _then) =
      __$AutenticadoCopyWithImpl;
  @useResult
  $Res call({UsuarioEntidad usuario});
}

/// @nodoc
class __$AutenticadoCopyWithImpl<$Res> implements _$AutenticadoCopyWith<$Res> {
  __$AutenticadoCopyWithImpl(this._self, this._then);

  final _Autenticado _self;
  final $Res Function(_Autenticado) _then;

  /// Create a copy of EstadoAuth
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? usuario = null,
  }) {
    return _then(_Autenticado(
      null == usuario
          ? _self.usuario
          : usuario // ignore: cast_nullable_to_non_nullable
              as UsuarioEntidad,
    ));
  }
}

/// @nodoc

class _PerfilIncompleto implements EstadoAuth {
  const _PerfilIncompleto(this.usuario);

  final UsuarioEntidad usuario;

  /// Create a copy of EstadoAuth
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PerfilIncompletoCopyWith<_PerfilIncompleto> get copyWith =>
      __$PerfilIncompletoCopyWithImpl<_PerfilIncompleto>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PerfilIncompleto &&
            (identical(other.usuario, usuario) || other.usuario == usuario));
  }

  @override
  int get hashCode => Object.hash(runtimeType, usuario);

  @override
  String toString() {
    return 'EstadoAuth.perfilIncompleto(usuario: $usuario)';
  }
}

/// @nodoc
abstract mixin class _$PerfilIncompletoCopyWith<$Res>
    implements $EstadoAuthCopyWith<$Res> {
  factory _$PerfilIncompletoCopyWith(
          _PerfilIncompleto value, $Res Function(_PerfilIncompleto) _then) =
      __$PerfilIncompletoCopyWithImpl;
  @useResult
  $Res call({UsuarioEntidad usuario});
}

/// @nodoc
class __$PerfilIncompletoCopyWithImpl<$Res>
    implements _$PerfilIncompletoCopyWith<$Res> {
  __$PerfilIncompletoCopyWithImpl(this._self, this._then);

  final _PerfilIncompleto _self;
  final $Res Function(_PerfilIncompleto) _then;

  /// Create a copy of EstadoAuth
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? usuario = null,
  }) {
    return _then(_PerfilIncompleto(
      null == usuario
          ? _self.usuario
          : usuario // ignore: cast_nullable_to_non_nullable
              as UsuarioEntidad,
    ));
  }
}

/// @nodoc

class _NoAutenticado implements EstadoAuth {
  const _NoAutenticado();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _NoAutenticado);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'EstadoAuth.noAutenticado()';
  }
}

/// @nodoc

class _Error implements EstadoAuth {
  const _Error(this.mensaje);

  final String mensaje;

  /// Create a copy of EstadoAuth
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ErrorCopyWith<_Error> get copyWith =>
      __$ErrorCopyWithImpl<_Error>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Error &&
            (identical(other.mensaje, mensaje) || other.mensaje == mensaje));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mensaje);

  @override
  String toString() {
    return 'EstadoAuth.error(mensaje: $mensaje)';
  }
}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res>
    implements $EstadoAuthCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) =
      __$ErrorCopyWithImpl;
  @useResult
  $Res call({String mensaje});
}

/// @nodoc
class __$ErrorCopyWithImpl<$Res> implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

  /// Create a copy of EstadoAuth
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? mensaje = null,
  }) {
    return _then(_Error(
      null == mensaje
          ? _self.mensaje
          : mensaje // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
