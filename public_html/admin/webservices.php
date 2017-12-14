<?php

require ('../includes/config.inc.php');
require(MYSQL);

$response = array();

function edit_stock($id, $type, $stock){
    global $dbc;
    $product = null;

    if (filter_var($stock, FILTER_VALIDATE_INT, array('min_range' => 1))) {

        $query1 = 'UPDATE storage_device_products SET stock=? WHERE id=?';
        $query2 = 'SELECT CONCAT("S", sdp.id) as sku, sdp.`id`,sdp.storage_device_id, sd.`category`, \'storage\' as type, sz.`size`, sdp.size_id, sdp.`company_name`, sdp.`description`, sdp.`usb2_3`, sdp.`scsi_ide`, sdp.`price`, sdp.`stock`, sdp.`date_created`, sdp.`image` FROM `storage_device_products` sdp INNER JOIN `storage_devices` sd ON sdp.storage_device_id = sd.id INNER JOIN `sizes` sz ON sdp.size_id = sz.id WHERE sdp.id=?';
        if($type !== 'storage'){
            $query1 = 'UPDATE other_products SET stock=? WHERE id=?';
            $query2 = 'SELECT CONCAT("S", op.id) as sku, op.`id`, op.`other_category_id`, oc.`category`,\'other\' as type, null ,null, op.`name`, op.`description`, op.`image`, null,null,op.`price`, op.`stock`, op.`date_created` FROM `other_products` op INNER JOIN `other_categories` oc ON op.`other_category_id` = oc.`id` WHERE op.id=?';
        }

        $stmt = mysqli_prepare($dbc, $query1);
        
        // Bind the variables:
        mysqli_stmt_bind_param($stmt, 'ii', $stock, $id);

        mysqli_stmt_execute($stmt);
        
        // Add to the affected rows:
        $affected = mysqli_stmt_affected_rows($stmt);

        if($affected === 1){
            $stmt = mysqli_prepare($dbc, $query2);
            
            // Bind the variables:
            mysqli_stmt_bind_param($stmt, 'i', $id);
    
            mysqli_stmt_execute($stmt);

            $r = mysqli_stmt_get_result($stmt);

            if(mysqli_num_rows($r) === 1){
                $product = mysqli_fetch_array($r, MYSQLI_ASSOC);
            }
        }
    } //end of if

    return $product;
    
}

function edit_product($id, $type, $category, $size, $name, $description, $usb2_3, $scsi_ide, $price){
    global $dbc;
    $errors = array();
    $product = null;
    $description = htmlspecialchars($description);

    if(empty($errors)){
        $query1 = 'UPDATE storage_device_products SET `storage_device_id`=?,`size_id`=?,`company_name`=?,`description`=?,`usb2_3`=?,`scsi_ide`=?,`price`=? WHERE id=?';
        $query2 = 'SELECT CONCAT("S", sdp.id) as sku, sdp.`id`,sdp.storage_device_id, sd.`category`, \'storage\' as type, sz.`size`, sdp.size_id, sdp.`company_name`, sdp.`description`, sdp.`usb2_3`, sdp.`scsi_ide`, sdp.`price`, sdp.`stock`, sdp.`date_created`, sdp.`image` FROM `storage_device_products` sdp INNER JOIN `storage_devices` sd ON sdp.storage_device_id = sd.id INNER JOIN `sizes` sz ON sdp.size_id = sz.id WHERE sdp.id=?';
        if($type !== 'storage'){
            $query1 = 'UPDATE other_products SET `other_category_id`=?,`name`=?,`description`=?,`price`=? WHERE id=?';
            $query2 = 'SELECT CONCAT("S", op.id) as sku, op.`id`, op.`other_category_id`, oc.`category`,\'other\' as type, null ,null, op.`name`, op.`description`, op.`image`, null,null,op.`price`, op.`stock`, op.`date_created` FROM `other_products` op INNER JOIN `other_categories` oc ON op.`other_category_id` = oc.`id` WHERE op.id=?';
        }

        $stmt = mysqli_prepare($dbc, $query1);
        
        // Bind the variables:
        if($type === 'storage'){
            mysqli_stmt_bind_param($stmt, 'iissssdi', $category, $size, $name, $description, $usb2_3, $scsi_ide, $price, $id);
        }
        else{
            mysqli_stmt_bind_param($stmt, 'issdi', $category, $name, $description, $price, $id );
        }

        mysqli_stmt_execute($stmt);
        
        // Add to the affected rows:
        $affected = mysqli_stmt_affected_rows($stmt);

        if($affected === 1){
            $stmt = mysqli_prepare($dbc, $query2);
            
            // Bind the variables:
            mysqli_stmt_bind_param($stmt, 'i', $id);

            mysqli_stmt_execute($stmt);

            $r = mysqli_stmt_get_result($stmt);

            if(mysqli_num_rows($r) === 1){
                $product = mysqli_fetch_array($r, MYSQLI_ASSOC);
            }
        }
    }
    else{
        return $errors;
    }

    return $product;
}

if($_SERVER['REQUEST_METHOD'] === 'POST'){
    if(!isset($_SESSION['user_id'])){
        $response['responsecode'] = 403;
        $response['response'] = 'Not Authorized';
    }
    else{
        $response['responsecode'] = 200;
        $id = $_POST['id'];
        $type = $_POST['type'];
        $operation = $_POST['operation'];
        $product = null;
        switch($operation){
            case 'editstock':
                $stock = $_POST['stock'];
                $product = edit_stock($id, $type, $stock);
                if($product === null){
                    $response['responsecode'] = 500;
                    $response['response'] = 'Error in update';
                }
            break;

            case 'updateProduct':
                $category = $_POST['category'];
                $size = $_POST['size'];
                $company_name =  $_POST['company_name'];
                $description = $_POST['description'];
                if(isset($_POST['usb2_3'])) $usb2_3 = $_POST['usb2_3'];
                if(isset($_POST['scsi_ide'])) $scsi_ide = $_POST['scsi_ide'];
                $price = $_POST['price'];

                $product = edit_product($id, $type, $category, $size, $company_name, $description, (isset($usb2_3)?$usb2_3:''), (isset($scsi_ide)?$scsi_ide:''), $price);
            break;
        }

        $product['description'] = htmlspecialchars_decode($product['description']);

        $response['product'] = $product;
    }
}
else{
    $response['responsecode'] = 500;
    $response['response'] = 'Only POST Request is accepted';
}

echo json_encode($response);