// Use the http package
import 'package:http/http.dart' as http;

import 'dart:convert'; // for json
import 'dart:io';

// Global variables
import 'package:payment/globals.dart' as globals;

// All functions must be asynchronous
Future<void> main(List<String> arguments) async {
    
    // When the user wants to buy a ticket we need to know two things:
    // - The user who wants to buy it
    // - For what event the users wants to buy a ticket
    // Through the event we can get to know the club that hosts this club.
    // Note that a event has different type of tickets (e.g: VIP, Wave 1, Wave 2,...)
    //
    // We can know which user wants to buy a ticket by checking the ID of the logged
    // in user.
    // We know for what event the user wants to buy a ticket because the user
    // clicked on that event in the app.

    // Make data for purchase
    Map<String, dynamic> purchase_info = {
        "user": 53,                 // Insert USER ID here
        "event_ticket": 14         // Insert EventTicket ID here 
    };

    // Convert to JSON
    String json = jsonEncode(purchase_info);

    // URL to purchase endpoint
    final url = "${globals.URL}/payment/buy.php";

    // Making HTTP POST request to purchase endpoint
    final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json,
    );

    if (response.statusCode == 200) {
        print("[Success] Opening payment page in browser");
        open_in_browser(response.body);
    } else {
        print("[Failed] status code ${response.statusCode}: ${response.body}");
        exit(0);
    }

    // Currently the user sees the page with the success or failure message
    // in the browser.
    // Update the redirectUrl in Mollie to a APP_LINK so it returns back to your app.
    // https://docs.flutter.dev/cookbook/navigation/set-up-app-links
    // https://pub.dev/packages/app_links
}

// Function to launch a URL in the browser
void open_in_browser(String url) {
    if (Platform.isWindows) {
        Process.run('start', [url]);
    } else if (Platform.isLinux) {
        Process.run('xdg-open', [url]);
    } else if (Platform.isMacOS) {
        Process.run('open', [url]);
    } else {
        print('Unsupported platform');
    }
}
