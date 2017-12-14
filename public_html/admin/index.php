<?php

// This is the adminstrative home page.
// This script is created in Chapter 11.

// Require the configuration before any PHP code as configuration controls error reporting.
require ('../includes/config.inc.php');
require ('../includes/form_functions.inc.php');


if(isset($_SESSION['user_id'])) {
	header("location:./products.php");
}

// Set the page title and include the header:
$page_title = 'Store it! - Administration';

$errors = array();
if($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['btnLogin'])){ 
	// Require the database connection:
	require (MYSQL);

	
	// Check for Magic Quotes:
	if (get_magic_quotes_gpc()) {
		$_POST['email'] = stripslashes($_POST['email']);
		// Repeat for other variables that could be affected.
	}


	if(preg_match('/^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/', $_POST['email'])){
		$email = addslashes($_POST['email']);
	}
	else{
		$errors['email'] = 'Please enter a valid email address';
	}

	if(preg_match('/^[A-Za-z0-9]{4,}$/', $_POST['password'])){
		$password = addslashes($_POST['password']);
	}
	else{
		$errors['password'] = 'Please enter a valid password with minimum 4 characters';
	}

	if(empty($errors)){

	// Invoke the stored procedure:
		$r = mysqli_query ($dbc, "CALL validate_admin('$email', '$password')");


		if (mysqli_num_rows($r) == 1) {

			list($_SESSION['user_id']) = mysqli_fetch_array($r);
			$_SESSION['admin_email'] = $email;
			$location = 'http://' . BASE_URL . 'admin/products.php';
			header("location:$location");
			exit();
			
		} else {
			$error = "Invalid Login Credentials";
		}
	}
	else{
		$error="Please correct the following errors";
	}

}


include ('./includes/header_login.html');


include ('./views/login.html')

?>



<?php include ('./includes/footer.html'); ?>