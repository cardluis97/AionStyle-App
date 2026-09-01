---
name: apis-aionstyle
description: "Creación de endpoints y fuentes de datos para AionStyle Móvil. Úsame cuando necesites crear un endpoint, una fuente de datos, un repositorio de datos, o un archivo JSON mock. Solo POST. Siempre con la estructura estándar: cuerpo, estado, fecha_consumo."
---

# SKILL: APIs AionStyle

## Cuándo se aplica

- Crear una nueva fuente de datos (`FuenteDatos*`)
- Agregar un endpoint a la mock API
- Implementar un repositorio en la capa `datos/`
- Consultar cómo estructurar la respuesta de un endpoint

---

## Regla fundamental

> **Solo POST.** No usar `GET`, `PUT`, `DELETE` ni `PATCH` en ningún endpoint, ni en mock ni en producción futura.

Toda acción (consultar, crear, actualizar, eliminar) se modela como un `POST` con un `accion` en el cuerpo de la petición.

---

## Estructura estándar de un endpoint JSON mock

Cada archivo JSON en `assets/mock_api/` representa un endpoint y **siempre** tiene esta estructura:

```json
{
  "estado": "200",
  "fecha_consumo": "2025-01-01T00:00:00Z",
  "cuerpo": {
    // datos específicos del endpoint
  }
}
```

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `estado` | `String` | Código HTTP como string: `"200"`, `"400"`, `"401"`, `"404"`, `"500"` |
| `fecha_consumo` | `String` | ISO 8601. Representa cuándo fue consumido / generado el mock |
| `cuerpo` | `Object` | Payload de la respuesta. Varía por endpoint |

---

## Organización de archivos mock

```
assets/
└── mock_api/
    ├── auth/
    │   ├── login_post.json
    │   └── registro_post.json
    ├── businesses/
    │   ├── listar_negocios_post.json
    │   └── detalle_negocio_post.json
    ├── barbers/
    │   ├── listar_barberos_post.json
    │   └── detalle_barbero_post.json
    ├── appointments/
    │   ├── crear_cita_post.json
    │   └── listar_citas_post.json
    ├── payments/
    │   └── procesar_pago_post.json
    ├── qr/
    │   └── generar_qr_post.json
    └── barber_mode/
        ├── pendientes_post.json
        └── confirmar_corte_post.json
```

Convención de nombre: `{accion}_{recurso}_post.json`

---

## Ejemplos de mocks

### Login
`assets/mock_api/auth/login_post.json`
```json
{
  "estado": "200",
  "fecha_consumo": "2025-01-01T10:00:00Z",
  "cuerpo": {
    "token": "mock_token_abc123",
    "usuario": {
      "id": "usr_001",
      "nombre": "Carlos Rodríguez",
      "correo": "carlos@ejemplo.com",
      "rol": "cliente"
    }
  }
}
```

### Listar negocios
`assets/mock_api/businesses/listar_negocios_post.json`
```json
{
  "estado": "200",
  "fecha_consumo": "2025-01-01T10:00:00Z",
  "cuerpo": {
    "negocios": [
      {
        "id": "neg_001",
        "nombre": "Barbería El Maestro",
        "categoria": "barberia",
        "direccion": "Av. Principal 123",
        "calificacion": 4.8
      }
    ]
  }
}
```

### Error genérico
```json
{
  "estado": "400",
  "fecha_consumo": "2025-01-01T10:00:00Z",
  "cuerpo": {
    "mensaje": "Datos inválidos",
    "codigo_error": "VALIDACION_FALLIDA"
  }
}
```

---

## Cómo consumir un mock en la fuente de datos

```dart
// En datos/fuentes_de_datos/fuente_datos_negocios.dart
import 'dart:convert';
import 'package:flutter/services.dart';

class FuenteDatosNegociosLocal {
  Future<Map<String, dynamic>> listarNegocios() async {
    final json = await rootBundle.loadString(
      'assets/mock_api/businesses/listar_negocios_post.json',
    );
    return jsonDecode(json) as Map<String, dynamic>;
  }
}
```

El repositorio implementación (`datos/repositorios/`) toma el `cuerpo` y mapea a entidades del dominio usando los modelos Freezed.

---

## Checklist antes de crear un endpoint

- [ ] El archivo está en `assets/mock_api/{feature}/`
- [ ] El nombre termina en `_post.json`
- [ ] Tiene los tres campos raíz: `estado`, `fecha_consumo`, `cuerpo`
- [ ] `estado` es un String (no número)
- [ ] El archivo está declarado en `pubspec.yaml` bajo `assets:`
- [ ] Existe la fuente de datos correspondiente en `datos/fuentes_de_datos/`

---

## Plantilla de contrato (usar como guía)

Este archivo es una referencia de formato y convenciones.
No se deben documentar aquí todos los endpoints literales del proyecto.

Reglas:
- Solo `POST`.
- Mantener el envoltorio estándar en respuestas.
- Dejar `cuerpo` al final cuando se use el formato con `error` explícito.

Plantilla de respuesta exitosa:

```json
{
  "estatus": "200",
  "fecha_consumo": "2026-01-01T00:00:00Z",
  "error": null,
  "cuerpo": {
    "data": {}
  }
}
```

Plantilla de respuesta con error:

```json
{
  "estatus": "400",
  "fecha_consumo": "2026-01-01T00:00:00Z",
  "error": {
    "codigo": "VALIDACION",
    "mensaje": "Mensaje de error",
    "detalles": {}
  },
  "cuerpo": {}
}
```
