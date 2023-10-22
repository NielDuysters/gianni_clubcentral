// Use the http package
import 'package:http/http.dart' as http;

// Use crypto package for password hashig
import 'dart:convert'; // for the utf8.encode method

// Global variables
import 'package:api/globals.dart' as globals;

import 'dart:io';

// Example of how to add a User
Future<int> add_user(Map<String, dynamic> data) async {
    // Endpoint URL to add a User
    const url = globals.URL + "/api/users.php?api_key=" + globals.API_KEY;

    // Convert to JSON
    String json = jsonEncode(data);

    // Making request
    // Adding a user HTTP POST
    final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json,
    );

    if (response.statusCode == 201) {
        print("[Success] User ID: ${response.body}");
        return int.parse(response.body);
    } else {
        print("[Failed] status code ${response.statusCode}: ${response.body}");
        exit(0);
    }
}

// Example of how to retrieve a user
Future<String> get_user(int id) async {
    // Endpoint URL to get a User
    final url = globals.URL + "/api/users.php/$id?api_key=" + globals.API_KEY;

    // Getting a user HTTP GET
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
        print("[Success] retrieved User: ${response.body}");
        return response.body;
    } else {
        print("[Failed] status code ${response.statusCode}: ${response.body}");
        exit(0);
    }
}

// Example of how to retrieve a user by email
Future<String> get_user_by_email(String email) async {
    // Endpoint URL to get a User (Note: add /email/ to endpoint)
    final url = globals.URL + "/api/users.php/email/$email?api_key=" + globals.API_KEY;

    // Getting a user HTTP GET
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
        print("[Success] retrieved User: ${response.body}");
        return response.body;
    } else {
        print("[Failed] status code ${response.statusCode}: ${response.body}");
        exit(0);
    }
}

// Example of how to update a user
Future<void> update_user(int id, String user) async {
    // Endpoint URL to update
    final url = globals.URL + "/api/users.php/$id?api_key=" + globals.API_KEY;

    // Making request
    // Updating a user HTTP PUT
    final response = await http.put(
        Uri.parse(url),
        headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: user,
    );

    if (response.statusCode == 200) {
        print("[Success] ${response.body}");
    } else {
        print("[Failed] status code ${response.statusCode}: ${response.body}");
        exit(0);
    }
}


// Example of how to delete a user
Future<void> delete_user(int id) async {
    // Endpoint URL to delete
    final url = globals.URL + "/api/users.php/$id?api_key=" + globals.API_KEY;

    // Making request
    // Deleting a user HTTP DELETE
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
        print("[Success] ${response.body}");
    } else {
        print("[Failed] status code ${response.statusCode}: ${response.body}");
        exit(0);
    }
}

// Example of how to retrieve all the tickets bought by a user
Future<List<dynamic>> get_tickets_from_user(int user_id) async {
    // Endpoint URL to get all Tickets from a user
    // we can call /api/tickets.php/user/user_id to do this
    final url = globals.URL + "/api/tickets.php/user/$user_id?api_key=" + globals.API_KEY;

    // Getting tickets with HTTP GET
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
        print("[Success]");
        return json.decode(response.body);
    } else {
        print("[Failed] status code ${response.statusCode}: ${response.body}");
        exit(0);
    }
}
