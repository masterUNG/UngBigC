<?php
	include 'connected.php';
	header("Access-Control-Allow-Origin: *");

if (!$link) {
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    
    exit;
}

if (!$link->set_charset("utf8")) {
    printf("Error loading character set utf8: %s\n", $link->error);
    exit();
	}

if (isset($_GET)) {
	if ($_GET['isAdd'] == 'true') {
				
		$idUser = $_GET['idUser'];
		$nameUser = $_GET['nameUser'];
		$idProduct = $_GET['idProduct'];
		$nameProduct = $_GET['nameProduct'];
		$price = $_GET['price'];
		$amount = $_GET['amount'];
		
		
							
		$sql = "INSERT INTO `orderUNG`(`id`, `idUser`, `nameUser`, `idProduct`, `nameProduct`, `price`, `amont`) VALUES (Null,'$idUser','$nameUser','$idProduct','$nameProduct','$price','$amount')";

		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "Welcome Master UNG";
   
}
	mysqli_close($link);
?>