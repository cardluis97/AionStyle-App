/// Configuración global de la aplicación.
/// Cambia entre ambientes modificando [entorno].
abstract class ConfiguracionApp {
  static const entorno = _Entorno.desarrollo;

  static String get urlBase {
    switch (entorno) {
      case _Entorno.desarrollo:
        return 'https://api-dev.aionstyle.com/v1';
      case _Entorno.staging:
        return 'https://api-staging.aionstyle.com/v1';
      case _Entorno.produccion:
        return 'https://api.aionstyle.com/v1';
    }
  }

  static const tiempoConexionMs = 30000;
  static const tiempoRecepcionMs = 30000;
  static const nombreApp = 'AionStyle';
  static const versionApp = '1.0.4';

  // Stripe
  static const stripePublicKeyDev = 'pk_test_XXXXXXXXXXXXXXXXXXXXXXXX';
  static const stripePublicKeyProd = 'pk_live_XXXXXXXXXXXXXXXXXXXXXXXX';
  static const googleClientIdWeb = 'dev-web-client-id.apps.googleusercontent.com';

  static String get stripePublicKey => entorno == _Entorno.produccion
      ? stripePublicKeyProd
      : stripePublicKeyDev;
}

enum _Entorno { desarrollo, staging, produccion }
