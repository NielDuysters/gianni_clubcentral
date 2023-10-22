<?php

require '../gateways/address_gateway.php';
require '../controllers/controller.php';

$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$uri = explode('/', $uri);

if ($uri[2] !== "addresses.php") {
    header("HTTP/1.1 404 Not Found");
    exit();
}

if (!isset($_GET['api_key']) || $_GET['api_key'] != API_KEY) {
    header("HTTP/1.1 401 Unauthorized");
    exit();
}

$id = null;
$column = null;
if (count($uri) == 5) {
    $id = $uri[4];
    $column = $uri[3];
} else if (isset($uri[3])) {
    $id = (int)$uri[3];
}

$gateway = new address_gateway;
$controller = new controller($_SERVER["REQUEST_METHOD"], $gateway, $id, $column);
$controller->process_request();
