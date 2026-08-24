# TPI · Caso 2 · Aplicaciones SSR independientes

Este repositorio no contiene Angular. Es la infraestructura que integra tres aplicaciones Angular independientes:

```text
/             -> tpi-multirepo-shell
/usuarios/    -> tpi-multirepo-usuarios
/productos/   -> tpi-multirepo-productos
```

## Estructura local esperada

Clonar los cuatro repositorios como hermanos:

```text
ejemplo-tpi-docker-multirepo/
├── tpi-multirepo-gateway-main/
├── tpi-multirepo-shell-main/
├── tpi-multirepo-usuarios-main/
├── tpi-multirepo-productos-main/
├── tpi-backend-bff-main/
├── tpi-backend-usuarios-main/
└── tpi-backend-productos-main/
```

Desde este repositorio:

```bash
export DEMO_LOGIN_EMAIL='docente@example.test'
# Export DEMO_LOGIN_PASSWORD, USERS_DB_PASSWORD and PRODUCTS_DB_PASSWORD from a local secret manager or the current shell.
docker compose up --build
```

Abrir [http://localhost:8080](http://localhost:8080).

Los tres frontends y el BFF se ejecutan en el mismo entorno. Nginx enruta `/` al Shell, `/usuarios/` y `/productos/` a sus aplicaciones SSR, y solo publica el BFF bajo `/api/v1/`.

El gateway no habilita CORS, limita `POST /api/v1/auth/login`, no reintenta operaciones y rechaza `/internal` y `/actuator`. No comparte TypeScript, memoria ni `node_modules` entre aplicaciones; cada equipo puede versionar, compilar y desplegar su repositorio independientemente.
