import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:app/globals.dart' as globals;

Future<Map<String, dynamic>?> get(int id) async {
    String url = "${globals.URL}/api/eventtickets.php/$id?api_key=${globals.API_KEY}";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
        return json.decode(response.body);
    } else {
        return null;
    }
}

Future<List<dynamic>?> get_by_event(int event_id) async {
    String url = "${globals.URL}/api/eventtickets.php/event/$event_id?api_key=${globals.API_KEY}";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
        return json.decode(response.body);
    } else {
        return null;
    }
}

