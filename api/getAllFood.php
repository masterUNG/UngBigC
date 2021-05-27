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

	$result = mysqli_query($link, "SELECT * FROM foodTABLE");
   
	while($row=mysqli_fetch_assoc($result)){
	$output[]=$row;
	}

	echo json_encode($output);

	mysqli_close($link);
?>