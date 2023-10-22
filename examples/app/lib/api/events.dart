import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:app/globals.dart' as globals;

Future<Map<String, dynamic>?> get(int id) async {
    String url = "${globals.URL}/api/events.php/$id?api_key=${globals.API_KEY}";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
        return json.decode(response.body);
    } else {
        return null;
    }
}

Future<List<dynamic>?> get_by_club(int club_id) async {
    String url = "${globals.URL}/api/events.php/club/$club_id?api_key=${globals.API_KEY}";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
        return json.decode(response.body);
    } else {
        return null;
    }
}

