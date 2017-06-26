<?php

if ( defined( 'WP_CLI' ) && WP_CLI ) {
	$_SERVER['HTTP_HOST'] = 'wplib.box';
}

/**
 * Autoload any non-WordPress dependencies
 */
if ( is_file( __DIR__ . '/vendor/autoload.php' ) ) {
	require( __DIR__ . '/vendor/autoload.php' );
}

/**
 * Load configuration object
 */
if ( is_file( __DIR__ . '/config-loader.php' ) ) {
	trigger_error( 'File not found: ' . __DIR__ . '/config-loader.php' );
	exit;
}
$config = require( __DIR__ . '/config-loader.php' );

define( 'WP_HOME', 				$config->WP_HOME );
define( 'WP_SITEURL', 			$config->WP_SITEURL );
define( 'WP_CONTENT_DIR', 		$config->WP_CONTENT_DIR );
define( 'WP_CONTENT_URL', 		$config->WP_CONTENT_URL );

define( 'DB_NAME', 				$config->DB_NAME );
define( 'DB_USER', 				$config->DB_USER );
define( 'DB_PASSWORD', 			$config->DB_PASSWORD );
define( 'DB_HOST', 				$config->DB_HOST );
define( 'DB_CHARSET', 			$config->DB_CHARSET );
define( 'DB_COLLATE', 			$config->DB_COLLATE );

define( 'WP_DEBUG', 			$config->WP_DEBUG );
define( 'DISALLOW_FILE_EDIT', 	$config->DISALLOW_FILE_EDIT );

/**
 * https://api.wordpress.org/secret-key/1.1/salt/ 
 */
define( 'AUTH_KEY',         	$config->AUTH_KEY );
define( 'SECURE_AUTH_KEY',  	$config->SECURE_AUTH_KEY );
define( 'LOGGED_IN_KEY',    	$config->LOGGED_IN_KEY );
define( 'NONCE_KEY',        	$config->NONCE_KEY );
define( 'AUTH_SALT',        	$config->AUTH_SALT );
define( 'SECURE_AUTH_SALT', 	$config->SECURE_AUTH_SALT );
define( 'LOGGED_IN_SALT',   	$config->LOGGED_IN_SALT );
define( 'NONCE_SALT',       	$config->NONCE_SALT );

define( 'ABSPATH', 				$config->ABSPATH );

$table_prefix = 				$config->TABLE_PREFIX;

unset( $config );

require_once( ABSPATH . 'wp-settings.php' );