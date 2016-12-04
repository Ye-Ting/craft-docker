<?php
/**
 * General Configuration
 *
 * You can see a list of the default settings in craft/app/etc/config/defaults/general.php
 */
return array(
  '*' => array(
    'omitScriptNameInUrls' => true,
    'sendPoweredByHeader' => false,
    'devMode' => getenv("CRAFT_DEVMODE") == "true"
  )
);
?>
