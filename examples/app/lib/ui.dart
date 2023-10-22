// All the User Interfaces in the app.
// This is a CLI-app. Convert the implementation to the GUI.

import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:app/usersession.dart';
import 'package:app/helpers.dart' as helpers;
import 'package:app/api/users.dart' as users;
import 'package:app/api/tickets.dart' as tickets;
import 'package:app/api/clubs.dart' as clubs;
import 'package:app/api/addresses.dart' as addresses;
import 'package:app/api/events.dart' as events;
import 'package:app/api/eventtickets.dart' as eventtickets;
import 'package:app/payment/payment.dart' as payment;

// Home screen
Future<void> home() async {
    helpers.clear_screen();
    print("Welkom bij Club Central!\n\n1) Registreer\n2) Login");

    stdout.write("\n\n>");
    switch(stdin.readLineSync()) {
        case "1":
            register();
            break;
        case "2":
            login();
            break;
        default:
            home();
            break;
    }
}

// Register screen
Future<void> register() async {
    helpers.clear_screen();
    print("Uw info.\n");
    
    stdout.write("naam: ");
    String name = stdin.readLineSync() ?? exit(0);
    
    stdout.write("email: ");
    String email = stdin.readLineSync() ?? exit(0);
    
    stdout.write("telnr: ");
    String telnr = stdin.readLineSync() ?? exit(0);
    
    stdout.write("pass: ");
    String pass = stdin.readLineSync() ?? exit(0);

    // Of course implement checks for valid emails and telnr etc.
    // ...

    // Hash password
    pass = sha256.convert(utf8.encode(pass)).toString();

    // Make user JSON
    Map<String, dynamic> user = {
        'name': name,
        'telnr': telnr,
        'email': email,
        'password': pass
    };

    int? user_id = await users.add(user);
    if (user_id == null) {
        print("Gebruiker kon niet aangemaakt worden. Is dit telefoonnummer of email-adres al in gebruik?");
        exit(0);
    }

    // Log user in
    UserSession.user_id = user_id;
    welcome();
}

// Login screen
Future<void> login() async {
    helpers.clear_screen();
    print("Login.\n");

    stdout.write("email: ");
    String email = stdin.readLineSync() ?? exit(0);

    stdout.write("pass: ");
    String pass = stdin.readLineSync() ?? exit(0);

    Map<String, dynamic>? user = await users.get_by_email(email);
    if (user != null) {
        // Check password
        pass = sha256.convert(utf8.encode(pass)).toString();
        if (user['password'] == pass) {
            // Login if correct
            UserSession.user_id = user['ID'];
            welcome();
        } else {
            print("Fout wachtwoord.");
            exit(0);
        }
    } else {
        print("Gebruiker niet gevonden.");
        exit(0);
    }
}

// Welcome screen for logged in user
Future<void> welcome() async {
    helpers.clear_screen();

    var user = await users.get(UserSession.user_id!) ?? exit(0);
    
    print("Welkom bij Club Central ${user['name']}!\n\n");
    print("1) Bekijk mijn tickets\n2) Bekijk clubs");
    
    stdout.write("\n\n>");
    switch(stdin.readLineSync()) {
        case "1":
            user_panel();
            break;
        case "2":
            clubs_screen();
            break;
        default:
            welcome();
            break;
    }
}

// User panel where the logged in user can see all his tickets
Future<void> user_panel() async {
    helpers.clear_screen();
    
    var user = await users.get(UserSession.user_id!) ?? exit(0);
    print("Account van ${user['name']}.\n\n");

    print("Uw bestelde tickets:");
    List<dynamic> user_tickets = await tickets.get_by_user(user['ID']) ?? [];
    if (user_tickets.length == 0) {
        print("U heeft momenteel nog geen tickets besteld. Wilt u de clubs bekijken om een ticket te kopen? (j/n)");
    
        stdout.write("\n\n>");
        switch(stdin.readLineSync()) {
            case "j":
                clubs_screen();
                return;
                break;
            case "n":
                print("U heeft de app verlaten.");
                exit(0);
                break;
            default:
                user_panel();
                return;
                break;
        }
    }

    for (var ticket in user_tickets) {
        Map<String, dynamic> event_ticket = await eventtickets.get(ticket['event_ticket']) ?? exit(0);
        Map<String, dynamic> event = await events.get(event_ticket['event']) ?? exit(0);
        Map<String, dynamic> club = await clubs.get(event['club']) ?? exit(0);

        print("#${ticket['ID']} Ticket voor ${event['name']} - ${club['name']} (${ticket['payment_status']})");
    }

    print("\nDruk op een toets...");
    stdin.readLineSync();
    welcome();
}

