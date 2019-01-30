# Wordpress con Docker

## Variables de entorno que nos proporciona Wordpress por defecto

The following environment variables are also honored for configuring your WordPress instance:

   * `-e WORDPRESS_DB_HOST=...` (defaults to the IP and port of the linked mysql container)
   * `-e WORDPRESS_DB_USER=...` (defaults to "root")
   * `-e WORDPRESS_DB_PASSWORD=...` (defaults to the value of the MYSQL_ROOT_PASSWORD environment variable from the linked mysql container)
   * `-e WORDPRESS_DB_NAME=...` (defaults to "wordpress")
   * `-e WORDPRESS_TABLE_PREFIX=...` (defaults to "", only set this when you need to override the default table prefix in wp-config.php)
   * `-e WORDPRESS_AUTH_KEY=...`, -e WORDPRESS_SECURE_AUTH_KEY=..., -e WORDPRESS_LOGGED_IN_KEY=..., -e WORDPRESS_NONCE_KEY=..., -e WORDPRESS_AUTH_SALT=..., -e WORDPRESS_SECURE_AUTH_SALT=..., -e WORDPRESS_LOGGED_IN_SALT=..., -e WORDPRESS_NONCE_SALT=... (default to unique random SHA1s)
   * `-e WORDPRESS_DEBUG=1` (defaults to disabled, non-empty value will enable WP_DEBUG in wp-config.php)
   * `-e WORDPRESS_CONFIG_EXTRA=...` (defaults to nothing, non-empty value will be embedded verbatim inside wp-config.php -- especially useful for applying extra configuration values this image does not provide by default such as WP_ALLOW_MULTISITE; see docker-library/wordpress#142 for more details)
