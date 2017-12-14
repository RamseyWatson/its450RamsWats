<?php

// This file allows the administrator to add inventory.
// This script is created in Chapter 11.

// Require the configuration before any PHP code as configuration controls error reporting.
require ('../includes/config.inc.php');
require ('../includes/form_functions.inc.php');

if(!isset($_SESSION['user_id'])){
	header("location:./index.php");
}

// Set the page title and include the header:
$page_title = 'Manage Products - Store it! -Administrator';
include ('./includes/header.html');
// The header file begins the session.

// Require the database connection:
require (MYSQL);

$r = mysqli_query($dbc, "SELECT `id`, `category` FROM `storage_devices`");
$storage_categories = array();

if(mysqli_num_rows($r)>0){
	while ($row = mysqli_fetch_array($r, MYSQLI_ASSOC)) {
		$storage_categories[$row['id']] = $row['category'];
	}
}

$r = mysqli_query($dbc, "SELECT `id`, `category` FROM `other_categories`");
$other_categories = array();

if(mysqli_num_rows($r)>0){
	while ($row = mysqli_fetch_array($r, MYSQLI_ASSOC)) {
		$other_categories[] = $row;
	}
}

$r = mysqli_query($dbc, "SELECT `id`, `size` FROM `sizes`");
$sizes = array();

if(mysqli_num_rows($r)>0){
	while ($row = mysqli_fetch_array($r, MYSQLI_ASSOC)) {
		$sizes[$row['id']] = $row['size'];
	}
}


$r = mysqli_query($dbc, "CALL get_products_list()");



include ('./views/products.html');

include ('./includes/footer.html');