// Screen with all the clubs on the app
Future<void> clubs_screen() async {
    helpers.clear_screen();
    print("Kies een club.\n");

    List<dynamic> all_clubs = await clubs.get_all() ?? [];
    if (all_clubs.length == 0) {
        print("Er zijn momenteel nog geen clubs.");
        stdin.readLineSync();
        welcome();
    } else {
        for (var club in all_clubs) {
            print("${club['ID']}) ${club['name']}");
        }
    }
    
    stdout.write("\n\n>");
    String? selected_club = stdin.readLineSync();
    if (selected_club == null) {
        welcome();
    } else {
        club_details(int.parse(selected_club));
    }
}

// Screen of a club
Future<void> club_details(int id) async {
    helpers.clear_screen();

    Map<String, dynamic> club = await clubs.get(id) ?? exit(0);
    print("- ${club['name']} -\n\n${club['info']}");

    Map<String, dynamic> address = await addresses.get(club['address']) ?? exit(0);
    print("\n\nAddress: ${address['street']} ${address['nr']}, ${address['postalcode']} ${address['region']}");

    List<dynamic> club_events = await events.get_by_club(id) ?? [];
    if (club_events.length == 0) {
        print("Deze club heeft momenteel geen events. Andere clubs bekijken? (j/n)");
        
        stdout.write("\n\n>");
        switch(stdin.readLineSync()) {
            case "j":
                clubs_screen();
                break;
            case "n":
                print("U heeft de app verlaten.");
                exit(0);
                break;
            default:
                club_details(id);
                break;
        }
    }
    
    print("\n\nKies een event:");
    for (var event in club_events) {
        print("${event['ID']}) ${event['name']}");
    }

    stdout.write("\n\n>");
    String? selected_event = stdin.readLineSync();
    if (selected_event == null) {
        welcome();
    } else {
        event_details(int.parse(selected_event), club);
    }
}

// Detail page of a Event
Future<void> event_details(int id, Map<String, dynamic> club) async {
    helpers.clear_screen();

    Map<String, dynamic> event = await events.get(id) ?? exit(0);
    print("${event['name']} - Organised by ${club['name']}\n${event['info']}");

    print("\n\nKoop een ticket:");
    List<dynamic> tickets_of_event = await eventtickets.get_by_event(id) ?? exit(0);
    for (var event_ticket in tickets_of_event) {
        String price = event_ticket['price'].toStringAsFixed(2).replaceAll(".", ",");
        print("${event_ticket['ID']}) ${event_ticket['title']} - $price EUR");
    }
    
    stdout.write("\n\n>");
    String? selected_ticket = stdin.readLineSync();
    if (selected_ticket == null) {
        welcome();
    } else {
        buy_event_ticket(int.parse(selected_ticket));
    }
}

// Function to buy the ticket
Future<void> buy_event_ticket(int id) async {
    helpers.clear_screen();

    Map<String, dynamic> event_ticket = await eventtickets.get(id) ?? exit(0);
    String price = event_ticket['price'].toStringAsFixed(2).replaceAll(".", ",");
    print("Aankoop: ${event_ticket['title']} voor $price EUR.");

    // Send info for purchase to backend and retrieve the payment_url.
    // The payment_url is the Mollie-page where the user can select their
    // payment method and do the payment.
    // In the actual open this should be openend in the default browser-app.
    String payment_url = await payment.make_payment(id, UserSession.user_id!);

    // Go to payment_url
    helpers.open_in_browser(payment_url);
    
    print("U wordt na de aankoop omgeleid naar uw ticketoverzicht... Druk op een toets als dit te lang duurt...");
    
    stdin.readLineSync();
    user_panel();
}


