// Use the http package
import 'package:http/http.dart' as http;

// Use crypto package for password hashig
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for the utf8.encode method

// Global variables
import 'package:api/globals.dart' as globals;

// Import to add Addresses
import 'package:api/addresses.dart' as addresses;

import 'dart:io';

// Example of how to add a Club
Future<int> add_club(Map<String, dynamic> data) async {
    // Endpoint URL to add a Club
    const url = globals.URL + "/api/clubs.php?api_key=" + globals.API_KEY;

    // First make add address
    // If address already exists the API will return the ID of that address
    var address = data['address'];
    int address_id = await addresses.add_address(address);

    // Set address_id to Club
    data['address'] = address_id;

    // Convert club to JSON
    String json = jsonEncode(data);

    // Making request
    // Adding a club HTTP POST
    final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json,
    );

    if (response.statusCode == 201) {
        print("[Success] Club ID: ${response.body}");
        return int.parse(response.body);
    } else {
        print("[Failed] status code ${response.statusCode}: ${response.body}");
        exit(0);
    }
}

// Example of how to retrieve all Clubs
Future<String> all_clubs() async {
    // Endpoint URL to get all Clubs
    const url = globals.URL + "/api/clubs.php?api_key=" + globals.API_KEY;


    // Making request
    // Getting clubs HTTP GET
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
        print("[Success] ${response.body}");
        return response.body;
    } else {
        print("[Failed] status code ${response.statusCode}: ${response.body}");
        exit(0);
    }
}

// Example of how to retrieve a Club
Future<Map<String, dynamic>> get_club(int id) async {
    // Endpoint URL to get a Club
    final url = globals.URL + "/api/clubs.php/$id?api_key=" + globals.API_KEY;

    // Getting a Club HTTP GET
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
        print("[Success] retrieved Club: ${response.body}");
        return json.decode(response.body);
    } else {
        print("[Failed] status code ${response.statusCode}: ${response.body}");
        exit(0);
    }
}

// Example of how to retrieve all the users who bought a ticket from a event at this Club
// Note that the table tickets does not store a reference to the club directly.
// > From the table tickets we first retrieve the event_ticket. 
// > From the event_tickets table we retrieve the event.
// > From the events table we can finally retrieve the club/
//
// So to achieve this we go the other way around.
// > Retrieve all the events from a club (events table has reference to clubs)
// > Retrieve all the event_tickets from all those events
// > Retrieve all the tickets with a matching event_ticket
//
// Store the ID's of these objects in a List with UNIQUE VALUES.
Future<List<int>> get_all_clients_from_club(int club_id) async {
    
    // 1. RETRIEVE ALL EVENTS OF A CLUB
    // Endpoint URL to all Events from a Club
    String url = globals.URL + "/api/events.php/club/$club_id?api_key=" + globals.API_KEY;

    List<dynamic> events;
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
        events = json.decode(response.body);
    } else {
        print("[1 Failed] status code ${response.statusCode}: ${response.body}");
        exit(0);
    }

    
    // 2. RETRIEVE ALL EVENT_TICKETS FROM ALL EVENTS OF THE CLUB
    List<int> event_tickets = [];
    for (var event in events) {
        // Endpoint URL to all EventTickets from a Event
        String url = globals.URL + "/api/eventtickets.php/event/${event['ID']}?api_key=" + globals.API_KEY;
        var response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
            // Loop over all event_tickets of this event add add the ID to the list event_tickets 
            for (var event_ticket in json.decode(response.body)) {
                event_tickets.add(event_ticket['ID']);
            }
        }
    }

    // 3. Retrieve all Tickets which belong to a event_ticket in the list event_tickets
    // > Loop over all the ID'S the event_tickets list.
    // > Retrieve the tickets matching a ID.
    // > Add the User of the ticket to the list users.
    // > Remove duplicate values from the list users.
    List<int> users = [];
    for (var event_ticket_id in event_tickets) {
        // Endpoint URL to all Tickets with this event_ticket_id
        String url = globals.URL + "/api/tickets.php/event_ticket/$event_ticket_id?api_key=" + globals.API_KEY;
        var response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
            // Loop over all tickets and add user of ticket to list users
            for (var ticket in json.decode(response.body)) {
                users.add(ticket['user']);
            }
        }
    }

    // Remove duplicates from list users
    Set<int> _temp = Set<int>.from(users);
    users = _temp.toList();

    return users;
}

