// Use the http package
import 'package:http/http.dart' as http;

// Use crypto package for password hashig
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for the utf8.encode method

import 'package:api/clubs.dart' as clubs;                   // Clubs
import 'package:api/events.dart' as events;                 // Clubs

// Global variables
import 'package:api/globals.dart' as globals;

import 'dart:io';

// Example of how to add a EventTicket
Future<int> add_eventticket(Map<String, dynamic> data) async {
    // Endpoint URL to add a Event
    const url = globals.URL + "/api/eventtickets.php?api_key=" + globals.API_KEY;

    // Convert event to JSON
    String json = jsonEncode(data);

    // Making request
    // Adding a eventticket HTTP POST
    final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json,
    );

    if (response.statusCode == 201) {
        print("[Success] EventTicket ID: ${response.body}");
        return int.parse(response.body);
    } else {
        print("[Failed] status code ${response.statusCode}: ${response.body}");
        exit(0);
    }
}

// Example of how to retrieve a EventTicket
Future<String> get_eventticket(int id) async {
    // Endpoint URL to get a EventTicket
    final url = globals.URL + "/api/eventtickets.php/$id?api_key=" + globals.API_KEY;

    // Getting a EventTicket HTTP GET
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
        print("[Success] retrieved EventTicket: ${response.body}");
        return response.body;
    } else {
        print("[Failed] status code ${response.statusCode}: ${response.body}");
        exit(0);
    }
}

// A Club hosts multiple Events > a Event has different type of EventTickets
// For each type EventTicket we must know to what Event it belongs to. This is why
// we store the ID of the Event in the database tabel event_tickets.
// For each Event we want to know to what Club it organizes. This is why we
// store the ID of the club in the database table events.
// Note how the table event_tickets only has a reference to Event and not to Club.
//
// What if we want to retrieve the name of the Club of a EventTicket? This is not directly
// possible because the table event_tickets has no reference to Club.
//
// To solve this we first retrieve the Event of the EventTicket, when we have retrieved
// the Event we can retrieve the Club. Because the table events does have a reference to clubs.

Future<Map<String, dynamic>> get_club_of_event_ticket(int event_ticket_id) async {
    // Retrieve EventTicket from database
    var event_ticket = json.decode(await get_eventticket(event_ticket_id));
    // Get Event ID of this EventTicket
    int event_of_event_ticket = event_ticket['event'];

    // Get event using event ID
    var event = await events.get_event(event_of_event_ticket);
    // Get Club ID of this event
    int club_of_event = event['club'];

    // Get Club of 
    var club = await clubs.get_club(club_of_event);

    return club;
}
