<?php
class Config_Loader {
	private static $_instance;
	static function instance() {
		return self::$_instance;
	}
	static function set_instance( $instance ) {
		self::$_instance = $instance;
	}
	public $CORE_DIR;
	public $CORE_PATH;
	public $BOOT_PATH;
	public $CONTENT_PATH;
	public $CONFIG_PATH;

	public $WP_HOME;
	public $WP_SITEURL;
	public $WP_CONTENT_DIR;
	public $WP_CONTENT_URL;

	public $DB_NAME;
	public $DB_USER;
	public $DB_PASSWORD;
	public $DB_HOST;
	public $DB_CHARSET;
	public $DB_COLLATE;

	public $WP_DEBUG;
	public $DISALLOW_FILE_EDIT;

	public $TABLE_PREFIX;


	static function on_load() {
		$config = new self();
        $config->CONFIG_PATH  = realpath( "{{config_path}}" );
        $http_host = preg_replace( '#^www\.(.+)$#', '$1', $_SERVER['HTTP_HOST'] );
        $local_config = "{$config->CONFIG_PATH}/config-[{$http_host}].php";
        do {
        	if ( ! is_file( $local_config ) ) {
        		break;
	        }
	        $config_values = require( $local_config );
			if ( ! is_array( $config_values ) ) {
				break;
			}
	        foreach( $config_values as $config_name => $config_value ) {
				if ( defined( $config_name ) ) {
					trigger_error( sprintf( "%s already defined.", $config_name ) );
					exit;
				}
		        $config->$config_name = $config_value;
	        }

        } while ( false );

		self::$_instance = $config;
    }
}
Config_Loader::on_load();
