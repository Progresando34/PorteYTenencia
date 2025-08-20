# Usar imagen oficial de PHP con CLI
FROM php:8.2-cli

# Instalar extensiones necesarias
RUN apt-get update && apt-get install -y \
    libzip-dev zip unzip git \
    && docker-php-ext-install pdo pdo_mysql zip

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Crear directorio de trabajo y copiar proyecto
WORKDIR /var/www/html
COPY . .

# Instalar dependencias
RUN composer install --no-dev --optimize-autoloader

# Copiar archivo .env y generar key
COPY .env.example .env
RUN php artisan key:generate

# Exponer puerto (Render asignará $PORT en runtime)
EXPOSE 8080

# Arrancar Laravel en el puerto dinámico
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=${PORT}"]
