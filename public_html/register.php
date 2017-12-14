<?php

// This file is the login page. 
// It lists every it allows users to login to the site.

// Require the configuration before any PHP code:
require ('./includes/config.inc.php');

// Include the header file:
$page_title = 'User Register - StoreIt!- Storage Solution for Everyone';


if(isset($_GET['returnUrl']))
	$returnUrl = $_GET['returnUrl'];

$errors = array();


if($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['btnRegister'])){
	// Require the database connection:
	require (MYSQL);


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

	if($_POST['password'] !== $_POST['confirmPassword']){
		$errors['confirmPassword'] = 'Password and Confirm Password doesn\'t match';
	}

	// Check for a first name:
	if (preg_match ('/^[A-Z \'.-]{2,20}$/i', $_POST['firstName'])) {
		$firstName = addslashes($_POST['firstName']);
	} else {
		$errors['firstName'] = 'Please enter your first name!';
	}
	
	// Check for a last name:
	if (preg_match ('/^[A-Z \'.-]{2,40}$/i', $_POST['lastName'])) {
		$lastName  = addslashes($_POST['lastName']);
	} else {
		$errors['lastName'] = 'Please enter your last name!';
	}

	if(preg_match('/^(0|1)[\d]\/[0-3][\d]\/(19|20)[\d]{2}$/', $_POST['dateOfBirth'])){
		$date = DateTime::createFromFormat("m/d/Y",$_POST['dateOfBirth']);
		$dob = $date->format("Y-m-d");
	}
	else{
		$errors['dateOfBirth'] = 'please enter a valid date in mm/dd/yyyy format';
	}

	if(isset($_POST['gender'])){
		$gender = $_POST['gender'];

	}
	else{
		$errors['gender'] = "Please select a gender";
	}	

	// var_dump($errors);

	if(empty($errors)){
		// Invoke the stored procedure:
		$r = mysqli_query ($dbc, "CALL add_customer('$email', '$password', '$firstName', '$lastName', '$gender', '$dob', @cid)");

		if ($r) {
			// Retrieve the customer ID:
			$r = mysqli_query($dbc, 'SELECT @cid');
			if (mysqli_num_rows($r) == 1) {

				list($_SESSION['customer_id']) = mysqli_fetch_array($r);
				$_SESSION['email'] = $email;

				if(isset($returnUrl)){
					$location = 'http://' . BASE_URL . $returnUrl;
					header("location:$location");
				}

				include ('./views/registration_success.html');
			}
		}
		else{
			echo mysqli_error($dbc);

			switch (mysqli_errno($dbc)) {
				case 1062:
					$error = "Account with the email address already exists";
					break;
				
				default:
					$error = "Something Happened we are unable to create your account";
					break;
			}
		}
	} else {
		$error = "Please correct the following errors";
	}

}
include ('./includes/header.html');

include ('./views/register.html');


// Include the footer file:
include ('./includes/footer.html');
?>