# Tepeapulco

Aplicación web para promoción turística y cultural del municipio de Tepeapulco, Hidalgo.

## Sistema de Autenticación

Se ha implementado un sistema de autenticación híbrido con las siguientes características:

- **Registro tradicional**: Los usuarios pueden registrarse utilizando correo electrónico y contraseña.
- **Registro con Google**: Integración con Google OAuth para permitir inicio de sesión con cuentas de Google.
- **Gestión de credenciales**: Los usuarios que ingresan con OAuth pueden establecer o cambiar su contraseña posteriormente.
- **Sistema de roles**: 
  - Administradores: acceso completo al sistema y panel de administración.
  - Usuarios comunes: acceso limitado a funcionalidades básicas.

## Tecnologías utilizadas

- Rails 8
- PostgreSQL
- Tailwind CSS
- Devise
- OmniAuth con Google OAuth2
- Slim

## Configuración

### Variables de entorno

Para el funcionamiento de OAuth se requieren las siguientes variables de entorno:

```
GOOGLE_CLIENT_ID
GOOGLE_CLIENT_SECRET
```

Estas se configuran en Kamal para producción.

### Desarrollo

1. Clonar el repositorio
2. Instalar las dependencias: `bundle install`
3. Configurar la base de datos: `rails db:setup`
4. Iniciar el servidor: `bin/dev`

## Despliegue

El despliegue se realiza mediante Kamal:

```bash
bin/kamal setup
bin/kamal deploy
```

## Funcionalidades principales

- Autenticación híbrida (email/contraseña y OAuth)
- Panel de administración para usuarios con rol de administrador
- Perfiles de usuario con posibilidad de actualización de datos
- Integración con Google para login sencillo
