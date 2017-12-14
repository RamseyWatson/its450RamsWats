<?php

// This file is the login page. 
// It lists every it allows users to login to the site.

// Require the configuration before any PHP code:
require ('./includes/config.inc.php');
require ('./includes/form_functions.inc.php');



if(isset($_SESSION['customer_id'])) {
	header("location:/index.php");
}

// Include the header file:
$page_title = 'User Login - StoreIt!- Storage Solution for Everyone';


$returnUrl = "/index.php";
if(isset($_GET['returnUrl']))
	$returnUrl = $_GET['returnUrl'];

$errors = array();
if($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['btnLogin'])){ 
	// Require the database connection:
	require (MYSQL);

	
	// Check for Magic Quotes:
	if (get_magic_quotes_gpc()) {
		$_POST['first_name'] = stripslashes($_POST['first_name']);
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


	if(isset($_GET['returnUrl'])){
		$returnUrl = $_GET['returnUrl'];
	}

	if(empty($errors)){
		// Invoke the stored procedure:
		$r = mysqli_query ($dbc, "CALL validate_user('$email', '$password')");


		if (mysqli_num_rows($r) == 1) {
			if (isset($_COOKIE['SESSION'])) {
				$uid = $_COOKIE['SESSION'];
			} else {
				$uid = md5(uniqid('biped',true));
			}

			// Send the cookie:
			setcookie('SESSION', $uid, time()+(60*60*24*30));

			session_id($uid);

			list($_SESSION['customer_id']) = mysqli_fetch_array($r);
			$_SESSION['email'] = $email;
			$location = 'http://' . BASE_URL . $returnUrl;
			header("location:$location?session=$uid");
			exit();
			
		} else {
			$error = "Invalid Login Credentials";
		}
	}
	else{
		$error="Please correct the following errors";
	}

}

include ('./includes/header.html');


include ('./views/login.html');


// Include the footer file:
include ('./includes/footer.html');
?>