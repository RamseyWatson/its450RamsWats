<?php

// This file is the first step in the checkout process.
// It takes and validates the shipping information.
// This script is begun in Chapter 10.

// Require the configuration before any PHP code:
require ('./includes/config.inc.php');

// Check for the user's session ID, to retrieve the cart contents:
if (!isset($_SESSION['customer_id'])) {
	$location = 'http://' . BASE_URL . 'login/?returnUrl=checkout.php';
	header("Location: $location");
	exit();
}


// Create an actual session for the checkout process...

// Require the database connection:
require (MYSQL);

// Validate the checkout form...

// For storing errors:
$shipping_errors = array();

// Check for a form submission:
if ($_SERVER['REQUEST_METHOD'] == 'POST') {


	if(isset($_POST['btnAddAddress'])){
		// Check for Magic Quotes:
		if (get_magic_quotes_gpc()) {
			$_POST['first_name'] = stripslashes($_POST['first_name']);
			// Repeat for other variables that could be affected.
		}

		// Check for a first name:
		if (preg_match ('/^[A-Z \'.-]{2,20}$/i', $_POST['first_name'])) {
			$fn = addslashes($_POST['first_name']);
		} else {
			$shipping_errors['first_name'] = 'Please enter your first name!';
		}
		
		// Check for a last name:
		if (preg_match ('/^[A-Z \'.-]{2,40}$/i', $_POST['last_name'])) {
			$ln  = addslashes($_POST['last_name']);
		} else {
			$shipping_errors['last_name'] = 'Please enter your last name!';
		}
		
		// Check for a street address:
		if (preg_match ('/^[A-Z0-9 \'\/,.#-]{2,80}$/i', $_POST['address1'])) {
			$a1  = addslashes($_POST['address1']);
		} else {
			$shipping_errors['address1'] = 'Please enter your street address!';
		}
		
		// Check for a second street address:
		if (empty($_POST['address2'])) {
			$a2 = NULL;
		} elseif (preg_match ('/^[A-Z0-9 \',.#-]{2,80}$/i', $_POST['address2'])) {
			$a2 = addslashes($_POST['address2']);
		} else {
			$shipping_errors['address2'] = 'Please enter your street address!';
		}
		
		// Check for a city:
		if (preg_match ('/^[A-Z \'.-]{2,60}$/i', $_POST['city'])) {
			$c = addslashes($_POST['city']);
		} else {
			$shipping_errors['city'] = 'Please enter your city!';
		}
		
		// Check for a state:
		if (preg_match ('/^[A-Z]{2}$/', $_POST['state'])) {
			$s = $_POST['state'];
		} else {
			$shipping_errors['state'] = 'Please enter your state!';
		}
		
		// Check for a zip code:
		if (preg_match ('/^(\d{5}$)|(^\d{5}-\d{4})$/', $_POST['zip'])) {
			$z = $_POST['zip'];
		} else {
			$shipping_errors['zip'] = 'Please enter your zip code!';
		}
		
		// Check for a phone number:
		// Strip out spaces, hyphens, and parentheses:
		$phone = str_replace(array(' ', '-', '(', ')'), '', $_POST['phone']);
		if (preg_match ('/^[0-9]{10}$/', $phone)) {
			$p  = $phone;
		} else {
			$shipping_errors['phone'] = 'Please enter your phone number!';
		}
		
		// Check for an email address:
		// if (filter_var($_POST['email'], FILTER_VALIDATE_EMAIL)) {
		// 	$e = $_POST['email'];
		// 	$_SESSION['email'] = $_POST['email'];
		// } else {
		// 	$shipping_errors['email'] = 'Please enter a valid email address!';
		// }	
		
		// Check if the shipping address is the billing address:
		if (isset($_POST['use']) && ($_POST['use'] == 'Y')) {
			$_SESSION['shipping_for_billing'] = true;
			$_SESSION['cc_first_name']  = $_POST['first_name'];
			$_SESSION['cc_last_name']  = $_POST['last_name'];
			$_SESSION['cc_address']  = $_POST['address1'] . ' ' . $_POST['address2'];
			$_SESSION['cc_city'] = $_POST['city'];
			$_SESSION['cc_state'] = $_POST['state'];
			$_SESSION['cc_zip'] = $_POST['zip'];
		}

		if (empty($shipping_errors)) { // If everything's OK...			
			
			// // Call the stored procedure:
			$r = mysqli_query($dbc, "CALL add_address({$_SESSION['customer_id']},'$fn', '$ln', '$a1', '$a2', '$c', '$s', $z, $p, @aid)");

			// Confirm that it worked:
			if ($r) {

				// Retrieve the customer ID:
				$r = mysqli_query($dbc, 'SELECT @aid');
			
				if (mysqli_num_rows($r) == 1) {
					list($_SESSION['delivery_address']) = mysqli_fetch_array($r);
					// Redirect to the next page:
					$location = 'https://' . BASE_URL . 'billing.php';
					header("Location: $location");
					exit();	
				}
						
					

			}

			// Log the error, send an email, panic!

			trigger_error('Your order could not be processed due to a system error. We apologize for the inconvenience.');
		}

	} // Errors occurred IF.
	else if($_POST['btnContinue']){
		if(isset($_POST['user-address']) && $_POST['user-address']){
			$_SESSION['delivery_address'] = $_POST['user-address'];
		}
		else{
			$shipping_errors['user-address'] = 'Please select an Address';
		}

		if (isset($_POST['use']) && ($_POST['use'] == 'Y')) {
			$_SESSION['shipping_for_billing'] = true;

			$r = mysqli_query($dbc, "CALL get_address({$_POST['user-address']})");

			if (mysqli_num_rows($r) == 1) {
				$address = mysqli_fetch_array($r);
				$_SESSION['cc_first_name']  = $address['first_name'];
				$_SESSION['cc_last_name']  = $address['last_name'];
				$_SESSION['cc_address']  = $address['address1'] . ' ' . $address['address2'];
				$_SESSION['cc_city'] = $address['city'];
				$_SESSION['cc_state'] = $address['state'];
				$_SESSION['cc_zip'] = $address['zip'];
			}
		}

		if (empty($shipping_errors)) { // If everything's OK...
			$location = 'https://' . BASE_URL . 'billing.php';
			header("Location: $location");
			exit();	
		}
	}

} // End of REQUEST_METHOD IF.
							
// Include the header file:
$page_title = 'Store It! - Checkout - Your Shipping Information';
include ('./includes/checkout_header.html');

$page = './views/checkout.html';

if(isset($_SESSION['customer_id'])){
	$addresses = array();

	$r = mysqli_query($dbc,'CALL get_addresses('.$_SESSION['customer_id'].')');
	if(mysqli_num_rows($r) > 0){
		while($address = mysqli_fetch_array($r)){
			array_push($addresses, $address);
		}
	}

	mysqli_next_result($dbc);
	
	$page = './views/user_checkout.html';
}



// Get the cart contents:
$r = mysqli_query($dbc, "CALL get_shopping_cart_contents('$uid')");

if (mysqli_num_rows($r) === 0) { // Products to show!
	$page = './views/emptycart.html';
}

include ($page);

// Finish the page:
include ('./includes/footer.html');
?>