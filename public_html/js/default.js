(function($){

	function sendAjax(requesturl, params, callback, errorcallback) {
		$.ajax({
			data : params,
			error: errorcallback,
			method : 'POST',
			success : callback,
			url : requesturl,
			dataType:'json'
		});
	}

	function validate_email(email){
		return email.match(/^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/gi);
	}

	function validate_dob(dob){
		return dob.match(/^(0|1)[\d]\/[0-3][\d]\/(19|20)[\d]{2}$/gi);
	}
	
	function moveover(e) {
		$(".drop-down ul").css("visibility", "visible");
	}

	function mouseout(e) {
		$(".drop-down ul").css("visibility", "hidden");
	}

	function stockUpdated(data,textStatus, xhr) {
		if(data.responsecode == 200){
			var product = data.product;
			var row = $("#"+product.type+"-"+product.id+" td");
			$(row[9]).find("span").text(product.stock);
			$(row[9]).find("a").data('product', product);
			$(row[11]).find("a").data('product', product);
			$("#edit-stock").dialog("close");
		}
		else if(data.responsecode == 403){
			$("#stock-error").text("You are not allowed to update the stock");
		}
		else{
			$("#stock-error").text("Access Denied");
		}
	}
	function productUpdated(data,textStatus, xhr) {
		if(data.responsecode == 200){
			var product = data.product;
			var row = $("#"+product.type+"-"+product.id+" td");
			$(row[2]).text(product.category);
			$(row[3]).text(product.size);
			$(row[4]).text(product.company_name);
			$(row[5]).html(product.description);
			$(row[6]).text(product.usb2_3);
			$(row[7]).text(product.scsi_ide);
			$(row[8]).text("$ " + product.price);
			$(row[9]).find("a").data('product', product);
			$(row[11]).find("a").data('product', product);
			$("#edit-storage-product").dialog("close");
		}
		else if(data.responsecode == 403){
			$("#storage-product-error").text("You are not allowed to update the product");
		}
		else{
			$("#storage-product-error").text("Access Denied");
		}
	}

	function error(){}

	function updateStock(){
		var product = $("#edit-stock").data('product');
		var count = parseInt($("#dialogStockQty").val());
		if(count < 0){
			$("#stock-error").text("Please enter stock greater than or equal to 0");
			return false;
		}
		var params = {
			id : product.id,
			type : product.type,
			stock : count,
			operation:'editstock'
		}

		sendAjax(admin_ajax,params,stockUpdated, error);
	}

	function updateProduct(){
		var product = $("#edit-storage-product").data('product');
		var params = {
			id : product.id,
			type : product.type,
			operation:'updateProduct'
		}
		if(product.type == 'storage'){
			params['category'] = $("#storage-category").val();
			params['size'] = $("#size").val();
			params['company_name'] =  $("#storageCompanyName").val();
			params['description'] = $("#storageDescription").val();
			if(params['category'] == 1 || params['category'] == 2){
				params['usb2_3'] = $("#usb2_3").val();
			} else{
				params['scsi_ide'] = $("#scsi_ide").val();
			}
			params['price'] = parseFloat($("#storagePrice").val());
		}
		
		if(params['price'] < 1){
			$("#stock-error").text("Please enter price greater than 0");
			return false;
		}

		sendAjax(admin_ajax,params,productUpdated, error);
	}

	$(function(){
		$(".drop-down").hover(moveover, mouseout);


		if(document.getElementById('btnLogin')){
			// $("form").on('submit', function(e){
			// 	alert('Hello');				
			// })
		}
		else if(document.getElementById('btnRegister')){
			$("#dateOfBirth").datepicker({
				dateFormat:'mm/dd/yy',
				changeMonth:true,
				changeYear:true,
				maxDate:"-5y",
				yearRange:"-99:-5"
			});

			$(".gender").checkboxradio();

			$("form").on("submit", function(e){
				var errors = false;
				var email = $("#email").val();
				var password = $("#password").val();
				var confirmPassword = $("#confirmPassword").val();
				var dateOfBirth = $("#dateOfBirth").val();
				var gender = $(".gender:checked").val();

				if(!validate_email(email)){
					errors=true;
					$("#email").next(".error").text("Please enter a valid email address");
				}
				else{
					$("#email").next(".error").text("");	
				}

				if(!password.match(/^[A-Za-z0-9]{4,}$/gi)){
					errors = true;
					$("#password").next(".error").text("Please enter the password with alphabets and digits only with minimum 4 characters");
				}
				else{
					$("#password").next(".error").text("");	
				}

				if(password != confirmPassword){
					errors = true;
					$("#confirmPassword").next(".error").text("Password and Confirm Password does not match");
				}
				else{
					$("#confirmPassword").next(".error").text("");
				}

				if(!validate_dob(dateOfBirth)){
					errors = true;
					$("#dateOfBirth").next(".error").text("please enter a valid date in mm/dd/yyyy format");
				}
				else{
					$("#dateOfBirth").next(".error").text("");
				}

				if(typeof gender != 'undefined'){
					errors = false;
					$("label.ui-checkboxradio-label:last").next(".error").text("Please select a gender");
				}
				else{
					$("label.ui-checkboxradio-label:last").next(".error").text("");	
				}


				if(errors){
					e.preventDefault();	
				}
				
			})
		}
		else if(document.getElementById("btnContinue")){
			$("form#select-address").on("submit", function(e){
				if(typeof $(".select-user-address:checked").val()=="undefined"){
					$("#user-address-error").text("Please select an Address");
					e.preventDefault();
				}
			});
			
		}
		else if(document.getElementById("btnPlaceOrder")){
			$('#billing_form').submit(function(){
				$('input[type=submit]', this).attr('disabled', 'disabled');
				$('#submit_div').html('<p class="button">Processing...</p>');
			});
		}
		else if(document.getElementById("edit-stock")){
			$("#edit-stock").dialog({
				autoOpen: false,
				height: 450,
				width: 350,
				modal: true,
				buttons: {
				  "Update": updateStock,
				  Cancel: function() {
					$("#edit-stock").dialog( "close" );
				  }
				},
				close: function() {
				  document.forms[ 0 ].reset();
				  $(".ui-state-error").removeClass( "ui-state-error" );
				}
			});
			
			$("#edit-storage-product").dialog({
				autoOpen: false,
				height: 650,
				width: 450,
				modal: true,
				buttons: {
				  "Update Product": updateProduct,
				  Cancel: function() {
					$("#edit-storage-product").dialog( "close" );
				  }
				},
				close: function() {
					document.forms[ 1 ].reset();
					$(".ui-state-error").removeClass( "ui-state-error" );
				}
			});

			$(".edit-item-stock").on("click", function(e) {
				var data = $(this).data('product');
				$("#edit-stock").data('product', data).dialog("open");
				$("#dialogSKU").val(data.sku);
				$("#dialogCategory").val(data.category);
				$("#dialogSize").val(data.size);
				$("#dialogStockQty").val(data.stock);
				e.preventDefault();
			});

			$(".edit-product-item").on("click", function(e) {
				var data = $(this).data('product');
				if(data.type=='storage'){
					$("#edit-storage-product select option").removeAttr('selected');
					$("#edit-storage-product").data('product', data).dialog("open");
					$("#storage-category option[value=" + data.storage_device_id +" ]").attr('selected', 'selected');
					$("#size option[value=" + data.size_id +" ]").attr('selected', 'selected');
					$("#storageCompanyName").val(data.company_name);
					$("#storageDescription").val(data.description);
					if(data.storage_device_id == 1 || data.storage_device_id == 2){
						$("#usb2_3 option[value=" + data.usb2_3 +" ]").attr('selected', 'selected');
						$("#scsi_ide").attr('disabled', 'disabled');
					} else{
						$("#usb2_3").attr('disabled', 'disabled');
						$("#scsi_ide option[value=" + data.scsi_ide +" ]").attr('selected', 'selected');
					}
					$("#storagePrice").val(data.price);
				}
				else{

				}
				e.preventDefault();
			});
		}
	});

})(jQuery);