import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:app/globals.dart' as globals;

Future<List<dynamic>?> get_by_user(int user_id) async {
    String url = "${globals.URL}/api/tickets.php/user/$user_id?api_key=${globals.API_KEY}";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
        return json.decode(response.body);
    } else {
        return null;
    }
}
