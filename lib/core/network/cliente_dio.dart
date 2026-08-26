import 'package:dio/dio.dart';
import '../../app/config/configuracion_app.dart';
import 'interceptores/interceptor_auth.dart';
import 'interceptores/interceptor_errores.dart';

/// Instancia singleton de Dio configurada para AionStyle API.
class ClienteDio {
  ClienteDio._();

  static Dio crear({required InterceptorAuth interceptorAuth}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ConfiguracionApp.urlBase,
        connectTimeout: const Duration(milliseconds: ConfiguracionApp.tiempoConexionMs),
        receiveTimeout: const Duration(milliseconds: ConfiguracionApp.tiempoRecepcionMs),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      interceptorAuth,
      InterceptorErrores(),
    ]);

    return dio;
  }
}
