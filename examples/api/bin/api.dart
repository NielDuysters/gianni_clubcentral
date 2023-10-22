import 'dart:convert'; // for json
import 'package:crypto/crypto.dart'; // for password hashing
        
import 'package:api/users.dart' as users;                   // Users
import 'package:api/clubs.dart' as clubs;                   // Clubs
import 'package:api/events.dart' as events;                 // Clubs
import 'package:api/eventtickets.dart' as eventtickets;     // EventTickets

// All functions must be asynchronous
Future<void> main(List<String> arguments) async {

    //  USERS   
    // Add a User and retrieve ID
    // User data
    Map<String, dynamic> data = {
        'name': 'Foo Bar',
        'telnr': '+3247583838',
        'email': 'foobar@mail.com',
        'password': sha256.convert(utf8.encode("pass123")).toString()
    };
    int user_id = await users.add_user(data);

    // Retrieve name of recently added User
    var user = json.decode(await users.get_user(user_id));
    var user_name = user['name'];
    print("Username: $user_name");

    // Update name of User
    user['name'] = "Gux Guz";
    await users.update_user(user_id, json.encode(user));

    // Retrieve a User by email
    await users.get_user_by_email(user['email']);

    // Delete user
    await users.delete_user(user_id);
   
    // Add few users
    Map<String, dynamic> user_foo_bar = {
        'name': 'Foo Bar',
        'telnr': '+3247583838',
        'email': 'foobar@mail.com',
        'password': sha256.convert(utf8.encode("pass123")).toString()
    };
    Map<String, dynamic> user_gux_guz = {
        'name': 'Gux Guz',
        'telnr': '+32473323838',
        'email': 'guxguz@mail.com',
        'password': sha256.convert(utf8.encode("password123")).toString()
    };
    Map<String, dynamic> user_guf_zoo = {
        'name': 'Guf Zoo',
        'telnr': '+324732443838',
        'email': 'gufzoo@mail.com',
        'password': sha256.convert(utf8.encode("pass453")).toString()
    };
    await users.add_user(user_foo_bar);
    await users.add_user(user_gux_guz);
    await users.add_user(user_guf_zoo);


    //  CLUBS   
    // Add Club Vaag
    Map<String, dynamic> club_vaag = {
        "name": "Club Vaag",
        "info": "Open op donderdag en vrijdag",
        "address": {
            'street': 'Straat',
            'nr': '1',
            'postalcode': '2000',
            'region': 'Antwerpen',
            'country': 'Belgium',
            'latitude': 2.00,
            'longitude': 2.00
        }
    };
    
    // Add club and retrieve ID
    int club_vaag_id = await clubs.add_club(club_vaag);

    // Add Kompass Klub
    Map<String, dynamic> club_kompass = {
        "name": "Kompass Klub",
        "info": "Techno Club",
        "address": {
            'street': 'Gentseweg',
            'nr': '5',
            'postalcode': '9000',
            'region': 'Gent',
            'country': 'Belgium',
            'latitude': 4.00,
            'longitude': 4.00
        }
    };
    
    // Add club and retrieve ID
    int club_kompass_id = await clubs.add_club(club_kompass);
   
    // Retrieve all clubs and print their name
    List<dynamic> all_clubs = json.decode(await clubs.all_clubs());
    for (var club in all_clubs) {
        print("${club['ID']}: ${club['name']}");
    }
    
    //  EVENTS   
    // A club can host different Events
    // Add two events to Club Vaag
    // Vage donderdag
    Map<String, dynamic> vage_donderdag = {
        "name": "Vage Donderdag",
        "info": """
            Vage donerdag op 26 oktober. DJ's:
            - Fux Gux,
            - Foo Bar
            """,
        "club": club_vaag_id,
    };
    int vage_donderdag_id = await events.add_event(vage_donderdag);
    
    // Saturday Rave
    Map<String, dynamic> saturday_rave = {
        "name": "Saturday Rave",
        "info": """
            Rave op oktober 28. DJ's:
            - Fux Gux,
            - Foo Bar
            """,
        "club": club_vaag_id,
    };
    int saturday_rave_id = await events.add_event(saturday_rave);
    
    // EVENTTICKETS (Different type of tickets configured by a club)  
    // A event hosted by a club can sell different type of tickets
    // with different prices.
    // Note how most parties have e.g VIP tickets or standard tickets.
    // Or how raves sell in different waves e.g Wave 1 (5.00 EUR), Wave 2 (7.50 EUR).

    // Add two type of tickets to Vage Donderdag
    Map<String, dynamic> wave_1 = {
        "event": vage_donderdag_id,
        "title": "Wave 1",
        "price": 5.00
    };
    Map<String, dynamic> wave_2 = {
        "event": vage_donderdag_id,
        "title": "Wave 2",
        "price": 7.50
    };
    int wave_1_id = await eventtickets.add_eventticket(wave_1);
    int wave_2_id = await eventtickets.add_eventticket(wave_2);

    // Get Club name of wave_1
    var club_of_wave_1 = await eventtickets.get_club_of_event_ticket(wave_1_id);
    print("Name of club Wave 1: ${club_of_wave_1['name']}");

    /*
    //  TICKETS (Tickets purchased by a User)
    int user_id_to_get_tickets_from = 54;   // SET USER_ID here
    var tickets_of_user = await users.get_tickets_from_user(user_id_to_get_tickets_from);
    for (var ticket in tickets_of_user) {
        print("Ticket (#${ticket['ID']}) - ${ticket['payment_status']}");
    }
    
    // Get all users who bought a ticket at a club
    var club_id_to_get_users_from = 27; // Set club id here
    var users_who_bought_at_club_vaag = await clubs.get_all_clients_from_club(club_id_to_get_users_from);

    print("Klanten Club Vaag:");
    for (var user_id in users_who_bought_at_club_vaag) {
        var user = json.decode(await users.get_user(user_id));
        print("${user['name']}");
    }*/
}
