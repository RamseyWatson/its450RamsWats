<?php

// This file contains the database access information. 
// This file establishes a connection to MySQL and selects the database.
// This script is begun in Chapter 7.

// Set the database access information as constants:
DEFINE ('DB_USER', 'root');
DEFINE ('DB_PASSWORD', 'toor');
DEFINE ('DB_HOST', 'localhost');
DEFINE ('DB_NAME', 'ecommerce');


// // //server config
// DEFINE ('DB_USER', 'cassandra2');
// DEFINE ('DB_PASSWORD', 'cassey69');
// DEFINE ('DB_HOST', 'mysql.its450000.com');
// DEFINE ('DB_NAME', 'caswat2');

// Make the connection:
$dbc = mysqli_connect (DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);

// Set the character set:
mysqli_set_charset($dbc, 'utf8');

// Omit the closing PHP tag to avoid 'headers already sent' errors!
