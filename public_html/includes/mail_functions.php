<?php
	function send_mail($to, $subject, $message, $body_plain=''){
		
		// Include the class definition:
		require dirname(__FILE__).'/library/PHPMailer/PHPMailerAutoload.php';

		//Create a new PHPMailer instance
		$mail = new PHPMailer;
		// Set PHPMailer to use the SMTP
		$mail->isSMTP();

		//Enable SMTP debugging
		// 0 = off (for production use)
		// 1 = client messages
		// 2 = client and server messages
		$mail->SMTPDebug = 0;

		//Ask for HTML-friendly debug output
		$mail->Debugoutput = 'html';

		//Set the hostname of the mail server
		$mail->Host = 'sub5.mail.dreamhost.com';
		// $mail->Host = 'smtp.gmail.com';

		//Set the SMTP port number - 587 for authenticated TLS, a.k.a. RFC4409 SMTP submission
		$mail->Port = 465;

		//Set the encryption system to use - ssl (deprecated) or tls
		$mail->SMTPSecure = 'ssl';

		//Whether to use SMTP authentication
		$mail->SMTPAuth = true;

		//Username to use for SMTP authentication - use full email address for gmail
		$mail->Username = 'info@its450000.com';

		//Password to use for SMTP authentication
		$mail->Password = "cassey69";

		//Set who the message is to be sent from
		$mail->setFrom('info@its450000.com', 'Cassandra Watson');
		//Set an alternative reply-to address
		$mail->addReplyTo('info@its450000.com', 'Cassandra Watson');
		//Set who the message is to be sent to
		$mail->addAddress($to);
		//Set the subject line
		$mail->Subject = $subject;
		//Read an HTML message body from an external file, convert referenced images to embedded,
		//convert HTML into a basic plain-text alternative body
		$mail->msgHTML($message);
		//Replace the plain text body with one created manually
		$mail->AltBody =$body_plain;
		//send the message, check for errors
		return $mail->send();
	}