<?php

require_once 'mollie/initialize.php';
require '../gateways/eventticket_gateway.php';
require '../gateways/ticket_gateway.php';

// Turn off display_errors so we only return the checkoutUrl in case of warning
ini_set('display_errors', 0);

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = (array)json_decode(file_get_contents('php://input'), TRUE);

    if (!validate_data($data)) {
        header('HTTP/1.1 422 Unprocessable Entity');
        exit();
    }

    $eventticket_gateway = new eventticket_gateway;
    $event_ticket = $eventticket_gateway->retrieve($data['event_ticket']);

    $ticket_gateway = new ticket_gateway;
    $ticket_id = $ticket_gateway->insert(array(
        "user" => (int)$data['user'],
        "event_ticket" => (int)$data['event_ticket'],
        "code" => bin2hex(openssl_random_pseudo_bytes(32)),
    ));

    $payment = $mollie->payments->create([
        "amount" => [
            "currency" => "EUR",
            "value" => number_format((float)$event_ticket['price'], 2, "."),
        ],
        "description" => "Aankoop van ticket",
        "redirectUrl" => URL . "/payment/check.php",
        "webhookUrl" => URL . "/payment/webhook.php",
        "metadata" => [
            "ticket_id" => $ticket_id,
        ],
    ]);

    $payment->redirectUrl = URL . "/payment/check.php?id=" . $payment->id;
    $payment = $payment->update();

    $ticket = $ticket_gateway->retrieve($ticket_id);
    $ticket['payment_id'] = $payment->id;
    $ticket_gateway->update($ticket_id, $ticket);

    echo $payment->getCheckoutUrl();
}

function validate_data($data) {
    if (!isset($data['user'])) {
        return false;
    }

    if (!isset($data['event_ticket'])) {
        return false;
    }

    return true;
}
