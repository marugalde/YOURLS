-- Crea la base de datos y el usuario MySQL para YOURLS.
-- Credenciales tomadas del README.md y de user/config.php.
-- Ejecutar con una cuenta MySQL con permisos para crear bases de datos y usuarios.

CREATE DATABASE IF NOT EXISTS `urlshortener`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'urlshortener'@'localhost'
  IDENTIFIED BY 'urlshortener';

GRANT ALL PRIVILEGES ON `urlshortener`.* TO 'urlshortener'@'localhost';

FLUSH PRIVILEGES;
