// Use the http package
import 'package:http/http.dart' as http;

// Use crypto package for password hashig
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for the utf8.encode method

// Global variables
import 'package:api/globals.dart' as globals;

import 'dart:io';

// Example of how to add a event
Future<int> add_event(Map<String, dynamic> data) async {
    // Endpoint URL to add a Event
    const url = globals.URL + "/api/events.php?api_key=" + globals.API_KEY;

    // Convert event to JSON
    String json = jsonEncode(data);

    // Making request
    // Adding a event HTTP POST
    final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json,
    );

    if (response.statusCode == 201) {
        print("[Success] Event ID: ${response.body}");
        return int.parse(response.body);
    } else {
        print("[Failed] status code ${response.statusCode}: ${response.body}");
        exit(0);
    }
}

// Example of how to retrieve a Event
Future<Map<String, dynamic>> get_event(int id) async {
    // Endpoint URL to get a Event
    final url = globals.URL + "/api/events.php/$id?api_key=" + globals.API_KEY;

    // Getting a Event HTTP GET
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
        print("[Success] retrieved Event: ${response.body}");
        return json.decode(response.body);
    } else {
        print("[Failed] status code ${response.statusCode}: ${response.body}");
        exit(0);
    }
}
