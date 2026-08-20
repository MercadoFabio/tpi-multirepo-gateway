# TPI Multirepo · Nginx Gateway

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
├── tpi-multirepo-gateway/
├── tpi-multirepo-shell/
├── tpi-multirepo-usuarios/
└── tpi-multirepo-productos/
```

Desde este repositorio:

```bash
docker compose up --build
```

Abrir [http://localhost](http://localhost).

El Gateway enruta por HTTP. No comparte TypeScript, memoria ni `node_modules` entre aplicaciones. Cada equipo puede versionar, compilar y desplegar su repo independientemente.
