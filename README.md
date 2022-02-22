# Docker Redash
## Requisitos
- Docker
- Docker Compose
- Python 3
- Secrets python module
- pwgen (optativo)

## Configurar .env
Usar de base o copiar env_template

### Valores a mofdificar y actualizar .env
- REDASH_SECRET_KEY=
- REDASH_COOKIE_SECRET=
- POSTGRES_PASSWORD=
- REDASH_DATABASE_URL=postgresql://postgres:${POSTGRES_PASSWORD}@postgres/postgres
- REDASH_REDIS_URL=redis://HOST-DE-REDIS:6379/0

Crear variables / claves REDASH_SECRET_KEY y REDASH_COOKIE_SECRET
``python3 -c 'import secrets; print(secrets.token_hex())'``
``pwgen -1s 32``

- Crear u obtener password de Postgres
- Obtener string de conexión Postgres
- Obtener string de conexión Redis

## Docker Lab
### Construir imagen Docker
``docker build -t redash .``

### Instalación Inicial
``docker-compose run --rm server create_db``

### Puesta en marcha
``docker-compose up -d``

## Actualización
### Detener servicios Redash
``docker-compose stop server scheduler scheduled_worker adhoc_worker nginx``

### Actualizar a versión reciente
Dockerfile (probado de v8 a v10)
FROM redash/redash:8.0.2.b37747 => FROM redash/redash:10.1.0.b50633

### Actualizar dependencias de BD
``docker-compose run --rm server manage db upgrade``

### Poner en marcha nuevamente Redash
``docker-compose up -d server scheduler scheduled_worker adhoc_worker nginx``
