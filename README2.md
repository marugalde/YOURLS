# yourls

- repositorio yourls base.
- configurado para trabajo en local
- Antes de subir a producción, editar el fichero config.php en la carpeta users.

## Credenciales de usuario

### mysql

| usuario      | contraseña   | bbdd         |
| :----------- | :----------- | :----------- |
| urlshortener | urlshortener | urlshortener |

### Interfaz admin yourls:

| usuario      | contraseña   |
| :----------- | :----------- |
| urlshortener | urlshortener |

## Configurar un VirtualHost en Apache2 (Linux)

Estos pasos están pensados para Debian y Ubuntu. Se asume que YOURLS está instalado en `/var/www/yourls` y que se accederá desde el equipo local mediante el dominio `yourls.local`. Ajusta la ruta y el dominio si tu instalación utiliza otros valores.

### 1. Comprobar los módulos de Apache

Activa `rewrite`, necesario para las reglas de URLs de YOURLS:

```bash
sudo a2enmod rewrite
```

### 2. Crear el archivo del VirtualHost

Crea el archivo `/etc/apache2/sites-available/yourls.conf`:

```bash
sudo nano /etc/apache2/sites-available/yourls.conf
```

Añade esta configuración:

```apache
<VirtualHost *:80>
    ServerName yourls.local
    DocumentRoot /var/www/yourls

    <Directory /var/www/yourls>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/yourls-error.log
    CustomLog ${APACHE_LOG_DIR}/yourls-access.log combined
</VirtualHost>
```

Si YOURLS está en otra ubicación, sustituye `/var/www/yourls` tanto en `DocumentRoot` como en la directiva `<Directory>`.

### 3. Habilitar el sitio y comprobar la configuración

```bash
sudo a2ensite yourls.conf
sudo apache2ctl configtest
```

Si el resultado de `configtest` es `Syntax OK`, recarga Apache:

```bash
sudo systemctl reload apache2
```

### 4. Editar el archivo hosts

El archivo `hosts` permite asociar el dominio local con la dirección IP del propio equipo. Edítalo con permisos de administrador:

```bash
sudo nano /etc/hosts
```

Añade esta línea:

```text
127.0.0.1    yourls.local
```

Guarda el archivo. Si Apache está en otra máquina, sustituye `127.0.0.1` por la dirección IP de ese servidor y realiza esta modificación en el equipo desde el que abrirás YOURLS.

En Windows, el archivo equivalente es `C:\\Windows\\System32\\drivers\\etc\\hosts`; ábrelo con un editor ejecutado como administrador y añade la misma asociación. En macOS y Linux se utiliza normalmente `/etc/hosts`.

### 5. Configurar la URL de YOURLS

Edita `user/config.php` y comprueba que la URL base coincide con el dominio configurado:

```php
define('YOURLS_SITE', 'http://yourls.local');
```

No dupliques la definición si ya existe: modifica su valor actual. Conserva el resto de la configuración de base de datos.

### 6. Probar el acceso

Abre en el navegador:

- Sitio: http://yourls.local
- Administración: http://yourls.local/admin/

Si no carga, revisa el estado y los registros de Apache:

```bash
sudo systemctl status apache2
sudo tail -n 50 /var/log/apache2/yourls-error.log
```

**Nota:** `yourls.local` es un nombre de ejemplo para uso local. Para publicar el servicio en Internet se necesita un dominio real, DNS apuntando al servidor, configuración de firewall y HTTPS; no basta con modificar el archivo `hosts`.
