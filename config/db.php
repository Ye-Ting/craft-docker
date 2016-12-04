<?php
/**
 * Database Configuration
 * You can see a list of the default settings in craft/app/etc/config/defaults/db.php
 */
$env = getenv("MYSQL_ENV") ?: "MYSQL_PORT";
$url = getenv($env) ?: getenv("CLEARDB_DATABASE_URL");
if (getenv("MYSQL_ENV_MYSQL_ALLOW_EMPTY_PASSWORD") == "yes") {
 $url = 'mysql://' . (getenv("MYSQL_USER") ?: 'root') . '@' . getenv("MYSQL_PORT_3306_TCP_ADDR") . ':' . getenv("MYSQL_PORT_3306_TCP_PORT") . '/' . getenv("MYSQL_ENV_MYSQL_DATABASE");
}
$url = $url ?: getenv("MYSQL_URL");
$url = parse_url($url ?: 'mysql://root@localhost');

return array(
  'server' => getenv('CRAFT_DB_SERVER') ?: $url["host"],
  'port' => getenv('CRAFT_DB_PORT') ?: $url["port"],
  'user' =>  getenv('CRAFT_DB_USER') ?: $url["user"],
  'password' =>  getenv('CRAFT_DB_PASSWORD') ?: ($url["pass"] ?: ""),
  'database' => getenv('CRAFT_DB_NAME') ?: substr($url["path"],1),
  'tablePrefix' => getenv('CRAFT_DB_TABLE_PREFIX') ?: 'craft',
);
?>
