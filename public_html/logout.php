<?php

// This file is the login page. 
// It lists every it allows users to login to the site.

// Require the configuration before any PHP code:
require ('./includes/config.inc.php');

$logout_success = false;
// remove the user session variables
if(isset($_SESSION['customer_id']) && isset($_SESSION['email'])){
	unset($_SESSION['customer_id']);
	unset($_SESSION['email']);
	$logout_success = true;
}

// Include the header file:
$page_title = 'Logout - StoreIt!- Storage Solution for Everyone';
include ('./includes/header.html');

if($logout_success){
	include ('./views/logout_success.html');
}
else{
	include ('./views/logout_failed.html');
}



// Include the footer file:
include ('./includes/footer.html');
?>