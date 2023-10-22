// Use the http package
import 'package:http/http.dart' as http;

// Use crypto package for password hashig
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for the utf8.encode method

// Global variables
import 'package:api/globals.dart' as globals;

import 'dart:io';

// Example of how to add a Address
Future<int> add_address(Map<String, dynamic> data) async {
    // Endpoint URL to add a Address
    const url = globals.URL + "/api/addresses.php?api_key=" + globals.API_KEY;

    // Convert to JSON
    String json = jsonEncode(data);

    // Making request
    // Adding a Address HTTP POST
    final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json,
    );

    if (response.statusCode == 201) {
        print("[Success] Address ID: ${response.body}");
        return int.parse(response.body);
    } else {
        print("[Failed] status code ${response.statusCode}: ${response.body}");
        exit(0);
    }
}

