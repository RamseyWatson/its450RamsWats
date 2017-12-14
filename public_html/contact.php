<?php

// This file is the home page. 
// This script is begun in Chapter 8.

// Require the configuration before any PHP code:
require ('./includes/config.inc.php');

// Include the header file:
$page_title = 'Contact - StoreIt!- Storage Solution for Everyone';
include ('./includes/header.html');

// Require the database connection:
require (MYSQL);


// Include the view:
include('./views/contact.html');

// Include the footer file:
include ('./includes/footer.html');
?>