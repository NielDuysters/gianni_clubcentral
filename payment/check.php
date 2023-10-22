<?php

require_once 'mollie/initialize.php';

if (isset($_GET['id'])) {
    $payment = $mollie->payments->get($_GET['id']);

    if ($payment->status == "paid") {
        echo "Bedankt voor uw bestelling.";
        
        echo "<br><br><br>Gebruik App Links in Flutter om de app vanuit de browser terug te openen na de betaling: https://pub.dev/packages/app_links<br><br> E.g: my-app://payment-success";
    } else {
        echo "Er was een fout bij uw bestelling.";
        
        echo "<br><br><br>Gebruik App Links in Flutter om de app vanuit de browser terug te openen na de betaling: https://pub.dev/packages/app_links<br><br> E.g: my-app://payment-failed";
    }
}
