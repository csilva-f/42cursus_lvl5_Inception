<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the website, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
//define( 'DB_NAME', 'maria' );
define( 'DB_NAME', getenv('DB_NAME') );

/** Database username */
//define( 'DB_USER', 'umaria' );
define( 'DB_USER', getenv('DB_USER') );

/** Database password */
//define( 'DB_PASSWORD', 'abc' );
define( 'DB_PASSWORD', getenv('DB_PASSWORD') );

/** Database hostname */
//define( 'DB_HOST', 'mariadb' );
define( 'DB_HOST', getenv('DB_HOST') );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'nynZN@p%~s+VI2R}}wUJ[QIeCFk-DkNI)A:h=badn/,4xBpfAt,y(#,N}hnGAk [');
define('SECURE_AUTH_KEY',  '5}`z5X=]VN(~tp&pMG(~cwLoxIC`cnRqAP5Yf|f%^aN9-H+1O!|feL}slY#laZF9');
define('LOGGED_IN_KEY',    '_CI;<.-Yb#q6/C)w5BO*Qw!+rrp}umu+0bg|E,p<zdg T#E.|.<{|(BDczhL<#v(');
define('NONCE_KEY',        'M3eR`S~+F[Ie%NyZ$0x}(8:+FEp{cI?}J>J-j)cXU_Vno#,ylXd3|y`;#,fNlzX5');
define('AUTH_SALT',        'F)vM!awJo~0[A :hBe^Er1fv6uE0|*N*c+5>CYGRv` )E+@sk(&j?~@MX/d>!Tz~');
define('SECURE_AUTH_SALT', 'VK8-jb3.JA$|8]m&0TSoG#4nQ>+e1kB}A&ZYPzzJ.Ol#3  |tJlN.,IlL}.TAX5#');
define('LOGGED_IN_SALT',   'HcgLD)(7|e]E@1nh(|i~*dK+Pj*#T;rc+SR1*+{C%gQAD7is>xHT6*6O]b(J;G#m');
define('NONCE_SALT',       '=5RgOJnbZn:z7C&bv-x:O]$6cnkv.SRz!2Us F~Uvn:$PuKo8he`Wh,r!-p3x`h1');

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://developer.wordpress.org/advanced-administration/debug/debug-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
