<?php

require_once 'mollie/initialize.php';
require '../gateways/ticket_gateway.php';

if (isset($_POST['id'])) {
    
    $payment = $mollie->payments->get($_POST["id"]);
    $ticket_id = $payment->metadata->ticket_id;

    $ticket_gateway = new ticket_gateway;
    $ticket = $ticket_gateway->retrieve($ticket_id);

    // Zet payment status van Mollie in tickets
    $ticket['payment_status'] = $payment->status;
    $ticket_gateway->update($ticket_id, $ticket);

    if ($payment->isPaid() && ! $payment->hasRefunds() && ! $payment->hasChargebacks()) {
        // Betaling gelukt.
        // TODO: Mail verzenden
        // https://github.com/PHPMailer/PHPMailer
    } else {
        // Betaling mislukt.
    }
}
