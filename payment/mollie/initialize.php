<?php

require_once __DIR__ . "/vendor/autoload.php";
require_once '../config.php';

$mollie = new \Mollie\Api\MollieApiClient();
$mollie->setApiKey(MOLLIE_KEY);
