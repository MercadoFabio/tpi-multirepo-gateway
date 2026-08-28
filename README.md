# TPI · Gateway Frontend y Orquestador Docker Compose

Este repositorio contiene el **Reverse Proxy perimetral Nginx** y la orquestación completa de **11 contenedores** con `docker-compose.yml` para levantar la arquitectura multirepo del TPI (Microfrontends Angular, Spring Boot BFF con Redis, Eureka Service Discovery, Backend Gateway Nginx y bases PostgreSQL aisladas).

---

## 🏛️ Topología de Servicios

```text
[ Navegador ] ──► http://localhost:4200 (Frontend Gateway Nginx)
                     ├── /            ──► Shell MFE (tpi-multirepo-shell:80)
                     ├── /usuarios/   ──► Usuarios MFE (tpi-multirepo-usuarios:80)
                     ├── /productos/  ──► Productos MFE (tpi-multirepo-productos:80)
                     └── /api/v1/*    ──► BFF Spring Boot (tpi-backend-bff:3000)
                                            ├── Session Store (Redis:6379)
                                            ├── Service Discovery (Eureka:8761)
                                            └── Backend Gateway (Nginx:8080)
                                                   ├── Usuarios Service (:8080) ──► Postgres (users-db:5432)
                                                   └── Productos Service (:8081) ──► Postgres (products-db:5432)
```

---

## 🚀 Estructura Local de Repositorios

Para que el `docker-compose.yml` compile las imágenes locales correctamente, todos los repositorios deben clonarse como hermanos:

```text
Ejemplo-arq-front-tpi/
├── tpi-multirepo-gateway/       # Orquestador general y Nginx Frontend (:4200)
├── tpi-multirepo-shell/         # Microfrontend Angular Shell
├── tpi-multirepo-usuarios/      # Microfrontend Angular Usuarios (/usuarios/)
├── tpi-multirepo-productos/     # Microfrontend Angular Productos (/productos/)
├── tpi-ui-kit/                  # UI Kit compartido Tailwind CSS
├── tpi-backend-bff/             # Spring Boot BFF (:3000)
├── tpi-backend-discovery/       # Netflix Eureka Server (:8761)
├── tpi-backend-gateway/         # Backend Gateway interno (:8080)
├── tpi-backend-usuarios/        # Microservicio Usuarios
├── tpi-backend-productos/       # Microservicio Productos
└── tpi-arquitectura-presentacion/ # Slides docentes y diagramas interactivos
```

---

## ⚙️ Cómo Levantar el Stack Completo

Desde la carpeta `tpi-multirepo-gateway`:

```powershell
# Levantar los 11 contenedores en background
docker compose up --build -d

# Ver el estado y salud de los contenedores
docker compose ps

# Ver logs en tiempo real
docker compose logs -f
```

---

## 🌐 URLs de Acceso y Servicios

| Servicio | URL Pública / Puerto | Descripción |
| --- | --- | --- |
| **Portal Web (Shell)** | [http://localhost:4200](http://localhost:4200) | Entrada principal de la aplicación. |
| **MFE Usuarios** | [http://localhost:4200/usuarios/](http://localhost:4200/usuarios/) | Microfrontend de administración de usuarios. |
| **MFE Productos** | [http://localhost:4200/productos/](http://localhost:4200/productos/) | Microfrontend de catálogo de productos. |
| **API BFF** | [http://localhost:4200/api/v1/overview](http://localhost:4200/api/v1/overview) | Endpoints de agregación y negocio. |
| **Eureka Dashboard** | [http://localhost:8761](http://localhost:8761) | Panel de monitoreo de Service Discovery. |
| **Health Check** | [http://localhost:4200/health](http://localhost:4200/health) | Verificación de estado del gateway. |

---

## 🔐 Credenciales Demo

- **Email:** `docente@example.test`
- **Contraseña:** `password123456`
- **PostgreSQL Passwords:** `tpi_secret_password`

---

## 🛡️ Principios de Seguridad & Red

1. **Un solo origen (Same-Origin):** El frontend solo se comunica con `http://localhost:4200`. Nginx enruta internamente, eliminando la necesidad de habilitar CORS.
2. **Sesiones Seguras en Redis:** El BFF almacena las sesiones en Redis (`session-store:6379`) y emite una cookie segura:  
   `__Host-tpi-session; Secure; HttpOnly; SameSite=Strict`.
3. **Cero Tokens en Frontend:** No se guardan JWTs ni tokens de acceso en `localStorage` o `sessionStorage`, protegiendo la app contra ataques XSS.
4. **Protección Perimetral:** El gateway rechaza accesos externos a `/internal` y `/actuator`, y aplica rate limiting a los intentos de login (`POST /api/v1/auth/login`).
5. **Autonomía Operativa:** Cada microfrontend y microservicio tiene su propio `Dockerfile` y dependencias aisladas; no se comparten `node_modules` ni código fuente en runtime.

