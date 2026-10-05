<?php

$error = array();

$name = $_POST['name'];
$email = $_POST['email'];
$password = $_POST['password'];
$card = $_POST['card'];
$phone = $_POST['phone'];

if (!preg_match("/^[A-Za-z ]+$/", $name)) {
    $error[] = "Invalid Name Format";
}

if (!preg_match("/^[^\s@]+@[^\s@]+\.[^\s@]+$/", $email)) {
    $error[] = "Invalid Email Format";
}

if (!preg_match("/^[A-Za-z0-9]+$/", $password)) {
    $error[] = "Password is Invalid";
}

if (!preg_match("/^[0-9]{16}$/", $card)) {
    $error[] = "Credit Card Number must contain exactly 16 digits";
}

if (!preg_match("/^[0-9]{10}$/", $phone)) {
    $error[] = "Phone Number must contain exactly 10 digits";
}

if (count($error) > 0) {

    echo "<h2>Validation Error</h2>";

    foreach ($error as $message) {
        echo "<p >$message</p>";
    }

    echo "<br>";
    echo "<a href='index.html'>GO Back</a>";

} else {

    echo "<h1 >Registration Successful!</h1>";
    echo "<p><b>Name:</b> " . $name . "</p>";
    echo "<p><b>Email:</b> " . $email . "</p>";
    echo "<p><b>Phone:</b> " . $phone . "</p>";
    echo "<p><b>Credit Card:</b> " . $card . "</p>";
}

?>